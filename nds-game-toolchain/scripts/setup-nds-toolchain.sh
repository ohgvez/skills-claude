#!/usr/bin/env bash
# Build a working Nintendo DS homebrew toolchain (BlocksDS + libnds) from source
# on Debian/Ubuntu, using only apt, PyPI and GitHub.
#
# Use this when the normal installers are unavailable (locked-down network, CI
# container, no wf-pacman). On a normal machine prefer the Wonderful Toolchain
# (wf-pacman -S blocksds-toolchain) or devkitPro — see ../SKILL.md.
#
# What it produces:
#   /opt/blocksds/core      the SDK (libnds, maxmod, dswifi, ndstool, grit, ...)
#   /opt/blocksds/external  empty, for third-party libraries
#   arm-none-eabi-gcc + picolibc as the cross toolchain
set -euo pipefail

SRC_DIR="${SRC_DIR:-/opt/src}"
INSTALLDIR="${INSTALLDIR:-/opt/blocksds/core}"
EXTDIR="${EXTDIR:-/opt/blocksds/external}"
JOBS="${JOBS:-$(nproc)}"

sudo_cmd=""
[ "$(id -u)" -ne 0 ] && sudo_cmd="sudo"

echo "==> 1/6 Host packages"
export DEBIAN_FRONTEND=noninteractive
$sudo_cmd apt-get update -qq
# clang-20 is only needed because mmutil embeds binaries with C23 #embed, which
# Ubuntu's GCC 13 does not implement.
$sudo_cmd apt-get install -y --no-install-recommends \
    build-essential git ninja-build python3-pip clang-20 \
    gcc-arm-none-eabi binutils-arm-none-eabi \
    picolibc-arm-none-eabi libstdc++-arm-none-eabi-picolibc
pip install --quiet --break-system-packages meson || pip install --quiet meson

GCC_VER="$(arm-none-eabi-gcc -dumpversion)"
GCC_LIBDIR="/usr/lib/gcc/arm-none-eabi/$GCC_VER"
echo "    arm-none-eabi-gcc $GCC_VER"

echo "==> 2/6 picolibc from source (Ubuntu's 1.8.6 is too old for libnds)"
mkdir -p "$SRC_DIR"
if [ ! -d "$SRC_DIR/picolibc/.git" ]; then
    git clone --depth 1 https://github.com/picolibc/picolibc.git "$SRC_DIR/picolibc"
fi
cd "$SRC_DIR/picolibc"

# libnds is written against the Wonderful Toolchain's patched picolibc: DIR is
# opaque there (libnds defines `struct __dirstream` and every dirent call), and
# `struct dirent` carries d_off/d_reclen. picolibc ships no opendir()/readdir()
# of its own, so relaxing the header is safe.
python3 - <<'PY'
p = 'libc/include/sys/dirent.h'
s = open(p).read()
dirent_old = """struct dirent {
    ino_t     d_ino; /* Inode number */
    __uint8_t d_type;"""
dirent_new = """struct dirent {
    ino_t     d_ino; /* Inode number */
    __off_t   d_off; /* Offset of the next entry */
    reclen_t  d_reclen; /* Length of this record */
    __uint8_t d_type;"""
dir_old = """typedef struct {
    int           fd;
    size_t        offset;
    size_t        count;
    struct dirent dirent;
    union {
        char       buf[512];
        __uint64_t align;
    };
} DIR;"""
dir_new = """/* Defined by the platform (libnds/BlocksDS), which also implements
   opendir()/readdir()/closedir(). picolibc only declares it. */
typedef struct __dirstream DIR;"""
if dirent_old in s:
    s = s.replace(dirent_old, dirent_new)
if dir_old in s:
    s = s.replace(dir_old, dir_new)
open(p, 'w').write(s)
print("    patched libc/include/sys/dirent.h")
PY

# Both DS CPUs (arm7tdmi, arm946e-s) select GCC's default multilib, which is
# ARMv4T soft-float, so a single non-multilib build covers the whole console.
rm -rf build-nds
meson setup build-nds \
    --cross-file scripts/cross-arm-none-eabi.txt \
    -Dprefix=/usr \
    -Dincludedir=lib/picolibc/arm-none-eabi/include \
    -Dlibdir=lib/picolibc/arm-none-eabi/lib \
    -Dspecsdir="$GCC_LIBDIR" \
    -Dmultilib=false -Dtests=false \
    -Dc_args="-march=armv4t -mfloat-abi=soft -marm" \
    -Dcpp_args="-march=armv4t -mfloat-abi=soft -marm" >/dev/null
