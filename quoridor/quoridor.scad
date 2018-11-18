// table width
tw=150;
// table height
th=5;
// wall height
wh=15;
// slack
s=0.3;


// number of ditches
dn=8;
// ratio of ditch width to board width
dr=0.15;

// epsilon
e = 0.01;


// DITCHES

// width
dw=tw*dr/dn;
// height
dh=th/2;
// distance
fw=tw+dw;
dd=fw/(dn+1);

// WALLS

// width
ww=dw-2*s;
wl=2*dd-dw;

// cell width
cw=dd-dw;
// pawn width
pw=0.8*cw;

//mini_board();
//board();
pawn();
//wall();

module pawn() {
    $fn=40;
    translate([0, 0, th/2])
    union() {
        linear_extrude(scale=0.2, height=wh)
        circle(d=pw);
        
        translate([0, 0, wh])
        sphere(d=0.8*pw);
    }
}

module wall() {
    rotate([0, -90, 0])
    cube(size=[ww, wl, wh]);
}

module mini_board() {
    translate([-wl/2 + tw/2, -wl/2 + tw/2, th/2])
    intersection() {
        translate([-tw + wl - e, -tw + wl - e, 0])
        cube(size=tw, center=true);
        
        board();
    }
}

module board() {
    difference() {
        blank_board();
        ditches();
    }
}

module blank_board() {
    cube(size=[tw, tw, th], center=true);
}

module ditches() {
    sx = -tw/2 -dw/2;
    for (d = [1 : dn]) {
        translate([0, sx + d*dd, dh/2 + e])
        cube(size=[tw+1, dw, th/2], center=true);
        
        translate([sx + d*dd, 0, dh/2 + e])
        cube(size=[dw, tw+1, th/2], center=true);
    }
}