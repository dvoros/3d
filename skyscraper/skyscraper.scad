n = 5;

fw = 20; // field_width
bh = 2; // board_height
th = 5; // tile_height
tile_mfr = 0.4;  // mount_width/field_width ratio for inner tiles
clue_mfr = 0.4; // mount_width/field_width ratio for the clues
tfr = 0.75; // tile_width/field_width width ratio
lh = 2; // letter height
trench_w = 1; // trench width
trench_h = 1; // trench width
mark_h = 3; // mark_height (should be bigger then trench_h)

ss = 0.25;
sb = 0.3;
stop = 0.8;

// -------------------------

$fn=50;
e = 0.01;
mh = th / 3; // mount_height
clue_mw = fw * clue_mfr; // mount_width for clues
tile_mw = fw * tile_mfr; // mount_width for tiles
md = (clue_mw + sqrt(2)*clue_mw)/2; // mount_diameter (applies for clues only)
tw = fw * tfr; // tile_width

d = (n-1)/2 * fw;
d2 = (n+1)/2 * fw;

piece = "manual experimenting";
string = "";
num = 1;

if (piece == "clue") {
    clue(string);
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
if (piece == "mark") {
    rotate([180, 0, 0])
    mark();
}

//board();
//mini_board();
//building(6);
//clue(lett="1");

//translate([0, 0, mark_h/2+bh/2-trench_h])
//mark();

module rotz() {
    children();
    
    rotate([0, 0, 90])
    children();
}

module building(n=1) {
    level_h=th/2;
    height=th + level_h*(n);
    
    module windows() {
        x = tw/5; // width of window
        
        difference() {
            union() {
                rotz()
                for (i = [0:n-1]) {
                    for (j = [-1:1]) {
                        translate([-e, 1.5*j*x, height/2-x-i*(level_h)])
                        cube([tw+4*e, x, x/2], center=true);
                    }
                }
            }
            cube([0.9*tw,0.9*tw,height], center=true);
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
        x = tw/4;
        rh = 0.15*tw;
        for (i = [0:2]) {
            for (j = [0:2]) {
                if (number[i][j] == 1) {
                    translate([(i-1)*tw/3, (j-1)*tw/3, (height + rh)/2-e])
                    cube([x, x, rh], center=true);
                }
            }
        }
    }
    
    translate([0, 0, height/2-e])
    union() {
        difference() {
            // main building
            cube([tw, tw, height], center=true);
            
            // bottom hole for mount and mark
            h = sb + mark_h + stop;
            translate([0, 0, -height/2 + h/2 - e])
            cube([tw - 2*trench_w, tw - 2 * trench_w, h], center=true);
            
            // windows
            windows();
        }
        
        // rooftop
        rooftop();
    }
}

module mark() {
    cube([tile_mw-sb, tile_mw-sb, mark_h], center=true);
}

module clue(lett="") {
    translate([0, 0, th/2])
    difference() {
        cylinder(r = tw/2, h = th, center=true);
        
        translate([0, 0, -th/2 + (mh+stop)/2 - e])
        cylinder(d = md + 2*ss, h=mh+stop, center=true);
        
        if (lett != "") {
            letter(lett);
        }
    }
}

module letter(lett) {
    translate([0, 0, th/2-lh])
    linear_extrude(height=lh+e)
    offset(r = 0.2)
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
        union(){
            // board itself
            cube([(n+2)*fw, (n+2)*fw, bh], center=true);
            
            // adding mounts
            for (i = [-1 : n]) {
                for (j = [-1 : n]) {
                    translate([-d + i*fw, -d + j * fw, bh/2+mh/2-e])
                    if (i == -1 || i == n || j == -1 || j == n) {
                        cylinder(d = md, h=mh+e, center=true);
                    }
                }
            }
        }
        
        // trenches
        for (i = [0 : n-1]) {
            for (j = [0 : n-1]) {
                // for buildings
                translate([-d + i*fw, -d + j * fw, bh/2-trench_h+e])
                linear_extrude(height=trench_h)
                offset(delta=sb)
                projection(cut=true)
                building(1);
                
                // for mounts
                translate([-d + i*fw, -d + j * fw, bh/2-trench_h/2+e])
//                cube([tile_mw, tile_mw, mh + e], center = true);
                cube([tile_mw, tile_mw, trench_h], center = true);
            }
        }
        
        // cut off corners
        for (i = [-1, 1]) {
            for (j = [-1, 1]) {
                translate([i*d2, j*d2, 0])
                cube(fw+e, center = true);
            }
        }
    }
}