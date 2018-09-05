 
-----------------------------------------
-- Codificacao para display 7 segmentos
-- hexa to SSD

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY doisEbotoes IS
	GENERIC(
			N_BOTOES:  INTEGER := 2
		);
	PORT (
		ent: IN STD_LOGIC_VECTOR (N_BOTOES-1 DOWNTO 0);
		saida: OUT STD_LOGIC_VECTOR (N_BOTOES+1 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE doisEbotoes OF doisEbotoes IS
	-------------------------------------------
	----- SIGNAL 
	SIGNAL hexa: STD_LOGIC_VECTOR (N_BOTOES/2 DOWNTO 0);
BEGIN
	
	-------------------------------------------
	----- COMPONENTES
	ch1: entity work.chaves2hex generic map (N_CHAVES => N_BOTOES,N_SAIDA => N_BOTOES/2+1) 
										 port map (chaves => ent,saida => hexa);
	



	
	-------------------------------------------
	----- circuito
	saida <= (0=>'1', OTHERS=>'0') SLL hexa;


END ARCHITECTURE; 