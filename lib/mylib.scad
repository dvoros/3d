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