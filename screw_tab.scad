// Copyright (c) 2024 Chris Lee and contibuters.
// Licensed under the MIT license. See LICENSE file in the project root for details.

include <MCAD/units.scad>

// Screw tab is drawn in the y-direction (attached on -Y side).
module screw_tab(tab_width=10, thickness=2, screw_radius=2) {
  $fn=40;
  dz = thickness;
  sd = tab_width;
  sr = tab_width / 2;
  translate([-sr, -epsilon, 0]) difference() {
    union() {
      cube([sd, sr, dz]);
      translate([sr, sr, 0]) cylinder(dz, sr, sr);
    }
    translate([sr, sr, -epsilon]) cylinder(dz+1, screw_radius, screw_radius);
  }
}
