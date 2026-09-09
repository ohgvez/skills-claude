#!/usr/bin/env bash
# Set up the Steinberg VST3 SDK toolchain on Linux (Debian/Ubuntu).
#
# Result: a built SDK in $VST3_SDK_DIR with the validator, the VST3 inspector,
# the editor host and ~19 example plugins compiled as .vst3 bundles.
set -euo pipefail

VST3_SDK_DIR="${VST3_SDK_DIR:-/opt/toolchains/vst3sdk}"
VST3_BUILD_TYPE="${VST3_BUILD_TYPE:-Release}"
# ON symlinks built bundles into ~/.vst3 so hosts pick them up. Off by default
# because it is useless in a container.
VST3_PLUGIN_LINK="${VST3_PLUGIN_LINK:-OFF}"
JOBS="${JOBS:-$(nproc)}"

echo "==> Installing host dependencies"
sudo_cmd=""
[ "$(id -u)" -ne 0 ] && sudo_cmd="sudo"
export DEBIAN_FRONTEND=noninteractive
$sudo_cmd apt-get update -qq
$sudo_cmd apt-get install -y --no-install-recommends \
    build-essential cmake ninja-build git pkg-config \
    libx11-xcb-dev libxcb-util-dev libxcb-cursor-dev libxcb-keysyms1-dev \
    libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
    libfontconfig1-dev libfreetype-dev libcairo2-dev libgtkmm-3.0-dev \
    libsqlite3-dev libgl-dev

echo "==> Fetching the VST3 SDK into $VST3_SDK_DIR"
if [ -d "$VST3_SDK_DIR/.git" ]; then
    git -C "$VST3_SDK_DIR" pull --ff-only
    git -C "$VST3_SDK_DIR" submodule update --init --recursive
else
    mkdir -p "$(dirname "$VST3_SDK_DIR")"
    # The SDK pulls in base, pluginterfaces, public.sdk, vstgui4 as submodules.
    git clone --recursive https://github.com/steinbergmedia/vst3sdk.git "$VST3_SDK_DIR"
fi

echo "==> Configuring"
cmake -S "$VST3_SDK_DIR" -B "$VST3_SDK_DIR/build" -G Ninja \
    -DCMAKE_BUILD_TYPE="$VST3_BUILD_TYPE" \
    -DSMTG_CREATE_PLUGIN_LINK="$VST3_PLUGIN_LINK"

echo "==> Building (this takes a few minutes)"
cmake --build "$VST3_SDK_DIR/build" -j"$JOBS"

echo
echo "SDK        : $VST3_SDK_DIR"
echo "Plugins    : $VST3_SDK_DIR/build/VST3/$VST3_BUILD_TYPE/*.vst3"
echo "Tools      : $VST3_SDK_DIR/build/bin/$VST3_BUILD_TYPE (validator, editorhost, moduleinfotool, VST3Inspector)"
echo
echo "Smoke test:"
echo "  $VST3_SDK_DIR/build/bin/$VST3_BUILD_TYPE/validator $VST3_SDK_DIR/build/VST3/$VST3_BUILD_TYPE/again.vst3"
