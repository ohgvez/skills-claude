# Chapters 6-9: Terrain, KineFX + Fur, Procedural Assets for Unreal, City with PDG

> Coverage: LOW. Only Terrain part 1 was read. KineFX, Unreal and PDG lessons are known ONLY from the table of contents. Do not invent parameter values from this file; re-read the PDF pages listed before use. PDF: `houdini_foundations_19_5_01.pdf` (Downloads), pages per the book's numbering.

## Ch6 Terrain Generation (p.133)
Steps: Shape terrain with Heightfields; mask layers; remap and erode; scatter points; open in Unreal.
Read: HeightField 1000x1000 grid spacing 2 → Noise (Worley Cellular F1, amplitude 360) → Blur radius 20 → Distort (amp 40, element size 220) → Noise (amp 10, size 20). Mask by Feature (slope 35-60). Slump erosion (75 iterations) writes Mask, Flow, Flow Direction layers. Heights are 2D volumes; `height` and `mask` are default layers; nodes take a mask on the second input.

## Ch7 KineFX Rigging | Fur Dude (p.141)
Draw skeleton; capture geometry; more bones; joint orientation; attach capture geometry; paint capture weights; rigid geometry capture; capture rig asset; animation rig asset; control joints; main controls; IK legs; reverse foot; promote leg/spine controls; eye controls; animate; add & groom fur; set up and render the shot. Overview facts: KineFX treats joints as points with edges, works in SOPs, imports FBX; Bone Capture Biharmonic reduces weight painting.

## Ch8 Procedural Assets for Unreal (p.181)
Simple building HDA; import into Unreal (Houdini Engine); Copy to Points; another HDA; instancing; geometry drives asset; import RBD sim into Unreal.

## Ch9 Build a City with PDG (p.197)
City grid; generate and display work items; add attributes; buildings; combine; isolate a building; wedge the city core; streets; wedge four maps; render a mosaic; scale up.

## Use when
Only if the task is terrain, character rigging, game-engine assets or PDG wedging. Otherwise ignore.
