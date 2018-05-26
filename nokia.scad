$fn = 20;

phone_x = 52.7;
phone_y = 120;
phone_z = 9.5;
corner_radius = 7;

slack = 0.16;
case_width = 1;

below_buttons = 5.5;
above_buttons = 8.5;
buttons_height = 44.5;

screen_x = 45;
screen_y = 59;

cutoff_size = 5;

camera_radius = 4.1;
camera_from_top = 12.3;

front_speaker_x = 10;
front_speaker_y = 1.6;
front_speaker_from_top = 4.2;

rear_speaker_x = 13.4;
rear_speaker_y = 2.2;
rear_speaker_from_bottom = 20.2;

top_hole_x = 33;
top_hole_z = 5; 
top_hole_from_bottom = 3;

// ------------------------

// How much bigger is the case
case_diff = 2 * (slack + case_width);

module rounded_rect(x, y, radius) {
    hull() {
        translate([-x/2+radius, -y/2+radius, 0])
        circle(radius);
        
        translate([x/2-radius, -y/2+radius, 0])
        circle(radius);
        
        translate([-x/2+radius, y/2-radius, 0])
        circle(radius);
        
        translate([x/2-radius, y/2-radius, 0])
        circle(radius);
    }
}

module buttons() {
    linear_extrude(height = 100)
    difference() {
        rounded_rect(phone_x, phone_y, corner_radius);
        
        translate([-500, -phone_y/2 + buttons_height, 0])
        square([1000, 1000]);
        
        translate([-500, -1000-phone_y/2 + below_buttons, 0])
        square([1000, 1000]);
    }
}

module screen() {
    linear_extrude(height = 100)
    translate([-screen_x/2, -phone_y/2 + buttons_height + above_buttons])
    square([screen_x, screen_y]);
}


module top_cutoff() {
    translate([-phone_x/2, 0, 0])
    cube([phone_x + slack, 1000, phone_z + slack]);
}

module camera() {
    translate([0, phone_y/2 - camera_from_top, -1000 + phone_z/2])
    linear_extrude(height=1000)
    circle(camera_radius);
}

module front_speaker() {
    translate([-front_speaker_x/2, phone_y/2-front_speaker_from_top, phone_z/2])
    linear_extrude(height=1000)
    square([front_speaker_x, front_speaker_y]);
}

module rear_speaker() {
    translate([-rear_speaker_x/2, -phone_y/2+rear_speaker_from_bottom, -1000 + phone_z/2])
    linear_extrude(height = 1000)
    square([rear_speaker_x, rear_speaker_y]);
}

module phone() {
    linear_extrude(height = phone_z)
    rounded_rect(phone_x, phone_y, corner_radius);
}

module top_hole() {
    translate([0, 0, top_hole_from_bottom])
    rotate([-90, 0, 0])
    linear_extrude(height=100)
    hull() {
        translate([-top_hole_x/2, 0, 0])
        circle(d = top_hole_z);
        
        translate([top_hole_x/2, 0, 0])
        circle(d = top_hole_z);
    }
}

module full_case() {
    difference() {
        // case
        translate([0, 0, -case_diff/2])
        linear_extrude(height = phone_z + case_diff)
        rounded_rect(phone_x + case_diff, phone_y + case_diff, corner_radius + case_diff/2);

        phone();
        buttons();
        screen();
        top_hole();
        camera();
        front_speaker();
        //rear_speaker();
    }
}

module snap_test() {
    h = 6;
    sh = 3;
    snap_factor = 1.05;
    
    difference() {
        union() {
            cube([phone_x, phone_z, h], center = true);

            translate([0, 0, h/2])
            linear_extrude(height = sh, scale = [1, snap_factor])
            square([phone_x, phone_z/2-slack], center = true);
        };
        
        
        translate([0, 0, -h/2-0.01])
        linear_extrude(height = sh, scale = [1, snap_factor])
        square([phone_x*2, phone_z/2], center = true);
        
        cube([phone_x-case_diff, phone_z-case_diff, h*3], center = true);
    }
    
}

snap_test();