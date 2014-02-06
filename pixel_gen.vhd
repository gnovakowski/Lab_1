----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:06:36 01/29/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
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

entity pixel_gen is
    Port ( row : in unsigned(10 downto 0);
           column : in unsigned(10 downto 0);
           blank : in  STD_LOGIC;
			  SW0 : in STD_LOGIC;
			  SW1 : in STD_LOGIC;
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));

end pixel_gen;

architecture Behavioral of pixel_gen is

begin

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

			elsif (SW0 = '1' and SW1 = '0') then
				if (row > 360) then
					r <= (others => '0');
					g <= (others => '1');
					b <= (others => '1');
				elsif (column < 200) then
					r <= (others => '0');
					g <= (others => '1');
					b <= (others => '0');
				elsif (column > 440) then
					r <= (others => '0');
					g <= (others => '0');
					b <= (others => '1');
				else
					r <= (others => '1');
					g <= (others => '1');
					b <= (others => '0');
				end if;

			elsif (SW0 = '1' and SW1 = '1') then
				if (row > 360) then
					r <= (others => '0');
					g <= (others => '1');
					b <= (others => '1');
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
			end if;
			
	end process;

end Behavioral;

