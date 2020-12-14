use <../lib/chrisspen_gears/gears.scad>;
use <../lib/mylib.scad>;

e=0.01;
color_orange=[255/255, 165/255, 0/255];

//gear();
//platform(75/2);
//motor_platform(75/2);
//driver_gear();
//bearing_inner();
//large_bearing();
#translate([0, 0, -20]) slip_ring();
pcb();

cut_x()
maxi_station() {
    color("blue")
    station_blue(in_place=true);
    
    color("green")
    station_green(in_place=true);
    
    color("purple")
    station_purple(in_place=true);
    
    color(color_orange)
    station_orange(true);

//    station_bearing();
    
    station_bolts();
};

//maxi_station()
//station_orange();
//station_purple();
//station_green();
//station_blue();

module maxi_station() {
    $fn=100;
    
    $bearing_inner_d = 50;
    $bearing_outer_d = 72;
    $bearing_h = 12;
    
    $tooth_num = 100;
    $gear_h = 10;
    
    
    $slip_ring_small_d = 7.8;
    $slip_ring_large_d = 21.8;
    $slip_ring_plate_h = 0; // TODO: is slipring plate on the inside?
    
    
    // M3 nut+bolt parameters
    // All these need at least a tight fit slack (0.2)
    // on their diameter to make a socket
    $m3_body_d = 3.0;
    $m3_head_d = 5.8;
    $m3_head_h = 2.4;
    $m3_nut_square = 5.4;
    $m3_nut_d = 6.2;
    $m3_nut_h = 2.3;
    $m3_body_after_nut_safety = 4; // includes nut height
    
    // M4 nut+bolt parameters
    // All these need at least a tight fit slack (0.2)
    // on their diameter to make a socket
    $m4_body_d = 4.0;
    $m4_head_d = 8.0;
    $m4_head_h = 3.2;
    $m4_nut_square = 6.8;
    $m4_nut_d = 7.8;
    $m4_nut_h = 3.0;
    $m4_body_after_nut_safety = 6; // includes nut height
    
    // Bolt length
    $bolt_inner_body_len = 16;
    $bolt_outer_body_len = 20;
    
    
    // "no slack"
    $s0 = 0;
    // very tight fit
    $s1 = 0.15;
    // easy fit
    $s2 = 0.3;
    // tight fit
    $s3 = 0.2;
    // needs to be pulled together with a bolt to get a tight fit
    $s4 = 0.4;
    // can't touch
    $s5 = 0.8;
    
    
    // REST IS CALCULATED, DO NOT EDIT!
    
    // width where m3 nut is embeddable (horizontally)
    $h1 = ($m3_nut_h + $s3) * 2; echo($h1=$h1);
    // diameter where m3 nut is embeddable in the center (vertically)
    $h2 = ($m3_nut_d + $s3) * 2; echo($h2=$h2);
    // rigid wall width
    $h3 = 0.8;
    $h4 = $slip_ring_plate_h + $s5;
    
    $w1 = $bearing_inner_d - $s2;
    $w2 = $bearing_inner_d + ($bearing_outer_d - $bearing_inner_d) / 3;
    $w3 = $bearing_outer_d - ($bearing_outer_d - $bearing_inner_d) / 3;
    $w4 = $bearing_outer_d + $s2;
    $w5_min = $w4 + 2*$h2;
    $w5 = $tooth_num + 2;
    
    
    $plate_d = $w5;
    
    assert($w5 >= $w5_min, "teeth number is too small to fit");
    
    // Radius of cirlce on which to place the bolts on
    $bolt_inner_r = $w1/2 - $h2/2;
    $bolt_outer_r = $w5/2 - $h2/2;
    
    // Desired distrance of nuts from the heads
    $bolt_inner_nut_z = $bolt_inner_body_len - $m3_body_after_nut_safety;
    $bolt_outer_nut_z = $bolt_outer_body_len - $m3_body_after_nut_safety;
    
    // Middle of bearing is positioned in the center
    // relative positions follow
    
    // height of green part (added up from top to bottom)
    $green_h =
        $h1 // plate width
        + $s5 + $h1 // space for ORANGE
        + ($bearing_h/2 - $s4); // within bearing
        
