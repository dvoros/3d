char="a";
piece="holder";
size=4; // size of holder

// TODO: auto-generate blank piece

e=0.01;
y=10;

font="Type Machine";
font_size=8;


// Use these together with "all_letters_on_top" to make all letters fit
top_x=14;
letter_x=1;
letter_y=-3.7;

extra_space_after_letter=0.8;

// ------

tm=textmetrics(text=char,font=font, size=font_size);
letter_width=tm.size.x+letter_x+extra_space_after_letter;

bottom_x=top_x+5;
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
//        all_letters_on_top();
    }
}

if (piece == "holder") {
    holder(letters=size);
}


module cross_section() {
    bottom=3;
    
    polygon([[0, 0], [bottom_x, 0], [bottom_x, bottom], [bottom_x-dx, y], [dx, y], [0, bottom]]);
}

module letter_on_top(ch = "W") {
    translate([letter_x, bottom_x/2 + letter_y, y-e])
    linear_extrude(2)
    text(ch, font=font, size=font_size, halign="left", valign="baseline");
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
    // Extra letters
    for (ch = ["á", "Á", "é", "É", "ő", "Ő", "ú", "Ú", "ű", "Ű", "ö", "Ö", "ü", "Ü", "ó", "Ó", "í", "Í"]) {
        letter_on_top(ch);
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
        offset(delta=0.05)
        union() {
            cross_section();
        }
        
        translate([0, bottom_x/2-font_size/4, -4+0.1])
        linear_extrude(2)
        text(str(letters), font=font, size=font_size, halign="left", valign="baseline");
    }
}