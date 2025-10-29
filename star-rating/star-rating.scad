//First text
text_1="Customer Service";
//Second text
text_2="";

//Rating
rating=4.5;

//Number of colors you want to print with
colors="three"; // [two,three]

/* [Dimensions] */

//Height of card
height=60;
//Width of card
width=150;

/* [Positioning] */

text_1_x=0;
text_1_y=12;
text_2_x=0;
text_2_y=0;
stars_x=0;
stars_y=-12;

stars_scale=100;

/* [Font] */

font_1="Liberation Sans"; //[Liberation Sans,Harmony OS Sans,Inter,Inter Tight,Lora,Merriweather Sans,Montserrat,Noto Sans,Nunito,Nunito Sans,Open Sans,Open Sans Condensed,Oswald,Playfair Display,Plus Jakarta Sans,Raleway,Roboto,Roboto Condensed,Roboto Flex,Roboto Mono,Roboto Serif,Roboto Slab,Rubik,Source Sans 3,Ubuntu Sans,Ubuntu Sans Mono,Work Sans]
font_2="Liberation Sans"; //[Liberation Sans,Harmony OS Sans,Inter,Inter Tight,Lora,Merriweather Sans,Montserrat,Noto Sans,Nunito,Nunito Sans,Open Sans,Open Sans Condensed,Oswald,Playfair Display,Plus Jakarta Sans,Raleway,Roboto,Roboto Condensed,Roboto Flex,Roboto Mono,Roboto Serif,Roboto Slab,Rubik,Source Sans 3,Ubuntu Sans,Ubuntu Sans Mono,Work Sans]
//Font size of first text
font_size_1=10;
//Font size of second text
font_size_2=10;

/* [Advanced] */

//Radius of rounded corners
rounded_corner=20;

//Width of edge
edge_width=5;

//Bottom thickness
thickness_bottom=1;
//Middle thickness
thickness_middle=1;
//Top thickness (only when using 3 colors)
thickness_top=0.6;


/* [Hidden] */

$fn=40;

is_three_colors=colors=="three";

overall_thickness=(is_three_colors ? (thickness_bottom+thickness_middle+thickness_top) : (thickness_bottom+thickness_middle));
star_fill_thickness=thickness_bottom+thickness_middle;
thicknesses=[thickness_bottom, thickness_middle, thickness_top];

star_distances=25;
stars_pos=[stars_x, stars_y, 0];
stars_scales=[stars_scale/100, stars_scale/100, 1];

text_1_pos=[text_1_x, text_1_y, 0];
text_2_pos=[text_2_x, text_2_y, 0];


// Card bottom
color("black")
linear_extrude(height=thickness_bottom)
rounded_rectangle(width, height, rounded_corner);

// Card edge middle
middle(thickness_bottom)
card_edge(width, height, rounded_corner, thickness_middle, edge_width);
// Card edge top
top(is_three_colors, thickness_bottom+thickness_middle)
card_edge(width, height, rounded_corner, thickness_top, edge_width);

// Text 1
if(text_1!="")
translate(text_1_pos)
do_text(text_1, font_1, font_size_1, thicknesses);


// Text 2
if(text_2!="")
translate(text_2_pos)
do_text(text_2, font_2, font_size_2, thicknesses);

// Star ratings
translate(stars_pos)
scale(stars_scales)
{
    // Star outlines middle
    middle(thickness_bottom)
    star_outlines(thickness_middle, star_distances);
    // Star outlines top
    top(is_three_colors, thickness_bottom+thickness_middle)
    star_outlines(thickness_top, star_distances);
    
    // Star fills
    middle(thickness_bottom)
    intersection() {
        translate([-width + ((rating-2.5)*star_distances), -height/2, 0])
        cube([width, height, thickness_middle]);
        
        union() {
            for(i=[-2:2]) {
                translate([i*star_distances, 0, -thickness_middle])
                linear_extrude(height=thickness_middle*5, convexity=3)
                offset(r=-0.8)
                star();
            }
        }
    }
}

module middle(thickness) {
    translate([0, 0, thickness])
    color("#E4BD68")
    children();
}

module top(is_three_colors, thickness) {
    if(is_three_colors)
    color("white")
    translate([0, 0, thickness])
    children();
}

module do_text(txt, font, font_size, thicknesses) {
    // Text middle
    middle(thicknesses[0])
    do_text_layer(txt, font, font_size, thicknesses[1]);

    // Text top
    top(is_three_colors, thicknesses[0]+thicknesses[1])
    do_text_layer(txt, font, font_size, thicknesses[2]);
}

module do_text_layer(txt, font, font_size, thickness) {
    linear_extrude(height=thickness)
    text(text = txt, font=font, size = font_size, halign = "center", valign="center");
}

module card_edge(width, height, rounded_corner, thickness, edge_width) {
    difference() {
        linear_extrude(height=thickness)
        rounded_rectangle(width, height, rounded_corner);
        
        translate([0, 0, -thickness])
        linear_extrude(height=thickness*5)
        rounded_rectangle(width-edge_width, height-edge_width, rounded_corner-edge_width);
    }
}

module star_outlines(thickness, star_distances) {
    for(i=[-2:2]) {
        translate([i*star_distances, 0, 0])
        linear_extrude(height=thickness)
        
        difference() {
            offset(r=1)
            star();
            
            
            offset(r=-0.8)
            star();
        }
    }
}

module star(p=5, r1=5, r2=11.5) {
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
