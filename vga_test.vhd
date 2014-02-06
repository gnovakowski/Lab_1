--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:27:02 02/05/2014
-- Design Name:   
-- Module Name:   C:/Users/C15Geoffrey.Novakows/Documents/Classes/ECE 383/Lab1/vga_test.vhd
-- Project Name:  Lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vga_sync
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY vga_sync_test IS
END vga_sync_test;
 
ARCHITECTURE behavior OF vga_sync_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vga_sync
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         h_sync : OUT  std_logic;
         v_sync : OUT  std_logic;
         v_completed : OUT  std_logic;
         blank : OUT  std_logic;
         row : OUT  unsigned(10 downto 0);
         column : OUT  unsigned(10 downto 0)
        );
    END COMPONENT;
    


   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';


 	--Outputs
   signal h_sync : std_logic;
   signal v_sync : std_logic;
   signal v_completed : std_logic;
   signal blank : std_logic;
   signal row : unsigned(10 downto 0);
   signal column : unsigned(10 downto 0);


   -- Clock period definitions
   constant clk_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vga_sync PORT MAP (
          clk => clk,
          reset => reset,
          h_sync => h_sync,
          v_sync => v_sync,
          v_completed => v_completed,
          blank => blank,
          row => row,
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
      reset <= '1';

      wait for clk_period*10;

		reset <= '0';

		wait for clk_period*639;
		assert (blank = '0') report "not working"; 

      wait;
   end process;



END;
