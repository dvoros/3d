use <../lib/mylib.scad>;

$fn=60;

x=15;

d=x/cos(30);
slack=0.2;
wall=2;

//rotate([180, 0, 0])
difference() {
    cylinder(h=20, d=d+2*slack+wall);

    translate([0, 0, 20-10])
    hexagon(
        d/2+slack,
        100
    );

    // TODO: Gub-Haindrich method of co-axial hexes
    cube([6.45, 6.45, 100], center=true);
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