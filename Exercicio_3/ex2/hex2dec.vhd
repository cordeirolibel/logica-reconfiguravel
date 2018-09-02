
------------------------------------------------------------
-- Converte um numero em hexa para decimal
-- 1011 -> 1 0001      (11)
------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
------------------------------

ENTITY hex2dec IS
	PORT (
		hexa: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		saida: OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		);
END ENTITY;
------------------------------
ARCHITECTURE hex2dec OF hex2dec IS

BEGIN
	saida <= "0" & hexa WHEN hexa < 9 ELSE
			 "1" & (hexa - "1010");

END ARCHITECTURE;