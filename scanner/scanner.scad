// LIDAR 3D scanner
// by dvoros
//
// TODO:
// - same words used with multiple meaning:
//    - leg
//    - plug

use <../lib/chrisspen_gears/gears.scad>;
use <../lib/mylib.scad>;

e=0.01;
color_orange=[255/255, 165/255, 0/255];

$fn=30;

part="stand";


//
// BEGINNING OF PARAMETER DEFINITIONS
//

//
// Slacks
//

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

// Parameters of bearing responsible for horizontal rotation of the plate
$xbearing_inner_d = 50;
$xbearing_outer_d = 72;
$xbearing_h = 12;

// Parameters of bearing responsible for vertical rotation of the LIDAR mount
$ybearing_inner_d = 6;
$ybearing_outer_d = 13;
$ybearing_h = 5;

// Tooth numbers for the horizontal gears
$base_tooth_num = 100;
$xdriver_tooth_num = 25;

// Tooth numbers for the vertical gears
$stand_tooth_num = 60;
$ydriver_tooth_num = 20;

$bolt_ygear_r = 16;

$gear_h = 10;

$motor_d = 54; // diameter of circle on plate for motor
$motor_h = 40;
$motor_w = 42;
$motor_shaft_h = 23;
$motor_shaft_d = 5;

// distance of y-shaft from the plate
$yshaft_z=70;
$stand_leg_foot_d = 15;

$main_pcb_x = 72;
$main_pcb_y = 72;
$main_pcb_hole_dist = 65;
$main_pcb_hole_offset_x = 4.2; // distance of top-left hole (center) from the left
$main_pcb_hole_offset_y = 3.5; // distance of top-left hole (center) from the top

$plug_pcb_x = 23;
$plug_pcb_y = 11;

$magnet_d=3;
$magnet_h=1.7;

$mount_y=($stand_tooth_num-2)/sqrt(2); // depth of mount
$mount_h=$ybearing_h; // wall width for mount (needs to fit bearing)
$mount_magnet_shaft_dist=$mount_y/2;


$slip_ring_small_d = 7.8;
$slip_ring_small_h = 8.5;
$slip_ring_plate_d = 43.8;
$slip_ring_plate_h = 2.5;
$slip_ring_large_d = 21.8;
$slip_ring_large_h = 28-$slip_ring_plate_h;
$slip_ring_hole_r = $slip_ring_plate_d/2-4.2; // radius of the circle that the holes lie on
$slip_ring_hole_d = 5.5; // diameter of holes
$slip_ring_wire_slack = 10; // necessary distance for wires to bend
$slip_ring_conduit_d = 8;

$lidar_bolts_x=28.6;
$lidar_bolts_y=27.4;

// M2 nut+bolt parameters
// All these need at least a tight fit slack (0.2)
// on their diameter to make a socket
$m2_body_d = 2.0;
$m2_head_d = 4;
$m2_head_h = 1.8;
$m2_nut_square = 4;
$m2_nut_d = 4.6; // ~= $m2_nut_square / cos(30)
$m2_nut_h = 1.5;
$m2_body_after_nut_safety = $m2_nut_h + 2.0;

// M3 nut+bolt parameters
// All these need at least a tight fit slack (0.2)
// on their diameter to make a socket
$m3_body_d = 3.0;
$m3_head_d = 5.8;
$m3_head_h = 2.4;
$m3_nut_square = 5.4;
$m3_nut_d = 6.2; // ~= $m3_nut_square / cos(30)
$m3_nut_h = 2.3;
$m3_body_after_nut_safety = $m3_nut_h + 2.0;

// M4 nut+bolt parameters
// All these need at least a tight fit slack (0.2)
// on their diameter to make a socket
$m4_body_d = 4.0;
$m4_head_d = 8.0;
$m4_head_h = 3.2;
$m4_nut_square = 6.8;
$m4_nut_d = 7.8; // ~= $m4_nut_square / cos(30)
$m4_nut_h = 3.0;
$m4_body_after_nut_safety = $m4_nut_h + 2.0;

// Bolt lengths
$bolt_inner_body_len = 25;
$bolt_outer_body_len = 40;

//
// Voltage source PCB parameters
//
$plug_pcb_pcb_z = 1.6 + 2*$s3;
$plug_pcb_plug_z = 10.9 + 2*$s3;
$plug_pcb_plug_y = 10 + 2*$s3;
$plug_pcb_plug_dist = 3.7; // from the back of the PCB
$plug_pcb_leg_offset = 1; // from the sides of the PCB
$plug_pcb_leg_z = 4.5 + 2*$s3;
$plug_pcb_h = $plug_pcb_leg_z + $plug_pcb_plug_z;

//
// REST IS CALCULATED, DO NOT EDIT!
//