    // height of blue part (added up from top to bottom)
    $blue_h = ($bearing_h/2 - $s4) + $h1;
    
    // height of purple part (added up from top to bottom)
    $purple_h = $h1 + $h4 + $h1 + ($bearing_h - $s4);
    
    $orange_h = $h1;
    
    children();
}

module station_orange(in_place=false) {
    in_place_z = in_place ? $bearing_h/2 : 0;
    translate([0, 0, in_place_z])
    difference() {
        cylinder(d=$w5, h=$h1);
        cylinder(d=$w3, h=$orange_h);
        
        // bolt cutouts
        z_rot_copy(r=$bolt_outer_r)
        union() {
            // body of bolt
            cylinder(d=$m3_body_d+$s2, h=$orange_h);
          
            // bolt_head pocket
            translate([0, 0, $orange_h/2])
            cylinder(d=$m3_head_d+2*$s2, h=$orange_h);
        }
    }
}

// TODO: - holes for mounting slip-ring
//       - border around slip-ring on the bottom to make sure it
//         is centered when attaching
module station_purple(in_place=false) {
    in_place_z = in_place ? -($purple_h + $s4 - $bearing_h/2) : 0;
    translate([0, 0, in_place_z])
    difference() {
        union() {
            base_h= $h1 + $h4 + $h1 + ($bearing_h-$gear_h)/2;
            cylinder(d=$w5, h=base_h);
            
            translate([0, 0, base_h])
            gear(tooth_number=$tooth_num, width=$gear_h, bore=0);
        }
        
        // smaller dia, under bearing
        translate([0, 0, $h1])
        cylinder(d=$w3, h=$purple_h);
        
        // larger dia, around bearing
        translate([0, 0, $h1+$h4+$h1])
        cylinder(d=$w4, h=$purple_h);
        
        // bolt cutouts
        z_rot_copy(r=$bolt_outer_r)
        union() {
            // body of bolt
            cylinder(d=$m3_body_d+$s2, h=$purple_h);
          
            // nut pocket
            hexagon(
                ($m3_nut_d+2*$s2)/2,
                $purple_h - ($bolt_outer_nut_z - ($h1/2 + $s4))
            );
        }
        
        // slip ring
        cylinder(d=$slip_ring_large_d, h=$purple_h);
    }
    
}


module station_green(in_place=false) {
    mirror_z = in_place ? 1 : 0;
    in_place_z = in_place ? $green_h + $s4 : 0;
    translate([0, 0, in_place_z])
    mirror([0, 0, mirror_z])
    difference() {
        union() {
            // plate
            cylinder(d=$plate_d, h=$h1);
            
            // middle part that makes space for ORANGE
            translate([0, 0, $h1])
            cylinder(d=$w2, h=$h1+$s5);
            
            // small disc inside the bearing
            translate([0, 0, $h1 + $s5 + $h1])
            station_inside_bearing();
        }
        
        // bolt cutouts
        z_rot_copy(r=$bolt_inner_r)
        union() {
            // body of bolt
            cylinder(d=$m3_body_d+$s2, h=$green_h);
          
            // bolt_head pocket
            cylinder(d=$m3_head_d+2*$s2, h=$green_h+$s4-$bolt_inner_body_len/2);
        }
        
        // slip ring
        cylinder(d=$slip_ring_small_d, h=$green_h);
    }
}

module station_blue(in_place=false) {
    in_place_z = in_place ? -$blue_h-$s4 : 0;
    translate([0, 0, in_place_z])
    difference() {
        union() {
            // larger outer part
            cylinder(d=$w2, h=$h1);
            
            // small disc inside the bearing
            translate([0, 0, $h1])
            station_inside_bearing();
        }
        
        // bolt cutouts
        z_rot_copy(r=$bolt_inner_r)
        union() {
            // body of bolt
            cylinder(d=$m3_body_d+$s2, h=$blue_h);
          
            // nut pocket
            hexagon(($m3_nut_d+2*$s2)/2, $blue_h+$s4-($bolt_inner_nut_z-$bolt_inner_body_len/2));
        }
        
        // slip ring
        cylinder(d=$slip_ring_small_d, h=$blue_h);
    }
}

