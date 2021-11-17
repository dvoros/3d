$fn=50;

e=0.01;

d1=23.4;
d2=15.5;
d3=19.1;
d4=5.8;
d4x=2.8;



h1=3;
h2=9;
h3=1.1;
h4=15.7;

w1=2.4;
w2=9.1;

wall=1.2;



module blades() {
    x=3.7;
    h5=6;
    
    rotz(180)
    rotz(90)
    mirror([0, 1, 0])
    intersection(){
        linear_extrude(h5, twist=20, slices=20)
        translate([(d2-2*wall)/2-x/2, 0, 0])
        square([x, x], center=true);


        rotate([0, 0, -10])
        cube(100);
        
//        #cylinder(d=d2-wall, h=h2);
    }
}

//blades();
smoothie();

module smoothie() {
    difference() {
        linear_extrude(h1, scale=d2/d1)
        circle(d=d1);
        
        translate([0, 0, -e])
        linear_extrude(h1+2*e, scale=(d2-2*wall)/(d1-2*wall))
        circle(d=d1-2*wall);
    }

    translate([0, 0, h1])
    difference() {
        cylinder(d=d2, h=h2);
        
        translate([0, 0, -e])
        cylinder(d=d2-2*wall, h=h2);
    }
    
    translate([0, 0, h1+h2])
    mirror([0, 0, 1])
    blades();

    translate([0, 0, h1+h2])
    cylinder(d=d3, h=h3);

    translate([0, 0, h1+h2+h3])
    difference() {
        union() {
            cylinder(d=d4, h=h4);
            
            rotz(90)
            translate([0, 0, h4/2])
            cube([w1, w2, h4], center=true);
        }
        
        cylinder(d=d4x, h=h4+e);
    }
}

module rotz(z=90) {
    children();
    
    rotate([0, 0, z])
    children();
}