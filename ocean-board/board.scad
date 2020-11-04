$fn=1000;

// FREE TO EDIT

curve_len = 350;
curve_height = 50;
curve_width = 40;

hole_small_r = 4;
hole_large_r = 8;
hole_x = 120;
hole_small_h = 20;

// COMPUTED BELOW

e = 0.01;
curve_r = (pow(curve_height, 2) + pow(curve_len/2, 2)) / (2 * curve_height);

echo("Curve radius: ", curve_r);

difference() {

    translate([0, 0, -(curve_r-curve_height)])
    rotate([90, 0, 0])
    cylinder(r=curve_r, h=curve_width, center=true);
    
    
    mirror([0, 0, 1])
    linear_extrude(height=2*curve_r)
    square(2*curve_r+1, center=true);
    
    
    mirror_x()
    translate([hole_x, 0, -e])
    cylinder(r=hole_small_r, h=curve_height+e);
    
    mirror_x()
    translate([hole_x, 0, hole_small_h])
    cylinder(r=hole_large_r, h=curve_height+e);
}

module mirror_x() {
    children();
    
    mirror([1, 0, 0])
    children();
}