# Chapter 4: Smashing Wine Glass (RBD + FLIP + retime + glass lookdev)

## Core Idea
Combine Bullet RBD and FLIP in one AutoDopNetwork, cache short sims, retime them (slow then reverse), export USD, light and render in Solaris with glass and liquid materials.

## Recipe (values from the book)
- **Glass model**: polygon curve traced over a profile image (Grid snap on for start/end points) → **Revolve** → **Crease** 0.75 on top and base edges → **Subdivide** depth 2 → `GLASS_OUT`.
- **Liquid**: Extract copy of glass, Blast top faces and base, **Reverse** normals, **PolyFill** (Quadrilateral Grid, Tangent Strength 0) to close, PolyExtrude 0.01 (overlap so fluid renders right) → `FLUID_OUT`.
- **Bullet**: Sphere (X axis, radius 0.2,0.125,0.125, columns 12) → Clip → PolyExtrude (front translate Z 0.04, scale 0.7) → delete tip triangles → PolyFill (Quad Grid, Corner Offset 1) → Subdivide 2.
- **Fracture**: Grid drawing surface + Draw Curve → PolyExtrude sheets (divisions 4) → duplicate/rotate sheets → **Mountain** amplitude 0.75 → Object Merge into glass → **Boolean** (B treat as Surface, Operation Shatter (Pieces of A)); Exploded View to inspect. Boolean gives jagged shards; Voronoi Shatter would not.
- **RBD sim**: RBD Convex Proxy shelf tool (Convex Decomposition, Max Concavity 0.05), ground plane, glass Density 2000, bullet Velocity 400,0,0 and Density 20000, pin the base with `active` attribute (group `!171` value `1,0,0,0`, index varies), AutoDopNet **Substeps 5**.
- **FLIP**: FLIP Fluid from Object; Particle Separation 0.05; solver: Add ID Attribute on, Reseed off, Velocity Transfer APIC Swirly, Surface Tension 500.
- **Cache and retime**: Compressed Cache to `$HIP/geo/fluid/` for 10 frames; **Retime** node (By Frame, Scale Velocities on) with keys frame 1→1, 5→1, 10→7, 40→10, 45→1 shaped in the Animation Editor; copy/paste the same Retime onto glass and bullet so timing matches; Particle Fluid Surface (Average Position, Dilate 2, Smooth Laplacian Flow).
- **Glass swap**: Switch with `$F>5 && $F<45` between whole glass and shards; Attribute Delete `name` prim attribute.
- **USD Export** each (`wine_surface.usd`, `wineglass.usd`, `bullet.usd`).
- **Solaris**: Reference nodes with Primitive Path `/geo/$OS`, Merge, backdrop grid 200x200 + Bend, Camera, Environment Light with HDRI `HDRIHaven_skylit_garage_2k.rat`.
- **Materials**: Material Library; Glass gallery materials for glass and wine; wine: Inside IOR 1.3443, Reflectivity 0.2, Transmission Color 0.2,0,0, At Distance 0.3; copper for bullet. Karma Render Settings + OptiX denoiser; output `$HIP/render/wineglass_$F4.exr`.
- **Final quality**: second Karma node, Convergence Mode Variance, more samples, denoiser off; test at low res first.

## Anti-patterns
- Surfacing fluid live in the viewport when caching; cache particles, surface after retime.
- Restarting sims without Reset Simulation.

## Key Takeaways
1. Glass = transmission + IOR (wine 1.3443, glass density 2000 in the sim). Use gallery Glass as a start.
2. Reverse the normals of a shell you intend to close with PolyFill.
3. Copy the same Retime node everywhere for sync.
4. Store lots of disk space for caches.
5. Reference USD in Solaris so lighting never triggers a resim.

## Connects To
ch03 (Karma settings), ch04 (caching/solvers), ch02 (Boolean, Crease, Revolve).
