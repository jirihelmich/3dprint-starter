// Example: a simple parametric cable clip — verifies the toolchain works.
//
// Build with:
//   make build/example/example.stl
//   make build/example/example.3mf

include <../../lib/common.scad>

/* [Cable] */
cable_d   = 6;     // outer diameter of the cable to hold
opening_w = 4.5;   // gap to snap the cable through (< cable_d for grip)

/* [Body] */
wall      = 2;
height    = 10;

/* [Quality] */
$fn = 60;

module cable_clip() {
    outer_d = cable_d + 2 * wall;
    difference() {
        // Outer body — a rounded square block
        rounded_cube([outer_d, outer_d, height], radius = 1.5);
        // Cable bore in the middle
        translate([outer_d/2, outer_d/2, -0.1])
            cylinder(h = height + 0.2, d = cable_d + tolerance);
        // Snap-through opening on one side
        translate([outer_d/2 - opening_w/2, -0.1, -0.1])
            cube([opening_w, outer_d/2, height + 0.2]);
    }
}

cable_clip();