ninja -C build-nds
rm -rf /tmp/picolibc-stage
DESTDIR=/tmp/picolibc-stage meson install -C build-nds --quiet >/dev/null
$sudo_cmd cp -a /tmp/picolibc-stage/usr/. /usr/

# BlocksDS passes its own linker scripts from inside its specs files, which the
# `%{!T:...}` test cannot see, so picolibc.ld would be added on top of them and
# its ASSERTs would fail the link.
$sudo_cmd sed -i 's/%{!T:-Tpicolibc\.ld}//' "$GCC_LIBDIR/picolibc.specs"

echo "==> 3/6 BlocksDS sources"
if [ ! -d "$SRC_DIR/blocksds-sdk/.git" ]; then
    git clone --recurse-submodules https://github.com/blocksds/sdk.git "$SRC_DIR/blocksds-sdk"
fi
cd "$SRC_DIR/blocksds-sdk"

echo "==> 4/6 Adapting the SDK to GCC 13 + upstream picolibc"
# -std=gnu23 is GCC 14 spelling; GCC 13 calls the same standard gnu2x.
grep -rl 'std=gnu23' --include='Makefile*' --include='*.mk' . \
    | xargs -r sed -i 's/-std=gnu23/-std=gnu2x/g'
# __sync_synchronize_none is a no-op barrier that only exists in wf-picolibc.
# Nothing in the SDK calls __sync_synchronize, so drop the redirection.
grep -rl '__sync_synchronize_none' sys/crts/ \
    | xargs -r sed -i 's/ --defsym=__sync_synchronize=__sync_synchronize_none//'
# __builtin_clzg() needs GCC 14.
python3 - <<'PY'
p = 'libs/libnds/source/arm9/math.c'
s = open(p).read()
old = "    int shift = 32 - __builtin_clzg((uint32_t)(reciprocal64 >> 32), 32);"
new = """#if defined(__GNUC__) && !defined(__clang__) && __GNUC__ < 14
    // __builtin_clzg() requires GCC 14. Same semantics: 32 when the input is 0.
    uint32_t reciprocal_hi = (uint32_t)(reciprocal64 >> 32);
    int shift = 32 - (reciprocal_hi ? __builtin_clz(reciprocal_hi) : 32);
#else
    int shift = 32 - __builtin_clzg((uint32_t)(reciprocal64 >> 32), 32);
#endif"""
if old in s:
    open(p, 'w').write(s.replace(old, new))
    print("    patched libs/libnds/source/arm9/math.c")
PY

echo "==> 5/6 Building"
export ARM_NONE_EABI_PATH=          # use the system arm-none-eabi-* from PATH
export BLOCKSDS="$PWD"
export HOSTCC=clang-20 HOSTCXX=clang++-20

# Host tools first, with the plain host compiler.
make tools -j"$JOBS"

# The SDK libraries compile without -specs, expecting a toolchain whose default
# libc is picolibc. Ours defaults to newlib, so pass the specs explicitly.
CFLAGS="-specs=picolibc.specs" \
CXXFLAGS="-specs=picolibc.specs" \
ASFLAGS="-specs=picolibc.specs" \
    make libs -j"$JOBS"

# sys/ already selects the BlocksDS specs (which include picolibc.specs); adding
# it again would re-run picolibc's %rename directives and fail.
make sys -j"$JOBS"

echo "==> 6/6 Installing to $INSTALLDIR"
$sudo_cmd mkdir -p "$INSTALLDIR" "$EXTDIR"
$sudo_cmd -E env PATH="$PATH" make install INSTALLDIR="$INSTALLDIR"

echo
echo "==> Smoke test: building the ARM9-only ROM template"
tmp="$(mktemp -d)"
cp -r templates/rom_arm9_only "$tmp/rom"
( cd "$tmp/rom" && BLOCKSDS="$INSTALLDIR" BLOCKSDSEXT="$EXTDIR" ARM_NONE_EABI_PATH= make -j"$JOBS" >/dev/null )
ls -l "$tmp/rom"/*.nds
"$INSTALLDIR/tools/ndstool/ndstool" -i "$tmp/rom"/*.nds | head -5
rm -rf "$tmp"

cat <<EOF

Done. Add this to your shell profile:

    export BLOCKSDS=$INSTALLDIR
    export BLOCKSDSEXT=$EXTDIR
    export ARM_NONE_EABI_PATH=

Start a project by copying $SRC_DIR/blocksds-sdk/templates/rom_arm9_only
(or rom_combined for an ARM9 + ARM7 project) and running make.
EOF
