inner_width = 57;
inner_length = 60;
inner_height = 35;
thick = 3;

outer_width = inner_width+thick*2;
outer_length = inner_length+thick*2;
outer_height = inner_height+thick*2;


m_thick = 2;
l_thick = 1;
fix = 0.01;

power_length = 14;
power_width = 8;
power_z_offset = 8;

cables_height = 14;
cables_width = 35;


module blade(w, thick, l_thick) {
    blade_thick = 0.3;
    shift = 0.3;
    
    
    hull() {        
        translate([0,thick-l_thick,0])
        cube([w,l_thick, blade_thick]);
        
        translate([0,shift,thick-l_thick-shift])
        cube([w,l_thick, blade_thick]);
    }
}

module wall(w, h, thick, l_thick=1, n_big_uprights = 2, n_little_uprights=3, n_blades=20) {     
    
    cube([w, thick, thick]);
    
    cube([thick, thick, h]);
    
    translate([0,0,h-thick])
    cube([w, thick, thick]);
    
    translate([w-thick,0,0])
    cube([thick, thick, h]);
    

    big_upright_step = (w-thick)/(n_big_uprights+1);
    
    
    little_upright_step = (big_upright_step-thick+l_thick)/(n_little_uprights+1);
    
    blade_step = (h-thick*2)/(n_blades+1);
    
    for (i = [0:n_big_uprights]) {
        translate([i*big_upright_step,0,0])
        cube([thick, thick, h]);
        
        for (j = [1:n_little_uprights]) {
            translate([i*big_upright_step+thick-l_thick+j*little_upright_step,thick-l_thick,0])
            cube([l_thick, l_thick, h]);
            
            
        }
    }
     
    for (i = [0:n_blades]) {
        translate([0,0,thick+i*blade_step])
        blade(w=w,thick=thick, l_thick=l_thick);
      
    }
    
}

module top(w, l, thick) {   
    cube([l, w, thick]);
}




module main_walls() {
    
    //cube([inner_length+thick*2,inner_width+thick*2, inner_height+thick*2]);

    cube([inner_length+thick*2,inner_width+thick*2, thick]);

    //cube([inner_length+thick*2,thick, inner_height+thick*2]);

//    translate([0,inner_width+thick,0])
//    cube([inner_length+thick*2,thick, inner_height+thick*2]);

//    translate([inner_length+thick,0,0])
//    cube([thick,inner_width+thick*2, inner_height+thick*2]);
        
    wall(w=inner_length+thick*2,h=inner_height+thick*2, thick=thick);
        
    translate([0,inner_width+thick*2,0])
    mirror([0,1,0])
    wall(w=inner_length+thick*2,h=inner_height+thick*2, thick=thick);

    translate([outer_length,0,0])
    rotate([0,0,90])
    wall(w=inner_width+thick*2,h=inner_height+thick*2, thick=thick);
    
        translate([0,outer_width,0])
    rotate([0,0,-90])
    wall(w=inner_width+thick*2,h=inner_height+thick*2, thick=thick);
    
//    translate([0,0,outer_height-thick])
//    top(w=outer_width, l=outer_length, thick=m_thick);
}


module power_frame() {
    translate([thick+inner_length-power_width-m_thick, inner_width+thick, thick+power_z_offset-m_thick])
    cube([power_width+m_thick*2,thick,power_length+m_thick*2]);
}

module power_hole() {
    translate([thick+inner_length-power_width, thick+inner_width-fix, thick+power_z_offset])
    cube([power_width,thick+fix*2,power_length]);
}



module cables_frame() {
    translate([0, (outer_width-(cables_width+m_thick*2))/2, thick-m_thick])
    cube([thick,cables_width+m_thick*2, cables_height+m_thick*2]);
}

module cables_hole() {
    translate([-fix,(outer_width-cables_width)/2,thick])
    cube([thick+fix*2, cables_width,cables_height]);
}

module slide_back() {
}


module main() {
    difference() {
        union() {            
            main_walls();
            power_frame();
            cables_frame();
        }        
        power_hole();
        cables_hole();
        slide_back();
    }
}


wall(w=inner_length+thick*2,h=inner_height+thick*2, thick=thick);

main();

