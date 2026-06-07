// Common utilities for 3D print designs.
//
// Include from a model file with:
//   include <../../lib/common.scad>

// Default FDM clearance for sliding/snap fits (mm)
tolerance = 0.2;

// Rounded cube with configurable corner radius
//   size   : [x, y, z]
//   radius : corner radius (default 1mm)
module rounded_cube(size, radius = 1) {
    hull() {
        for (x = [radius, size[0] - radius])
            for (y = [radius, size[1] - radius])
                for (z = [radius, size[2] - radius])
                    translate([x, y, z])
                        sphere(r = radius, $fn = 20);
    }
}

// Cylinder sized with FDM tolerance applied. Use for through-holes that need
// a sliding fit on a known shaft.
module printable_hole(d, h, tol = tolerance) {
    cylinder(d = d + tol, h = h, $fn = 40);
}

// Teardrop hole: round at the top, pointed at the bottom. Prints horizontally
// without supports because the top of the bore self-supports at <45° overhang.
//   d : hole diameter
//   h : extrusion length
module teardrop_hole(d, h) {
    r = d / 2;
    linear_extrude(height = h)
        union() {
            circle(r = r, $fn = 40);
            polygon([[-r, 0], [r, 0], [0, r * 1.5]]);
        }
}
