// Copyright (c) 2024 Chris Lee and contibuters.
// Licensed under the MIT license. See LICENSE file in the project root for details.

module screw_mount(height, wall, screw_radius) {
  $fn = 20;
  difference() {
    cylinder(height, screw_radius+wall, screw_radius+wall);
    cylinder(height+epsilon, screw_radius, screw_radius);
  }
}