// width where nut is embeddable (horizontally)
$h1m3 = ($m3_nut_h + $s3) * 2; echo($h1m3=$h1m3);
$h1m4 = ($m4_nut_h + $s3) * 2; echo($h1m4=$h1m4);
// diameter where nut is embeddable in the center (vertically)
$h2m3 = ($m3_nut_d + $s3) * 2; echo($h2m3=$h2m3);
$h2m4 = ($m4_nut_d + $s3) * 2; echo($h2m4=$h2m4);
// rigid wall width
$h3 = 0.8;
// place for an M4 head that can't touch the ceiling
$h4 = $m4_head_h + 2*$s5;

$w1 = $xbearing_inner_d - $s2;
$w2 = $xbearing_inner_d + ($xbearing_outer_d - $xbearing_inner_d) / 3;
$w3 = $xbearing_outer_d - ($xbearing_outer_d - $xbearing_inner_d) / 3;
$w4 = $xbearing_outer_d + $s2;
$w5_min = $w4 + 2*$h2m4;
$w5 = $base_tooth_num + 2;

$leg_pcb_gap = 2*$s5;

$plate_d = $w5;
$plate_h = $h1m3;

$xmotor_x = ($base_tooth_num+$xdriver_tooth_num)/2;
$ymotor_z = ($stand_tooth_num+$ydriver_tooth_num)/2;

// distance of stand legs
$stand_legs_dist = $main_pcb_x+4*$s5;
// height of the bottom part of the stand legs
$stand_legs_bottom_width=$h1m4;
// outer width of the LIDAR mount
$mount_x=$stand_legs_dist-2*$leg_pcb_gap-$gear_h;

// TODO: re-enable!!!
//    assert($w5 >= $w5_min, str("teeth number is too small to fit (",$w5,"<",$w5_min,")"));

// Radius of cirlce on which to place the bolts on
$bolt_inner_r = $w1/2 - $h2m3/2;
$bolt_outer_r = $w5/2 - $h2m4/2;

// Desired distrance of nuts from the heads
$bolt_inner_nut_z = $bolt_inner_body_len - $m4_body_after_nut_safety;
$bolt_outer_nut_z = $bolt_outer_body_len - $m4_body_after_nut_safety;

// Middle of bearing is positioned in the center
// relative positions follow

$orange_h = $h1m4;

// height of green part (added up from top to bottom)
$green_h =
    $plate_h // plate height
    + $s5 + $orange_h // space for ORANGE
    + ($xbearing_h/2 - $s4); // within bearing
$plate_z = $green_h + $s4;
    
// height of blue part (added up from top to bottom)
$blue_h = ($xbearing_h/2 - $s4) + $h1m3;

// height of purple part (added up from top to bottom)
$purple_h_min = $slip_ring_small_h + $slip_ring_wire_slack - $h4;

$purple_h = 2*$h3 + $plug_pcb_h;

// height of pink part (added up from top to bottom)
$pink_h = ($xbearing_h - $s4) + $h4 + $h1m3;

// the very bottom when everything's in place
$bottom_z = -($purple_h+$pink_h + $s4 - $xbearing_h/2);

//
// END OF PARAMETERS
//

// Shows all parts of the base station cut in half.
// Useful when working on the base station.
if (part == "station_cut") {
    cut_x()
    {
        base_station();

        %cut_x() xbearing();
        %cut_x() station_bolts();
        %cut_x() pcb(in_place=true);
        %cut_x() slip_ring(in_place=true);
    };
}

// All the stand together (everything that atands on the plate).
if (part == "stand") {
    // plate
    % projection()
    station_green();
    
    stand();
}

if (part == "everything") {
    base_station();
    %station_bolts();
    translate([0, 0, $plate_z])
    stand();
}

if (part == "pink") station_pink();
if (part == "purple") station_purple();
if (part == "orange") station_orange();
if (part == "green") station_green();
if (part == "blue") station_blue();

if (part == "x_driver_gear") driver_gear(tooth_number=$xdriver_tooth_num, inverted=true);
if (part == "y_driver_gear") driver_gear(tooth_number=$ydriver_tooth_num, inverted=true);
if (part == "y_gear_plug") ygear_plug_m4();
if (part == "y_bearing_plug") ybearing_plug_m4();
if (part == "y_gear") y_gear();
if (part == "idle_leg") idle_leg();
if (part == "driver_leg") driver_leg();
if (part == "mount") mount();

module base_station() {
    color("blue")
    station_blue(in_place=true);
    
    color("green")
    station_green(in_place=true);
    
    color("purple")
    station_purple(in_place=true);
    
    color("pink")
    station_pink(in_place=true);
    
    color(color_orange)
    station_orange(true);
}

module stand() {
    // parts of the stand
    idle_leg();
    driver_leg();
    ybearing_plug_m4(in_place=true);
    ygear_plug_m4(in_place=true);
    y_gear(in_place=true);
    mount(in_place=true);
    
