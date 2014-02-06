--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:25:18 02/05/2014
-- Design Name:   
-- Module Name:   C:/Users/C15Geoffrey.Novakows/Documents/Classes/ECE 383/Lab1/v_test.vhd
-- Project Name:  Lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: v_sync_gen
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

 
ENTITY v_test IS
END v_test;
 
ARCHITECTURE behavior OF v_test IS     

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal h_completed : std_logic := '0';

 	--Outputs
   signal v_sync : std_logic;
   signal blank : std_logic;
   signal completed : std_logic;
   signal row : unsigned(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.v_sync_gen(behavioral)
		  
		  generic map (
			 active_size => 480,
			 front_size => 10,
			 sync_size => 2,
			 back_size  => 33,
			 total_size => 525
		  )
		  
		  PORT MAP (
          clk => clk,
          reset => reset,
          h_completed => h_completed,
          v_sync => v_sync,
          blank => blank,
          completed => completed,
          row => row
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
		assert v_sync = '1' report "initial v_sync error";
		assert blank = '0' report "initial blank error";
		assert completed = '0' report "initial completed error";
		assert row = "00000000000" report "initial column error";


		wait for clk_period * 480; --beginning of front
		assert v_sync = '1' report "front v_sync error";
		assert blank = '1' report "front blank error";
		assert completed = '0' report "front completed error";
		assert row = "00000000000" report "front column error";	


		wait for clk_period * 10; --beginning of sync
		assert v_sync = '0' report "initial v_sync error";
		assert blank = '1' report "initial blank error";
		assert completed = '0' report "initial completed error";
		assert row = "00000000000" report "initial column error";


		wait for clk_period * 2; --beginning of back
		assert v_sync = '1' report "initial v_sync error";
		assert blank = '1' report "initial blank error";
		assert completed = '0' report "initial completed error";
		assert row = "00000000000" report "initial column error";


		wait for clk_period * 32; --completed
		assert v_sync = '1' report "initial v_sync error";
		assert blank = '1' report "initial blank error";
		assert completed = '1' report "initial completed error";
		assert row = "00000000000" report "initial column error";
      
		wait;
   end process;
END;
