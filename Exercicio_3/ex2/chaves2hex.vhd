
------------------------------------------------------------
-- Numero de chaves ligadas para hexa 

------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

------------------------------
ENTITY chaves2hex IS
	PORT (
		chaves: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		saida: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END ENTITY;
------------------------------
ARCHITECTURE chaves2hex OF chaves2hex IS

BEGIN
	saida <= ("000" & chaves(0)) + ("000" & chaves(1)) +
			 ("000" & chaves(2)) + ("000" & chaves(3)) +
			 ("000" & chaves(4)) + ("000" & chaves(5)) +
			 ("000" & chaves(6)) + ("000" & chaves(7)) +
			 ("000" & chaves(8)) + ("000" & chaves(9));

END ARCHITECTURE;