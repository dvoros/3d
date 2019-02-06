coin_diameter=75;
coin_height=6.9;

stand_x=82;
stand_top_x=72;
stand_y=32;
stand_top_y=22;
stand_z1=13.7;
stand_z2=19.1;
stand_depth=7.5;

e=0.01;
slack=0.25;
$fn=100;

difference() {
    // stand
    union() {
        cube([stand_x, stand_y, stand_z1], center=true);

        translate([0, 0, stand_z1/2-e])
        linear_extrude(height=stand_z2-stand_z1, scale=[stand_top_x/stand_x, stand_top_y/stand_y])
        square([stand_x, stand_y], center=true);
    }

    // coin
    translate([0, 0, coin_diameter/2 + stand_z2/2 - stand_depth])
    rotate([90, 0, 0])
    cylinder(d=coin_diameter+2*slack, h=coin_height+2*slack, center=true);
}