    // other accessories
    % pcb();
    % xmotor();
    % ymotor();
    % lidar(in_place=true);
    % ybearings();
}


module hall_hole() {
    h=$h1m3;
    hall_d=4.4;
    hall_l=4;
    
    hole_l=10;
    entrance_deg=80;
    

   translate([0, 0, 0.4 + hall_d/2-e])
    union() {
        translate([0, 0, -0.4/2])
        cube([hall_d, hall_d, hall_d+0.4], center=true);
        
        rotate([0, 90, 0])
        translate([-hall_d/2, -hall_d/2, 0])
        cube([hall_d, hall_d, hole_l]);
        
        x=cos(entrance_deg)*hall_d;
        y=sin(entrance_deg)*hall_d;
        translate([hole_l-x/2, 0, -(hall_d-y)/2])
        rotate([0, entrance_deg, 0])
        translate([-hall_d/2, -hall_d/2, 0])
        cube([hall_d, hall_d, 30]);
    }
}

module magnet_slot() {
    cylinder(d=$magnet_d+$s2, h=$magnet_h+$s1);
}

module y_gear(in_place = false) {
    in_place_translate = in_place ? [-$stand_legs_dist/2 + $leg_pcb_gap, 0, $yshaft_z] : [0, 0, 0];
    in_place_rotate = in_place ? [0, 90, 0] : [0, 0, 0];
    
    translate(in_place_translate)
    rotate(in_place_rotate)
    rotate([0, 0, -45])
    difference() {
        gear(tooth_number=$stand_tooth_num, width=$gear_h, bore=0, angle=210, angle_offset=60);
        
        // shaft
        cylinder(d=$ybearing_outer_d+$s3, h=3*$gear_h, center=true);
        
        // nuts
        z_rot_copy(r=$bolt_ygear_r)
        m3_nut_pocket(z=$gear_h/2);
    }
}

module xmotor() {
    translate([$xmotor_x, 0, 0])
    mirror([0, 0, 1])
    motor();
}
    
module ymotor() {
    motor_plate_dist=$yshaft_z-$ymotor_z;
    
    // motor body
    translate([-$stand_legs_dist/2-$h1m3-$s2, 0, motor_plate_dist])
    rotate([0, 90, 0])
    motor();
    
    // driver gear
    translate([-$stand_legs_dist/2 + $gear_h/2 + $leg_pcb_gap, 0, motor_plate_dist])
    rotate([0, 90, 0])
    translate([0, 0, -$gear_h/2])
    driver_gear(tooth_number=20, inverted=true);
}

module driver_leg() {
    motor_plate_dist=$yshaft_z-$ymotor_z;
    sz=$yshaft_z-$stand_legs_bottom_width; // y-shaft distance from the top of the bottom part
    motor_sz=motor_plate_dist-$stand_legs_bottom_width; // motor's distance from the top of the bottom part
    
    // bottom
    translate([-$main_pcb_x/2-$leg_pcb_gap, 0, 0])
    difference() {
        union() {
            // base
            linear_extrude(height=$h1m4)
            hull() {
                mirror_y()
                mirror([1, 0])
                translate([0, $motor_w/2+$s5])
                leg_zprojection();
            }
            
            // motor holder
            translate([-1.5*$stand_leg_foot_d, -$motor_w/2, 0])
            cube([1.5*$stand_leg_foot_d, $motor_w, motor_plate_dist - $motor_w/2 - $s2]);
            
            // main wall
            translate([0, 0, $stand_legs_bottom_width])
            mirror([1, 0, 0])
            rotate([90, 0, 90])
            difference() {
                linear_extrude(height=$h1m3)
                hull() {
                    // half of depth of legs
                    y = $motor_w/2+$s5+$stand_leg_foot_d;
                    polygon([[-y, 0], [y, 0], [0, sz]]);
                    
                    // round top arounf shaft
                    translate([0, sz])
                    circle(d=$h2m4);
                }
                
                // nut pocket and yshaft
                translate([0, sz, 0])
                mirror([0, 0, 1])
                m4_nut_pocket(z=-$h1m3/2);
                
                // holes for mounting the motor
                translate([0, motor_sz, -e])
                motor_holes();
            }
        }
        
        // bolts on the bottom
        mirror_y()
        mirror([1, 0])
        translate([0, $motor_w/2+$s5, 0])
        leg_bottom_sockets();
    }
    
    
}

module idle_leg() {
    h=$yshaft_z+$h2m4/2;
    mw = $motor_w+2*$s5; // motor width with gap
    sz = $yshaft_z-$stand_legs_bottom_width; // y-shaft distance from the top of the bottom part
    
