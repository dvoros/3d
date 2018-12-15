d = 59.3;
h = 3.5;
$fn = 100;

difference() {
    cylinder(d = d + 2, h = 7);
    
    translate([0, 0, 3.5])
    cylinder(d = d, h = 10);
}