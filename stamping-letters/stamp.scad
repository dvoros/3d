char="W";
piece="holder";
size=4; // size of holder

e=0.01;

bottom_x=17;
top_x=12;
y=10;

font_size=9;
letter_width=7.5;

dx=(bottom_x-top_x)/2;

if (piece == "letter") {
    mirror([1, 0, 0])
    union() {
        difference() {
            // base
            rotate([90, 0, 90])
            linear_extrude(letter_width)
            cross_section();
            
            // notch
            translate([letter_width-1+e, 0, y-1+e])
            cube([1, dx+1, 1]);
        }
        
        letter_on_top(char);
        
        // Use this to test how letters fit
    //    all_letters_on_top();
    }
}

if (piece == "holder") {
    holder(letters=size);
}


module cross_section() {
    bottom=3;
    
    polygon([[0, 0], [bottom_x, 0], [bottom_x, bottom], [bottom_x-dx, y], [dx, y], [0, bottom]]);
}

module elephant_foot() {
    polygon([[-0.5, 0], [bottom_x+0.5, 0], [bottom_x, 1], [0, 1]]);
}

module letter_on_top(ch = "W") {
    // Font: Tlwg Typist
    // Copyright (C) 2003, 2004 Poonlap Veerathanabutr <poonlap@linux.thai.net>
    translate([0, bottom_x/2-font_size/4, y-e])
    linear_extrude(2)
    text(ch, font="Tlwg Typist", size=font_size, halign="left", valign="baseline");
}

module all_letters_on_top() {
    for (ch = [ord("a"):1:ord("z")]) {
        letter_on_top(chr(ch));
    }
    for (ch = [ord("A"):1:ord("Z")]) {
        letter_on_top(chr(ch));
    }
    for (ch = [ord("0"):1:ord("9")]) {
        letter_on_top(chr(ch));
    }
}

module holder(letters=10) {
    mirror([1, 0, 0])
    difference() {
        translate([0, -2, -2-e])
        cube([(letter_width+0.15) * letters, bottom_x + 4, y + 2]);
        
        translate([-500, 0, 0])
        rotate([90, 0, 90])
        linear_extrude(1000)
        offset(delta=0.15)
        union() {
            elephant_foot();
            cross_section();
        }
        
        translate([0, bottom_x/2-font_size/4, -4+0.1])
        linear_extrude(2)
        text(str(letters), font="Tlwg Typist", size=font_size, halign="left", valign="baseline");
    }
}