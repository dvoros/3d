use <../lib/mylib.scad>;

$fn=100;
e=0.01;

difference() {
    translate([0, 0, 10])
    sphere(d=40);

    translate([0, 0, -100 + 5])
    cylinder(d=17.8+0.4, h=100);

    translate([0, 0, 5+0.4])
    hexagon(r=5.9, h=5.3);

    translate([0, 0, -100-6.5])
    cylinder(d=100, h=100);
}