//  _______________________
// ^\                     /<- d4
// | \                   /
// |  "\               /"  <- d3
// h2 ^ \             /    <- d2
// |  h1 \           /
// |  |   \         /      <- d1 
// v  v    """""""""
// 
module pot(d1, d2, d3, d4, h1, h2, space_below=10, slack=1) {
    union() {
        translate([0, 0, h1+slack])
        linear_extrude(height=h2-h1+slack, scale=(d4+slack)/(d3+slack))
        circle(d=d3+slack);
        
        linear_extrude(height=h1+slack, scale=(d2+slack)/(d1+slack))
        circle(d=d1+slack);
        
        translate([0, 0, -space_below])
        linear_extrude(height=space_below)
        circle(d=d1+slack);
    }
}

$fn=80;
d1=40;
d2=47.6;
d3=50.8;
d4=54;
h1=47.55-9.1;
h2=47.55;
pot(d1, d2, d3, d4, h1, h2);