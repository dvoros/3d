use <../lib/chrisspen_gears/gears.scad>;
use <../lib/mylib.scad>;

e=0.01;
color_orange=[255/255, 165/255, 0/255];

$fn=100;

//gear();
//platform(75/2);
//motor_platform(75/2);
//maxi_station() motor_holes();
//driver_gear(tooth_number=20, inverted=true);
//bearing_inner();


//maxi_station()
//slip_ring();

//cut_x()
//maxi_station() {
//    color("blue")
//    station_blue(in_place=true);
//    
//    color("green")
//    station_green(in_place=true);
//    
//    color("purple")
//    station_purple(in_place=true);
//    
//    color(color_orange)
//    station_orange(true);
//
////    xbearing();
//    
////    station_bolts();
//    
////    color("cyan") pcb(in_place=true);
//    
//    %slip_ring(in_place=true);
//};


maxi_station()
//station_purple();
//station_green();
//station_orange();
station_blue();


//maxi_station() {
//    projection()
//    station_green();
//    
//    % pcb();
//    
//    translate([$xmotor_x, 0, 0])
//    mirror([0, 0, 1])
//    % motor();
//    
//
//    mini_stand();
//}

//maxi_station()
//mini_stand();


//ygear_plug_m4();
//ybearing_plug_m4();
//y_gear();

//maxi_station()
//hall_hole();



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


module maxi_station() {
    $xbearing_inner_d = 50;
    $xbearing_outer_d = 72;
    $xbearing_h = 12;
    
    $ybearing_inner_d = 6;
    $ybearing_outer_d = 13;
    $ybearing_h = 5;
    
    $base_tooth_num = 100;
    $xdriver_tooth_num = 25;
    
    $stand_tooth_num = 60;
    $ydriver_tooth_num = 20;
    
    $bolt_ygear_r = 16;
    
    $gear_h = 10;
    
    $motor_d = 54; // diameter of circle on plate for motor
    $motor_h = 40;
    $motor_w = 42;
    $motor_shaft_h = 23;
    $motor_shaft_d = 5;
    
    $leg_wall_d = 15;
    
    $pcb_x = 72;
    $pcb_y = 72;
    
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
    $slip_ring_wire_slack = 8; // necessary distance for wires to bend
    $slip_ring_conduit_d = 8;
    
    $lidar_bolts_x=28.6;
    $lidar_bolts_y=27.4;
    
    
    // M3 nut+bolt parameters
    // All these need at least a tight fit slack (0.2)
    // on their diameter to make a socket
    $m3_body_d = 3.0;
    $m3_head_d = 5.8;
    $m3_head_h = 2.4;
    $m3_nut_square = 5.4;
    $m3_nut_d = 6.2;
    $m3_nut_h = 2.3;
    $m3_body_after_nut_safety = $m3_nut_h + 2.0;
    
    // M4 nut+bolt parameters
    // All these need at least a tight fit slack (0.2)
    // on their diameter to make a socket
    $m4_body_d = 4.0;
    $m4_head_d = 8.0;
    $m4_head_h = 3.2;
    $m4_nut_square = 6.8;
    $m4_nut_d = 7.8;
    $m4_nut_h = 3.0;
    $m4_body_after_nut_safety = $m4_nut_h + 2.0;
    
    // Bolt length
    $bolt_inner_body_len = 20;
    $bolt_outer_body_len = 35;
    
    
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
    
    // width where nut is embeddable (horizontally)
    $h1m3 = ($m3_nut_h + $s3) * 2; echo($h1m3=$h1m3);
    $h1m4 = ($m4_nut_h + $s3) * 2; echo($h1m4=$h1m4);
    // diameter where nut is embeddable in the center (vertically)
    $h2m3 = ($m3_nut_d + $s3) * 2; echo($h2m3=$h2m3);
    $h2m4 = ($m4_nut_d + $s3) * 2; echo($h2m4=$h2m4);
    // rigid wall width
    $h3 = 0.8;
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
    
