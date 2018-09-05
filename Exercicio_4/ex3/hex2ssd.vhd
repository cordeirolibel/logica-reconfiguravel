 
-----------------------------------------
-- Codificacao para display 7 segmentos
-- hexa to SSD

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY dec2ssd IS
	PORT (
		ent: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		saida: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE dec2ssd OF dec2ssd IS

BEGIN

	saida <="0000001" WHEN ent="0000" ELSE  -- '0'
			"1001111" WHEN ent="0001" ELSE  -- '1'
			"0010010" WHEN ent="0010" ELSE  -- '2'
			"0000110" WHEN ent="0011" ELSE  -- '3'
			"1001100" WHEN ent="0100" ELSE  -- '4' 
			"0100100" WHEN ent="0101" ELSE  -- '5'
			"0100000" WHEN ent="0110" ELSE  -- '6'
			"0001111" WHEN ent="0111" ELSE  -- '7'
			"0000000" WHEN ent="1000" ELSE  -- '8'
			"0000100" WHEN ent="1001" ELSE  -- '9'
			"0001000" WHEN ent="1010" ELSE  -- 'a'
			"1100000" WHEN ent="1011" ELSE  -- 'b'
			"0110001" WHEN ent="1100" ELSE  -- 'c'
			"1000010" WHEN ent="1101" ELSE  -- 'd'
			"0110000" WHEN ent="1110" ELSE  -- 'e'
			"0111000";  -- 'f'

END ARCHITECTURE;