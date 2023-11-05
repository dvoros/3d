char=" ";

e=0.01;

bottom_x=17;
top_x=12;
y=10;

font_size=9;
letter_width=10;

// TODO:
// - autoamte generation of holder
// - engrave size into holder

mirror([1, 0, 0])
union() {
    rotate([90, 0, 90])
    linear_extrude(8)
    cross_section();
    
    letter_on_top(char);
//    letter_on_top("W");
//    letter_on_top("g");
}

//holder(letters=2);


module cross_section() {
    bottom=3;
    dx=(bottom_x-top_x)/2;
    polygon([[0, 0], [bottom_x, 0], [bottom_x, bottom], [bottom_x-dx, y], [dx, y], [0, bottom]]);
}

module letter_on_top(ch = "W") {
    // Font: Tlwg Typist
    // Copyright (C) 2003, 2004 Poonlap Veerathanabutr <poonlap@linux.thai.net>
    translate([0.2, bottom_x/2-font_size/4, y-e])
    linear_extrude(2)
    text(ch, font="Tlwg Typist", size=font_size, halign="left", valign="baseline");
}

module holder(letters=10) {
    difference() {
        translate([0, -2, -2-e])
        cube([(letter_width+0.15) * letters, bottom_x + 4, y + 2]);
        
        translate([-500, 0, 0])
        rotate([90, 0, 90])
        linear_extrude(1000)
        offset(delta=0.15)
        cross_section();
    }
}