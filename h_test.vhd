--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:56:13 02/05/2014
-- Design Name:   
-- Module Name:   C:/Users/C15Geoffrey.Novakows/Documents/Classes/ECE 383/Lab1/h_test.vhd
-- Project Name:  Lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: h_sync_gen
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

 
ENTITY h_test IS
END h_test;
 
ARCHITECTURE behavior OF h_test IS 

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal h_sync : std_logic;
   signal blank : std_logic;
   signal completed : std_logic;
   signal column : unsigned(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.h_sync_gen(behavioral)
		 generic map(
			active_size => 640,
			front_size => 16,
			sync_size => 96,
			back_size  => 48,
			total_size => 800
		 )

		  PORT MAP (
          clk => clk,
          reset => reset,
          h_sync => h_sync,
          blank => blank,
          completed => completed,
          column => column
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      wait for clk_period*10;

		wait for clk_period/4;

		reset <= '1';
		wait for clk_period * 5;
		reset <= '0';
		assert h_sync = '1' report "initial h_sync error";
		assert blank = '0' report "initial blank error";
		assert completed = '0' report "initial completed error";
		assert column = "00000000000" report "initial column error";

		wait for clk_period * 640; --front
		assert h_sync = '1' report "front h_sync error";
		assert blank = '1' report "front blank error";
		assert completed = '0' report "front completed error";
		assert column = "00000000000" report "front column error";	

		wait for clk_period * 16; --sync
		assert h_sync = '0' report "initial h_sync error";
		assert blank = '1' report "initial blank error";
		assert completed = '0' report "initial completed error";
		assert column = "00000000000" report "initial column error";

		wait for clk_period * 96; --back
		assert h_sync = '1' report "initial h_sync error";
		assert blank = '1' report "initial blank error";
		assert completed = '0' report "initial completed error";
		assert column = "00000000000" report "initial column error";

		wait for clk_period * 47; --end
		assert h_sync = '1' report "initial h_sync error";
		assert blank = '1' report "initial blank error";
		assert completed = '1' report "initial completed error";
		assert column = "00000000000" report "initial column error";
      
		wait;
   end process;
END;
