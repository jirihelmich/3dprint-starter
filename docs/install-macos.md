# Install on macOS

Step-by-step setup for macOS (Intel or Apple Silicon).

## 1 — Install Node.js

Claude Code is distributed as an npm package, so you need Node.

**Recommended via Homebrew:**

```sh
brew install node
```

Verify:

```sh
node --version   # should be v18 or newer
```

If you don't have Homebrew, install it first from <https://brew.sh/>.

## 2 — Install Claude Code (CLI)

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

## 3 — Install VS Code + the Claude Code extension

1. Download VS Code: <https://code.visualstudio.com/>
2. Open VS Code → Extensions sidebar (⇧⌘X).
3. Search **"Claude Code"** (publisher: Anthropic).
4. Click **Install**.

To use it: open any folder in VS Code, then hit **⌘ + Esc** (Cmd-Escape) — a
Claude Code panel opens inside the editor. It inherits your terminal login.

The first time, it may ask you to "trust" the workspace — that lets Claude
read/edit files in the project.

## 4 — Install OpenSCAD

Download from <https://openscad.org/downloads.html> and drag the app into
`/Applications`.

Verify the binary path — on macOS the installer puts it inside the .app bundle.
For OpenSCAD 2021.01 the path is:

```
/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD
```

For a newer version, adjust accordingly. **Open the [`Makefile`](../Makefile) and
update the `OPENSCAD` line at the top if your path is different.**

> Why the full path: the Homebrew symlink (`/usr/local/bin/openscad`) often gets
> blocked by macOS Gatekeeper. Going via the app bundle avoids the
> "openscad cannot be opened" dialog every time.

## 5 — Install Bambu Studio

Download from <https://bambulab.com/en/download/studio> → install → log in →
add your Bambu Lab printer → calibrate.

This is the slicer. Claude Code produces `.stl` / `.3mf` mesh files; you load
them into Bambu Studio to slice and send to the printer.

## 6 — Verify the toolchain

From the repo root:

```sh
make build/example/example.stl
```

You should get `build/example/example.stl` and `build/example/example.3mf`.
Open the `.3mf` in Bambu Studio — if it shows a small parametric cable clip,
everything is wired up correctly.

Now head back to the [main README](../README.md#asking-claude-to-design-something-new)
to start designing.
