// Copyright (c) 2024 Chris Lee and contibuters.
// Licensed under the MIT license. See LICENSE file in the project root for details.

include <ProjectBox/project_box.scad>

// board_thickness = 1.6;
// pad_space = 2.54;
// board_dims = [XX*pad_space, YY*pad_space, board_thickness];

module {{project}}_board() {
  u = pad_space;

  // Board imported from KiCad (VRML) -> Blender
  translate([board_dims[0]/2, board_dims[1]/2, board_dims[2]/2]) color("white")
    import(file="{{project}}.stl", convexity=3);

}