    // TODO: re-enable!!!
//    assert($w5 >= $w5_min, "teeth number is too small to fit");
    
    // Radius of cirlce on which to place the bolts on
    $bolt_inner_r = $w1/2 - $h2m3/2;
    $bolt_outer_r = $w5/2 - $h2m4/2;
    
    // Desired distrance of nuts from the heads
    $bolt_inner_nut_z = $bolt_inner_body_len - $m3_body_after_nut_safety;
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
    
    $purple_bottom_h = $slip_ring_small_h + $slip_ring_wire_slack - $h4;
    // height of purple part (added up from top to bottom)
    $purple_h = $purple_bottom_h + $h4 + $h1m3 + ($xbearing_h - $s4);
    
    
    
    children();
}

module y_gear() {
    difference() {
        gear(tooth_number=$stand_tooth_num, width=$gear_h, bore=0);
        cylinder(d=$ybearing_outer_d+$s3, h=$gear_h);
        
        z_rot_copy(r=$bolt_ygear_r)
        union() {
            // body of bolt
            cylinder(d=$m3_body_d+2*$s2, h=$gear_h);
          
            // nut pocket
            hexagon(
                ($m3_nut_d+2*$s2)/2,
                $gear_h/2
            );
        }
    }
}

module mini_stand() {
    h=70;
    
//    translate([0, 0, $plate_z+h])
    stand(
        dist=$pcb_x+4*$s5,
        shaft_z=h,
        y=30
    );
}

// dist: distance between legs
// shaft_z: shaft distance from plate
// y: 
module stand(dist, shaft_z, y) {
    x=dist+2*$h1m4;
    
    
    
    mount_x=dist-2*$leg_pcb_gap-$gear_h;
    
    
    leg_bottom_width=$h1m4;
    
    ledge=($ybearing_outer_d-$ybearing_inner_d)/2/3;
    
    motor_plate_dist=shaft_z-$ymotor_z;
    
    y = $motor_w/2+$s5+$leg_wall_d;
    sz = shaft_z-leg_bottom_width; // shaft distance from the top of the bottom part
    mw = $motor_w+2*$s5; // motor width with gap
    
//    test_stand_legs();
    
//    mount();
    
    color("green")
    idle_leg();
    color("red")
    driver_leg();
    %ymotor();
    
    
    
    
    translate([0, 0, shaft_z]) {
        translate([-mount_x/2 + dist/2 - $leg_pcb_gap, 0, 0]) {
            mount();
            translate([0, 0, -y/2 - $mount_h/2])
            %lidar();
        }
        
        
        // bearing+plug
        translate([dist/2 - $ybearing_h/2 - $leg_pcb_gap, 0])
        rotate([0, -90, 0])
        {
            ybearing_plug_m4();
            %ybearing();
        }

        // gear+bearings+plug
        translate([-dist/2 + $gear_h/2 + $leg_pcb_gap, 0, 0])
        rotate([0, 90, 0])
        {
            translate([0, 0, $ybearing_h/2])
            %ybearing();
            translate([0, 0, -$ybearing_h/2])
            %ybearing();
            ygear_plug_m4();
        }
        
        translate([-dist/2 + $leg_pcb_gap, 0, 0])
        rotate([0, 90, 0])
        rotate([0, 0, 45])
        y_gear();
        
    }
    
    module ymotor() {
        // motor body
        translate([-dist/2-$h1m3-$s2, 0, motor_plate_dist])
        rotate([0, 90, 0])
        motor();
        
        // driver gear
        translate([-dist/2 + $gear_h/2 + $leg_pcb_gap, 0, motor_plate_dist])
        rotate([0, 90, 0])
        translate([0, 0, -$gear_h/2])
        driver_gear(tooth_number=20);
    }
    
