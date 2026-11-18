---
name: cli-anything
description: >-
  Build an agent-native CLI ("harness") for any GUI application or codebase with the CLI-Anything
  7-phase method (HKUDS/CLI-Anything). Use when the user says /cli-anything, wants to make a program
  usable by AI agents through a command line, or wants to refine, test, validate or list
  CLI-Anything harnesses. For installing ready-made CLIs, use cli-hub-meta-skill instead.
---

# CLI-Anything (local wrapper)

Wrapper for the `cli-anything` Claude Code plugin, read from the local clone so it stays updated with
`git pull`. Plugin root:

`C:\Users\Federico\Desktop\PROGETTI AI\CLI-Anything\cli-anything-plugin`

Treat that folder as `./` in everything below (paths like `./HARNESS.md` and `../guides/...` are
relative to it or to its `commands/` folder).

## Pick the sub-command from the arguments

| User asks | Read and follow |
|---|---|
| `/cli-anything <path-or-repo>` (build a new harness) | `commands/cli-anything.md` |
| `refine <path> [focus]` | `commands/refine.md` |
| `test <path-or-repo>` | `commands/test.md` |
| `validate <path-or-repo>` | `commands/validate.md` |
| `list [--path …]` | `commands/list.md` |

Always read `HARNESS.md` (plugin root) first: it is the source of truth. Guides in `guides/`, templates
in `templates/`, helpers `repl_skin.py`, `skill_generator.py`, `preview_bundle.py`.

## Local setup on this PC

- Python: create a venv per harness (never `pip install --user`: from this app it lands in the AppX
  cache and is invisible to the user's own terminal).
- Ready-made CLIs are managed with `cli-hub` (already installed, see cli-hub-meta-skill).
- Clone target repos into `C:\Users\Federico\Desktop\PROGETTI AI\`.