module station_bolts() {
    z_rot_copy(r=$bolt_inner_r)
    m3_with_nut(l=$bolt_inner_body_len, nut_z=$bolt_inner_nut_z, center=true);
    
    
    translate([0, 0, -$bolt_outer_body_len+$bearing_h/2+$h1/2])
    z_rot_copy(r=$bolt_outer_r)
    m3_with_nut(l=$bolt_outer_body_len, nut_z=$bolt_outer_nut_z, center=false);
}

module station_bearing() {
    translate([0, 0, -e])
    difference() {
        cylinder(d=$bearing_outer_d, h=$bearing_h, center=true);
        
        cylinder(d=$bearing_inner_d, h=3*$bearing_h, center=true);
    }
}

// Part of green and blue that's inside the bearing.
// Doesn't include holes for the bolts.
module station_inside_bearing() {
    h= $bearing_h/2 - $s4;
    union() {
        // outer ring
        difference() {
            cylinder(d=$w1, h=h);
            translate([0, 0, -h])
            cylinder(d=$w1-2*$h3, h = 3*h);
        }
        
        // bolt supports
        z_rot_copy(r=$bolt_inner_r)
        cylinder(d=$h2, h=h);
    }
}

// l: body length
// nut_z: distance between head and nut
module m3_with_nut(l, nut_z, center=true) {
    c = center ? -l/2 : 0;
    
    // head
    translate([0, 0, l+c])
    scale([$m3_head_d, $m3_head_d, 2*$m3_head_h])
    cut_z()
    sphere(d=1);
    
    // body
    translate([0, 0, c])
    cylinder(d=$m3_body_d, h=l);
    
    // nut
    translate([0, 0, l - nut_z - $m3_nut_h + c])
    hexagon($m3_nut_d/2, $m3_nut_h);
}

module z_rot_copy(r=0, arr=[0:90:360]) {
    for(rot=arr) {
        rotate([0, 0, rot])
        translate([r, 0, 0])
        children();
    }
}

module mini_station() {
    $fn = 200;
    bearing_inner_d = 40;
    bearing_outer_d = 60;
    bearing_height = 10;
    
    nut_h = 2.5;
    nut_w = 5.6;
    simple = true;
    
    h1=2;
    h2=6;
    h3=2;
    bolt_out_d=10;
    bolt_r=(bearing_inner_d-0.2)/2 - bolt_out_d/2;
    
    module blue() {
        // mid
        translate([0, 0, bearing_height/2])
        cylinder(d=bearing_inner_d + h2, h=h1+e);
        
        // bottom
        translate([0, 0, 0.3])
        cylinder(d=bearing_inner_d-0.6, h=bearing_height/2-0.3+e);
    }
    module blue_cutout() {
        translate([0, 0, -e])
        difference() {
            cylinder(d=bearing_inner_d-0.6-1, h=bearing_height/2);
            for (x = [[0, 1], [0, -1], [1, 0], [-1, 0]]) {
                translate([x[0]*bolt_r, x[1]*bolt_r, 0])
                cylinder(d=bolt_out_d, h=bearing_height/2 + h1);
            }
        }
        
        
        for (x = [[0, 1], [0, -1], [1, 0], [-1, 0]]) {
            translate([x[0]*bolt_r, x[1]*bolt_r, -e])
            cylinder(d=3.2, h=100);
        }
    }
    
    // BLUE
    color("blue")
    mirror([0, 0, 1])
    difference() {
        blue();
        
        blue_cutout();
    }
    
    
    // GREEN
    color("green")
    difference() {
        union() {
            // top
            translate([0, 0, bearing_height/2 + h1 -e])
            cylinder(d=bearing_outer_d + 2, h=h3+e);
            
            blue();
        }
        blue_cutout();
    }
    
    // PURPLE
    color("purple")
    union() {
        translate([0, 0, -5])
        gear(tooth_number=70, width=10, bore=bearing_outer_d+0.6);
        