    translate([$main_pcb_x/2+$leg_pcb_gap, 0, $stand_legs_bottom_width])
    rotate([90, 0, 90])
    difference() {
        linear_extrude(height=$h1m3)
        // triangular part above motor
        difference() {
            
            hull() {
                // half of depth of legs
                y = $motor_w/2+$s5+$stand_leg_foot_d;
                polygon([[-y, 0], [y, 0], [0, sz]]);
                
                // shaft rounding
                translate([0, sz])
                circle(d=$h2m4);
                
                // motor rounding
                mirror_x()
                translate([mw/2, mw - $stand_legs_bottom_width])
                circle(d=20);
            }

            // place for motor
            translate([0, mw/2-$stand_legs_bottom_width])
            square(mw, center=true);
        }
        
        // nut pocket and yshaft
        translate([0, sz, 0])
        mirror([0, 0, 1])
        m4_nut_pocket(z=-$h1m3/2);
        
        // hall hole
        translate([0, sz-$mount_magnet_shaft_dist, 0])
        mirror([1, 0, 0])
        hall_hole();
    }
    
    
    // bottom
    mirror_y()
    translate([$main_pcb_x/2+$leg_pcb_gap, $motor_w/2+$s5])
    difference() {
        linear_extrude(height=$stand_legs_bottom_width)
        leg_zprojection();
        
        leg_bottom_sockets();
    }
}

module leg_bottom_sockets() {
    translate([$stand_leg_foot_d, $stand_leg_foot_d/2, 0])
    m4_head_pocket();
}

module mount(in_place=false) {
    in_place_translate = in_place ? [-$mount_x/2 + $stand_legs_dist/2 - $leg_pcb_gap, 0, $yshaft_z] : [0, 0, 0];
    ledge=($ybearing_outer_d-$ybearing_inner_d)/2/3;
    
    translate(in_place_translate)
    difference() {
        union () {
            intersection() {
                translate([-$mount_x/2, -$mount_y/2 , -$mount_y/2 - $mount_h])
                difference() {
                    r = $mount_x/2 - ($bolt_ygear_r/sin(45));
                    
                    rotate([0, 0, 90])
                    rotate([90, 0, 0])
                    linear_extrude(height=$mount_x)
                    hull() {
                        translate([r, $mount_y+$mount_h-r])
                        circle(r=r);
                        
                        translate([$mount_y-r, $mount_y+$mount_h-r])
                        circle(r=r);
                        
                        square([$mount_y, 1]);
                    }
                    
                    
                    translate([$mount_h, -$mount_y, $mount_h])
                    cube([$mount_x-2*$mount_h, 3*$mount_y, 3*$mount_y]);
                }
                
                // remove parts that would reach out from behind the gear
                rotate([0, 90, 0])
                cylinder(d=$stand_tooth_num, h=3*$mount_x, center=true);
            }
            
            translate([$mount_x/2-$mount_h-2, 0, 0])
            rotate([0, 90, 0])
            cylinder(d=$ybearing_outer_d+$s3+3, h=$mount_h);
        }
        
        // holes for mounting on gear
        translate([-$mount_x/2+$mount_h+e, 0, 0])
        rotate([0, -90, 0])
        z_rot_copy(r=$bolt_ygear_r, offset_deg=45)
        mirror([0, 0, 1])
        m3_head_pocket(z=-$mount_h/2);
        
        // hole for bolt on idle and gear side
        translate([$mount_x/2-$mount_h, 0, 0])
        rotate([0, 90, 0])
        cylinder(d=$ybearing_outer_d+$s3, h=$mount_x);
        rotate([0, 90, 0])
        cylinder(d=$ybearing_outer_d-2*ledge, h=2*$mount_x, center=true);
        
        // holes on the idle side to help assembly
        translate([$mount_x, 0, 0])
        rotate([0, -90, 0])
        z_rot_copy(r=$bolt_ygear_r, offset_deg=45)
        cylinder(d=$m4_head_d+2*$s2, h=$mount_x);

        // bolts for mounting lidar
        mirror_x()
        mirror_y()
        translate([$lidar_bolts_x/2, $lidar_bolts_y/2, 0])
        m3_nut_pocket(z=-$mount_y/2 - $mount_h/2);
        
        // magnet socket
        translate([$mount_x/2+e, 0, -$mount_magnet_shaft_dist])
        rotate([0, -90, 0])
        magnet_slot();
    }
}

module leg_zprojection() {
    hull() {
        translate([$stand_leg_foot_d, $stand_leg_foot_d/2, 0])
        circle(d=$stand_leg_foot_d);
        square([$stand_leg_foot_d/2, $stand_leg_foot_d]);
    }
}

module station_orange(in_place=false) {
    in_place_z = in_place ? $xbearing_h/2 : 0;
    translate([0, 0, in_place_z])
    difference() {
        cylinder(d=$w5, h=$orange_h);
        cylinder(d=$w3, h=3*$orange_h, center=true);
        
        // bolt cutouts
        z_rot_copy(r=$bolt_outer_r)
        m4_head_pocket(z=$orange_h/2);
        
        // magnet slot and notch
        rotate([0, 0, 45]) {
            translate([$bolt_outer_r, 0, $orange_h+e])
            mirror([0, 0, 1])
            magnet_slot();
            
            translate([$w5/2, 0, 0])
            cylinder(d=3, h=3*$orange_h, center=true);
        }
    }
}

