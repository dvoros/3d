// Hive Pocket sized blank tile (for painting)

flat2flat = 25;
height = 10;

module regular_polygon(order, r=1){
    angles=[ for (i = [0:order-1]) i*(360/order) ];
    coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
    polygon(coords);
}
 
module hexagon(r, h) {
    linear_extrude(h)
    scale([r, r, 1])
    regular_polygon(6);
}


r = sqrt(flat2flat*flat2flat/3);

rotate([0, 0, 30])
hexagon(r, height);