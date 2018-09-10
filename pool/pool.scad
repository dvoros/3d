r = 310 / 2;
dy = 25;
wall = 5;

$fn = 200;

difference() {
intersection() {
difference() {
    scale([1, 1, .9])
    translate([0, 0, r - dy])
    sphere(r = r);
    
    translate([0, 0, -500])
    cube(size = 1000, center = true);
 
    translate([0, 0, 500 + r - dy])
    cube(size = 1000, center = true);
}

translate([-500 - 50, 0, -40 + r - dy + 1])
cube(size = [1000, 1000, 80], center = true);
}

translate([500 - 100, 0, -20 + r - dy - 40 - 1])
cube(size = [1000, 1000, 40], center = true);


translate([500 - 100 -1000 - wall, 0, -20 + r - dy - 40 + wall])
cube(size = [1000, 1000, 40], center = true);

translate([500 - 50 - 1000 - wall, 0, -20 + r - dy - 40 + 40 + wall - 1])
cube(size = [1000, 1000, 40], center = true);
}

intersection() {
    scale([1, 1, .9])
    translate([0, 0, r - dy])
    sphere(r = r);



    translate([-50 + wall - 1, 0, r - dy + 1 - 10])
    cube(size = [2 * wall, 1000, wall], center = true);
}