# Install on Windows

Step-by-step setup for Windows 10 / 11. All commands run in **PowerShell**
unless noted otherwise.

> **TL;DR for the impatient:** if you already have a Linux mindset, install
> WSL2 + Ubuntu and follow the [macOS guide](install-macos.md) inside it —
> the commands translate 1:1. The guide below covers the native Windows path
> instead.

## 1 — Install Node.js

Claude Code is distributed as an npm package, so you need Node.

**Recommended via winget (built into Windows 10/11):**

```powershell
winget install OpenJS.NodeJS.LTS
```

Close and reopen PowerShell, then verify:

```powershell
node --version   # should be v18 or newer
```

Alternative: download the LTS installer from <https://nodejs.org/>.

## 2 — Install Git for Windows

Needed for cloning repos and gives you Git Bash (a Unix-like shell that
matters in step 6).

```powershell
winget install Git.Git
```

## 3 — Install Claude Code (CLI)

In PowerShell:

```powershell
npm install -g @anthropic-ai/claude-code
```

First-time login (opens a browser):

```powershell
claude login
```

Sanity-check:

```powershell
cd ~
claude          # opens the interactive REPL
```

Type `/exit` (or Ctrl-C twice) to leave.

> **Antivirus note**: some AV products flag globally-installed npm packages
> as suspicious. If `claude` won't launch, check your AV quarantine and
> whitelist `%APPDATA%\npm\claude.cmd` and `%APPDATA%\npm\node_modules\@anthropic-ai`.

## 4 — Install VS Code + the Claude Code extension

```powershell
winget install Microsoft.VisualStudioCode
```

Then:

1. Open VS Code → Extensions sidebar (Ctrl+Shift+X).
2. Search **"Claude Code"** (publisher: Anthropic).
3. Click **Install**.

To use it: open any folder in VS Code, then hit **Ctrl + Esc** — a Claude Code
panel opens inside the editor. It inherits your terminal login.

## 5 — Install OpenSCAD

```powershell
winget install OpenSCAD.OpenSCAD
```

Or download from <https://openscad.org/downloads.html>.

The binary lands at:

```
C:\Program Files\OpenSCAD\openscad.exe
```

**Open the [`Makefile`](../Makefile) and update the `OPENSCAD` line at the top:**

```makefile
OPENSCAD := "C:/Program Files/OpenSCAD/openscad.exe"
```

(Forward slashes work fine for `make`; the quotes handle the space.)

## 6 — Install `make`

The Makefile expects GNU `make`, which Windows doesn't ship. Two easy options:

**Option A — Chocolatey (recommended if you'll do more dev work):**

Install Chocolatey from <https://chocolatey.org/install>, then:

```powershell
choco install make
```

Verify:

```powershell
make --version
```

**Option B — Skip `make` and build directly:**

If you'd rather not install `make`, run OpenSCAD directly. From the repo root,
in PowerShell:

```powershell
mkdir build\example -Force
& "C:\Program Files\OpenSCAD\openscad.exe" -o build\example\example.stl models\example\example.scad
& "C:\Program Files\OpenSCAD\openscad.exe" -o build\example\example.3mf models\example\example.scad
```

This works fine for a single model. When you ask Claude to build, it can run
these commands directly.

## 7 — Install Bambu Studio

Download from <https://bambulab.com/en/download/studio> → install → log in →
add your Bambu Lab printer → calibrate.

This is the slicer. Claude Code produces `.stl` / `.3mf` mesh files; you load
them into Bambu Studio to slice and send to the printer.

## Done — back to the main flow

That's everything you need installed. Head back to the
[main README → *Clone this repo*](../README.md#clone-this-repo) section to
grab the project and verify the toolchain end-to-end.

## Common Windows gotchas

- **Path separators**: OpenSCAD and most tools accept forward slashes — use
  `/` rather than `\` when typing paths in commands. Avoids escaping headaches.
- **Long paths**: Windows has a 260-character path limit by default. If you
  clone deep inside `Documents`, you may hit it. Enable long-path support:
  `git config --system core.longpaths true`.
- **Line endings**: Git on Windows may rewrite `\n` → `\r\n` on checkout.
  For `.scad` and `.md` files this is fine. For shell scripts in WSL it
  matters — use `core.autocrlf=input` if you go the WSL route.
