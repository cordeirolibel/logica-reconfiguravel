 --  1)	Construa	um	circuito	que	adicione	um	bit	de	paridade	a	
-- um	vetor	de	entrada	de	tamanho	DATA_SIZE.	Utilize	uma	
-- entrada	como	seletor	de	paridade,	 i.e.,	que	
-- configura	o	circuito	a	definir	a	paridade	como	par	ou	
-- ímpar.


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ex2 IS
	GENERIC(
			N:  INTEGER := 4
		);
	PORT (
		ent: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		saida: OUT STD_LOGIC
		);
END ENTITY;

ARCHITECTURE ex2 OF ex2 IS
	SIGNAL mask: STD_LOGIC_VECTOR (N-3 DOWNTO 0);
BEGIN

	G1: FOR i IN 0 TO N-3 GENERATE
		mask(i) <= (NOT ent(i)) AND (NOT ent(i+1)) AND (NOT ent(i+2));
	END GENERATE G1;

	saida <= '0' WHEN to_integer(unsigned(mask))=0 ELSE
			   '1';
			 
END ARCHITECTURE;
