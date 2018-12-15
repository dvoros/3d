n = 4;

fw = 20; // field_width
bh = 2; // board_height
th = 5; // tile_height
mfr = 0.4; // mount_width/field_width ratio
tfr = 0.85; // tile_width/field_width width ratio

ss = 0.15;
sb = 0.5;

// -------------------------

$fn=50;
e = 0.01;
mh = th / 3; // mount_height
mw = fw * mfr; // mount_width
md = (mw + sqrt(2)*mw)/2; // mount_diameter
tw = fw * tfr; // tile_width

d = (n-1)/2 * fw;
d2 = (n+1)/2 * fw;
    
//%board();
//mini_board();
//tile();
//translate([fw, 0, 0])
clue();

module tile() {
    translate([-d + fw, -d + fw, th/2 + bh/2])
    difference() {
        cube([tw, tw, th], center=true);
        
        translate([0, 0, -th/2 + (mh+sb)/2 - e])
        cube([mw+sb, mw+sb, mh+sb], center=true);
    }
}

module clue() {
    translate([-d + fw, -d + fw, th/2 + bh/2])
    difference() {
        cube([tw, tw, th], center=true);
        
        translate([0, 0, -th/2 + (mh+ss)/2 - e])
        cylinder(d = md + 2*ss, h=mh+ss, center=true);
    }
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
            cube([(n+2)*fw, (n+2)*fw, bh], center=true);
            
            for (i = [-1 : n]) {
                for (j = [-1 : n]) {
                    translate([-d + i*fw, -d + j * fw, th/2])
                    if (i == -1 || i == n || j == -1 || j == n) {
                        cylinder(d = md, h=mh+e, center=true);
                    } else {
                        cube([mw, mw, mh + e], center = true);
                    }
                }
            }
        }
        for (i = [-1, 1]) {
            for (j = [-1, 1]) {
                translate([i*d2, j*d2, 0])
                cube(fw+e, center = true);
            }
        }
    }
}