    module driver_leg() {
        
        
        y=$motor_w/2+$s5+$leg_wall_d;
        sz=shaft_z-leg_bottom_width; // y-shaft distance from the top of the bottom part
        motor_sz=motor_plate_dist-leg_bottom_width; // motor's distance from the top of the bottom part
        
        
        // bottom
        translate([-$pcb_x/2-$leg_pcb_gap, 0, 0])
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
                translate([-1.5*$leg_wall_d, -$motor_w/2, 0])
                cube([1.5*$leg_wall_d, $motor_w, motor_plate_dist - $motor_w/2 - $s2]);
                
                // main wall
                translate([0, 0, leg_bottom_width])
                mirror([1, 0, 0])
                rotate([90, 0, 90])
                difference() {
                    linear_extrude(height=$h1m3)
                    difference() {
                        
                        hull() {
                            polygon([[-y, 0], [y, 0], [0, sz]]);
                            
                            // shaft rounding
                            translate([0, sz])
                            circle(d=$h2m4);
                        }
                        
                        // yshaft
                        translate([0, sz])
                        circle(d=$m4_body_d+2*$s2);
                        
                    }
                    
                    // nut pocket on yshaft
                    translate([0, sz, $h1m3/2])
                    hexagon(
                        ($m4_nut_d+2*$s2)/2,
                        $h1m3
                    );
                    
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
        h=shaft_z+$h2m4/2;
        
        translate([$pcb_x/2+$leg_pcb_gap, 0, leg_bottom_width])
        rotate([90, 0, 90])
        difference() {
            linear_extrude(height=$h1m3)
            // triangular part above motor
            difference() {
                
                hull() {
                    polygon([[-y, 0], [y, 0], [0, sz]]);
                    
                    // shaft rounding
                    translate([0, sz])
                    circle(d=$h2m4);
                    
                    // motor rounding
                    mirror_x()
                    translate([mw/2, mw - leg_bottom_width])
                    circle(d=20);
                }
                
                // shaft
                translate([0, sz])
                circle(d=$m4_body_d+2*$s2);
                
                // place for motor
                translate([0, mw/2-leg_bottom_width])
                square(mw, center=true);
            }
            
            // nut pocket
            translate([0, sz, $h1m3/2])
            hexagon(
                ($m4_nut_d+2*$s2)/2,
                $h1m3
            );
            
            // hall hole
            translate([0, sz-$mount_magnet_shaft_dist, 0])
            mirror([1, 0, 0])
            hall_hole();
        }
        
        
        // bottom
        mirror_y()
        translate([$pcb_x/2+$leg_pcb_gap, $motor_w/2+$s5])
        difference() {
            linear_extrude(height=leg_bottom_width)
            leg_zprojection();
            
            leg_bottom_sockets();
        }
    }
    
    module leg_bottom_sockets() {
        // bolt
        translate([$leg_wall_d, $leg_wall_d/2, -leg_bottom_width])
        cylinder(d=$m4_body_d+2*$s2, h=3*leg_bottom_width);
        
        // bolt head pocket
        translate([$leg_wall_d, $leg_wall_d/2, leg_bottom_width/2])
        cylinder(d=$m4_head_d+2*$s2, h=leg_bottom_width);
    }
    
