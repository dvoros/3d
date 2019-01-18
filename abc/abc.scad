n = 5;

fw = 20; // field_width
bh = 2; // board_height
th = 5; // tile_height
tile_mfr = 0.2;  // mount_width/field_width ratio for inner tiles
clue_mfr = 0.4; // mount_width/field_width ratio for the clues
tfr = 0.75; // tile_width/field_width width ratio
lh = 2; // letter height
trench_w = 1; // trench width
trench_h = 1; // trench width
mark_h = 1; // mark_height

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

//%board();
//mini_board();
//building(5);
//clue(lett="1");
//mark();

module rotz() {
    children();
    
    rotate([0, 0, 90])
    children();
}

module building(n=1) {
    level_h=th/2;
    height=th + level_h*(n-1);
    
    module windows() {
        if (n > 1) {
            x = tw/5; // width of window
            
            difference() {
                union() {
                    rotz()
                    for (i = [0:n-2]) {
                        for (j = [-1:1]) {
                            translate([-e, 1.5*j*x, height/2-x-i*(level_h)])
                            cube([tw+4*e, x, x/2], center=true);
                        }
                    }
                }
                cube([0.9*tw,0.9*tw,height], center=true);
            }
        }
    }
    
    // n: building number
    module rooftop() {
        for (i = [1:2]) {
            rh = 0.1*i*tw;
            x = tw/pow(1.5,i);
            translate([0, 0, (height + rh)/2-e])
            cube([x, x, rh], center=true);
        }
    }
    
    translate([0, 0, height/2-e])
//    translate([-tw/2,-tw/2,0])
    union() {
        difference() {
            cube([tw, tw, height], center=true);
            
            h = trench_h + mh + sb + mark_h + stop;
            translate([0, 0, (mh+stop-height)/2-e])
            cube([tw - 2*trench_w, tw - 2 * trench_w, h], center=true);
            
            // windows
            windows(n);
        }
        
        // rooftop
        rooftop(n);
    }
}

module mark() {
    w = tile_mw + 2*mark_h + 2*sb;
    h = mh + sb + mark_h;
    difference() {
        translate([0, 0, h/2])
        cube([w, w, h], center=true);
        
        translate([0, 0, (mh + sb)/2 - e])
        cube([w - 2*mark_h, w - 2*mark_h, mh + sb], center = true);
    }
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
                    } else {
                        cube([tile_mw, tile_mw, mh + e], center = true);
                    }
                }
            }
        }
        
        // trenches for buildings
        for (i = [0 : n-1]) {
            for (j = [0 : n-1]) {
                #translate([-d + i*fw, -d + j * fw, bh/2-trench_h+e])
                linear_extrude(height=trench_h)
                offset(delta=sb)
                projection(cut=true)
                building(1);
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