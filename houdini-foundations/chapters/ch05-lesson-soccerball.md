# Chapter 2: Model, Render, Animate (soccer ball lesson)

## Core Idea
A start-to-finish scene: model, UV, light, texture, render with Karma, rig and animate, then simulate. Best single reference for the full Houdini pipeline order.

## Recipe (values from the book)
1. **Project**: File > Set Project, Save As `.hip`. Textures in `$HIP/tex`.
2. **Model**: Platonic Solids (Solid Type Soccer Ball) → Subdivide → **Ray** node (second input: Sphere radius 1,1,1, primitive type Primitive) to make it truly round → PolyExtrude.
3. **For-Each loop**: Attribute Create `patches` (Class Primitive, value `@primnum`) right after the platonic node; `For-each Named Primitive` begin/end around PolyExtrude; end node Piece Attribute `patches`; PolyExtrude Divide Into = Connected Components; Distance 0.1, Inset -0.02; then Fuse, Subdivide depth 2. Single Pass checkbox previews the loop one piece at a time.
4. **UVs**: UV Quickshade to preview, UV Flatten with group `@patches>19` (dark) and `@patches<20` (light) before Fuse; pin a vertex, Repack; bypass quickshade; end with `GEOMETRY_OUT` null. Object render tab: Render Polygons as Subdivisions.
5. **Solaris**: Match Size (Justify Y = Min) → Scene Import (Force Objects) → backdrop (Grid 80x80 + Bend 75, capture origin 0,0,-30, dir 0,0,-1, length 5 + Subdivide 2) → Camera (Alt-click shelf tool to match view) → Environment Light intensity 0.5 → Point Light (Shift-F shadow mode) → Light (Shift-S specular) → Light Mixer.
6. **Materials**: Material Library → two Principled Shaders (`soccerball_mat`, `backdrop_mat`), textures via `$HIP` for base colour, roughness, reflectivity, normal (Effect Scale ~0.5); Assign Material with Primitives and Material Path; UV Project on backdrop before Bend (V Range 0,-1).
7. **Render**: Karma Render Settings (denoiser OptiX) + USD Render ROP → Render to MPlay.
8. **Rig**: copy object, Null controls (`soccerball_ctrl` circles, `squash_ctrl` box), roll rotation from translation `-ch("../../soccerball_ctrl/tx")*360/(2*$PI*1.1)`, Bend node driven by squash control (Length Scale + 1, Preserve Volume), lock unused channels.
9. **Animate**: range 120 frames; keys with K; untie handles at contact for sharp bounces; Motion FX Noise (Amplitude 1) + Limit (0 to 6); keyframe amplitude with Constant curve.
10. **Shot 2**: Extract → USD Export (Valid Frame Range = Render Frame Range) → Reference LOP; retarget material path; new camera; copy Null/Karma/ROP; output `$HIP/render/anim/name_$F2.exr`.
11. **Sim**: Extract, Match Size, Box (center 0,8,0, rotate 45, uniform scale 6, axis divisions 3) → Mountain jitter → Copy to Points with Pack and Instance → RBD Bullet Solver SOP (ground plane, Bounce 0.8, Density 10) → USD Export → third shot.

## Anti-patterns
- Flip the order of Subdivide vs PolyExtrude and you get a flat-faced polyhedron instead of leather-like patches.
- Editing the original geo used by SHOT 1 when building the rig: copy it first.

## Key Takeaways
1. Use attributes (`@primnum`) + For-Each to operate on patches independently.
2. Put UV nodes where the seams still exist.
3. Reference-copy shots by Alt-dragging the Null + Karma + ROP chain.
4. Rig with locked Null controls so animators only see what they need.
5. Cache to USD between geometry and Solaris stages.

## Connects To
ch03 (Solaris/Karma details), ch04 (dynamics), ch06 (HDAs).