        translate([0, 0, -h1-h3-5-e])
        difference() {
            cylinder(d=bearing_outer_d+h2, h=h1+h3+e);
            translate([0, 0, h3-1])
            cylinder(d=bearing_outer_d-h2, h=100);
            
            // holes on the bottom
            cylinder(d=21.8+0.5, h=100, center=true);
            for (i=[0:60:360]) {
                rotate([0, 0, i])
                translate([20, 0, 0])
                cylinder(d=12, h=100, center=true);
            }
        }
    }
    
    // ORANGE
    color([242/256,98/256,35/256])
    translate([0, 0, 2*h1-5-e])
    difference() {
        cylinder(d=bearing_outer_d+h2, h=h1-1);
        translate([0, 0, -h1])
        cylinder(d=bearing_outer_d-h2, h=2*h1);
    }
    
    

    
   
    
    large_bearing(inner_d=bearing_inner_d, ball_d=6.3, raceway_width=bearing_height, outer_d=bearing_outer_d, num_balls=14, simple=true);
}


module pcb() {
    translate([0, 0, 22])
    cube([72, 72, 10], center=true);
}

module slip_ring() {
    cylinder(d=21.8, h=26.5);
    
    translate([0, 0, 19])
    cylinder(d=44.5, h=3); // TODO: 3 was only a guess
    
    translate([0, 0, 26.5 - e])
    cylinder(d=7.8, h=9.5);
}


// names are from here: https://www.researchgate.net/figure/Geometry-and-dimensions-of-a-deep-groove-ball-bearing_fig11_222797271
module large_bearing(inner_d=40, ball_d=6.3, raceway_width=10, outer_d=60, num_balls=14, simple=false) {
    $fn=50;
    
    
    wall = (outer_d - inner_d - 2*ball_d) / 4;
    ball_r=ball_d/2;
    pitch_d=inner_d + 2*(wall + ball_r);
    angle_per_ball=360/num_balls;
    
    echo(inner_d=inner_d);
    echo(pitch_d=pitch_d);
    echo(outer_d=outer_d);
    echo(wall=wall);
    echo(raceway_width=raceway_width);
    
    
    if (simple) {
        $fn=200;
        difference() {
            cylinder(d=outer_d, h=raceway_width, center=true);
            cylinder(d=inner_d, h=2*raceway_width, center=true);
        }
    } else {
        // walls
        
        difference() {
            rotate_extrude(angle = 360, convexity = 4, $fn=200)
            translate([pitch_d/2, 0, 0])
            difference() {
                square([ball_d + 2*wall, raceway_width], center=true);
                square([1.4, raceway_width+9], center=true);
                circle(d=ball_d);
            }
            
            // cut on the outer part
            translate([pitch_d, 0, 0])
            cube([pitch_d, 0.4, pitch_d], center=true);
        }
        
        
        // separator

        difference() {
            rotate_extrude(angle = 360, convexity = 2, $fn=200)
            translate([pitch_d/2, 0, 0])
            square([0.6, raceway_width-1.4], center=true);
            
            // ball cutouts
            for(rot = [0:angle_per_ball:360]) {
                rotate([0, 0, rot])
                translate([pitch_d/2, 0, 0])
                rotate([45, 0, 0])
                rotate([0, 90, 0])
                translate([0, 0, -ball_d/2])
                linear_extrude(height=ball_d)
                intersection() {
                    hull() for (x = [[-1, 1], [-1, -1], [1, 1], [1, -1]]) {
                    translate([x[0]*0.75*(ball_r + 0.1), x[1]*0.75*(ball_r + 0.1), 0])
                    circle(d=ball_d/4);
                };
                rotate([0, 0, -45])
                square([ball_d+0.4, 2*ball_d], center=true);
                }
            }
        }
        
        // balls
        
//        for(rot = [0:angle_per_ball:360]) {
//            rotate([0, 0, rot])
//            translate([pitch_d/2, 0, 0])
//            sphere(d=ball_d-0.2);
//        }
    }
}

