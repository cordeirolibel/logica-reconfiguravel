 LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ex2 IS
	PORT (
		a_in, b_in, c_in: IN STD_LOGIC;
		and_out,or_out,nand_out,nor_out: OUT STD_LOGIC;
		not_out,buffer_out,xor_out,xnor_out: OUT STD_LOGIC
		);
END ENTITY;

ARCHITECTURE ex2 OF ex2 IS

BEGIN
				
	and_out  <= a_in AND b_in AND c_in;
	or_out   <= a_in OR  b_in OR  c_in;
	nand_out <= NOT (a_in AND b_in AND c_in);
	nor_out  <= NOT (a_in OR  b_in OR  c_in);
	
	not_out <= NOT a_in;
	buffer_out <= '1' WHEN a_in='1' ELSE 
	              '0';
	xor_out  <= a_in XOR b_in XOR c_in;
	xnor_out <= NOT (a_in XOR  b_in XOR c_in);
	
END ARCHITECTURE;


