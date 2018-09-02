  
-----------------------------------------
-- Codificacao para display 7 segmentos
-- decimal to SSD

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
	-- a = A+C+BD+B'D'
	-- b = B'+C'D'+CD
	-- c = B+C'+D
	-- d = B'D'+CD'+BC'D+B'C+A
	-- e = B'D'+CD'
	-- f = A+C'D'+BC'+BD'
	-- g = A+BC'+B'C+CD'

	saida(0) <= ent(0) OR ent(2) OR (ent(1) AND ent(3)) OR ((NOT ent(1)) AND (NOT ent(3)));
	saida(1) <= (NOT ent(1)) OR ((NOT ent(2)) AND (NOT ent(3))) OR (ent(2) AND ent(3));
	saida(2) <= ent(1) OR (NOT ent(2)) OR ent(3);
	saida(3) <= ((NOT ent(1)) OR (NOT ent(3))) OR (ent(2) AND (NOT ent(3))) OR 
				(ent(1) AND (NOT ent(2)) AND ent(3)) OR ((NOT ent(1)) AND ent(2)) OR ent(0);
	saida(4) <= ((NOT ent(1)) AND (NOT ent(3))) OR (ent(2) AND (NOT ent(3)));
	saida(5) <= ent(0) OR ((NOT ent(2)) AND (NOT ent(3))) OR (ent(1) AND (NOT ent(2))) OR (ent(1) AND (NOT ent(3)));
	saida(6) <= ent(0) OR (ent(1) AND (NOT ent(2))) OR ((NOT ent(1)) AND ent(2)) OR (ent(2) AND (NOT ent(3)));
	
END ARCHITECTURE;
