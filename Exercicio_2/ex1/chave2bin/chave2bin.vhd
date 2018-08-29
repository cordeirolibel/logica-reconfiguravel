-- 1) Transformar o número de chaves ligadas para binário 
-- sequencial. Os LEDs de saída devem representar o número de 
-- chaves ligadas em binário sequencial.

------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
------------------------------
ENTITY chave2bin IS
	PORT (
		sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7: IN STD_LOGIC;
		y: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END ENTITY;
------------------------------
ARCHITECTURE chave2bin OF chave2bin IS
	SIGNAL sig: STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
	y <= 	("000" & sw0)  + ("000" & sw1) + ("000" & sw2)  + ("000" & sw3) + ("000" & sw4)  + ("000" & sw5) + ("000" & sw6)  + ("000" & sw7);
END ARCHITECTURE;