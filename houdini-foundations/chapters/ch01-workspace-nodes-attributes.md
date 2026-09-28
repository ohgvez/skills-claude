# Chapter 1a: Workspace, Nodes, Parameters, Attributes (Overview pp. 1-15)

## Core Idea
Everything in Houdini is a node; nodes wire into networks that are a re-editable "recipe". Data travels down the chain as **attributes**. Change a parameter upstream and everything downstream recooks.

## Frameworks Introduced
- **Procedural / directable workflow**: every action stores a node; edits deep in the chain cascade to the result.
  - When to use: always; prototype with a simple input and swap it later (e.g. box → platonic solid).
- **Network types (contexts)**: OBJ scene, SOP geometry, LOP Solaris/USD, MAT/VOP materials and VEX, CHOP motion, ROP outputs, TOP tasks, DOP dynamics, COP compositing.
- **Node flags**: Display `R` (hollow ring), Render `T` (solid circle), Template `E`, Bypass `B`, Freeze (caches this node, ignores earlier nodes).

## Key Concepts
- **Parameter**: value/slider/checkbox on a node (what other apps call attribute). Changed-from-default values are bold; animated = green; locked = grey.
- **Attribute**: data attached to geometry. Classes: Point, Primitive, Vertex, Detail. Types: float, int, string, vector... Examples: `Cd` colour, `uv`, `N`, velocity, capture weights, `fuel` for Pyro.
- **Group**: named selection of points/prims/edges. Blank Group field on a node = operate on everything (survives topology change).
- **Channel**: an animated/referenced parameter. `ch("../../ctrl/tx")` is a channel reference.
- **Geometry Spreadsheet** `Alt-8`: shows every attribute value at the node currently selected. First stop when data looks wrong.
- **Attribute nodes**: Attribute Create, Randomize, Transfer (copy by proximity, uses Distance Threshold), Promote, Delete, Wrangle (VEX), Attribute VOP.

## Mental Models
- Think of a network as a history log you can edit; selecting an earlier node lets you tweak it while the display flag stays on the end.
- Use a `null` named `GEOMETRY_OUT` (or `..._OUT`) at the end of a chain: stable reference point for other networks and Object Merge.
- Use `Object Merge` (Transform: Into Specified Object) to pull geometry from another object.

## Anti-patterns
- **Forgetting the Display flag**: what you see at object level is whatever node has it. The book repeats: always check it.
- **Editing shelf-created nodes blindly**: shelf tools build node networks worth reading to learn from.
- **Moving points on generated geometry**: creates an Edit node keyed to point numbers; if upstream topology changes the edit lands somewhere else. Re-select via Handle tool + backtick.

## Hotkeys worth knowing
Radial menus `X` snap, `C` main, `V` views. `Tab` node menu (type to filter). Panes: Scene `Alt-1`, Network `Alt-2`, Params `Alt-3`, Tree `Alt-4`, Anim editor `Alt-6`, Material Palette `Alt-7`, Geo Spreadsheet `Alt-8`, Render View `Alt-9`. Dive in `I`, up `U`, toggle Obj/Geo `F8`. Selection modes `1` objects, `2` points, `3` edges, `4` prims, `5` vertices. `S` select, `Enter` handle tool, `N` select all/none, `Y` cut wire, `J` connect, `Alt+drag` copy node. Keyframe `K` or `Alt+click` a parameter. Expression editor `Alt-E`. `Spacebar+H/A/G` home grid/all/selected. `D` viewport display options, `W` wireframe toggle. Node Info Box: MMB on node.

## Worked Example
Poly Extrude on selected faces: prims 5,6,9,10 appear in the node's Group field. If upstream changes topology, those numbers point at different faces; fix by re-selecting or by using a named Group node.

## Key Takeaways
1. Read attributes in the Geometry Spreadsheet before guessing.
2. Blank group = all; named groups survive topology change better than numbers.
3. Expressions can be hscript or Python; `hou` is auto-imported in Python expressions and hython.
4. Right-click parameter → Copy Parameter, then Paste Relative References builds a `ch()` link.
5. Save reusable network chunks to a Gallery or turn them into an HDA.

## Connects To
- **ch02**: modeling and materials use the attributes defined here.
- **ch04**: scripting layers (VEX, HOM) operate on these attributes.