module gear(tooth_number=50, width=10, bore=10, optimized=false) {
    /* Herringbone_gear; uses the module "spur_gear"
    modul = Height of the Tooth Tip beyond the Pitch Circle
    tooth_number = Number of Gear Teeth
    width = tooth_width
    bore = Diameter of the Center Hole
    pressure_angle = Pressure Angle, Standard = 20° according to DIN 867. Should not exceed 45°.
    helix_angle = Helix Angle to the Axis of Rotation, Standard = 0° (Spur Teeth)
    optimized = Holes for Material-/Weight-Saving */
    herringbone_gear(1, tooth_number, width, bore, pressure_angle = 20, helix_angle=30, optimized=optimized);
}

module bearing_inner() {
    $fn=50;
    difference() {
        cylinder(d=5.8, h=9.8);
        cylinder(d=3.4, h=100, center=true);
    }
}

module driver_gear(tooth_number=25, nut_h = 2.5, nut_w=5.6, h=16) {
    $fn=50;
    
//    render(convexity = 2)
    difference() {
        union() {
            herringbone_gear(1, tooth_number, 10, 0, pressure_angle = 20, helix_angle=30, optimized=false);
            cylinder(d=15, h=h);
        }
        
        // shaft
        translate([0, 0, -e])
        difference() {
            cylinder(d=5.1, h=30);
            
            translate([5.1/2 - 0.5, -50, 0])
            cube(100);
        }
        
        // M3 pocket
        translate([5.1/2 - 0.5 + 1, -nut_w/2, h - nut_w + e])
        m3_side_pocket();
        
        translate([0, 0, h - nut_w/2])
        rotate([0, 90, 0])
        cylinder(d = 3.4, h = 20);
    }
    
    
}

module m3_side_pocket(nut_h = 2.5, nut_w=5.6, center=false) {
    cube([nut_h, nut_w, nut_w], center=center);
}

module motor_platform(dist, h=6, bolt_head_d = 5.7, nut_h = 2.5) {
    $fn=60;
    difference() {
        union() {
            // motor baseline
            linear_extrude(height=3, convexity=3)
            difference() {
                hull() {
                    mirror_x()
                    mirror_y()
                    translate([-31/2, -31/2, 0])
                    circle(d=8);
                }
                mirror_x()
                mirror_y()
                translate([-31/2, -31/2, 0])
                circle(d=3.4);
            }
            
            // motor ledge
            cylinder(d=34, h=h);
            
            // gear
            linear_extrude(height=h)
            hull() {
                translate([dist, 0, 0])
                circle(r=10);
                circle(r=10);
            }
        }
        
        translate([0, 0, -e])
        cylinder(d=24, h=100);
        
        // gear
        translate([dist, 0, 0])
        cylinder(d=3.2, center=true, h=3*h);
        translate([dist, 0, -e])
        cylinder(d=bolt_head_d, h=nut_h);
    }
    
    
}

module platform(dist, nut_h = 2.5, bolt_head_d = 5.5, height = 6) {
    $fn = 40;
    difference() {
    linear_extrude(height=height)
    hull() {
        translate([dist, 0, 0])
        circle(r=10);
        circle(r=10);
    }
    translate([dist, 0, 0])
    cylinder(d=3.2, center=true, h=3*height);
    cylinder(d=3.2, center=true, h=3*height);


    translate([0, 0, -e])
    cylinder(d=bolt_head_d, h=nut_h);
    translate([dist, 0, -e])
    cylinder(d=bolt_head_d, h=nut_h);

    translate([0, 0, height-nut_h+e])
    hexagon(3.4, nut_h);
    translate([dist, 0, height-nut_h+e])
    hexagon(3.4, nut_h);
    }
}

module cut_x() {
    intersection() {
        children();
        
        translate([-500, 0, -500])
        cube(1000);
    }
}
module cut_z() {
    intersection() {
        children();
        
        translate([-500, -500, 0])
        cube(1000);
    }
}


module hexagon(r, h) {
    linear_extrude(h)
    scale([r, r, 1])
    regular_polygon(6);
}

 module regular_polygon(order, r=1){
    angles=[ for (i = [0:order-1]) i*(360/order) ];
    coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
    polygon(coords);
 }