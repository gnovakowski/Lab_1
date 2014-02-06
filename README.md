Lab 1 - Video Synchronization
=====

### Introduction

The purpose of this laboratory exercise was to write a video controller for use with an FPGA. The FPGA was programmed using VHDL code to interface with a VGA-to-HDMI cable.


### Implementation

The implementation of this lab consisted of having to write code for five separate VHDL modules, with each module performing its specific function. A block diagram/RTL schematic of my design can be seen in the image below:

![alt text](http://i.imgur.com/TAYzB2g.png "RTL Schematic")

The modules that I wrote for this lab are listed below complete with examples and explanations:
 1. `atlys_lab_video` - This file is the top level VHDL file that includes the instantiations of both the `vga_sync` and `pixel_gen` modules. The instantiations for each of these components can be seen below:

```vhdl
	vga_sync_connect : entity work.vga_sync(behavioral)
		PORT MAP ( clk => pixel_clk,
         reset =>  reset, 
         h_sync =>  h_sync_inter,
         v_sync =>  v_sync_inter,
         v_completed =>  open,
         blank => blank_inter,
         row =>  row_sig,
         column => column_sig 		
	);
```

```vhdl
	pixel_gen_connect : entity work.pixel_gen(behavioral)
		PORT MAP(
			row => row_sig, 
			column => column_sig, 
			blank => blank_inter,
			SW0  => SW0,
			SW1 => SW1,
			r => red_inter,
			g => green_inter,
			b => blue_inter
	);
```

 2. `h_sync_gen` - blah
 3. `v_sync_gen`
 4. `vga_sync`
 5. `pixel_gen`


### Test/Debug




### Conclusion


 
