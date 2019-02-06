coin_diameter=75;
coin_height=6.9;

stand_x=62;
stand_top_x=42;
stand_y=22;
stand_top_y=14;
stand_z1=5;
stand_z2=19.1;
stand_depth=5;

e=0.01;
slack=0.15;
$fn=100;

difference() {
    // stand
    union() {
        translate([0, 0, stand_z1/2])
        cube([stand_x, stand_y, stand_z1], center=true);

        translate([0, 0, stand_z1-e])
        linear_extrude(height=stand_z2-stand_z1, scale=[stand_top_x/stand_x, stand_top_y/stand_y])
        square([stand_x, stand_y], center=true);
    }

    // coin
    #
    translate([0, 0, coin_diameter/2 + stand_z2 - stand_depth])
    rotate([90, 0, 0])
    cylinder(d=coin_diameter+2*slack, h=coin_height+2*slack, center=true);
}