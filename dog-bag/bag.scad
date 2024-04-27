$fn=50;

d_rope = 10;
d_bag = 28;
h_bag = 60;

wall = 2;

axis_diff = d_rope/2 + d_bag/2 + wall;

difference() {

linear_extrude(height=h_bag+2*wall)
hull() {
    circle(d=d_bag + 2*wall);

    translate([axis_diff, 0, 0])
    circle(d=d_rope + 2*wall);
}

translate([axis_diff, 0, 0])
cylinder(d=d_rope, h=1000, center=true);

translate([0, 0, wall])
cylinder(d=d_bag, h=1000);


translate([0, 0, wall])
cube([wall, 100, h_bag]);


translate([axis_diff, 0, h_bag/2 + wall/2])
rotate([0, 90, 0])
cylinder(d=4, h=100);
}

