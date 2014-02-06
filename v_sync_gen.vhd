----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:58:24 01/29/2014 
-- Design Name: 
-- Module Name:    v_sync_gen - Behavioral 
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

architecture Behavioral of v_sync_gen is

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
		elsif(clk'event and clk = '1' and h_completed = '1') then
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
			v_sync <= '1';
			blank <= '0';
			completed <= '0';
		elsif(count < (active_size + front_size)) then --front
			v_sync <= '1';
			blank <= '1';
			completed <= '0';			
		elsif(count < (active_size + front_size + sync_size)) then --sync
			v_sync <= '0';
			blank <= '1';
			completed <= '0';		
		elsif(count < total_size - 1) then -- back
			v_sync <= '1';
			blank <= '1';
			completed <= '0';
		else --end
			v_sync <= '1';
			blank <= '1';
			completed <= '1';
		end if;
	end process;

row <= count when (count < active_size) else (others => '0');

end Behavioral;
