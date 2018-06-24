$fn = 25;

// Distance between bug and tile walls
slack=0.2;

// Tile height
th = 5;
// Tile width
tw = 40;
// Tile wall width
ww = 2;

// Bug height
bh = 2;

// Grid height
gh = 0.4;


// EDIT HERE:
// ---------------------
bug_for()
//tile_for()

bee();
// ---------------------



module tile_for() {
  difference() {
        tile();
      
        translate([0, 0, th - bh - slack])
        linear_extrude(height=th)
        offset(r=slack)
        children();
    }
}

module bug_for() {
    linear_extrude(height = bh)
    children();
}

module grid() {
    r = tw/2;
    x = sin(30) * r * 2;
    y = cos(30) * r;

    scale([0.2, 0.2, 1])
    translate([-5*(tw+x), -10*y, 0])
    for (i = [0:10]) {
        for (j = [0:20]) {
            translate([i * (tw+x) + (j%2) * (tw-x/2), j * y, 0])
            scale([0.9, 0.9, 1])
            hexagon(tw/2, th*2);
        }
    }
}



 module regular_polygon(order, r=1){
    angles=[ for (i = [0:order-1]) i*(360/order) ];
    coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
    polygon(coords);
 }
 
 module tile() {
    difference() {
        linear_extrude(height = th)
        scale([tw/2, tw/2, 1])
        regular_polygon(6);
        
        intersection() {
            translate([0,0,th-gh])
            hexagon(tw/2-ww/2,th);
            
            grid();
        }
    }
}

module hexagon(r, h) {
    linear_extrude(h)
    scale([r, r, 1])
    regular_polygon(6);
}

// Importing bugs

module ant() {
    projection(cut = false)
    translate([252, -199.5, 0])
    import("ant.stl", convexity = 5);
}
module bee() {
    projection(cut = false)
    translate([179, -212, 0])
    import("bee.stl", convexity = 5);
}