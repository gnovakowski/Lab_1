----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:04:01 01/29/2014 
-- Design Name: 
-- Module Name:    vga_sync - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity vga_sync is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_sync : out  STD_LOGIC;
           v_sync : out  STD_LOGIC;
           v_completed : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           row : out  unsigned(10 downto 0);
           column : out  unsigned(10 downto 0));
end vga_sync;

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

