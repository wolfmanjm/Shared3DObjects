use <makerslide.scad>
use <w-wheel.scad>
use <myLibs.scad>
thickness = 20;

fudge= 1.0; // fudge factor to tighten the wheels around the slide 1.0 is snug but not too tight, smaller will be tighter
wheel_diameter = w_wheel_dia();
wheelx = (40 + wheel_diameter) / 2 +fudge;
wheely = wheelx +10;
wheel_width= w_wheel_width();

bearingThickness= 7;
bearingOD= 22;
bearingID= 8;
standoffht= (wheel_width-bearingThickness)/2+1; // add some clearance

d= sqrt(wheelx*wheelx + wheely*wheely);

%translate([0, 0, 20+thickness+bearingThickness/2+standoffht]) rotate([90, 90, 0]) makerslide(150);

// Bearing standoff that contacts inner sleave of bearing, and clears the wheels from the X frame
module standoff() {
	cylinder(r1= bearingID, r2=bearingID/2+2, h=standoffht);
}

translate([0, 0, thickness/2])
difference() {
  union() {
    for (x = [-wheelx, wheelx]) {
      for (y = [-wheely, wheely]) {
        translate([x, y, 0]) {
			cylinder(r=8, h=thickness, center=true);
			translate([0,0,thickness/2]) standoff();
 			%translate([0, 0, thickness/2 + bearingThickness/2+standoffht]) w_wheel();
        }
      }
    }
    for (a = [-40, 40]) rotate([0, 0, a]) difference() {
      cube([8, d*2, thickness], center=true);
      translate([0, 0, 50]) rotate([0, 90, 0])
        cylinder(r=50, h=8.1, center=true, $fn=120);
    }
  }
  for (x = [-wheelx, wheelx]) {
    for (y = [-wheely, wheely]) {
      translate([x, y, -thickness/2]) {
        hole(8, thickness+5);
      }
    }
  }
}