module station_pink(in_place=false) {
    base_h= $h4 + $h1m3 + ($xbearing_h-$gear_h) - $s4;
    pink_h = base_h + $gear_h;
    
    in_place_z = in_place ? $bottom_z + $purple_h : 0;
    
    translate([0, 0, in_place_z])
    difference() {
        union() {
            cylinder(d=$w5, h=base_h);
            
            translate([0, 0, base_h])
            gear(tooth_number=$base_tooth_num, width=$gear_h, bore=0);
        }
        
        // smaller dia, under bearing
        cylinder(d=$w3, h=3*pink_h, center=true);
        
        // larger dia, around bearing
        translate([0, 0, $h4+$h1m3])
        cylinder(d=$w4, h=$pink_h);
        
        // bolt cutouts
        z_rot_copy(r=$bolt_outer_r)
        cylinder(d=$m4_body_d+2*$s2, h=3*pink_h, center=true);
    }
}

module station_purple(in_place=false) {
    in_place_z = in_place ? $bottom_z : 0;
    
    translate([0, 0, in_place_z])
    difference() {
        union() {
            cylinder(d=$w5, h=$purple_h);
            
            // mounting holes on the bottom
            difference() {
                h=$h1m4;
                r=$w5/2 + $h2m4/2;
                linear_extrude(height=h)
                rotz()
                difference() {
                    hull()
                    mirror_y()
                    translate([0, r])
                    circle(d=$h2m4);
                }
                
                z_rot_copy(r=r, deg=90)
                m4_head_pocket();
            }
        }
        
        // bolt cutouts
        z_rot_copy(r=$bolt_outer_r)
        m4_nut_pocket(z=$purple_h + $pink_h - ($bolt_outer_nut_z - ($orange_h/2 + $s4)));
        
        // assembly hole for slip ring bolts
        translate([$slip_ring_hole_r, 0, 0])
        cylinder(d=$m4_head_d+2*$s5, h=3*$purple_h, center=true);
        
        // slip ring
        cylinder(d=$slip_ring_small_d+$s2, h=3*$purple_h, center=true);
        
        // conduit
        rotate([0, 90, 45])
        cylinder(d=$slip_ring_conduit_d, h=2*$w5);
        sphere(d=2*$slip_ring_wire_slack);
        
        // voltage plug
        voltage_plug(in_place=true);
    }
}

// plate
module station_green(in_place=false) {
    mirror_z = in_place ? 1 : 0;
    in_place_z = in_place ? $plate_z : 0;
    translate([0, 0, in_place_z])
    mirror([0, 0, mirror_z])
    difference() {
        union() {
            // plate
            linear_extrude(height=$plate_h)
            hull() {
                // main part above base
                circle(d=$plate_d);
                
                // motor holder
                translate([$xmotor_x, 0, 0])
                circle(d=$motor_d);
                
                // legs
                mirror_x()
                mirror_y()
                translate([$main_pcb_x/2+$leg_pcb_gap, $motor_w/2+$s5])
                leg_zprojection();
            }
            
            // middle part that makes space for ORANGE
            translate([0, 0, $plate_h])
            cylinder(d=$w2, h=$orange_h+$s5);
            
            // small disc inside the bearing
            translate([0, 0, $plate_h + $s5 + $orange_h])
            station_inside_bearing();
        }
        
        // middle bolt cutouts
        translate([0, 0, -e])
        z_rot_copy(r=$slip_ring_hole_r, deg=120)
        union() {
            // body of bolt
            cylinder(d=$m4_body_d+2*$s2, h=2*$green_h);
          
            // nut pocket
            hexagon(
                ($m4_nut_d+2*$s2)/2,
                $green_h + $s4 - ($bolt_inner_nut_z - ($blue_h + $s4))
            );
        }
        
        // assembly hole for orange bolts
        translate([0, $bolt_outer_r, -e])
        cylinder(d=$m4_head_d+2*$s2, h=2*$green_h);
        
        // hall sensor
        translate([0, -$bolt_outer_r, $plate_h])
        mirror([0, 0, 1])
        hall_hole();
        
        // motor bolt cutouts
        translate([$xmotor_x, 0, $plate_h+e])
        mirror([0, 0, 1])
        motor_holes();
        
        // slip ring
        cylinder(d=$slip_ring_large_d + 2*$s2, h=3*$green_h, center=true);
        
        // leg bolts with nut pocket
        mirror_x()
        mirror_y()
        translate([$main_pcb_x/2+$leg_pcb_gap, $motor_w/2+$s5])
        translate([$stand_leg_foot_d, $stand_leg_foot_d/2, 0])
        union() {
            cylinder(d=$m4_body_d+2*$s2, h=3*$h1m3, center=true);
            // TODO: we're putting M4 nut into plate that's supposed to only hold M3...
            translate([0, 0, $h1m3/2])
            hexagon(
                ($m4_nut_d+2*$s2)/2,
                $h1m3
            );
        }
        
        // pcb bolts with nut pocket
        pcb_holes();
    }
}

