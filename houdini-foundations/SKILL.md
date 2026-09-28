---
name: houdini-foundations
description: "Knowledge base from \"Houdini Foundations for Film, TV & GameDev (v19.5)\" by Robert Magee (SideFX). Use when driving Houdini (including via an MCP/hython), working with SOP nodes, attributes, Solaris/LOPs, Karma rendering, materials, Vellum/RBD/FLIP/Pyro caching, USD export or HDAs."
---

<!-- argument-hint: [topic, node name, or chapter number] -->

# Houdini Foundations (SideFX)
**Author**: Robert Magee | **Pages**: 226 | **Chapters**: 9 (Overview split in 4 files) | **Generated**: 2026-09-28

## How to Use This Skill
- No argument: read Core below.
- Topic: look it up in the Topic Index and read that chapter file first.
- Read the **Coverage** note at the top of ch06, ch08, ch09: those chapters were only partly read.
- This book is a tutorial for 19.5. It has **no recipe for inflated/chrome/balloon typography** (Vellum is only named). Combine with project-specific recipes.

---

## Core Frameworks & Mental Models

**Everything is a node; a network is an editable recipe.** Prototype with simple inputs and swap later. Display flag decides what you see; check it first.

**Attributes carry data down the chain.** Classes: point, primitive, vertex, detail. Inspect with the Geometry Spreadsheet. Blank Group field = everything; prefer named groups over prim numbers.

**Contexts**: OBJ, SOP (geometry), LOP (Solaris/USD), MAT/VOP (materials), DOP (dynamics), CHOP (motion), ROP (outputs), TOP (tasks), COP.

**Pipeline order that the book teaches**: model (SOP) → UVs → sim (DOP) → cache to disk → USD Export → Solaris (Reference, Merge, Prune) → materials (Material Library + Assign Material) → camera/lights → Karma Render Settings + USD Render ROP → MPlay.

**Cache boundaries**: never light or render on top of a live sim. File Cache/Compressed Cache, then USD. Plan disk space.

**Materials**: Principled Shader (Disney BRDF) + textures or MaterialX in a Material Library LOP; Assign Material by primitive path. Glass = transmission + IOR (wine 1.3443). Karma XPU: USD Preview/MaterialX, not VEX.

**Lighting**: dome/Environment Light with an HDRI as base (`$HFS/houdini/pic/hdri` has some), key and specular lights via Light LOP (`Shift-S` specular, `Shift-F` shadow), Light Mixer per shot. Draft low-res with denoiser; final with more samples.

**Shots**: Null `SHOT_xx` + camera + Light Mixer + Karma Render Settings + USD Render ROP; Alt-drag to branch. Retarget material and camera paths.

**Smooth surfaces**: Subdivide node for polygons, or Render Polygons as Subdivisions on the object; Crease keeps sharp edges; `Ray` to project onto a sphere; volumes/VDB can merge shapes and convert back to a surface.

**Scripting**: hscript/Python expressions in parameters; Python via `hou` (auto-imported in expressions, hython, Python Shell); VEX in Wrangles; import `hou` in plain Python to integrate. Shelf tools are Python.

**Anti-patterns**: UV nodes after Fuse/Subdivide/Bend; wrong Display flag; missing camera path on ROP; forgetting to Reset Simulation; hard-coded texture paths (use `$HIP`).

## Chapter Index

| # | Title | Key Frameworks |
|---|-------|----------------|
| [ch01](chapters/ch01-workspace-nodes-attributes.md) | Workspace, nodes, parameters, attributes | node flags, groups, attribute classes, hotkeys |
| [ch02](chapters/ch02-modeling-uv-materials.md) | Modeling, volumes, UVs, materials | subdivision, Boolean shatter, UV nodes, Principled/Layer Mix |
| [ch03](chapters/ch03-solaris-karma-rendering.md) | Solaris, cameras, lights, Karma | USD in LOPs, Light Mixer, Karma settings, denoisers |
| [ch04](chapters/ch04-dynamics-scripting.md) | Time, dynamics, volumes, scripting | solvers, caching, VEX/Python/HOM |
| [ch05](chapters/ch05-lesson-soccerball.md) | Soccer ball lesson | For-Each on attributes, rig, shots |
| [ch06](chapters/ch06-lesson-hda-brickify.md) | Brickify HDA (partial) | HDA interface, lock/test, sort/reveal |
| [ch07](chapters/ch07-lesson-wine-glass.md) | Smashing wine glass | RBD+FLIP, retime, glass material |
| [ch08](chapters/ch08-lesson-destruction-fx.md) | Destruction FX (partial) | Pyro post/cache, Prune by frame, emissive sparks |
| [ch09](chapters/ch09-terrain-kinefx-unreal-pdg.md) | Terrain, KineFX, Unreal, PDG (TOC only) | low coverage |

## Topic Index
- **Attribute Wrangle / VEX** → ch01, ch04
- **Bend / Lattice / Mountain** → ch02, ch05
- **Boolean shatter** → ch02, ch07
- **Camera (focal length, F-stop)** → ch03
- **Caching (File Cache, Compressed Cache)** → ch04, ch07, ch08
- **Crease / Subdivide** → ch02, ch07
- **Denoiser (OptiX, OIDN)** → ch03, ch07
- **Dome light / HDRI** → ch03, ch07
- **FLIP** → ch04, ch07
- **For-Each** → ch05
- **Glass material (IOR, transmission)** → ch07
- **HDA** → ch04, ch06
- **Karma / Karma XPU** → ch03
- **Light Mixer / Light Linker** → ch03, ch05
- **Material Library / Assign Material** → ch02, ch05, ch07
- **Prune LOP** → ch03, ch08
- **Pyro** → ch08
- **Retime** → ch07
- **Scripting / hou / hython** → ch04
- **UV Flatten / UV Project** → ch02, ch05
- **USD Export / Reference** → ch03, ch05, ch07, ch08
- **Vellum (named only)** → ch04
- **Volumes / VDB** → ch02, ch04
- **Terrain / KineFX / PDG** → ch09 (low coverage)

## Supporting Files
- [glossary.md](glossary.md)
- [patterns.md](patterns.md)
- [cheatsheet.md](cheatsheet.md)

---

## Scope & Limits
Covers the book only (Houdini 19.5, Dec 2022); newer versions differ, verify node/parameter names by introspection. ch06, ch08, ch09 are partial. Source PDF: `C:\Users\federico\Downloads\houdini_foundations_19_5_01.pdf`.
