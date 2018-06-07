module copy_x() {
    children();
    mirror([0,1,0])
    children();
}

$fn = 100;

d1 = 34;
d2 = 50;
d2in = 45;
d3 = 54;
h1 = 8;
h2 = 10.6;
h23 = 31;

w3 = 12.7;

cylinder(d = d1, h = h1);

difference() {
    union() {
        translate([0, 0, 8])
        cylinder(d = d2, h = h23);
        
        translate([0, 0, h1 + h23])
        mirror([0, 0, 1])
        linear_extrude(height = 7, scale = d3/d2)
        circle(d = d2);
    }
    
    copy_x()
    translate([-50, w3/2, h1+h2])
    cube([100, 100, 100]);
    
    translate([0, 0, h1 + 2.5])
    cylinder(d = d2in, h = 100);
}
