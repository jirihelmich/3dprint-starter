# 3D Print Starter — Claude Code + OpenSCAD + Bambu Lab

A starter project for generating parametric 3D-printable models with Claude Code,
authoring them in OpenSCAD, and printing on a Bambu Lab printer.

Tested on the **X1 Carbon** and **P1S** (both enclosed, AMS-capable). Should
work on any Bambu printer that Bambu Studio supports — pick your machine in the
slicer when you import the `.3mf`.

This repo is structured so that Claude Code (running in your terminal or VS Code)
already knows how to add new models, build them, and follow project conventions —
the rules live in [`CLAUDE.md`](CLAUDE.md) and Claude reads them automatically.

---

## Install — pick your platform

You'll install five things: Node.js, Claude Code (CLI), VS Code + the Claude
Code extension, OpenSCAD, and Bambu Studio. Skip whichever you already have.

- 🍎 **[macOS install guide →](docs/install-macos.md)**
- 🪟 **[Windows install guide →](docs/install-windows.md)**

Each guide ends with a quick build of the example model so you know everything's
wired up. Come back here once that works.

---

## Asking Claude to design something new

Open the repo in VS Code, launch Claude (⌘+Esc on macOS, Ctrl+Esc on Windows),
then ask:

> *"Design a wall hook for a coiled garden hose with a 30mm tube diameter, two
> screw holes for M4 screws, and a curved profile that won't kink the hose."*

Claude will:

1. Read [`CLAUDE.md`](CLAUDE.md) to learn the project conventions.
2. Create `models/hose-hook/hose-hook.scad`.
3. Run `make build/hose-hook/hose-hook.stl` to verify it compiles.
4. Tell you when it's ready to slice.

You then open the `.3mf` in Bambu Studio and print it.

### Tips for getting good models

- **Give measurements with units** (mm). Say *"the slot is 5.2 mm wide"*, not *"about 5 mm"*.
- **Describe the print orientation** if you have a preference — Claude will design with that in mind.
- **Mention the loads** ("the bracket holds 2 kg") so Claude picks reasonable wall thickness.
- **Ask for a small test print first** if you're unsure: *"export a 10 mm-tall slice of the cradle to verify the fit before printing the whole thing"*.

---

## Repo layout

```
3dprint-starter/
├── README.md              ← This file
├── CLAUDE.md              ← Project conventions (Claude reads this)
├── Makefile               ← Builds models/*.scad → build/*.stl + .3mf
├── docs/
│   ├── install-macos.md   ← Setup for macOS
│   └── install-windows.md ← Setup for Windows
├── lib/
│   └── common.scad        ← Shared OpenSCAD utilities (tolerance, rounded_cube, …)
└── models/
    └── example/
        └── example.scad   ← Tiny test model
```

When Claude adds a new model `foo`, it'll create `models/foo/foo.scad`, and
running `make` exports it to `build/foo/foo.stl` and `build/foo/foo.3mf`.

---

## Print settings (X1C / P1S — sensible defaults)

| Use case | Layer | Infill | Walls | Filament |
|---|---|---|---|---|
| Prototyping fit-check | 0.28 mm | 10–15 % | 2 | PLA |
| Final mechanical part | 0.20 mm | 20–25 % | 3 | PLA / PETG |
| Heat-exposed part (>60 °C) | 0.20 mm | 25 % | 3 | ABS / ASA (door cracked open) |

For ABS prints requiring supports, the **PLA-as-support-interface** trick gives
the cleanest release: keep ABS as the part body, set the support *interface*
filament to PLA in Bambu Studio (Support → "Use different filament for support"
→ pick the PLA slot). PLA and ABS don't fuse; the supports peel off cleanly.

---

## Useful Claude Code commands

| Command | What it does |
|---|---|
| `/help` | List available commands |
| `/clear` | Clear the conversation |
| `/init` | Generate or update CLAUDE.md based on the current code |
| `/review` | Review a pull request |
| `/exit` | Leave the REPL |

To resume a session from where you left off: `claude --continue`.
