# Chapter 1b: Modeling, Volumes, UVs, Materials (Overview pp. 16-21)

## Core Idea
Model with SOP nodes (each edit is a node), give the geometry UVs yourself (none by default), then assign materials in Solaris using the Principled Shader or MaterialX.

## Key Concepts
- **Creation**: primitives (box, sphere, tube, torus, platonic), grid, curve, PolyDraw.
- **Poly tools**: PolyExtrude (distance, inset, divide into individual elements vs connected components), PolyBevel, PolyBridge, PolySplit/EdgeLoop, PolyReduce, PointWeld, Blast (delete), Dissolve, Clip, Mirror, Fuse.
- **Subdivision**: Subdivide node adds real polygons; the object Render tab option renders polygons as subdivision surfaces (OpenSubdiv) so they are perfectly smooth at render time. Crease node keeps edges sharper (glass: crease 0.75, subdivide depth 2).
- **Surfacing from curves**: Revolve, Skin, Rails.
- **Boolean**: union/subtract/intersect and **Shatter (Pieces of A)** using sheet surfaces; outputs groups you can feed to PolyBevel.
- **Deformers**: Bend (capture region, length scale, preserve volume), Lattice, Mountain (noise moves points), Ripple, Waves, Ray (project points onto another geometry).
- **Copy to Points + Scatter & Align**: standard scattering; attributes drive scale/rotation. "Pack and Instance" option makes sims faster.
- **Volumes/VDB**: shapes can be merged into one volume then converted back to a surface (book cites this as a modeling technique). `Isooffset` turns closed polygons into a volume (fog or tetra mesh).
- **UVs**: not present on any geometry, even primitives. Nodes: UV Project (Initialize button first), UV Flatten (seams from edge groups, pins, Repack), UV Layout (island packing, UDIM tiles), UV Quickshade (preview only), UVEdit/UVTransform, Attribute Transfer to move UVs after topology change. UV sets: `uv`, `uv2`, any name.
- **Materials**: live in `/mat` or inside a **Material Library LOP** (VEX Builder). Principled Shader = Disney principled BRDF, accepts textures directly (base colour, roughness, reflectivity, bump/normal, displacement). MaterialX for Karma. **Layer Mix** blends two materials by an alpha; Collapse Selected into Material makes a material builder. Shader FX menu (icon at right of a parameter) creates VOPs in context. Materials can be saved as HDAs.
- **Assignment**: Assign Material LOP (Primitives path + Material Path; plus button for more rows). Material Variation LOP for procedural assignment. Mantra used stylesheets instead.

## Anti-patterns
- **Placing UV nodes after Fuse/Subdivide**: patch boundaries are lost. Put UV Flatten before the fuse so the seams exist.
- **Setting UV projection after a Bend**: create UVs before deforming (backdrop: UV Project between Grid and Bend).
- **Hard-coding absolute texture paths**: use `$HIP` relative paths.

## Worked Example
Layered look: shiny metal + matte rust → Layer Mix, feed a noise-based alpha via VOPs, choose to mix surface, displacement, or both.

## Key Takeaways
1. Add UVs explicitly and early; check distortion in the UV viewport.
2. Smoothness at render comes from subdivision surface option, not tessellation settings.
3. Karma XPU works with USD Preview Surface and MaterialX, NOT VEX materials.
4. Use `Ray` to project a subdivided shape onto a true sphere for roundness.
5. Bevel/crease before subdivide controls edge sharpness.

## Connects To
- **ch03**: materials get assigned and rendered in Solaris.
- **ch07**: glass and metal materials in a finished shot.
