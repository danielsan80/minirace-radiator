inner_width = 57;
//inner_length = 60;
inner_length = 120;
inner_height = 35;
thick = 3;

outer_width = inner_width+thick*2;
outer_length = inner_length+thick*2;
outer_height = inner_height+thick*2;


m_thick = 2;
l_thick = 1;
fix = 0.01;

min_thick = 0.3;

power_length = 14;
power_width = 8;
power_z_offset = 8;

cables_height = 14;
cables_width = 51;


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
    
 
    cube([inner_length+thick*2,inner_width+thick*2, thick]);

        
    wall(w=inner_length+thick*2,h=inner_height+thick*2, thick=thick, n_big_uprights = 5);
        
    translate([0,inner_width+thick*2,0])
    mirror([0,1,0])
    wall(w=inner_length+thick*2,h=inner_height+thick*2, thick=thick, n_big_uprights = 5);

    translate([outer_length,0,0])
    rotate([0,0,90])
    wall(w=inner_width+thick*2,h=inner_height+thick*2, thick=thick);
    
    translate([0,outer_width,0])
    rotate([0,0,-90])
    wall(w=inner_width+thick*2,h=inner_height+thick*2, thick=thick);
    
    translate([0,0,outer_height-thick])
    top(w=outer_width, l=outer_length, thick=m_thick);
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

module slide_back(void=true) {
    function p() = void?0:0.3;
    function more() = void?thick*2:0;
    
    color("red")
    translate([0,thick,thick])
    union() {
        hull() {

            translate([-fix,fix+p(),fix])
            cube([thick+fix*2, inner_width-fix*2-p()*2,  inner_height-fix*2-p()+more()]);
            
            translate([(thick-fix)/2, -thick/2+p(), fix])
            cube([fix, fix, inner_height-fix*2-p()+more()]);
            
            translate([(thick-fix)/2, inner_width-fix+thick/2-fix-p(), fix])
            cube([fix, fix, inner_height-fix*2-p()+more()]);
        }
    }
    

}


module slide_top(void=true) {
    function p() = void?0:0.3;

    
   
    
    
    color("red")
    translate([0, thick, thick+inner_height])
    union() {
        hull() {

            translate([-fix,fix+p(),-fix])
            cube([fix+thick+inner_length-p(), inner_width-fix*2-p()*2,  thick+fix*2]);
            
            translate([-fix,fix+p()-thick/2, (thick-fix)/2])
            cube([fix+thick+inner_length-p(), fix, fix]);
            
            translate([-fix, inner_width-fix+thick/2-fix-p(), (thick-fix)/2])
            cube([fix+thick+inner_length-p(), fix, fix]);
        }
    }
    

}

module keep()  {
    
    translate([inner_length+thick-4-2,thick,thick])
    cube([2,3, inner_height-3]);    
}

module keep2()  {
    
    translate([inner_length+thick-2,inner_width+thick-10-3,thick])
    cube([2,3, inner_height-3]);    
}

module box() {
    
    difference() {
        union() {            
            main_walls();
            power_frame();
            cables_frame();
            keep();
            keep2();
        }        
        power_hole();
        cables_hole();
    }
}

module print_box() {
    
    difference() {
        box();    
        slide_back(void=true);
        slide_top(void=true);
    }
}

module print_slide_back() {
    
    color("blue")
    intersection() {
        box();    
        slide_back(void=false);
    }
}


module print_slide_top() {

    color("green")    
    intersection() {
        box();    
        slide_top(void=false);
    }
}



//wall(w=inner_length+thick*2,h=inner_height+thick*2, thick=thick);

print_box();

//print_slide_back();
//print_slide_top();

