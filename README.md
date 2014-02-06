Lab 1 - Video Synchronization
=====

### Introduction

The purpose of this laboratory exercise was to write a video controller for use with an FPGA. The FPGA was programmed using VHDL code to interface with monitor display via a VGA-to-HDMI cable. The primary goal of this lab was to display a given test pattern on a monitor. In addition, for A functionality, the goal was to also display different test patterns that corresponded to input from two separate switches on the FPGA. The desired test pattern can be seen below.

![alt text](http://i.imgur.com/BTZaoeB.png "Basic Test Pattern")

### Implementation

The implementation of this lab consisted of having to write code for five separate VHDL modules, with each module performing its specific function. A block diagram/RTL schematic of my design can be seen in the image below:

![alt text](http://i.imgur.com/TAYzB2g.png "RTL Schematic")

In addition, the state diagram for `h_sync_gen` can be seen below:

![alt text](http://i.imgur.com/1vy1Ikx.png "State Diagram")

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


 * `h_sync_gen` - This VHDL module generates the horizontal signal to be displayed on the monitor. The goal of this module is to generate an unsigned number for the column so that the pixel generator will know where to write a pixel. The code consists of generics (containing the sizes of the different states), a counter to determine the location of the horizontal signal, and a series of outputs explaining the state of the different signals to be used in `v_sync_gen` and `vga_sync`. The entity declaration (with generics) can be seen in the code below:

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
 * The code below shows the counter required to know the location of the horizonal signal and when to reset back to zero:

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


 * `v_sync_gen` - This VHDL module behaves in a very similar way to `h_sync_gen` except that it applies to the vertical aspect of the monitor display. The goal of this module is to generate an unsigned number for the row so that the pixel generator will know where to write a pixel. The code consists of generics (containing the sizes of the different states), a counter to determine the location of the vertical signal, and a series of outputs explaining the state of the different signals to be used in `vga_sync`. The entity declaration (with generics) can be seen in the code below:

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


 * `vga_sync` - The purpose of this VHDL module is to connect the `v_sync_gen` and `h_sync_gen` modules so that they work together, and to generate a blank signal for use with the pixel generator. The architecture of the vertical and horizontal sync connections can be seen in the code below:

```vhdl
architecture Behavioral of vga_sync is
	signal h_complete_new, v_blank, h_blank : std_logic;
begin
	 h_sync_connect: entity work.h_sync_gen(behavioral)
		generic map(active_size => 640, 
						front_size => 16, 
						sync_size => 96, 
						back_size  => 48,	
						total_size => 800)

		PORT MAP (  clk => clk,
						reset => reset,
						h_sync => h_sync,
						blank => h_blank,
						completed => h_complete_new,
						column => column ); 
   
	  v_sync_connect: entity work.v_sync_gen(behavioral)
	    generic map(active_size => 480, 
						 front_size => 10, 
						 sync_size => 2, 
						 back_size  => 33,	
						 total_size => 525)
						 
	    PORT MAP (	 clk => clk,
						 reset => reset,
						 h_completed => h_complete_new,
						 v_sync => v_sync,
						 blank => v_blank,
						 completed => v_completed,
						 row => row );
	  
	  blank <= (h_blank or v_blank);

end Behavioral;
```


 * `pixel_gen` - This VHDL module is the pixel generator, which is the file that actually writes pixels to the monitor display, using signals and generics initialized in the earlier VHDL modules. Part of the process for drawing a design on the display (with input from two switches on the FPGA) can be seen below:

```vhdl
	process(row, column, blank, SW0, SW1) is
		begin
			if(blank = '1') then
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '0');
				
			elsif (SW0 = '0' and SW1 = '0') then
				if (row > 360) then
					r <= (others => '1');
					g <= (others => '1');
					b <= (others => '0');
				elsif (column < 200) then
					r <= (others => '1');
					g <= (others => '0');
					b <= (others => '0');
				elsif (column > 440) then
					r <= (others => '0');
					g <= (others => '0');
					b <= (others => '1');
				else
					r <= (others => '0');
					g <= (others => '1');
					b <= (others => '0');
				end if;
			
			elsif (SW0 = '0' and SW1 = '1') then
				if (row > 360) then
					r <= (others => '1');
					g <= (others => '1');
					b <= (others => '0');
				elsif (column < 200) then
					r <= (others => '1');
					g <= (others => '0');
					b <= (others => '1');
				elsif (column > 440) then
					r <= (others => '0');
					g <= (others => '1');
					b <= (others => '1');
				else
					r <= (others => '1');
					g <= (others => '1');
					b <= (others => '1');
				end if;
```


### Test/Debug

Throughout the course of this lab, I experienced issues with each of my VHDL modules. However, through the careful application of testbenches (and some consulatation with experts such as Captain Branchflower), I was able to properly diagnose and fix the different errors. The problems I experienced can be seen below.
 * In `h_sync_gen`, my first issue came with differences in type. I had initialized various signals to be used with my code, but I had written them with incorrect types. This gave me numerous problems while writing the code for this file, especially when trying to assign a value to my `column` that was dependent on count. I then realized that the value I needed to generate an unsigned value for `column`. After fixing this mistake, my code for `h_sync_gen` worked appropriately. 
 * In `vga_sync`, I was also experiencing issues, which once again seemed to be a result of a conflict in types. After failing to see what was wrong, a careful analysis of the error messages showed that one of my declared signals was not being appropriately used. The signal was being declared but not being used in the highest level file of `v_sync_gen`. After commenting out this input declaration, my code for `vga_sync` worked appropriately.
 * My final issue was one that should not have particularly beeen an issue. After not being able to get my completed code working on my FPGA, I realized that I had not created a constraints file that specified which parts of my FPGA to use. After the creation of this file, my code properly displayed the desired pattern on the monitor display.




### Conclusion


 
