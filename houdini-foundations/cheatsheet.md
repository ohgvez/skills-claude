# Cheatsheet: decisions and defaults (Houdini Foundations 19.5)

## Decision rules
| Situation | Do | Because |
|---|---|---|
| Surface must look perfectly smooth at render | Render Polygons as Subdivisions (object Render tab) | Karma renders subdiv/NURBS smooth without tessellation settings |
| Need UVs | Add UV nodes before Fuse/Subdivide/Bend | Seams/patches still exist |
| Texture missing in Karma | Check UVs, `$HIP` path, primitive path of the assignment | UVs never exist by default |
| ROP renders nothing | Check camera prim path and Valid Frame Range | Default `/cameras/camera1` may not exist |
| Viewport denoise clean, disk render noisy | Set denoiser on Karma Render Settings > Image Output > Filters | Viewport setting does not carry over |
| Lighting a cached sim | Reference USD in Solaris | No resim while lighting |
| Fast projectile misses/tunnels | Raise solver substeps (book: +5 on AutoDopNet) | Bullet default too coarse |
| Shape must be round after subdivide | Ray onto sphere | Subdivide alone stays faceted |
| Need to keep node output stable | End with a `_OUT` null | Stable target for Object Merge |
| Karma XPU | USD Preview / MaterialX only; not VEX | Book, 19.5 alpha |
| Point-based reveal comes from one side | Sort points along a vector | Order follows point numbers |

## Thresholds and defaults from the book
Glass density 2000, lead 20000; wine IOR 1.3443; bullet velocity 400 m/s along X; crease 0.75; subdivide depth 2; FLIP particle separation 0.05; surface tension 500; Karma primary samples 32 in the destruction example; timeline default 24 fps; MPlay gamma 2.2; principled normal Effect Scale ~0.5.

## Tells and smells
- Object looks wrong → check Display flag.
- Selection moved after upstream change → group by number; switch to named group.
- Sim looks dead after edit → Reset Simulation.
- Shards invisible/single mesh in Solaris → `name` attribute or packed prims.
- Geometry pokes through at handoff frame → delay swap by one frame.

## Version warning
Book targets Houdini 19.5 (Dec 2022). Later versions changed Karma XPU (no longer alpha), renderer/UI details, node versions. Verify node type names and parameter names via introspection before scripting.
