$fn=40;

d=4.6;


translate([0, 0, -d/2])
rotate([0, -90, 0])
cylinder(d=d, h=10);

rotate([-90, 0, 0])
translate([0, 0, -5])
linear_extrude(height=10)
polygon([[0,0], [10,0], [0,10]]);