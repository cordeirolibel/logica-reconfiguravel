 
-----------------------------------------
-- Codificacao para display 7 segmentos
-- hexa to SSD

LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE IEEE.STD_LOGIC_SIGNED.ALL;
--USE ieee.Std_Logic_Arith.ALL;
USE ieee.numeric_std.all;

ENTITY ex3 IS
	GENERIC(
			N_BOTOES:  INTEGER := 3;
			N_CHAVES:  INTEGER := 10;
			N_LEDS:  INTEGER := 10
		);
	PORT (
		chaves: IN STD_LOGIC_VECTOR (N_CHAVES-1 DOWNTO 0);
		botoes: IN STD_LOGIC_VECTOR (N_BOTOES-1 DOWNTO 0);

		ssd_unidade: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		ssd_dezena: OUT STD_LOGIC_VECTOR (6 DOWNTO 0); 
		leds: OUT STD_LOGIC_VECTOR (N_LEDS-1 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE ex3 OF ex3 IS
	-------------------------------------------
	----- SIGNAL 
	SIGNAL num_chaves: STD_LOGIC_VECTOR (N_CHAVES/2 DOWNTO 0);
	--SIGNAL num_botoes: STD_LOGIC_VECTOR (N_BOTOES/2 DOWNTO 0);
	SIGNAL doisEXPbotoes: STD_LOGIC_VECTOR (N_BOTOES DOWNTO 0); 
	SIGNAL soma_final: INTEGER; 
	SIGNAL digito_unidade: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL digito_dezena: STD_LOGIC_VECTOR (3 DOWNTO 0);
	
BEGIN
	
	-------------------------------------------
	----- COMPONENTES

	--covertendo numero de chaves ligados para um numero
	ch2: entity work.chaves2hex generic map (N_CHAVES => N_CHAVES,N_SAIDA => N_CHAVES/2+1) 
								port map (chaves => chaves,saida => num_chaves);
	
	--fazendo 2**(numero de botoes ligados)
	db1: entity work.doisEbotoes generic map (N_BOTOES => N_BOTOES) 
								 port map (ent => botoes,saida => doisEXPbotoes);

	-- ligacoes dos ssd
	ssd1: entity work.hex2ssd port map (ent => digito_unidade,saida => ssd_unidade);
	ssd2: entity work.hex2ssd port map (ent => digito_dezena,saida => ssd_dezena);
	
	-------------------------------------------
	----- circuito
	
	--somando num_chaves+2**num_botoes
	soma_final <= to_integer(unsigned(num_chaves))+to_integer(unsigned(doisEXPbotoes));
	
	--binario para os leds
	leds <= std_logic_vector(to_unsigned(soma_final, leds'length));
	
	--separando digitos para o ssd
	digito_unidade <= std_logic_vector(to_unsigned(soma_final, digito_unidade'length)) WHEN soma_final<16 ELSE
					  std_logic_vector(to_unsigned(soma_final-16, digito_unidade'length));
	
	digito_dezena <= "0000" WHEN soma_final<16 ELSE
				     "0001";
						  
END ARCHITECTURE; 