-- 2) Similar ao exercício anterior, mostrar o número de 
-- chaves ligadas como um número representado no display de 
-- sete segmentos (SSD). Mostre esse valor em hexadecimal.

 ------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
------------------------------
ENTITY chave2ssd IS
	PORT (
		sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7, sw8: IN STD_LOGIC;
		seg_out	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END ENTITY;
------------------------------
ARCHITECTURE chave2ssd OF chave2ssd IS
	signal b_in: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
		b_in <= 	("000" & sw0)  + ("000" & sw1) + ("000" & sw2)  + ("000" & sw3) + ("000" & sw4)  + ("000" & sw5) + ("000" & sw6)  + ("000" & sw7) + ("000" & sw8);
		seg_out <= 		"0000001" WHEN b_in = "0000" ELSE
						"1001111" WHEN b_in = "0001" ELSE
						"0010010" WHEN b_in = "0010" ELSE
						"0000110" WHEN b_in = "0011" ELSE
						"1001100" WHEN b_in = "0100" ELSE
						"0100100" WHEN b_in = "0101" ELSE
						"0100000" WHEN b_in = "0110" ELSE
						"0001111" WHEN b_in = "0111" ELSE
						"0000000" WHEN b_in = "1000" ELSE
						"0000100" WHEN b_in = "1001" ELSE
						"0000000";
END ARCHITECTURE;