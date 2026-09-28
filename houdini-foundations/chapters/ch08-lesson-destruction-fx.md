# Chapter 5: Destruction FX (bomb, particles, Pyro, Solaris shot)

> Coverage: I read parts 8-11 in depth (Pyro setup tail, USD export, Solaris shot, PyroFX render). Parts 1-7 (model bomb, fuse, animate fuse, animated camera, soot trail, particle sparks, blow up the bomb) are known from the table of contents only.

## Core Idea
Layered shot: fuse, soot, sparks (particles), fracture (RBD), explosion (Pyro). Cache each element to USD, assemble in a LOP network, swap static → exploding bomb by frame, render with two cameras.

## Recipe
- **Pyro collision**: Quick Settings > Setup SDF Collision (`vdbfrompolygons`, voxel size taken from the Pyro Solver); RBD Unpack + Unpack (Transfer Velocity `v`); Peak 0.1 to thicken; Attribute Adjust Vector length scale 2; limit collision range (frames 200-240).
- **Pyro Post Process**: Convert to VDB, 16-bit float, Cull Volume and Resample by `vel`: smaller caches. Cache with Quick Setups > Cache Simulation to `$HIP/geo/pyrosim/`.
- **Pyro Bake Volume** (`pyrolook`) previews in the viewport: dark Smoke Color, Scatter Intensity Scale 2500.
- **Exports**: UV Flatten with a `uv_edges` group and Manual Layout off; Unpack + Attribute Delete `name` prim attribute so a fracture sequence arrives as one mesh; Normal node; `width` 0.0005 attribute on sparks; USD Export each element (static: Render Current Frame; animated: Render Frame Range).
- **Solaris assembly**: `LOP Network` inside obj; Reference nodes (`/geo/$OS`, `/fx/$OS`); **Prune LOP** with `$F>200` on the static bomb and `$F<199` on the exploding one; Scene Import (Cameras) → `/cam/`.
- **Materials**: Principled for bomb/fuse/soot/sparks, Concrete for ground (Effect Scale 0.01); bomb Base Color black, Roughness 0.7, noise displacement (Alligator, freq 30, amp 0.01, rough 0.8); sparks Emission white intensity 10 with Use Point Color (also lights the ground).
- **Karma**: Primary Samples 32, OptiX denoiser, Convergence Mode Path Traced.
- **Pyro render**: Pyro solver Quick Setups > Create Render Stage, copy `rendergeometrysettings` (sets velocity motion blur and lets the volume light the shot); reference `Pyro_Shader` into the Material Library; Prune `$F<201` to avoid poking through the bomb.
- **Camera cut**: ROP 1 frames 1-210 on `/cam/cam1`; ROP 2 frames 211-240 on `/cameras/cam2`; output `$HIP/render/bomb/destruction_fx_$F2.exr`.

## Anti-patterns
- Leaving the default `camera1` path on a ROP when no such camera exists.
- Importing packed geometry with a `name` attribute: sequence splits into parts.

## Key Takeaways
1. Cache every element to USD and assemble late.
2. Use Prune with `$F` to swap elements by frame.
3. Emissive particles light nearby surfaces in Karma.
4. Quick Setups menus on the Pyro solver create post-process, caching and the render stage.
5. Convert volumes to 16-bit VDB to save disk.

## Connects To
ch03 (Karma), ch04 (Pyro/RBD caching), ch07 (USD pipeline).
