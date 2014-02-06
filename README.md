Lab 1 - Video Synchronization
=====

### Introduction

The purpose of this laboratory exercise was to write a video controller for use with an FPGA. The FPGA was programmed using VHDL code to interface with a VGA-to-HDMI cable.


### Implementation

The implementation of this lab consisted of having to write code for five separate VHDL modules, with each module performing its specific function. A block diagram/RTL schematic of my design can be seen in the image below:

![alt text](http://i.imgur.com/TAYzB2g.png "RTL Schematic")

The modules that I wrote for this lab are listed below complete with examples and explanations:

 * `atlys_lab_video` - This file is the top level VHDL file that includes the instantiations of both the `vga_sync` and `pixel_gen` modules. The instantiations for each of these components can be seen below:

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

 * `h_sync_gen` - This VHDL module generates the horizontal signal to be displayed on the monitor. The code consists of generics (containing the sizes of the different states), a counter to determine the location of the horizontal signal, and a series of outputs explaining the state of the different signals to be used in `v_sync_gen` and `vga_sync`. The entity declaration (with generics) can be seen in the code below:

```vhdl
entity h_sync_gen is
	 generic(
			  active_size : natural := 640;
			  front_size : natural := 16;
			  sync_size : natural := 96;
			  back_size : natural := 48;
			  total_size : natural := 800);

    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_sync : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           completed : out  STD_LOGIC;
           column : out  unsigned(10 downto 0));
end h_sync_gen;
```
The code below shows the counter required to know the location of the horizonal signal and when to reset back to zero:

```vhdl
	count_next <= count + 1;
	process(reset, clk) is
	begin
		if(reset = '1') then
			count <= zero;
		elsif(clk'event and clk = '1') then
			if(count = (total_size - 1)) then
				count <= zero;
			else
				count <= count_next;
			end if;
		end if;
	end process;
```

 * `v_sync_gen` - This VHDL module behaves in a very similar way to `h_sync_gen` except that it applies to the vertical aspect of the monitor display. The code consists of generics (containing the sizes of the different states), a counter to determine the location of the vertical signal, and a series of outputs explaining the state of the different signals to be used in `vga_sync`. The entity declaration (with generics) can be seen in the code below:

```vhdl
entity v_sync_gen is
	 generic(
			  active_size : natural := 480;
			  front_size : natural := 10;
			  sync_size : natural := 2;
			  back_size : natural := 33;
			  total_size : natural := 525);

    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           --h_blank : in  STD_LOGIC;
           h_completed : in  STD_LOGIC;
           v_sync : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           completed : out  STD_LOGIC;
           row : out  unsigned(10 downto 0));
end v_sync_gen;
```

 * `vga_sync` - 
 * `pixel_gen` - 


### Test/Debug




### Conclusion


 
