n = 4;

fw = 20; // field_width
tile_mfr = 0.4;  // mount_width/field_width ratio for inner tiles
clue_mfr = 0.4; // mount_width/field_width ratio for the clues
tfr = 0.75; // tile_width/field_width width ratio
lh = 0.6; // letter height
clue_height = 5;
tile_corner_radius = 1;

ss = 0.25;
sb = 0.3;
stop = 0.8;

magnet_cover_w=0.6;

// 3x1.7 magnet
magnet_h=1.7 + 0.3;
magnet_d=3 + 0.35;

// 4x2 magnet
//magnet_h=2+sb;
//magnet_d=4+sb;

// Bearing ball to be used instead of magnet in the pieces
bearing_ball_d=6+sb;

// -------------------------

level_h=3;  // level height (in buildings)
base_height=magnet_h+2*magnet_cover_w; // base heights

$fn=50;
e = 0.01;
tw = fw * tfr; // tile_width

d = (n-1)/2 * fw;

piece = "manual experimenting";
string = "";
num = 1;

if (piece == "clue") {
    clue(string);
}
if (piece == "clue_multi_color_base") {
    clue_multi_color_base(string);
}
if (piece == "clue_multi_color_letter") {
    clue_multi_color_letter(string);
}
if (piece == "tile") {
    building(n=num);
}
if (piece == "park") {
    park();
}
if (piece == "flag") {
    flag();
}

if (piece == "manual experimenting") {
    building(2);
//    park();
//    clue(lett="1");
//    flag();
//    clue_multi_color_base("1");
//    clue_multi_color_letter("1");
}

module rotz() {
    children();
    
    rotate([0, 0, 90])
    children();
}

module mirror_x() {
    children();
    
    mirror([1, 0, 0])
    children();
}

module mirror_y() {
    children();
    
    mirror([0, 1, 0])
    children();
}

module building(n=1) {
    height=level_h*(n) + 2;
    
    building_width=tw-2.1;
    
    module windows() {
        x = building_width/5; // width of window
        y = 1.6;
        
        difference() {
            union() {
                rotz()
                for (i = [0:n-1]) {
                    for (j = [-1:1]) {
                        translate([0, 1.5*j*x, 1+level_h/2+i*(level_h)])
                        cube([building_width+4*e, x, y], center=true);
                    }
                }
            }
            cube([0.9*building_width,0.9*building_width,3*height], center=true);
        }
    }
    
    module rooftop() {
        numbers = [
            [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0]
            ],
            [
            [1, 0, 0],
            [0, 0, 0],
            [0, 0, 1]
            ],
            [
            [0, 0, 1],
            [0, 1, 0],
            [1, 0, 0]
            ],
            [
            [1, 0, 1],
            [0, 0, 0],
            [1, 0, 1]
            ],
            [
            [1, 0, 1],
            [0, 1, 0],
            [1, 0, 1]
            ],
            [
            [1, 0, 1],
            [1, 0, 1],
            [1, 0, 1]
            ]
        ];
        number = numbers[n-1];
        x = building_width/4;
        rh = 1.8;
        for (i = [0:2]) {
            for (j = [0:2]) {
                if (number[i][j] == 1) {
                    translate([(i-1)*building_width/3, (j-1)*building_width/3, height+rh/2])
                    cube([x, x, rh], center=true);
                }
            }
        }
    }
    
    union() {
        difference() {
            // main building
            union() {
                // base
                base_with_magnet();
                // top
                translate([0, 0, height/2])
                cube([building_width, building_width, height], center=true);
            }
            
            // windows
            windows();
            
            // bearing ball inside
//            translate([0, 0, -height/2+bearing_ball_d/2+magnet_cover_w])
//            cylinder(d=bearing_ball_d, h=bearing_ball_d, center=true);
        }
        
        // rooftop
        rooftop();
    }
}

module flag() {
    base_with_magnet();
    
    translate([-level_h, 0, 3*level_h])
    {
        translate([0, 0, 1.5*level_h])
        cube([2*level_h, 2.2, level_h], center=true);
        
        rotate([0, -45, 0])
        difference() {
            rotate([90, 45, 0])
            cube([2*level_h, 2*level_h, 2.2], center=true);
                
            translate([-50, 0, 0])
            cube([100, 100, 100], center=true);
        }
    }
    
    cylinder(d=4, h=5*level_h);
}

module tree(h, trunk_wr=1.1, crown_hr=1.4, crown_wr=1, crown_y=0) {
    linear_extrude(height=h*level_h, scale=0.4)
    circle(d=trunk_wr*h);
    
    translate([0, 0, h*level_h+crown_y])
    scale([crown_wr, crown_wr, crown_hr])
    sphere(d=1.8*h);
}

module park() {
    base_with_magnet();
    
    tree(3.7);
    
    translate([-0.3*tw, 0.25*tw, 0])
    tree(1.7, trunk_wr=1.5, crown_hr=1.2, crown_wr=1.3, crown_y=-0.8);
    
    translate([0.25*tw, 0.2*tw, 0])
    tree(1.9, trunk_wr=1.7, crown_wr=1.2, crown_y=-1.2);
    
    translate([0.2*tw, -0.2*tw, 0])
    tree(2.7);
    
    translate([-0.29*tw, -0.32*tw, 0])
    tree(2.3, crown_wr=1.2);  
}

module base_with_magnet() {
    difference() {
        translate([0, 0, -base_height])
        %linear_extrude(base_height)
        hull()
        mirror_x()
        mirror_y()
        translate([tw/2 - tile_corner_radius, tw/2 - tile_corner_radius, 0])
        circle(tile_corner_radius);
        
        // magnet inside
        translate([0, 0, -magnet_h/2-magnet_cover_w])
        cylinder(d=magnet_d, h=magnet_h, center=true);
    }
}

module clue_multi_color_base(lett="") {
    translate([0, 0, clue_height/2])
    difference() {
        cylinder(r = tw/2, h = clue_height, center=true);
        
        if (lett != "") {
            letter(lett, 0.2);
        }
    }
}

module clue_multi_color_letter(lett="") {
    color([0.1,0.1,0.1])
    translate([0, 0, clue_height/2])
    letter(lett, 0.2);
}


module clue(lett="") {
    translate([0, 0, clue_height/2])
    difference() {
        cylinder(r = tw/2, h = clue_height, center=true);
        
        if (lett != "") {
            letter(lett);
        }
    }
}

module letter(lett, offset_r=0.2) {
    translate([0, 0, clue_height/2-lh])
    linear_extrude(height=lh+e)
    offset(r = offset_r)
    text(lett, font="DejaVu Serif:style=Bold", valign="center", halign="center");
}

module mirror_x() {
    children();
    
    mirror([1, 0, 0])
    children();
}

module mirror_y() {
    children();
    
    mirror([0, 1, 0])
    children();
}
