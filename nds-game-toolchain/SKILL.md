---
name: nds-game-toolchain
description: Set up a Nintendo DS homebrew toolchain (BlocksDS or devkitPro/devkitARM with libnds) and build .nds ROMs. Use this skill when the user wants to make a Nintendo DS or DSi game, install devkitARM/libnds/BlocksDS, compile a .nds file, or set up an NDS development environment.
---

# Nintendo DS Game Toolchain

A DS ROM is two programs in one file: ARM9 code (the main CPU, 67 MHz, runs the
game) and ARM7 code (33 MHz, handles audio, touchscreen, wifi, power). A
toolchain has to cross-compile both, then pack them with the icon, title and
filesystem into a `.nds` file.

## Which SDK

| | BlocksDS | devkitPro |
| --- | --- | --- |
| Toolchain | Wonderful Toolchain (`wf-pacman`) | devkitARM (`dkp-pacman`) |
| libc | picolibc | devkitPro's newlib fork |
| libnds | own fork, actively developed | upstream, now built on calico |
| Best for | new projects, open build from source | older tutorials and existing code |

Both use `libnds` and produce ordinary `.nds` ROMs; most sample code compiles on
either with small changes. Pick one and stay with it — headers and link scripts
are not interchangeable.

## Install

### Windows

**devkitPro (easiest):** download the *devkitPro Updater* graphical installer
from `github.com/devkitPro/installer/releases`, run it, and tick **NDS
Development**. It installs devkitARM, libnds, libfat, maxmod, the tools and an
MSYS2 shell. Build from the "devkitPro MSYS2" shell, where `$DEVKITPRO` and
`$DEVKITARM` are already set.

**BlocksDS:** install the Wonderful Toolchain from
`wonderful.asie.pl/wiki/doku.php?id=getting_started`, then:

```bash
wf-pacman -Syu wf-tools
wf-config repo enable blocksds
wf-pacman -Syu
wf-pacman -S blocksds-toolchain blocksds-docs
```

### macOS / Linux

devkitPro: install `devkitpro-pacman` from `github.com/devkitPro/pacman/releases`,
then `sudo dkp-pacman -S nds-dev`.

BlocksDS: same `wf-pacman` commands as above.

### From source (no installers available)

[`scripts/setup-nds-toolchain.sh`](scripts/setup-nds-toolchain.sh) builds
BlocksDS on Debian/Ubuntu from apt + PyPI + GitHub only: Ubuntu's
`gcc-arm-none-eabi`, picolibc built from source, then the SDK. Use it in CI or on
a machine that cannot reach `devkitpro.org` / `wonderful.asie.pl`.

It carries four adaptations, because BlocksDS targets a GCC 14 toolchain whose
default libc is a patched picolibc:

1. Ubuntu's picolibc 1.8.6 has no `uchar.h` or `sys/statvfs.h` → build picolibc
   from git.
2. Upstream picolibc defines a concrete `DIR` and a minimal `struct dirent`;
   libnds defines `struct __dirstream` itself and needs `d_off`/`d_reclen`
   → [`scripts/patches/picolibc-libnds-dirent.patch`](scripts/patches/picolibc-libnds-dirent.patch).
3. GCC 13 spells C23 `-std=gnu2x`, not `-std=gnu23`, and has no
   `__builtin_clzg()` → both substituted in the SDK.
4. `__sync_synchronize_none` (a no-op barrier that only exists in wf-picolibc) is
   dropped from the link specs, and picolibc's default linker script is removed
   from `picolibc.specs` so it cannot stack on top of the BlocksDS ones.

`mmutil` embeds binaries with C23 `#embed`, so it needs clang-20 as the *host*
compiler; everything else builds with the system GCC.

## Build a ROM

BlocksDS (with `BLOCKSDS` and `BLOCKSDSEXT` exported):

```bash
cp -r <blocksds sources>/templates/rom_arm9_only mygame   # or rom_combined
cd mygame && make
```

The templates live in the SDK's source tree (and in the `blocksds-docs`
package); `make install` only installs the libraries, tools and the
`sys/default_makefiles` that a project's own Makefile includes.

devkitPro:

```bash
cp -r $DEVKITPRO/examples/nds/templates/arm9 mygame
cd mygame && make
```

Both drop a `.nds` next to the Makefile. Inspect it with
`ndstool -i mygame.nds`.

A typical project:

```
Makefile          # sets GAME_TITLE, GAME_ICON, source dirs
source/           # C/C++, compiled for the ARM9
arm7/source/      # only in a combined project
graphics/*.png    # converted by grit into tiles/palettes
audio/            # .mod/.wav converted by mmutil into a maxmod soundbank
nitrofs/          # optional read-only filesystem embedded in the ROM
```

Assets are converted at build time by the SDK's tools — `grit` (graphics),
`mmutil` (audio), `bin2c`/`bin2s` (raw data) — and linked in as arrays or as a
NitroFS image; you do not commit generated `.c` files.

## Run and debug

- **melonDS** — most accurate, best for DSi and wifi features.
- **DeSmuME** — widely packaged (`apt install desmume`), good debugger.
- **no$gba** — `consoleDebugInit(DebugDevice_NOCASH)` sends `stderr` to its
  debug window.
- **Real hardware** — copy the `.nds` to a flashcart's SD card. Homebrew that
  touches the card's filesystem must be DLDI-patched; most loaders (TWiLight
  Menu++, hbmenu) patch on the fly.

The ARM9 has no MMU protection worth relying on: a wild pointer usually shows up
as a white screen or a guru-meditation crash dump, not an exception. Initialize a
console early (`consoleDemoInit()`) and `printf` your way through bring-up.

## Gotchas

- Main RAM is 4 MB (16 MB on DSi in TWL mode). VRAM is banked and must be mapped
  to a purpose (`vramSetBankA(VRAM_A_MAIN_BG)`) before use.
- The two screens are separate 2D engines; the 3D core can only draw to one of
  them at a time.
- `swiWaitForVBlank()` is the frame clock — 60 Hz, and everything touching the
  display should happen right after it.
- ARM7 and ARM9 share memory through a FIFO plus uncached transfer regions;
  cache-flush anything the other CPU must see (`DC_FlushRange`).
