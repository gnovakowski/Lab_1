----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:56:12 01/29/2014 
-- Design Name: 
-- Module Name:    h_sync_gen - Behavioral 
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
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.VComponents.all;

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

architecture Behavioral of h_sync_gen is
	signal count : unsigned(10 downto 0) := (others => '0');
	signal count_next : unsigned(10 downto 0);
	constant zero: unsigned(10 downto 0) := (others => '0');

begin

   --counter
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

	--output
	process(count) is
	begin
		if(count < active_size) then --active
			h_sync <= '1';
			blank <= '0';
			completed <= '0';
		elsif(count < (active_size + front_size)) then --front
			h_sync <= '1';
			blank <= '1';
			completed <= '0';			
		elsif(count < (active_size + front_size + sync_size)) then --sync
			h_sync <= '0';
			blank <= '1';
			completed <= '0';		
		elsif(count < total_size - 1) then --back
			h_sync <= '1';
			blank <= '1';
			completed <= '0';
		else --end
			h_sync <= '1';
			blank <= '1';
			completed <= '1';
		end if;
	end process;

column <= count when (count < active_size) else (others => '0');

end Behavioral;
