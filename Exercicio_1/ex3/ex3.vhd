 LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ex3 IS
	PORT (
		sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		one_hot_out: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE ex3 OF ex3 IS

BEGIN
	one_hot_out <= "0001" WHEN sel="00" ELSE
		            "0010" WHEN sel="01" ELSE
						"0100" WHEN sel="10" ELSE
						"1000";
END ARCHITECTURE;
