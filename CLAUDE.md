# 3D Print Design Project

Parametric 3D models designed in OpenSCAD, targeting a Bambu Lab printer (X1 Carbon
or P1S, 0.4 mm nozzle).

## Structure

- `models/<name>/<name>.scad` — one subdirectory per model, source file inside
- `lib/` — shared OpenSCAD libraries (`include <../lib/common.scad>` from a model)
- `build/` — generated STL/3MF output (gitignored)

When adding a new model `foo`, create `models/foo/foo.scad` — `make` will pick it up
automatically. Don't put loose `.scad` files directly under `models/`.

## Conventions

- **All dimensions in millimeters.** No mixed units.
- **Parametric values at the top** of each `.scad` file, with a comment explaining
  the measurement source ("measured with calipers", "from manufacturer datasheet", etc.).
- **Default FDM tolerance: 0.2 mm.** Use it for any sliding/snap fit.
- **Use `$fn = 60–120`** for visible cylinders/spheres; `$fn = 30` for hidden geometry.
- **Group geometry into named `module`s.** A single 200-line monolithic block at the
  bottom is harder to iterate on than a few composable modules.
- **Comment the *why*, not the *what*.** `// 0.4mm clearance for FDM shrinkage` is
  useful; `// cylinder` is not.

## Build

```sh
make              # build everything to STL + 3MF
make stl          # only STL
make 3mf          # only 3MF
make build/foo/foo.stl    # build one model
make clean        # wipe build/
```

The Makefile uses `/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD` —
update if your version differs. **Do not use the Homebrew symlink** (`/usr/local/bin/openscad`);
macOS Gatekeeper blocks it.

When you write code that modifies a model, always run the appropriate `make` target
to verify it still compiles to valid geometry. The CGAL renderer will catch
non-manifold or self-intersecting meshes that won't slice.

## Print orientation hints

When deciding model geometry, consider how it will be printed:

- **Overhangs steeper than 45° from vertical need supports.** Try to design so
  large flat faces sit on the build plate.
- **Internal bridges up to ~5 mm** print fine on the X1C/P1S without support.
- **Holes printed vertically** come out round. Holes printed horizontally come out
  slightly egg-shaped — compensate by making them 0.2–0.3 mm oversize on the
  vertical axis.
- **Tall thin walls (<1 mm)** can wobble during print. Either make them ≥1.2 mm or
  add a brim in the slicer.

If a part needs supports, mention it in a comment in the .scad file so the user
knows when slicing.

## Multi-material / support tricks (X1C or P1S with AMS)

For ABS prints needing supports, the cleanest release comes from using **PLA as
the support interface filament**. ABS for the part body, ABS for the support
body, PLA only for the 2–3 interface layers that touch the part. PLA and ABS
don't fuse — the support peels off and leaves a smooth surface. Set this in
Bambu Studio's *Support* tab.

For ABS prints with PLA in the AMS, the enclosed chamber should NOT be fully
sealed — crack the front door so the chamber stays around 40–45 °C, otherwise
PLA softens and clogs. This applies equally to the X1C and P1S (both are
passively heated by the bed; neither has an active chamber heater stock).

## When to use the shared library

`lib/common.scad` has these utilities:

- `tolerance` — global FDM clearance constant (default 0.2 mm)
- `rounded_cube([x, y, z], radius)` — cube with rounded corners (uses sphere hull)
- `printable_hole(d, h)` — hole with FDM tolerance pre-applied

If you find yourself writing the same pattern in two different models, extract
it into `lib/common.scad` rather than copy-pasting.
