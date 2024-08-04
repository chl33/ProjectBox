// Copyright (c) 2024 Chris Lee and contibuters.
// Licensed under the MIT license. See LICENSE file in the project root for details.

include <ProjectBox/project_box.scad>
include <board.scad>

ones = [1, 1, 1];

wall_thickness = 1;
gap = 0.2;
corner_radius = 2;

space_above_board = 12;
space_below_board = 5;
inner_dims = (board_dims
	      + Z*(space_above_board+space_below_board)
	      + 2*gap*ones);
outer_dims = (inner_dims
	      + 2*ones*wall_thickness
	      + [2, 2, 0] * corner_radius);

module in_{{project}}_board_frame(board_height=false) {
  zoffset = wall_thickness + (board_height ? space_below_board : 0);
  in_board_frame(outer_dims, board_dims, zoffset) children();
}

module {{project}}_box(top) {
  wall = wall_thickness;

  difference() {
    union() {
      project_box(outer_dims,
		  board_dims=board_dims,
		  wall_thickness=wall_thickness,
		  gap=gap,
		  snaps_on_sides=true,
		  corner_radius=corner_radius,
		  top=top);
      if (top) {
	// Bumps on top etc.
	// translate(b1o) rounded_box(b1d, corner_radius);
      } else {
	// Stuff to add on bottom.
      }	
    }
    // Cut outs.
    if (top) {
      // Negative space of bumps.
      // translate(b1o+[wall, wall, -epsilon]) rounded_box(b1d-wall*[2, 2, 1], corner_radius);
      // translate(b2o+[wall, wall, -epsilon]) rounded_box(b2d-wall*[2, 2, 1], corner_radius);

    }
  }
}
