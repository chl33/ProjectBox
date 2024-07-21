// Copyright (c) 2024 Chris Lee and contibuters.
// Licensed under the MIT license. See LICENSE file in the project root for details.

module shtc3_window(offset, space_above_board, wall, negative) {
  sz = [3, 3, 1];
  z_gap = 0.5;
  translate(offset) {
    if (negative) {
      translate([0, 0, z_gap-1]) {
	cube([sz[0], sz[1], space_above_board+wall+2]);
      }
    } else {
      translate([-wall, -wall, z_gap+epsilon]) {
	cube([sz[0] + 2*wall, sz[1] + 2*wall, space_above_board-z_gap]);
      }
    }
  }
}
