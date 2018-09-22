-- 2)	Construa	um	contador	sequencial	de	valores,
-- contando	de	meio	em	meio	segundo,	de	0	a	31	e,	entÃƒÂ£o,	
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
			TEMPO:  INTEGER := 500;--milissegundos
			MINIMO: INTEGER := 5;
			MAXIMO: INTEGER := 55; --conta de valor minimo a maximo inclusive
			PERIODO: INTEGER := 50000;
			ALGARISMOS: INTEGER := 16
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
	SIGNAL valor : INTEGER := MINIMO;
	
BEGIN
	
	-------------------------------------------
	----- COMPONENTES

	--covertendo numero de chaves ligados para um numero
	es1: entity work.espera generic map (MS => TEMPO, PERIODO => PERIODO) 
						 	port map (saida_espera => clk_int, clk => clk);
	
	qs1: entity work.quebraSSDs 
	 		generic map (ALGARISMOS => ALGARISMOS, N_SSDS => N_SSDS) 
			port map (o_ssds => o_ssds, valor => valor);
	
	-------------------------------------------
	----- PROCESS

	PROCESS(clk_int)  -- PROCESS(ALL)
	BEGIN
		IF clk_int'EVENT AND clk_int='1' THEN
			valor <= valor + 1;
			IF valor >= MAXIMO THEN
				valor <= MINIMO;
			END IF;
		END IF;
	END PROCESS;
	
	-------------------------------------------
	----- CIRCUITO


END ARCHITECTURE;  