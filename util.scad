// Copyright (c) 2024 Chris Lee and contibuters.
// Licensed under the MIT license. See LICENSE file in the project root for details.

include <MCAD/units.scad>

ones = [1, 1, 1];

module RX(angle) {
  rotate(angle, X) children();
}
module RY(angle) {
  rotate(angle, Y) children();
}
module RZ(angle) {
  rotate(angle, Z) children();
}
module TX(dist) {
  translate(X*dist) children();
}
module TX(dist) {
  translate(X*dist) children();
}
module TY(dist) {
  translate(Y*dist) children();
}
module TZ(dist) {
  translate(Z*dist) children();
}

// x-extra and y-extra adjust the x/y offset at the far-x and far-y corners.
module at_corners(dims, corner_offset, to_draw=undef, x_extra=0.0, y_extra=0.0) {
  o = corner_offset;
  if (!to_draw || to_draw[0]) translate([o, o, 0]) children();
  if (!to_draw || to_draw[1]) translate([dims[0]-o+x_extra, o, 0]) rotate(90, Z) children();
  if (!to_draw || to_draw[2]) translate([dims[0]-o+x_extra, dims[1]-o+y_extra, 0])
				rotate(180, Z) children();
  if (!to_draw || to_draw[3]) translate([o, dims[1]-o+y_extra, 0]) rotate(270, Z) children();
}
