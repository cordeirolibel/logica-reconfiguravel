-- 
-- separa valor em diferentes ssds
-- 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--
-- A = ALGARISMOS
-- S = NUMERO DE SSDS
--
--A^S-1 > MAXIMO
--A^S > MAXIMO+1
--S*lg(A) > lg(MAXIMO+1)
--S = ceil(lg(MAXIMO+1)/lg(A))

ENTITY quebraSSDs IS
	
	GENERIC(
			ALGARISMOS:  INTEGER := 10;--10 ou 16
			N_SSDS: INTEGER := 1
		);
		
	PORT (		
		o_ssds: OUT STD_LOGIC_VECTOR(N_SSDS*7-1 DOWNTO 0);
		valor: IN INTEGER
		);
		
END ENTITY;

ARCHITECTURE quebraSSDs OF quebraSSDs IS

	TYPE SSD_TYPE is array(N_SSDS-1 DOWNTO 0) of STD_LOGIC_VECTOR(6 DOWNTO 0);
	TYPE DIG_TYPE is array(N_SSDS-1 DOWNTO 0) of STD_LOGIC_VECTOR(3 DOWNTO 0);

	-------------------------------------------
	----- SIGNAL 
	SIGNAL s_ssds: SSD_TYPE;
	SIGNAL s_digitos: DIG_TYPE;
	
BEGIN
	
	-------------------------------------------
	----- COMPONENTES
	
	-- ligacoes dos ssd
	G1: FOR i IN 0 TO N_SSDS-1 GENERATE
		ssds: entity work.hex2ssd port map (ent => s_digitos(i),saida => s_ssds(N_SSDS-i-1));
	END GENERATE G1;
	
	-------------------------------------------
	----- PROCESS


	
	-------------------------------------------
	----- CIRCUITO

	--separando digitos para o ssd
	G3: FOR i IN 0 TO N_SSDS-1 GENERATE
		s_digitos(i) <= std_logic_vector(to_unsigned( 
						(valor mod ALGARISMOS**(i+1))/(ALGARISMOS**i),
						s_digitos(i)'length));
	END GENERATE G3;

	-- ligacoes do sinal com a saida dos ssd
	G2: FOR i IN 0 TO N_SSDS-1 GENERATE
		o_ssds(7*(i+1)-1 DOWNTO 7*i) <= s_ssds(i);
	END GENERATE G2;
	
END ARCHITECTURE;  