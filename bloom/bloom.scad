size = 4;

bh = 5; // board height

r = 16; // tile radius
th = 4; // tile height

edge = 2;
slack = 0.4;
depth = 2;

// --------------------------
x = 2*cos(30)*r;
y = sin(30)*r+r;
mid = 2*size-1;

// --------------------------

board();
//tile();

// --------------------------

module tile() {
    translate([0, 0, bh])
    linear_extrude(height=th)
    offset(delta=-edge-2*slack)
    regular_polygon(6, r);
}

module board() {
    difference() {
        linear_extrude(height=bh)
        offset(delta=edge)
        board_2d(0);
        
        translate([0, 0, bh-depth])
        linear_extrude(height=bh)
        board_2d(os=-edge);
    }
}

module board_2d(os=0) {
    for (i = [0:size-1]) {
        dupe()
        translate([i*x/2, i*y, 0])
        line(mid-i, r, os);
    }
}

module line(n, r, os) {
    for (i = [0:n-1]) {
        translate([i*x, 0, 0])
        offset(delta=os)
        regular_polygon(6, r);
    }
}

module regular_polygon(order = 4, r=1 ){
    angles=[ for (i = [0:order-1]) i*(360/order) ];
    coords=[ for (th=angles) [r*sin(th), r*cos(th)] ];
    polygon(coords);
}

module dupe() {
    children();
    
    mirror([0,1,0])
    children();
}