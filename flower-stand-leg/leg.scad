$fn=100;

alpha=73;
d1=8;
d2=26;
d3=7 + 0.4;
y=4;
h=30;

sc=d1/d2;
x1=h/(tan(alpha)*(1-sc));
x2=x1-(y/tan(alpha));

difference() {
    linear_extrude(h, scale=sc)
    translate([0, x1, 0])
    circle(d=d2);

    translate([0, x2, y])
    rotate([90-alpha, 0, 0])
    cylinder(h=100, d=d3);
    
    // test fit
//    translate([0, 0, -50 + 20])
//    cube(100, center=true);
}