// Copyright (c) 2024 Chris Lee and contibuters.
// Licensed under the MIT license. See LICENSE file in the project root for details.

module rounded_box(dims, r) {
  x = dims[0];
  y = dims[1];
  z = dims[2];
  module cyl() {
    cylinder(z, r, r, $fn=40);
  }
  if (r == 0) {
    cube(r);
  } else {
    hull() {
      translate([r, r, 0]) cyl();
      translate([x-r, r, 0]) cyl();
      translate([x-r, y-r, 0]) cyl();
      translate([r, y-r, 0]) cyl();
    }
  }
}
