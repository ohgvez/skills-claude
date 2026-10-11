# Chapter 1c: Solaris, Cameras, Lights, Rendering (Overview pp. 22-27)

## Core Idea
Solaris (`/stage`, LOP nodes) builds a USD scene graph for layout, lookdev and lighting; Karma renders that stage in the viewport and to disk.

## Frameworks Introduced
- **USD in LOPs**: references, payloads, layers, variants, collections. Everything in the stage is USD; you cannot delete prims, only hide/deactivate (Prune LOP does this with expressions like `$F>200`).
- **Getting content in**: `Scene Import` LOP (use *Force Objects* to import even if display flag is off), `Reference`/`Sublayer` LOP for USD files (Primitive Path like `/geo/$OS`), `Stage Manager`, `Edit LOP` (non-destructive layer, optional Use Physics), `Instance LOP`, `Component Builder`, USD Export SOP to make assets.
- **Lights (Light LOP types)**: Point, Spot, Area (line, tube, grid, disk, sphere), Geometry Light, Distant, Environment (dome). Light Linker LOP connects lights to objects; Light Mixer LOP tweaks intensity/exposure/colour per shot without touching the originals.

## Key Concepts
- **Camera parameters**: Focal Length, Horizontal/Vertical Aperture, Shutter Open/Close (motion blur), Focus Distance, F-Stop (default 0 = depth of field off). `Shift-F` shows the focal plane.
- **Lock camera to view**: lets viewport navigation move the camera. Turn it off afterwards or a view change moves the camera.
- **Light placement in the camera view**: with the Light node selected, `Shift-S` specular, `Shift-D` diffuse, `Shift-F` shadow; click surfaces; `Ctrl-drag` distance; `Ctrl-Shift-drag` brightness.
- **Karma**: physically based ray tracer for USD, CPU; includes adaptive tessellation, subdivision, multi-segment motion blur, instancing, fur, volumes. Runs interactively in the viewport (Persp menu → Karma). **Karma XPU** = hybrid GPU/CPU engine; in Houdini 19.5 it was alpha/testing only.
- **Karma Render Settings LOP + USD Render ROP**: settings become part of the scene graph and override viewport settings. Set frame range ("Render Frame Range"), camera path, output picture, denoiser, samples.
- **Denoisers**: NVIDIA OptiX (viewport and disk, NVIDIA GPU), Intel OIDN (disk only). The viewport denoiser does NOT carry to the ROP: set it again under Image Output > Filters.
- **Render Gallery**: snapshots restore full look settings. **AOVs/Image Planes**: direct, indirect, shadows, depth for compositing. **MPlay**: viewer (default gamma 2.2), load sequences with Render > MPlay > Load Disk Files.
- **Other Hydra renderers**: RenderMan, Arnold, V-Ray, Redshift, ProRender via USD. Mantra is the legacy non-Solaris renderer.

## Mental Models
- Layout once, shot per branch: put shared backdrop/lights/materials above, branch each shot with its own Null (SHOT_01), camera, Light Mixer, Karma settings and ROP.
- Test low, finish high: draft at low resolution, then a second Karma node with more samples, Convergence Mode Variance, denoiser off if desired.

## Anti-patterns
- **Rendering with a camera that does not exist**: default camera path is `/cameras/camera1`; set the right prim path or the ROP renders nothing.
- **Forgetting to reassign materials when the primitive path changes** (e.g. `/soccerball_geo` vs `/soccerball_anim`).
- **Leaving Lock Camera on.**

## Key Takeaways
1. Everything in Solaris is USD; inspect with LOP Actions > Inspect Active Layer.
2. Use `$F` in output names with padding: `render/name_$F4.exr`.
3. Environment Light/dome + HDRI (e.g. `$HFS/houdini/pic/hdri`) is the base light; add key/spec lights via Light LOP.
4. Shots share nodes by Alt-dragging the Null, Karma settings and ROP chain.
5. Viewport render settings apply until a Karma Render Settings node exists.

## Connects To
- **ch02**: materials. **ch07**: full lookdev and render of a sim. **ch08**: pyro rendering and velocity motion blur.
