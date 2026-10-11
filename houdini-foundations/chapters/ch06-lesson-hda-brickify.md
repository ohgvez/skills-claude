# Chapter 3: Nodes, Networks and Digital Assets (Brickify)

> Coverage: I read parts 4-8 in depth. Parts 1-3 (single brick, copy bricks to a point cloud, add color and switch to a teapot) are known only from the table of contents plus the recap lines in later parts.

## Core Idea
Build a working network (copy a brick to points sampled from a shape), wrap it into a Houdini Digital Asset, expose a clean interface, lock it, test it, animate it.

## Recipe
- Point cloud from geometry (`pointsfromvolume`), Copy to Points with bricks; **Attribute Promote** vertex `Cd` to point, **Attribute Transfer** to copy colour to the cloud; **Switch** nodes for alternatives; turn off "Transform Using Target Point Orientation" to keep bricks straight.
- **Create asset**: select nodes → Assets > New Digital Asset From Selection; name `brickify`; save in `$HIP/hda`. Type Properties: Minimum Input 0, Maximum 1; press **Apply** (Accept closes the window).
- **Promote parameters**: drag a node's parameter into the asset's parameter list; edit Name/Label; Menu tab for dropdowns (tokens 0/1); **Disable When** e.g. `{ look != 0 }`; defaults on the Channels tab (default texture `Mandril.pic` is always available).
- **Lock Asset** so only the interface can be used; unlock to edit; **Save Asset** writes the `.hda`.
- **Test asset** on a second geometry (Squab test geometry); Extra Files tab can embed textures.
- **Animate**: Group by Range with Length `($F-1)*ch("../build_speed")` → Blast (Delete Non Selected); **Sort** along vector `0,1,0` so points appear bottom-up; Switch `animation_switch`; toggle parameter Animate Bricks; integer Build Speed (range 1-20).
- **Houdini Engine** plug-ins load the HDA in Maya, 3ds Max, Unity, Unreal. Colours and time-based animation may not survive in game engines.

## Anti-patterns
- Pressing Accept when you meant Apply (closes the dialog).
- Forgetting an `output` node so the asset returns the wrong branch when display flag is elsewhere.
- Relying on animation in a host that cannot play it (Unity/Unreal runtime).

## Key Takeaways
1. An HDA is a `.hda` file referenced into scenes; edits to it update all shots.
2. Build one working asset and one test instance.
3. Menus + Disable When make a self-explaining interface.
4. Sorting points controls the order of any point-count-based reveal.
5. Locking prevents accidental edits to the inside.

## Connects To
ch01 (attributes), ch04 (HDA/Engine mention).
