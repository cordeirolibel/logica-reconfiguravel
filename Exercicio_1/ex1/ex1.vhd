LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ex1 IS
	PORT (
		a_in, b_in, c_in, d_in: IN STD_LOGIC;
		a_out, b_out, c_out, d_out: OUT STD_LOGIC;
		all_out: OUT STD_LOGIC
		);
END ENTITY;

ARCHITECTURE ex1 OF ex1 IS

BEGIN
	a_out <= '0' WHEN a_in='0' ELSE
		      '1';
	b_out <= '0' WHEN b_in='0' ELSE
		      '1';
	c_out <= '0' WHEN c_in='0' ELSE
		      '1';
	d_out <= '0' WHEN d_in='0' ELSE
		      '1';
				
	all_out <= '1' WHEN (a_in AND b_in AND c_in AND d_in)='1' ELSE
				  '0';

END ARCHITECTURE;
