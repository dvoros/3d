full_length = 76;
width = 27;
circ_w = 10;
ledge_w = 5.5;


circ_r = width / 2;
circ_factor = circ_w / circ_r;
circ_dist = full_length - 2 * circ_w;
cut_length = full_length - 2 * ledge_w;

e = 0.01;


difference() {
// board
linear_extrude(height = 3)
hull() {
translate([-circ_dist/2, 0, 0])
scale([circ_factor, 1, 1])
circle(r=circ_r);


translate([circ_dist/2, 0, 0])
scale([circ_factor, 1, 1])
circle(r=circ_r);
}

// cut
cube([cut_length, width + e, 1], center=true);

// text
translate([0, 0, 2])
linear_extrude(height=2)
text("SW 2019", size=12, halign="center", valign="center");
}