    module mount() {
        difference() {
            union () {
                intersection() {
                    translate([-mount_x/2, -$mount_y/2 , -$mount_y/2 - $mount_h])
                    difference() {
                        cube([mount_x, $mount_y, $mount_y+$mount_h]);
                        translate([$mount_h, -$mount_y, $mount_h])
                        cube([mount_x-2*$mount_h, 3*$mount_y, 3*$mount_y]);
                    }
                    
                    // remove parts that would reach out from behind the gear
                    rotate([0, 90, 0])
                    cylinder(d=$stand_tooth_num, h=3*mount_x, center=true);
                }
                
                translate([mount_x/2-$mount_h-2, 0, 0])
                rotate([0, 90, 0])
                cylinder(d=$ybearing_outer_d+$s3+3, h=$mount_h);
            }
            
            // holes for mounting on gear
            translate([-mount_x/2+$mount_h+e, 0, 0])
            rotate([0, -90, 0])
            z_rot_copy(r=$bolt_ygear_r, offset_deg=45)
            union() {
                // body of bolt
                cylinder(d=$m3_body_d+2*$s2, h=2*$mount_h);
              
                // bolt_head pocket
                cylinder(d=$m3_head_d+2*$s2, h=$mount_h/2);
            }
            
            // hole for bolt on idle and gear side
            translate([mount_x/2-$mount_h, 0, 0])
            rotate([0, 90, 0])
            cylinder(d=$ybearing_outer_d+$s3, h=mount_x);
            rotate([0, 90, 0])
            cylinder(d=$ybearing_outer_d-2*ledge, h=2*mount_x, center=true);
            
            // holes on the idle side to help assembly
            translate([mount_x, 0, 0])
            rotate([0, -90, 0])
            z_rot_copy(r=$bolt_ygear_r, offset_deg=45)
            cylinder(d=$m3_head_d+2*$s2, h=mount_x);

            // bolts for mounting lidar
            mirror_x()
            mirror_y()
            translate([$lidar_bolts_x/2, $lidar_bolts_y/2, 0])
            union() {
                // body of bolt
                cylinder(d=$m3_body_d+2*$s2, h=3*$mount_y, center=true);
                
                // nut pocket
                translate([0, 0,-$mount_y/2 - 1.5*$mount_h])
                hexagon(
                    ($m3_nut_d+2*$s2)/2,
                    $mount_h
                );
            }
            
            // magnet socket
            translate([mount_x/2+e, 0, -$mount_magnet_shaft_dist])
            rotate([0, -90, 0])
            #magnet_slot();
        }
    }
    
//    module test_stand_legs() {
//        h=shaft_z+$h2m4/2;
//        difference() {
//            translate([0, 0, -h+$h2m4/2])
//            difference() {
//                linear_extrude(height=h, scale=[1, $h2m4/y])
//                square([x, y], center=true);
//                
//                // body
//                translate([0, 0, h/2+$h1m4])
//                cube([dist, 2*y, h], center=true);
//            }
//            
//            // bolts
//            rotate([0, 90, 0])
//            cylinder(d=$m4_body_d+2*$s2, h=2*x, center=true);
//            
//            // nut pocket
//            mirror_x()
//            translate([dist/2 + $h1m4/2, 0, 0])
//            rotate([0, 90, 0])
//            hexagon(
//                ($m4_nut_d+2*$s2)/2,
//                h
//            );
//        }
//    }
    
    
    
}

module leg_zprojection() {
    hull() {
        translate([$leg_wall_d, $leg_wall_d/2, 0])
        circle(d=$leg_wall_d);
        square([$leg_wall_d/2, $leg_wall_d]);
    }
}

module stand1(in_place=false) {
    $leg_wall_d=20;
    
//    mirror_x()
    mirror_y()
    #translate([$pcb_x/2+$s5, $motor_w/2+$s5])
    hull() {
        translate([$leg_wall_d, $leg_wall_d/2, 0])
        circle(d=$leg_wall_d);
        square([$leg_wall_d/2, $leg_wall_d]);
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
        union() {
            // body of bolt
            cylinder(d=$m4_body_d+$s2, h=$orange_h);
          
            // bolt_head pocket
            translate([0, 0, $orange_h/2])
            cylinder(d=$m4_head_d+2*$s2, h=$orange_h);
        }
        
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

module station_purple(in_place=false) {
    in_place_z = in_place ? -($purple_h + $s4 - $xbearing_h/2) : 0;
    translate([0, 0, in_place_z])
    difference() {
        union() {
            base_h= $purple_bottom_h + $h4 + $h1m3 + ($xbearing_h-$gear_h) - $s4;
            
            cylinder(d=$w5, h=base_h);
            
            translate([0, 0, base_h])
            gear(tooth_number=$base_tooth_num, width=$gear_h, bore=0);
        }
        
        // smaller dia, under bearing
        translate([0, 0, $purple_bottom_h])
        cylinder(d=$w3, h=$purple_h);
        
        // larger dia, around bearing
        translate([0, 0, $purple_bottom_h+$h4+$h1m3])
        cylinder(d=$w4, h=$purple_h);
        
        // bolt cutouts
        z_rot_copy(r=$bolt_outer_r)
        union() {
            // body of bolt
            cylinder(d=$m4_body_d+$s2, h=2*$purple_h);
          
            // nut pocket
            hexagon(
                ($m4_nut_d+2*$s2)/2,
                $purple_h - ($bolt_outer_nut_z - ($orange_h/2 + $s4))
            );
        }
        
        // assembly hole for slip ring bolts
        z_rot_copy(r=$slip_ring_hole_r, deg=120)
        union() {
            // body of bolt
            cylinder(d=$m4_head_d+2*$s5, h=2*$green_h);
          
        }
        
        // slip ring
        cylinder(d=$slip_ring_small_d+$s2, h=$purple_h);
        
        // conduit
        rotate([0, 90, 45])
        cylinder(d=$slip_ring_conduit_d, h=2*$w5);
        sphere(d=2*$slip_ring_wire_slack);
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
                translate([$pcb_x/2+$leg_pcb_gap, $motor_w/2+$s5])
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
                10 // TODO
            );
        }
        
        // assembly hole for orange bolts
        translate([0, $bolt_outer_r, -e])
        cylinder(d=$m4_head_d+$s2, h=2*$green_h);
        
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
        translate([$pcb_x/2+$leg_pcb_gap, $motor_w/2+$s5])
        translate([$leg_wall_d, $leg_wall_d/2, 0])
        union() {
            cylinder(d=$m4_body_d+2*$s2, h=3*$h1m3, center=true);
            // TODO: we're putting M4 nut into plate that's supposed to only hold M3...
            translate([0, 0, $h1m3/2])
            hexagon(
                ($m4_nut_d+2*$s2)/2,
                $h1m3
            );
        }
        
//        translate([$leg_wall_d, $leg_wall_d/2, leg_bottom_width/2])
//        cylinder(d=$m4_head_d+2*$s2, h=leg_bottom_width);
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
        cylinder(d=$m4_body_d+$s2, h=2*$blue_h, center=true);
        
        // slip ring plate
        translate([0, 0, -e])
        cylinder(d=$slip_ring_plate_d + 2*$s2, h=$slip_ring_plate_h+$s2);
        
        // slip ring body
        cylinder(d=$slip_ring_large_d + 2*$s2, h=3*$blue_h, center=true);
    }
}

module station_bolts() {
    
    
    // inner TODO: slip ring bolts!!!
    z_rot_copy(r=$bolt_inner_r)
    m3_with_nut(l=$bolt_inner_body_len, nut_z=$bolt_inner_nut_z, center=true);
    
    // outer
    translate([0, 0, -$bolt_outer_body_len+$xbearing_h/2+$orange_h/2])
    z_rot_copy(r=$bolt_outer_r)
    m4_with_nut(l=$bolt_outer_body_len, nut_z=$bolt_outer_nut_z, center=false);
}

module xbearing() {
    translate([0, 0, -e])
    difference() {
        cylinder(d=$xbearing_outer_d, h=$xbearing_h, center=true);
        
        cylinder(d=$xbearing_inner_d, h=3*$xbearing_h, center=true);
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
    cube([$pcb_x, $pcb_y, 10], center=true);
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

module lidar() {
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

module ybearing_plug_m3() {
    difference() {
        cylinder(d=5.8, h=9.8);
        cylinder(d=3.4, h=100, center=true);
    }
}

module ygear_plug_m4() {
    plug(h=$gear_h, gap=2*$s5);
}

module ybearing_plug_m4() {
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
    
//    render(convexity = 2)
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