 
-----------------------------------------
-- Codificacao para display 7 segmentos
-- hexa to SSD

LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE IEEE.STD_LOGIC_SIGNED.ALL;
--USE ieee.Std_Logic_Arith.ALL;
USE ieee.numeric_std.all;
use IEEE.math_real.all;
--use IEEE.math_real.log2;

ENTITY ex3 IS
	
	GENERIC(
			N_BOTOES:  INTEGER := 3;
			N_CHAVES:  INTEGER := 10
			--N_LEDS:  INTEGER := 10;
			--N_SSDS: INTEGER := 2
		);
		
	PORT (
		chaves: IN STD_LOGIC_VECTOR (N_CHAVES-1 DOWNTO 0);
		botoes: IN STD_LOGIC_VECTOR (N_BOTOES-1 DOWNTO 0);
		
		--o_ssds: OUT STD_LOGIC_VECTOR(integer(ceil(log2(real((N_CHAVES*(2**N_BOTOES))+1))/log2(16)))*7-1 DOWNTO 0);
		o_ssds: OUT STD_LOGIC_VECTOR(natural(ceil(log2(real((N_CHAVES*(2**N_BOTOES))+1))/real(4)))*7-1 DOWNTO 0);
		leds: OUT STD_LOGIC_VECTOR (natural(ceil(log2(real(N_CHAVES*2**N_BOTOES+1)))-real(1)) DOWNTO 0)
		);
		
END ENTITY;

ARCHITECTURE ex3 OF ex3 IS

	CONSTANT N_SSDS: INTEGER := natural(ceil(log2(real((N_CHAVES*(2**N_BOTOES))+1))/real(4)))*7-1;
	CONSTANT N_LEDS: INTEGER := natural(ceil(log2(real(N_CHAVES*2**N_BOTOES+1)))-real(1));


	TYPE SSD_TYPE is array(N_SSDS-1 DOWNTO 0) of STD_LOGIC_VECTOR(6 DOWNTO 0);
	TYPE DIG_TYPE is array(N_SSDS-1 DOWNTO 0) of STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-------------------------------------------
	----- SIGNAL 
	SIGNAL num_chaves: STD_LOGIC_VECTOR (N_CHAVES/2 DOWNTO 0);
	--SIGNAL num_botoes: STD_LOGIC_VECTOR (N_BOTOES/2 DOWNTO 0);
	SIGNAL doisEXPbotoes: STD_LOGIC_VECTOR (N_BOTOES DOWNTO 0); 
	SIGNAL soma_final: INTEGER; 
	SIGNAL digitos_unidade: STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	SIGNAL s_ssds: SSD_TYPE;
	SIGNAL s_digitos: DIG_TYPE;
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
	G1: FOR i IN 0 TO N_SSDS-1 GENERATE
		ssds: entity work.hex2ssd port map (ent => s_digitos(i),saida => s_ssds(i));

	END GENERATE G1;
	
	-------------------------------------------
	----- circuito
	
	--somando num_chaves+2**num_botoes
	soma_final <= to_integer(unsigned(num_chaves))*to_integer(unsigned(doisEXPbotoes));
	
	--binario para os leds
	leds <= std_logic_vector(to_unsigned(soma_final, leds'length));
	
	--separando digitos para o ssd
	G3: FOR i IN 0 TO N_SSDS-1 GENERATE
		s_digitos(i) <= std_logic_vector(to_unsigned(soma_final,4*N_SSDS))((i+1)*4-1 DOWNTO i*4);
	END GENERATE G3;
	
	-- ligacoes do sinal com a saida dos ssd
	G2: FOR i IN 0 TO N_SSDS-1 GENERATE
		o_ssds(7*(i+1)-1 DOWNTO 7*i) <= s_ssds(i);
	END GENERATE G2;
	
END ARCHITECTURE; 