module station_blue(in_place=false) {
    in_place_z = in_place ? -$blue_h-$s4 : 0;
    translate([0, 0, in_place_z])
    difference() {
        union() {
            // larger outer part
            cylinder(d=$w2, h=$h1m3);
            
            // small disc inside the bearing
            translate([0, 0, $h1m3])
            station_inside_bearing();
        }
        
        // bolt cutouts
        z_rot_copy(r=$slip_ring_hole_r, deg=120)
        cylinder(d=$m4_body_d+2*$s2, h=2*$blue_h, center=true);
        
        // slip ring plate
        translate([0, 0, -e])
        cylinder(d=$slip_ring_plate_d + 2*$s2, h=$slip_ring_plate_h+$s2);
        
        // slip ring body
        cylinder(d=$slip_ring_large_d + 2*$s2, h=3*$blue_h, center=true);
    }
}

module station_bolts() {
    z_rot_copy(r=$slip_ring_hole_r, deg=120)
    translate([0, 0, $bolt_inner_body_len - $blue_h - $s4])
    rotate([180, 0, 0])
    m4_with_nut(l=$bolt_inner_body_len, nut_z=$bolt_inner_nut_z, center=false);
    
    // outer
    translate([0, 0, -$bolt_outer_body_len+$xbearing_h/2+$orange_h/2])
    z_rot_copy(r=$bolt_outer_r)
    m4_with_nut(l=$bolt_outer_body_len, nut_z=$bolt_outer_nut_z, center=false);
}

module m3_head_pocket(z=$h1m3-$m3_head_h-$s2) {
    translate([0, 0, z])
    union() {
        cylinder(d=$m3_body_d+2*$s2, h=1000, center=true);
        cylinder(d=$m3_head_d+2*$s2, h=500);
    }
}

module m4_head_pocket(z=$h1m4-$m4_head_h-$s2) {
    translate([0, 0, z])
    union() {
        cylinder(d=$m4_body_d+2*$s2, h=1000, center=true);
        cylinder(d=$m4_head_d+2*$s2, h=500);
    }
}

module m4_nut_pocket(z=0) {
    translate([0, 0, z])
    union() {
        cylinder(d=$m4_body_d+2*$s2, h=1000, center=true);
        
        translate([0, 0, -500])
        hexagon(
            ($m4_nut_d+2*$s2)/2,
            500
        );
    }
}

module m3_nut_pocket(z=0) {
    translate([0, 0, z])
    union() {
        cylinder(d=$m3_body_d+2*$s2, h=1000, center=true);
        
        translate([0, 0, -500])
        hexagon(
            ($m3_nut_d+2*$s2)/2,
            500
        );
    }
}

module xbearing() {
    translate([0, 0, -e])
    difference() {
        cylinder(d=$xbearing_outer_d, h=$xbearing_h, center=true);
        
        cylinder(d=$xbearing_inner_d, h=3*$xbearing_h, center=true);
    }
}

module ybearings() {
    translate([0, 0, $yshaft_z]) {
        translate([$stand_legs_dist/2 - $ybearing_h/2 - $leg_pcb_gap, 0])
        rotate([0, -90, 0])
        {
            %ybearing();
        }

        translate([-$stand_legs_dist/2 + $gear_h/2 + $leg_pcb_gap, 0, 0])
        rotate([0, 90, 0])
        {
            translate([0, 0, $ybearing_h/2])
            %ybearing();
            translate([0, 0, -$ybearing_h/2])
            %ybearing();
        }
    }
}

module ybearing() {
    translate([0, 0, -e])
    difference() {
        cylinder(d=$ybearing_outer_d, h=$ybearing_h, center=true);
        
        cylinder(d=$ybearing_inner_d, h=3*$ybearing_h, center=true);
    }
}

// Part of green and blue that's inside the bearing.
// Doesn't include holes for the bolts.
module station_inside_bearing() {
    h= $xbearing_h/2 - $s4;
    union() {
        // outer ring
        difference() {
            cylinder(d=$w1, h=h);
            translate([0, 0, -h])
            cylinder(d=$w1-2*$h3, h = 3*h);
        }
        
        // bolt supports
        d=($w1/2-$slip_ring_hole_r)*2;
        z_rot_copy(r=$slip_ring_hole_r, deg=120)
        cylinder(d=d, h=h);
    }
}

// l: body length
// nut_z: distance between head and nut
module bolt_with_nut(l, nut_z, head_d, head_h, body_d, nut_h, nut_d, center=true) {
    c = center ? -l/2 : 0;
    
