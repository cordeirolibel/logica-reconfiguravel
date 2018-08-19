LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg_mux IS
	PORT (
		a, b, c, d: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		clk: IN STD_LOGIC;
		y: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END ENTITY;

ARCHITECTURE reg_mux OF reg_mux IS
	SIGNAL x: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	x <= a WHEN sel="00" ELSE
		  b WHEN sel="01" ELSE
		  c WHEN SEL="10" ELSE
		  d;
	PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
			y <= x;
		END IF;
	END PROCESS;
END ARCHITECTURE;
