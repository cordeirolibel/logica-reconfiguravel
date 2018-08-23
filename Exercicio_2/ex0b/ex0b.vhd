--   0)	Construa	um	conversor	de	binário	para	gray	e	outro	
--   conversor	de	gray	para	binário.	Demonstre	o	funcionamento	
--   do	circuito.

-- gray to binary 

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ex0b IS
	PORT (
		ent: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		saida: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
		
	SIGNAL s_saida: STD_LOGIC_VECTOR (3 DOWNTO 0);
END ENTITY;

ARCHITECTURE ex0b OF ex0b IS

BEGIN

	s_saida(3) <= ent(3);
	s_saida(2) <= s_saida(3) XOR ent(2);
	s_saida(1) <= s_saida(2) XOR ent(1);
	s_saida(0) <= s_saida(1) XOR ent(0);
				
	saida <= s_saida;

END ARCHITECTURE;