    // head
    translate([0, 0, l+c])
    scale([head_d, head_d, 2*head_h])
    cut_z()
    sphere(d=1);
    
    // body
    translate([0, 0, c])
    cylinder(d=body_d, h=l);
    
    // nut
    translate([0, 0, l - nut_z - nut_h + c])
    hexagon(nut_d/2, nut_h);
}

// l: body length
// nut_z: distance between head and nut
module m3_with_nut(l, nut_z, center=true) {
    bolt_with_nut(l, nut_z, 
        $m3_head_d,
        $m3_head_h,
        $m3_body_d,
        $m3_nut_h, 
        $m3_nut_d,
        center);
}

// l: body length
// nut_z: distance between head and nut
module m4_with_nut(l, nut_z, center=true) {
    bolt_with_nut(l, nut_z, 
        $m4_head_d,
        $m4_head_h,
        $m4_body_d,
        $m4_nut_h, 
        $m4_nut_d,
        center);
}

module pcb(in_place=false) {
    in_place_z = in_place ? $plate_z : 0;
    translate([0, 0, 5 + in_place_z])
    cube([$main_pcb_x, $main_pcb_y, 10], center=true);
}

module slip_ring(in_place=false) {
    in_place_mirror = in_place ? [0, 0, 1] : [0, 0, 0];
    in_place_z = in_place ? $slip_ring_large_h + $slip_ring_plate_h - $blue_h - $s4 : 0;
    
    translate([0, 0, in_place_z])
    mirror(in_place_mirror)
    union() {
    
        cylinder(d=$slip_ring_large_d, h=$slip_ring_large_h);
        
        translate([0, 0, $slip_ring_large_h])
        difference() {
            cylinder(d=$slip_ring_plate_d, h=$slip_ring_plate_h);
            
            z_rot_copy(deg=120)
            translate([$slip_ring_hole_r, 0, 0])
            cylinder(d=$slip_ring_hole_d, h=3*$slip_ring_plate_h, center=true);
        }
        
        translate([0, 0, $slip_ring_large_h+$slip_ring_plate_h])
        cylinder(d=$slip_ring_small_d, h=$slip_ring_small_h);
    }
}

module motor() {
    translate([0, 0, -$motor_h/2])
    cube([$motor_w, $motor_w, $motor_h], center=true);
    
    cylinder(d=$motor_shaft_d, h=$motor_shaft_h);
}

module lidar(in_place = false) {
    in_place_translate = in_place ? [-$mount_x/2 + $stand_legs_dist/2 - $leg_pcb_gap, 0, $yshaft_z - $mount_y/2] : [0, 0, 0];
    
    base_x=48;
    base_y=20;
    base_z=14.6;
    
    
    bolts_d=3.8;
    bolts_h=2.7;
    bolts_dd=6;
    
    lense_d=base_y;
    lense_h=25.6;
    
    bridge_h=22;
    bridge_y=9.7;
    
    translate(in_place_translate)
    union() {
        // base
        translate([0, 0, base_z/2])
        cube([base_x, base_y, base_z], center=true);
        
        // bolts
        for(i=[-1, 1]) {
            linear_extrude(height=bolts_h)
            difference() {
                hull() {
                    for(j=[-1, 1]) {
                        translate([i*$lidar_bolts_x/2, j*(base_y/2 + bolts_dd/2), 0])
                        circle(d=bolts_dd);
                    }
                }
                for(j=[-1, 1]) {
                    translate([i*$lidar_bolts_x/2, j*$lidar_bolts_y/2, 0])
                    circle(d=bolts_d);
                }
            }
        }
        
        // lenses
        for(i=[-1, 1]) {
            translate([i*(base_x/2 - lense_d/2), 0, base_z])
            cylinder(d=lense_d, h=lense_h);
        }
        
        // bridge between lenses
        translate([0, 0, bridge_h/2 + base_z])
        cube([base_x-lense_d, bridge_y, bridge_h], center=true);
    }
}

module gear(tooth_number=50, width=10, bore=10, optimized=false, angle=360, angle_offset=0) {
    /* Herringbone_gear; uses the module "spur_gear"
    modul = Height of the Tooth Tip beyond the Pitch Circle
    tooth_number = Number of Gear Teeth
    width = tooth_width
    bore = Diameter of the Center Hole
    pressure_angle = Pressure Angle, Standard = 20° according to DIN 867. Should not exceed 45°.
    helix_angle = Helix Angle to the Axis of Rotation, Standard = 0° (Spur Teeth)
    optimized = Holes for Material-/Weight-Saving */
    angle=360-angle;
    
