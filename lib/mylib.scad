module rotz(deg=90) {
    children();
    
    rotate([0, 0, deg])
    children();
}

module mirror_x() {
    children();
    
    mirror([1, 0, 0])
    children();
}

module mirror_y() {
    children();
    
    mirror([0, 1, 0])
    children();
}

module mirror_z() {
    children();
    
    mirror([0, 0, 1])
    children();
}

module z_rot_copy(r=0, deg=90, offset_deg=0) {
    arr = [0:deg:360];
    for(rot=arr) {
        rotate([0, 0, rot+offset_deg])
        translate([r, 0, 0])
        children();
    }
}

module cut_x() {
    intersection() {
        children();
        
        translate([-500, 0, -500])
        cube(1000);
    }
}
module cut_z() {
    intersection() {
        children();
        
        translate([-500, -500, 0])
        cube(1000);
    }
}

module hexagon(r, h) {
    linear_extrude(h)
    scale([r, r, 1])
    regular_polygon(6);
}

 module regular_polygon(order, r=1){
    angles=[ for (i = [0:order-1]) i*(360/order) ];
    coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
    polygon(coords);
 }