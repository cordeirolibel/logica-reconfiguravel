-- 2)	Construa	um	contador	sequencial	de	valores,
-- contando	de	meio	em	meio	segundo,	de	0	a	31	e,	entÃ£o,	
-- voltando	a	0.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.math_real.all;

--16^S-1 > MAXIMO
--2^(4S) > MAXIMO+1
--4S > lg(MAXIMO+1)
--S = ceil(lg(MAXIMO+1)/4)

ENTITY ex2 IS
	
	GENERIC(
			TEMPO:  INTEGER := 200;--milissegundos
			MINIMO: INTEGER := 5;
			MAXIMO: INTEGER := 55; --conta de valor minimo a maximo inclusive
			PERIODO: INTEGER := 50000
		);
		
	PORT (		
		o_ssds: OUT STD_LOGIC_VECTOR(integer(ceil(log2(real(MAXIMO)+real(1))/real(4)))*7-1 DOWNTO 0);
		clk: IN STD_LOGIC
		);
		
END ENTITY;

ARCHITECTURE ex2 OF ex2 IS

	CONSTANT N_SSDS: INTEGER := integer(ceil(log2(real(MAXIMO)+real(1))/real(4)));

	TYPE SSD_TYPE is array(N_SSDS-1 DOWNTO 0) of STD_LOGIC_VECTOR(6 DOWNTO 0);
	TYPE DIG_TYPE is array(N_SSDS-1 DOWNTO 0) of STD_LOGIC_VECTOR(3 DOWNTO 0);

	-------------------------------------------
	----- SIGNAL 
	SIGNAL clk_int: STD_LOGIC;
	SIGNAL s_ssds: SSD_TYPE;
	SIGNAL s_digitos: DIG_TYPE;

	SIGNAL valor : INTEGER := MINIMO;
	
BEGIN
	
	-------------------------------------------
	----- COMPONENTES

	--covertendo numero de chaves ligados para um numero
	es1: entity work.espera generic map (MS => TEMPO, PERIODO => PERIODO) 
						 	port map (saida_espera => clk_int, clk => clk);
	
	
	-------------------------------------------
	----- PROCESS

	PROCESS(clk_int)  -- PROCESS(ALL)
	BEGIN
		IF clk_int'EVENT AND clk_int='1' THEN
			valor <= valor + 1;
			IF valor > MAXIMO THEN
				valor <= MINIMO;
			END IF;
		END IF;
	END PROCESS;
	
	-------------------------------------------
	----- CIRCUITO

	--separando digitos para o ssd
	G3: FOR i IN 0 TO N_SSDS-1 GENERATE
		s_digitos(i) <= std_logic_vector(to_unsigned(valor,4*N_SSDS))((i+1)*4-1 DOWNTO i*4);
	END GENERATE G3;

	-- ligacoes dos ssd
	G1: FOR i IN 0 TO N_SSDS-1 GENERATE
		ssds: entity work.hex2ssd port map (ent => s_digitos(i),saida => s_ssds(N_SSDS-i-1));
	END GENERATE G1;

	-- ligacoes do sinal com a saida dos ssd
	G2: FOR i IN 0 TO N_SSDS-1 GENERATE
		o_ssds(7*(i+1)-1 DOWNTO 7*i) <= s_ssds(i);
	END GENERATE G2;
	
END ARCHITECTURE;  