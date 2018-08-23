--3)	Faça	um	circuito	que	acenda	um	LED	quando	duas	ou	mais	
--  das	4	chaves	de	entrada	estiverem	ligadas	mas	não	quando	
--  todas	estiverem	ligadas.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ex3 IS
	PORT (
		a: IN STD_LOGIC;
		b: IN STD_LOGIC;
		c: IN STD_LOGIC;
		d: IN STD_LOGIC;
		saida: OUT STD_LOGIC
		);
		
END ENTITY;

ARCHITECTURE ex3 OF ex3 IS

BEGIN
	-- y = A'CD + A'BD + BCD' + AB'D + AB'C + ABC'
	saida <= ((NOT a) AND c AND d) OR
				((NOT a) AND b AND d) OR
				(b AND c AND (NOT D)) OR
				(a AND (NOT b) AND d) OR
				(a AND (NOT b) AND c) OR
				(a AND b AND (NOT c));

END ARCHITECTURE;
