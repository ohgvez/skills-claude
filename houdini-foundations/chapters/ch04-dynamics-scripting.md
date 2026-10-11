# Chapter 1d: Time, Dynamics, Volumes, Scripting (Overview pp. 28-45)

## Core Idea
Simulations are solver networks (DOPs) usually created by shelf tools and fed by SOP geometry; cache them to disk before lookdev. Scripting is available in three layers: expressions, Python (HOM), VEX.

## Key Concepts
- **Animation**: keyframes `K`, Playbar, Animation Editor (graph, dope sheet, table), Motion FX (CHOP-based: noise, limit, cycle, smooth, lag). Default 24 fps. Flipbook previews viewport frames.
- **Dynamic solvers**: Rigid Body (Bullet), Static, FLIP fluids, Whitewater, **Vellum (cloth, hair, grains, fluids and soft bodies such as balloons)**, POP (particles/grains), Wire, Finite Element, Cloth, SOP Solver, Pyro.
- **Forces**: gravity, drag, uniform, fan, fluid, wind, magnet, vortex.
- **Dynamic Objects**: hold geometry plus density, friction, bounce. Active vs Static; animated/deforming geometry needs Initial Object Type or Use Deforming Geometry.
- **AutoDopNetwork**: created by shelf tools; holds objects, forces, solver, merge, output. Some SOP nodes (e.g. RBD Bullet Solver SOP) hide a DOP network inside.
- **Caching**: Playbar shows the memory cache. For real work write geometry with **File Cache** (bgeo sequences) or sim files from DOPs; then `Load from Disk`.
- **OpenCL (GPU)**: available on POP Grain, Pyro solver (Advanced tab), FLIP (Volume Motion > Solver).
- **Volumes**: voxels; Isooffset; OpenVDB nodes; Cloud FX; volumes hide under colliders, sim fields, fur grooming, heightfields.
- **PDG/TOPs**: task graphs to schedule and distribute work (wedging many variations).
- **HDA**: custom node from a network, saved as `.hda`; Houdini Engine loads it in Maya, 3ds Max, Unity, Unreal.

## Scripting layers
- **Hscript expressions**: any non-plain-number parameter value; `ch()` references; edit with `Alt-E`.
- **Python / HOM**: `hou` module is auto-imported in parameter Python expressions, the Python Shell pane and `hython`; you can also `import hou` in an ordinary Python interpreter to integrate Houdini into scripts. Shelf tools are Python (RMB → Edit Tool). Python States customize viewport interaction; PySide2/PyQt5 panels.
- **VEX**: fast C-like language used by Wrangle nodes (Attribute Wrangle for points/prims, plus channel, volume, deformation wrangles), VEX SOP, shaders (Karma/Mantra), COP VEX filters, VEX CHOP, fur. **VOPs** = node-based VEX; Attribute VOP; parameter VOPs promote sliders. Compile Blocks speed up SOP chains with restrictions.
- **HDK**: C++ plugin kit.

## Mental Models
- Shelf tool first, then dive in: the generated network is the fastest lesson and saves clicks.
- Cache every stage boundary (sim → cache → surface → USD) so later stages never resim.
- Sim scale trade-off: collision accuracy vs simulation time.

## Anti-patterns
- Simulating with too few substeps for fast objects (bullet needed extra substeps).
- Leaving heavy sims uncached while lighting; disk space must be planned.

## Key Takeaways
1. Reset Simulation after changing solver parameters, then Play.
2. Use `Wrangle` for quick attribute math; use VOPs if you prefer nodes.
3. Motion FX Noise + Limit is a quick procedural motion layer.
4. For games, see SideFX Labs tools for real-time-ready conversions.
5. Vellum pressure/soft body behaviour is only *named* here; the book has no inflate recipe.

## Connects To
- **ch07**: RBD + FLIP + retime. **ch08**: pyro + RBD.
