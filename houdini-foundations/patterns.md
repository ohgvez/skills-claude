# Patterns (Houdini Foundations 19.5)

## Project-safe file layout
**When**: any shot. **How**: File > Set Project; `$HIP/tex`, `$HIP/geo`, `$HIP/usd`, `$HIP/render`, `$HIP/hda`; use `$HIP` in every path. **Trade-off**: none; keeps scenes portable.

## Shelf tool then read the network
**When**: setting up sims, cameras, lights. **How**: use the shelf, dive in, learn the nodes. **Trade-off**: shelf defaults may need tuning.

## Cache boundary
**When**: sim → lighting. **How**: sim → File Cache/Compressed Cache → (surface) → USD Export → Reference in LOPs. **Trade-off**: disk space, resim needed to change the sim.

## Shot branching in Solaris
**When**: several shots share assets. **How**: shared backdrop/lights/materials above; per shot: Null `SHOT_xx`, camera, Light Mixer, Karma Render Settings, USD Render ROP (Alt-drag copies). **Trade-off**: paths must be retargeted (materials, camera).

## Per-piece operation with For-Each
**When**: apply an operation to sub-pieces of subdivided geometry. **How**: Attribute Create with `@primnum` before subdividing; For-Each Named Primitive on that attribute. **Trade-off**: slower than a single pass.

## Shatter with sheets
**When**: jagged breakage (glass). **How**: sheets from curves + PolyExtrude + Mountain; Boolean Shatter (Pieces of A); Convex Proxy for Bullet. **Trade-off**: heavier than Voronoi.

## Time remapping
**When**: slow motion / reverse of a short sim. **How**: cache short sim; Retime keyed frames; copy the same Retime to all elements. **Trade-off**: scale velocities for motion blur.

## Swap by frame
**When**: element changes state mid-shot. **How**: Prune LOP `$F>N` / `$F<N`, or SOP Switch `$F>5 && $F<45`. **Trade-off**: overlap frames can poke through (add a 1-frame delay).

## Digital asset with interface
**When**: reusable tool. **How**: New Digital Asset From Selection; promote parameters; menus; Disable When; Lock; test instance. **Trade-off**: host apps may drop colour/animation.

## Draft-then-final render
**When**: any render. **How**: low res + denoiser first; final node: more samples, Convergence Variance. **Trade-off**: denoiser can smear detail.