    if (angle == 0) {
        herringbone_gear(1, tooth_number, width, bore, pressure_angle = 20, helix_angle=30, optimized=optimized);
    } else {
        difference() {
            herringbone_gear(1, tooth_number, width, bore, pressure_angle = 20, helix_angle=30, optimized=optimized);
            
            difference() {
                rotate([0, 0, angle_offset])
                translate([0, 0, -width])
                rotate_extrude(angle=angle) square([2*tooth_number, 3*width]);
                
                cylinder(r=tooth_number/2 - 5, h=5*width, center=true);
            }
        }
    }
}

module ygear_plug_m4(in_place = false) {
    in_place_translate = in_place ? [-$stand_legs_dist/2 + $gear_h/2 + $leg_pcb_gap, 0, $yshaft_z] : [0, 0, 0];
    in_place_rotate = in_place ? [0, 90, 0] : [0, 0, 0];
    
    translate(in_place_translate)
    rotate(in_place_rotate)
    plug(h=$gear_h, gap=2*$s5);
}

module ybearing_plug_m4(in_place = false) {
    in_place_translate = in_place ? [$stand_legs_dist/2 - $ybearing_h/2 - $leg_pcb_gap, 0, $yshaft_z] : [0, 0, 0];
    in_place_rotate = in_place ? [0, -90, 0] : [0, 0, 0];

    translate(in_place_translate)
    rotate(in_place_rotate)
    plug(h=$ybearing_h, gap=2*$s5);
}

module plug(h=$ybearing_h, gap=$s5) {
    ledge=($ybearing_outer_d-$ybearing_inner_d)/2/3;
    
    translate([0, 0, -h/2-gap])
    difference() {
        union() {
            cylinder(d=$ybearing_inner_d - $s2, h=h + gap);
            cylinder(d=$ybearing_inner_d+2*ledge, h=gap);
        }
        cylinder(d=$m4_body_d+2*$s3, h=100, center=true);
    }
}

module driver_gear(tooth_number=25, nut_h = 2.5, nut_w=5.6, h=16, inverted=true) {
    invert_rotation = inverted ? 180 : 0;
    
    difference() {
        union() {
            // inverted
            translate([0, 0, 5])
            rotate([0, invert_rotation, 0])
            translate([0, 0, -5])
            herringbone_gear(1, tooth_number, 10, 0, pressure_angle = 20, helix_angle=30, optimized=false);
            
            cylinder(d=15, h=h);
        }
        
        // shaft
        translate([0, 0, -e])
        difference() {
            cylinder(d=5.3, h=30);
            
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

module motor_holes() {
    mirror_x()
    mirror_y()
    translate([-31/2, -31/2, 0])
    cylinder(d=$m3_head_d + 2*$s2, h=$m3_head_h + 2*$s2);
    
    linear_extrude(height=50) {
        mirror_x()
        mirror_y()
        translate([-31/2, -31/2, 0])
        circle(d=3.4);
        
        circle(d=24);
    }
    
}

module pcb_holes(nut_slack=$s3) {
    offset_by_default_x = ($main_pcb_x - $main_pcb_hole_dist) / 2;
    offset_by_default_y = ($main_pcb_y - $main_pcb_hole_dist) / 2;
    
    translate([$main_pcb_hole_offset_x-offset_by_default_x, $main_pcb_hole_offset_y-offset_by_default_y, 0])
    mirror_x()
    mirror_y()
    translate([$main_pcb_hole_dist/2, $main_pcb_hole_dist/2, 0])
    pcb_hole(nut_slack=nut_slack);
}

module pcb_hole(nut_slack=$s3) {
    union() {
        // body of bolt
        cylinder(d=$m2_body_d + 2*$s2, h=$green_h*3, center=true);
        
        // nut pocket
        translate([0, 0, $m2_nut_h])
        hexagon(
            ($m2_nut_d+nut_slack)/2,
            $green_h
        );
    }
}

module voltage_plug(in_place=false) {
    in_place_translation = in_place ? [0, 0, 2*$h3+e] : [0, 0, 0];
    in_place_rotation = in_place ? [0, 0, 135] : [0, 0, 0];
    
    rotate(in_place_rotation)
    translate(in_place_translation)
    translate([0, 0, $plug_pcb_leg_z])
    union() {
        translate([-$plug_pcb_x/2 - 2*$h3 + $w5/2 , 0, 0])
        {
            // PCB
            translate([0, 0, -$plug_pcb_pcb_z/2+e])
            cube([$plug_pcb_x, $plug_pcb_y, $plug_pcb_pcb_z], center=true);
            
            
            // Legs
            translate([0, 0, -$plug_pcb_leg_z/2])
            cube([$plug_pcb_x-2*$plug_pcb_leg_offset, $plug_pcb_y-2*$plug_pcb_leg_offset, $plug_pcb_leg_z], center=true);
        }
        
        
        // Plug
        translate([0, -$plug_pcb_plug_y/2, 0])
        cube([$w5, $plug_pcb_plug_y, $plug_pcb_plug_z]);
    }
}