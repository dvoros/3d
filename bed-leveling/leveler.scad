$wall_width=0.8;
$height=0.2;


for (x=[100 : 5 : 140]) {
    thinSquare(x);
}

module thinSquare(x=200) {
    difference() {
        cube([x, x, $height], center=true);
        cube([x-2*$wall_width, x-2*$wall_width, 3*$height], center=true);
    }
}