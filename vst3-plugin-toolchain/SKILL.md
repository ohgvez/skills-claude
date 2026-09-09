---
name: vst3-plugin-toolchain
description: Set up the Steinberg VST3 SDK and build audio plugins (.vst3) on Windows, macOS or Linux. Use this skill when the user wants to create, build, validate or debug a VST3 plugin, install the VST3 SDK, or set up a plugin build environment with CMake.
---

# VST3 Plugin Toolchain

Everything needed to compile a VST3 audio plugin from source: the Steinberg VST3
SDK, a C++17 compiler, CMake, and the SDK's own `validator` to check the result.

## What the toolchain consists of

| Piece | Role |
| --- | --- |
| VST3 SDK (`github.com/steinbergmedia/vst3sdk`) | `pluginterfaces` (the COM-like API), `base`, `public.sdk` (helper classes, hosting), `vstgui4` (plugin GUI framework) |
| CMake ≥ 3.25 + Ninja/VS/Xcode | build system, generates the `.vst3` bundle layout |
| C++17 compiler | MSVC 2022 / Apple Clang / GCC 12+ |
| `validator` | built by the SDK; runs the official conformance test suite on a plugin |
| `editorhost`, `VST3Inspector`, `moduleinfotool` | run a plugin without a DAW, inspect it, generate `moduleinfo.json` |

The SDK is **MIT licensed** (since the 2026 relicensing — GPLv3 and the
proprietary Steinberg license are no longer offered). VSTGUI carries its own
Steinberg license, and the "VST" name and logo remain Steinberg trademarks with
their own usage rules.

## Install

### Windows

1. Visual Studio 2022 with the "Desktop development with C++" workload
   (includes MSVC and a bundled CMake), plus Git for Windows.
2. Clone with submodules — the SDK is useless without them:

   ```powershell
   git clone --recursive https://github.com/steinbergmedia/vst3sdk.git C:\SDKs\vst3sdk
   ```

3. Configure and build:

   ```powershell
   cd C:\SDKs\vst3sdk
   cmake -B build -G "Visual Studio 17 2022" -A x64 -DSMTG_CREATE_PLUGIN_LINK=ON
   cmake --build build --config Release
   ```

   `SMTG_CREATE_PLUGIN_LINK=ON` makes the build drop a link to each built bundle
   in `%LOCALAPPDATA%\Programs\Common\VST3`, so DAWs see it immediately.

### macOS

Xcode + command line tools, then the same clone, with
`cmake -B build -G Xcode` and `cmake --build build --config Release`.

### Linux

Run [`scripts/setup-vst3-toolchain.sh`](scripts/setup-vst3-toolchain.sh). It
installs the X11/xcb/cairo/gtkmm development packages VSTGUI needs, clones the
SDK, configures with Ninja and builds. Override `VST3_SDK_DIR` to choose where
it lands (default `/opt/toolchains/vst3sdk`).

## Build outputs

```
build/VST3/Release/*.vst3          # plugin bundles (19 examples ship with the SDK)
build/bin/Release/validator        # conformance test runner
build/bin/Release/editorhost       # minimal host, opens a plugin's editor
build/bin/Release/VST3Inspector
build/bin/Release/moduleinfotool
```

On Linux a `.vst3` is a *directory* (`x.vst3/Contents/x86_64-linux/x.so`), not a
single file. Installed plugins live in `~/.vst3` (Linux),
`~/Library/Audio/Plug-Ins/VST3` (macOS), `%LOCALAPPDATA%\Programs\Common\VST3`
or `C:\Program Files\Common Files\VST3` (Windows).

## Validate a plugin

```bash
build/bin/Release/validator build/VST3/Release/again.vst3
```

The suite covers ~47 checks (parameter handling, bus arrangements, state
save/restore, process setup, silence flags). A plugin that fails here will
misbehave in real DAWs — run it after every meaningful change.

## Starting a new plugin

The fastest route is to copy an SDK example and rename it:

- `public.sdk/samples/vst/again` — minimal gain plugin, the canonical starting point
- `public.sdk/samples/vst/note_expression_synth` — instrument with a GUI
- `public.sdk/samples/vst/adelay` — parameter automation and state handling

A plugin needs, at minimum:

1. A processor class deriving from `AudioEffect` (`process()`, `setupProcessing()`,
   `setState()`/`getState()`).
2. A controller class deriving from `EditControllerEx1` (parameters, editor).
3. A factory in `factory.cpp` declaring both classes with fixed, unique FUIDs —
   generate new ones per plugin, never reuse an example's.
4. A `CMakeLists.txt` calling `smtg_add_vst3plugin(<target> <sources>)`, plus
   `smtg_target_configure_version_file` and, if there is a GUI,
   `smtg_target_add_plugin_resources`.

Point your own project at the SDK with
`add_subdirectory(<vst3sdk path> ${CMAKE_BINARY_DIR}/vst3sdk)` and call
`smtg_enable_vst3_sdk()` before declaring targets.

## Notes and gotchas

- Always clone with `--recursive`. A missing `vstgui4` submodule fails at
  configure time with confusing CMake errors.
- The real-time `process()` call must not allocate, lock, or do file I/O.
- Parameter values crossing the API are always normalized to `[0, 1]`.
- Rebuild with `-DSMTG_CREATE_PLUGIN_LINK=OFF` in containers and CI; the link
  step is pointless there and can fail without a home directory.
