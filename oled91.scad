// Copyright (c) 2024 Chris Lee and contibuters.
// Licensed under the MIT license. See LICENSE file in the project root for details.

// This is a simple model of a 0.91" OLED module.
// E.g., https://www.aliexpress.us/item/2251832485915041.html
module oled91() {
  s = inch * 0.1;
  pin_len = 4;
  color("silver") {
    for (i = [0: 3]) {
      translate([s*i+pad_space, pad_space/2, -pin_len]) cube([0.25, 0.25, pin_len]);
    }
  }
  color("gray") cube([12, 38, 1]);
  translate([0, 5.5, 1]) color("black") cube([12, 28, 1]);
}
