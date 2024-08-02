// Copyright (c) 2024 Chris Lee and contibuters.
// Licensed under the MIT license. See LICENSE file in the project root for details.

include <MCAD/units.scad>
include <rounded_box.scad>
include <screw_tab.scad>
use <util.scad>

bump_d = 0.8;

module in_board_frame(outer_dims, board_dims, space_below_board) {
  translate([(outer_dims[0] - board_dims[0])/2,
	     (outer_dims[1] - board_dims[1])/2,
	     space_below_board])
    children();
}

default_tab_len = 10;
function tab_length(dim, num_tabs=2) = min(default_tab_len, dim/(2*(num_tabs+1)));
function tab_offset(i, dim, num_tabs=2) = (dim*(i+1)/(num_tabs+1))-0.5*tab_length(dim, num_tabs);

module project_box(outer_dims,
		   wall_thickness=1,
		   gap=0.1,
		   humps=undef,
		   // If true put snaps for top/bottom on sides rather than front/back.
		   snaps_on_sides=false,
		   corner_radius=0.0,
		   top=true,
		   top_cutouts=undef,
		   ym_cutouts=undef,
		   yp_cutouts=undef,
		   screw_tab_d=0) {
  wall = wall_thickness;
  num_snaps = 2;

  // Length of side of box snap-tabs will be added.
  tabdim = snaps_on_sides ? outer_dims[1] : outer_dims[0];
  // Length of snap-tab holes (tabs shrinks slightly to fit).
  tablen = tab_length(tabdim, num_snaps);
  // Difference between tab length and tab hole length;
  tab_gap = 1;

  // Space between bottom of box and top of box.
  fit_gap = 0.02;

  // The bottom of the box fits inside the shell of the top.
  dims = top ? outer_dims : outer_dims - (2*wall+fit_gap) * [1, 1, 1];

  // Tabs for clicking base into start at wall-height, are 2*wall-height high.
  // Allow 2*wall_height above bump for hight of bottom part of box.
  tab_depth = min(bump_d, dims[2] - 3*wall);
  bottom_height = wall+tab_depth+2*wall;

  module bump() {
    dh = bump_d - fit_gap;
    rotate(90, Y) cylinder(tablen-tab_gap, dh, dh, $fn=20);
  }

  module hump_positives(humps, space_above_board, corner_radius, wall) {
    for (hump = humps) {
      offset = hump[0];
      outer_dims = hump[1];
      z_start = gap * 2 + wall + space_below_board + board_thickness + space_above_board + epsilon;
      translate([offset[0], offset[1], z_start]) rounded_box(outer_dims, corner_radius);
    }
  }
  module hump_negatives(humps, space_above_board, corner_radius, wall) {
    for (hump = humps) {
      offset = hump[0];
      outer_dims = hump[1];
      z_start = gap * 2 + wall + space_below_board + board_thickness + space_above_board - epsilon - epsilon;
      translate([offset[0]+wall, offset[1]+wall, z_start])
	rounded_box(outer_dims-[wall*2, wall*2, wall], corner_radius);
    }
  }
  module cutouts(cutout_list, remove_len) {
    for (cutout = cutout_list) {
      offset = cutout[0];
      dims = cutout[1];
      translate([offset[0], offset[1], 0]) cube([dims[0], dims[1], remove_len]);
    }
  }

  wedge_dx = 2*wall;
  wedge_dy = min(outer_dims[1]-2*wall-corner_radius, 10);
  wedge_dz = wedge_dx;
  module wedge() {
    // Bump to stop the bottom of box to go too up into the top.
    translate([0, 0, bottom_height+fit_gap]) {
      // Start with cube, switch to wedge for printing.
      translate(Y*wedge_dy) rotate(90, X)
	linear_extrude(wedge_dy) polygon([[0, 0], [0, wedge_dz], [wedge_dx, 0]]);
    }
  }

  // The bottom of the box fits inside the shell of the top.
  translate(top ? [0,0,0] : wall*[1, 1, 0]) union() {
    difference() {
      // shell
      difference() {
	union() {
	  rounded_box(dims, corner_radius);
	  if (top && humps)
	    hump_positives(humps, space_above_board, corner_radius, wall);
	}
	iz = top ? (dims[2] - 2*wall) : dims[2];  // inner-z
	translate(ones*wall) rounded_box([dims[0] - wall*2, dims[1]-wall*2, iz], corner_radius);
	if (top) {
	  if (humps) {
	    hump_negatives(humps, space_above_board, corner_radius, wall);
	  }
	  // cutouts from the top surface
	  if (top_cutouts)
	    cutouts(top_cutouts, remove_len=100);
	  // cutouts from the y=0 surface
	  if (ym_cutouts)
	    translate([0, 1+wall, 0]) rotate([90, 0, 0]) cutouts(ym_cutouts, remove_len=(wall+2));
	  if (yp_cutouts)
	    translate([outer_dims[0], outer_dims[1]-wall-0.01, 0])
	      rotate([0, 0, 180]) rotate([90, 0, 0]) cutouts(yp_cutouts, remove_len=(wall+2));
	}
      }

      if (!top) {
	// Box bottom

	// Cut off top.
	translate([-1, -1, bottom_height]) { cube(dims + 2 * ones); }
	// Make a slot for top to click into
	bottom_offset = -wall;  // offset to account for bottom fitting inside top.
	if (snaps_on_sides) {
	  for (isnap = [0:num_snaps-1]) {
	    y = tab_offset(isnap, tabdim, num_snaps) + bottom_offset;
	    translate([-1, y, wall]) cube([dims[0]+2, tablen, wall+tab_depth]);
	  }
	} else {
	  for (isnap = [0:num_snaps-1]) {
	    x = tab_offset(isnap, tabdim, num_snaps) + bottom_offset;
	    translate([x, -1, wall]) cube([tablen, dims[1]+2, wall+tab_depth]);
	  }
	}
      }	else {
	// Box top

	// Cut out for bottom
	translate(wall*[1, 1, -1]) {
	  rounded_box([dims[0]-2*wall, dims[1]-2*wall, wall*3], corner_radius);
	}
      }
    }

    // Board supports
    if (top) {
      // Snaps: Make bumps to click into slot in bottom.
      if (snaps_on_sides) {
	for (isnap = [0:num_snaps-1]) {
	  y = tab_offset(isnap, tabdim, num_snaps) + tab_gap/2;
	  translate([wall-epsilon, y, wall+gap/2]) rotate(90, Z) bump();
	  translate([dims[0]+epsilon-wall, y, wall+gap/2]) rotate(90, Z) bump();
	}
	translate([wall-epsilon, (outer_dims[1]-wedge_dy)/2, 0]) wedge();
	translate([outer_dims[0]-wall+epsilon, (outer_dims[1]+wedge_dy)/2, 0])
	  rotate(180, Z) wedge();
      } else {
	for (isnap = [0:num_snaps-1]) {
	  x = tab_offset(isnap, tabdim, num_snaps) + tab_gap/2;
	  translate([x, wall-epsilon, wall+gap/2]) bump();
	  translate([x, dims[1]+epsilon-wall, wall+gap/2]) bump();
	}
	translate([(outer_dims[0]+wedge_dy)/2, wall-epsilon, 0]) rotate(90, Z) wedge();
	translate([(outer_dims[0]-wedge_dy)/2, outer_dims[1]-wall+epsilon, 0])
	  rotate(270, Z) wedge();
      }
    }
  }

  if (top && screw_tab_d > 0) {
    translate([outer_dims[0]/2, outer_dims[1], 0])
      screw_tab(tab_width=screw_tab_d, thickness=2*wall, screw_radius=2);
  }
}

module holder_tab(wall_thickness, thickness=2, out_r=4, in_r=2) {
  translate(Z*wall_thickness) linear_extrude(thickness) {
    $fn = 20;
    y = epsilon;
    difference() {
      hull() {
	translate([0, epsilon-out_r]) circle(out_r);
	polygon([[-out_r, epsilon], [out_r, epsilon],
		 [out_r, 2*epsilon], [out_r, 2*epsilon]]);
      }
      translate([0, -out_r]) circle(in_r);
    }
  }
}
