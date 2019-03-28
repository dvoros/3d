side_width=30;
margin=3;
depth=5;

slack=0.2;
e=0.001;
$fn=50;

magnet_h=1.7+2*slack;
magnet_d=3+slack;
magnet_cover=0.6;

//rot5()
//one_block();

one_side_with_magnet();

module one_block() {
    translate([0, 0, -side_width/2])
    difference() {
        linear_extrude(height=side_width/2, scale=0)
        square(side_width, center=true);

        
        translate([0, 0, -e])
        one_side();
        
        translate([-magnet_d/2, -magnet_d/2, depth + magnet_cover])
        cube([magnet_d, magnet_d, magnet_h]);
    }
}

module one_side() {
    w = side_width - margin;
    difference() {
        linear_extrude(height=w/2, scale=0)
        square(w, center=true);
        
        translate([0, 0, w + depth])
        cube(2*w, center=true);
    }
}

module one_side_with_magnet() {
    union() {
        one_side();
        
        translate([0, 0, depth - magnet_h - magnet_cover])
        cylinder(d=magnet_d, h=magnet_h);
    }
}

module rot5() {
    translate([e, 0, 0])
    rotate([0, 90, 0])
    children();
    translate([-e, 0, 0])
    rotate([0, -90, 0])
    children();
    translate([0, -e, 0])
    rotate([90, 0, 0])
    children();
    translate([0, e, 0])
    rotate([-90, 0, 0])
    children();
    translate([0, 0, -e])
    rotate([180, 0, 0])
    children();
    
    children();
}