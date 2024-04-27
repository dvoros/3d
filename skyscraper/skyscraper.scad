n = 4;

fw = 20; // field_width
th = 5; // tile_height
tile_mfr = 0.4;  // mount_width/field_width ratio for inner tiles
clue_mfr = 0.4; // mount_width/field_width ratio for the clues
tfr = 0.75; // tile_width/field_width width ratio
lh = 0.6; // letter height
trench_w = 1; // trench width
trench_h = 1; // trench width
mark_h = 3; // mark_height (should be bigger then trench_h)

ss = 0.25;
sb = 0.3;
stop = 0.8;

// Regular magnet
magnet_h=1.7+sb;
magnet_d=3+sb;
magnet_cover_w=0.4+sb;

// Bearing ball to be used instead of magnet in the pieces
bearing_ball_d=6+sb;

// -------------------------

level_h=th/2;  // level height (in buildings)
bh = trench_h+magnet_h+2*magnet_cover_w; // board_height

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
if (piece == "board") {
    board();
}
if (piece == "mini_board") {
    mini_board();
}
if (piece == "park") {
    park();
}
if (piece == "flag") {
    flag();
}

if (piece == "manual experimenting") {
//    board();
//    mini_board();
    building(1);
%    park();
//    clue(lett="1");

    //translate([0, 0, mark_h/2+bh/2-trench_h])
//    flag();
//    flag2();
//    flag3();
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
    height=th + level_h*(n);
    
    building_width=tw-2.1;
    
    module windows() {
        x = building_width/5; // width of window
        
        difference() {
            union() {
                rotz()
                for (i = [0:n-1]) {
                    for (j = [-1:1]) {
                        translate([-e, 1.5*j*x, height/2-x-i*(level_h)])
                        cube([building_width+4*e, x, x/2], center=true);
                    }
                }
            }
            cube([0.9*building_width,0.9*building_width,height], center=true);
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
        rh = 0.15*building_width;
        for (i = [0:2]) {
            for (j = [0:2]) {
                if (number[i][j] == 1) {
                    translate([(i-1)*building_width/3, (j-1)*building_width/3, (height + rh)/2-e])
                    cube([x, x, rh], center=true);
                }
            }
        }
    }
    
    //translate([0, 0, height/2-e])
    union() {
        difference() {
            // main building
            union() {
                // base
                base_height=0.6*th;
                translate([0, 0, -height/2+base_height/2-e])
                cube([tw, tw, base_height], center=true);
                // top
                cube([building_width, building_width, height], center=true);
            }
            
            // windows
            windows();
            
            // magnet inside
            %translate([0, 0, -height/2+magnet_h/2+magnet_cover_w])
            cylinder(d=magnet_d, h=magnet_h, center=true);
            
            // bearing ball inside
//            translate([0, 0, -height/2+bearing_ball_d/2+magnet_cover_w])
//            cylinder(d=bearing_ball_d, h=bearing_ball_d, center=true);
        }
        
        // rooftop
        rooftop();
    }
}

module flag3() {
    flag_w=5;
    base_height=0.8*th;
    
    difference() {
        translate([0, 0, -base_height/2+e])
        cube([tw, tw, base_height], center=true);
        
        // magnet inside
        translate([0, 0, -base_height+magnet_h/2+magnet_cover_w])
        cylinder(d=magnet_d, h=magnet_h, center=true);
    }
    
    translate([-flag_w/2, -flag_w/2, 0])
    cube([flag_w, flag_w, 5*level_h]);
}

module flag2() {
    difference() {
        building(3);
        
        translate([0, 0, 10])
        cube(tw, center=true);
        translate([10, -9.5, 8])
        cube(tw, center=true);
        translate([7, 10, 7])
        cube(tw, center=true);
        translate([-10, -8.5, 5.1])
        cube(tw, center=true);
        translate([-6, 6, 6.5])
        cube(tw, center=true);
    }
}

module flag() {
    flag_w=4;
    base_height=0.8*th;
    
    difference() {
        translate([0, 0, -base_height/2+e])
        cube([tw, tw, base_height], center=true);
        
        // magnet inside
        translate([0, 0, -base_height+magnet_h/2+magnet_cover_w])
        cylinder(d=magnet_d, h=magnet_h, center=true);
    }
    
    translate([-level_h, 0, 3*level_h+e])
    {
        translate([0, 0, 1.5*level_h])
        cube([2*level_h, 2, level_h], center=true);
        
        rotate([0, -45, 0])
        difference() {
            rotate([90, 45, 0])
            cube([2*level_h, 2*level_h, 2], center=true);
                
            translate([-50, 0, 0])
            cube([100, 100, 100], center=true);
        }
    }
    
    cylinder(d=3, h=5*level_h);
}

module tree(h, trunk_wr=1.1, crown_hr=1.4, crown_wr=1, crown_y=0) {
    linear_extrude(height=h*level_h, scale=0.4)
    circle(d=trunk_wr*h);
    
    translate([0, 0, h*level_h+crown_y])
    scale([crown_wr, crown_wr, crown_hr])
    sphere(d=1.8*h);
}

module park() {
    base_height=0.8*th;
    
    difference() {
        translate([0, 0, -base_height/2+e])
        cube([tw, tw, base_height], center=true);
        
        // magnet inside
        translate([0, 0, -base_height+magnet_h/2+magnet_cover_w])
        cylinder(d=magnet_d, h=magnet_h, center=true);
    }
    
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

module clue_multi_color_base(lett="") {
    translate([0, 0, th/2])
    difference() {
        cylinder(r = tw/2, h = th, center=true);
        
        if (lett != "") {
            letter(lett, 0.2);
        }
    }
}

module clue_multi_color_letter(lett="") {
    color([0.1,0.1,0.1])
    translate([0, 0, th/2])
    letter(lett, 0.2);
}


module clue(lett="") {
    translate([0, 0, th/2])
    difference() {
        cylinder(r = tw/2, h = th, center=true);
        
        if (lett != "") {
            letter(lett);
        }
    }
}

module letter(lett, offset_r=0.2) {
    translate([0, 0, th/2-lh])
    linear_extrude(height=lh+e)
    offset(r = offset_r)
    text(lett, font="DejaVu Serif:style=Bold", valign="center", halign="center");
}

module mini_board() {
    intersection() {
        board();
        
        translate([n/2*fw, n/2*fw, 0])
        cube(2*fw+e, center = true);
    }
}

module board() {
    difference() {
        // board itself
        cube([(n+2)*fw, (n+2)*fw, bh], center=true);
        

        // clues
        for (i = [-1 : n]) {
            for (j = [-1 : n]) {
                translate([-d + i*fw, -d + j * fw, bh/2+th/2-2*trench_h])
                if (i == -1 || i == n || j == -1 || j == n) {
                    cylinder(d = tw+2*sb, h = th, center=true);
                }
            }
        }
        
        // buildings 
        for (i = [0 : n-1]) {
            for (j = [0 : n-1]) {
                translate([-d + i*fw, -d + j * fw, 0])
                {
                    // 
                    translate([0, 0, bh/2-trench_h+e])
                    linear_extrude(height=trench_h)
                    offset(delta=sb)
                    projection()
                    building(1);
                    
                    // magnet inside
                    translate([0, 0, bh/2-magnet_h/2-trench_h-magnet_cover_w])
                    cylinder(d=magnet_d, h=magnet_h, center=true);
                }
            }
        }
        
        // cut off corners
        mirror_x()
        mirror_y()
        translate([(n+2)/2 * fw, (n+2)/2 * fw, 0])
        rotate([0, 0, 135])
        rounded_cut();

    }
}

// used for cutting rounded corners
module rounded_cut() {
    cw = 1.5 * sqrt(2) * fw + e;
    x = (fw/2)/sqrt(2);
    difference() {
        union() {
        translate([0, cw/2-x, 0])
        cylinder(d=fw, h=2*th, center=true);
        
        
        cube([cw, cw, 2*th-2*e], center = true);
        }
        
        translate([cw/2-x, cw/2+x, 0])
        cylinder(d=fw, h=2*th, center=true);
        
        translate([-cw/2+x, cw/2+x, 0])
        cylinder(d=fw, h=2*th, center=true);
    }
}