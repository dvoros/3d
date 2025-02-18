$fn=40;

height=60;
width=150;

rounded_corner=20;

edge_width=5;

rating=3.5;

difference() {
    linear_extrude(height=3)
    rounded_rectangle(width, height, rounded_corner);
    
    translate([0, 0, 1])
    linear_extrude(height=100)
    rounded_rectangle(width-edge_width, height-edge_width, rounded_corner-edge_width);
}

translate([0, height/5, 0])
linear_extrude(height=3)
text(text = "Customer service:", size = 10, halign = "center", valign="center");


for(i=[-2:2]) {
    translate([i*(width/6), -height/5, 0])
    linear_extrude(height=3)
    
    difference() {
        offset(r=0.5)
        star();
        
        
        offset(r=-0.8)
        star();
    }
}

intersection() {
    translate([-width + ((rating-2.5)*(width/6)), -height/2, 0])
    cube([width, height, 2]);
    
    union() {
        for(i=[-2:2]) {
            translate([i*(width/6), -height/5, 0])
            linear_extrude(height=3)

            offset(r=-0.8)
            star();
        }
    }
}


module star(p=5, r1=5, r2=12) {
  s = [for(i=[0:p*2]) 
    [
      (i % 2 == 0 ? r1 : r2)*cos(180*i/p-90),
      (i % 2 == 0 ? r1 : r2)*sin(180*i/p-90)
    ]
  ];
  
  polygon(s);
}

module rounded_rectangle(x, y, d) {
    hull()
    mirror_y()
    mirror_x()
    translate([(x-d)/2, (y-d)/2])
    circle(d=d);
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
