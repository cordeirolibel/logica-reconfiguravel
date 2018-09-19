---------------------------------------------------- 
--1) Conte o número de entradas ligadas e acenda, em 
--sequencia, os LEDs, baseado nessa contagem

LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE IEEE.STD_LOGIC_SIGNED.ALL;
--USE ieee.Std_Logic_Arith.ALL;
USE ieee.numeric_std.all;

ENTITY ex1 IS
	GENERIC(
			N_CHAVES:  INTEGER := 10;
		);
	PORT (
		chaves: IN STD_LOGIC_VECTOR (N_CHAVES-1 DOWNTO 0);
		leds: OUT STD_LOGIC_VECTOR (N_CHAVES-1 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE ex1 OF ex1 IS
	-------------------------------------------
	----- SIGNAL 
	SIGNAL num_chaves: STD_LOGIC_VECTOR (N_CHAVES/2 DOWNTO 0);
	
BEGIN
	-------------------------------------------
	----- COMPONENTES

	--covertendo numero de chaves ligados para um numero
	ch2: entity work.chaves2hex generic map (N_CHAVES => N_CHAVES,N_SAIDA => N_CHAVES/2+1) 
								port map (chaves => chaves,saida => num_chaves);		
	-------------------------------------------
	----- circuito
	G1: FOR i IN 0 TO (N_CHAVES - 1) GENERATE
		leds(i) <= '1' WHEN to_integer(signed(num_chaves)) >= (i+1) ELSE
					  '0';
	END GENERATE;
	
END ARCHITECTURE; 