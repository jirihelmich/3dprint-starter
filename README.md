# 3D Print Starter — Claude Code + OpenSCAD + Bambu Lab X1C

A starter project for generating parametric 3D-printable models with Claude Code,
authoring them in OpenSCAD, and printing on a Bambu Lab X1 Carbon.

This repo is structured so that Claude Code (running in your terminal or VS Code)
already knows how to add new models, build them, and follow project conventions —
the rules live in [`CLAUDE.md`](CLAUDE.md) and Claude reads them automatically.

---

## What you'll install

1. **Claude Code** — the AI coding agent (this is the main tool)
2. **VS Code** — your editor
3. **OpenSCAD** — the parametric CAD that Claude writes code for
4. **Bambu Studio** — the slicer for your X1 Carbon
5. **Node.js** — required by Claude Code

You can probably skip whatever you already have.

---

## Step 1 — Install Node.js

Claude Code is distributed as an npm package, so you need Node.

**macOS (recommended via Homebrew):**

```sh
brew install node
```

Verify:

```sh
node --version   # should be v18 or newer
```

---

## Step 2 — Install Claude Code (CLI)

```sh
npm install -g @anthropic-ai/claude-code
```

First-time login (opens a browser):

```sh
claude login
```

Sanity-check it works:

```sh
cd ~                 # any directory
claude               # opens the interactive REPL
```

Type `/exit` (or Ctrl-C twice) to leave.

If `npm install -g` complains about permissions, use `sudo` or fix npm's prefix
to a user-owned directory (`npm config set prefix ~/.npm-global`, then add
`~/.npm-global/bin` to your `PATH`).

---

## Step 3 — Install VS Code + the Claude Code extension

1. Download VS Code: <https://code.visualstudio.com/>
2. Open VS Code → Extensions sidebar (⇧⌘X).
3. Search **"Claude Code"** (publisher: Anthropic).
4. Click **Install**.

To use it: open any folder in VS Code, then hit **⌘ + Esc** (Cmd-Escape) — a
Claude Code panel opens inside the editor. It inherits your terminal login.

The first time, it may ask you to "trust" the workspace — that lets Claude
read/edit files in the project.

---

## Step 4 — Install OpenSCAD

Download from <https://openscad.org/downloads.html> and drag to /Applications.

Verify the binary path — on macOS the installer puts it inside the .app bundle.
For OpenSCAD 2021.01 the path is:

```
/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD
```

For a newer version, adjust accordingly. **Open the [`Makefile`](Makefile) and
update the `OPENSCAD` line at the top if your path is different.**

> Why the full path: the Homebrew symlink (`/usr/local/bin/openscad`) often gets
> blocked by macOS Gatekeeper. Going via the app bundle avoids the
> "openscad cannot be opened" dialog every time.

---

## Step 5 — Install Bambu Studio

Download from <https://bambulab.com/en/download/studio> → install → log in →
add your X1 Carbon → calibrate.

This is the slicer. Claude Code produces `.stl` / `.3mf` mesh files, you load
them into Bambu Studio to slice and send to the printer.

---

## Your first model — verifying the toolchain

A tiny example model lives at [`models/example/example.scad`](models/example/example.scad).
Build it:

```sh
make build/example/example.stl
```

You should get `build/example/example.stl` and `build/example/example.3mf`.
Open the `.3mf` in Bambu Studio — if it shows a 20×20×10 mm parametric clip,
the toolchain works end-to-end.

---

## Asking Claude to design something new

Open the repo in VS Code, launch Claude (⌘+Esc), then ask:

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
├── lib/
│   └── common.scad        ← Shared OpenSCAD utilities (tolerance, rounded_cube, …)
└── models/
    └── example/
        └── example.scad   ← Tiny test model
```

When Claude adds a new model `foo`, it'll create `models/foo/foo.scad`, and
running `make` exports it to `build/foo/foo.stl` and `build/foo/foo.3mf`.

---

## Print settings (Bambu Lab X1C — sensible defaults)

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
