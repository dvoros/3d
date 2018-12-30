n = 4;

fw = 20; // field_width
bh = 2; // board_height
th = 5; // tile_height
mfr = 0.4; // mount_width/field_width ratio
tfr = 0.85; // tile_width/field_width width ratio
lh = 2; // letter height

ss = 0.25;
sb = 0.3;
stop = 0.8;

// -------------------------

$fn=50;
e = 0.01;
mh = th / 3; // mount_height
mw = fw * mfr; // mount_width
md = (mw + sqrt(2)*mw)/2; // mount_diameter
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
    tile(n=num);
}
if (piece == "board") {
    board();
}
if (piece == "mini_board") {
    mini_board();
}

////board();
//mini_board();
//tile(5);
//clue(lett="1");

module tile(n=1) {
    height=th*n;
    // translate([0, 0, height/2])
    translate([-tw/2,-tw/2,0])
    difference() {
        cube([tw, tw, height]);
        
//        translate([0, 0, -height/2 + (mh+stop)/2 - e])
        translate([mw/2+sb, mw/2+sb, -e])
        cube([mw+2*sb, mw+2*sb, mh+stop]);
        
        // Windows
        if (n > 1) {
            x = tw/5; // width of window
            for (i = [0:n-2]) {
                for (j = [0:2]) {
                    translate([-e, x/2 + j*1.5*x, (i+1) * th + e])
                    cube([tw+2*e, x, x]);
                }
                translate([x/2, -e, (i+1) * th + e])
                cube([0.8*tw, tw+2*e, x]);
            }
        }
    }
    
    // rooftop
    for (i = [1:2]) {
        x = tw/pow(1.5,i);
        translate([-x/2, -x/2, height])
        cube([x, x, i*tw/10]);
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
            cube([(n+2)*fw, (n+2)*fw, bh], center=true);
            
            for (i = [-1 : n]) {
                for (j = [-1 : n]) {
                    translate([-d + i*fw, -d + j * fw, bh/2+mh/2-e])
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