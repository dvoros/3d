wall=1.5;

dia=10;
h1=10;
h2=20;
scl=4;

e=0.01;

$fn=10;

difference() {
    linear_extrude(height=h2, scale=[scl,scl], slices=h2, twist=36)
    circle(d=dia);
    
    scl2=(dia*scl - 2 * wall) / (dia - 2 * wall);
    
    translate([0,0,-e])
    linear_extrude(height=h2+2*e, scale=[scl2,scl2], slices=h2, twist=36)
    circle(d=dia-2*wall);
}

translate([0,0,-h1])
linear_extrude(height=h1, twist=36, slices=h1)
difference() {
    circle(d=dia);
    circle(d=dia-2*wall);
}