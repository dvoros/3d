$fn=100;

difference() {
    translate([0, 0, -2])
    linear_extrude(30)
    hull() {
        translate([0, 0])
        circle(d=25);
        translate([24, 0])
        circle(d=25);
        translate([0, 24])
        circle(d=25);
        translate([24, 24])
        circle(d=25);
    }


    bottle_testfit(0, 0, 0);
    bottle_testfit(24, 0, 0.2);
    bottle_testfit(0, 24, 0.4);
    bottle_testfit(24, 24, 0.6);
};




//bottle_testfit(0, 0, 0.2);

module bottle_testfit(x=0, y=0, dd=0) {
    d = 22 + dd;
    
    translate([x, y, 0])
    union() {
        cylinder(d=d, h=50);
        
        translate([0,0,-0.4+0.01])
        linear_extrude(0.4)
        text(str(dd), 6, valign="center", halign="center");
    }
}