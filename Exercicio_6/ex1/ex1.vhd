-- 1)	Crie	um	circuito	que	faça	um	LED	girar	nas	posições	
-- existentes.
-- A	cada	quarto	de	segundo,	faça	o	LED	andar	para	a	
-- esquerda.	Quando	chegar	no	final,	deve	voltar	e	dar	a	
-- volta.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;



ENTITY ex1 IS
	
	GENERIC(
			TEMPO:  INTEGER := 250;--milissegundos
			N_LEDS: INTEGER := 4;
			PERIODO: INTEGER := 50000 --clocks por milissengundos
		);
		
	PORT (		
		leds: OUT STD_LOGIC_VECTOR (N_LEDS-1 DOWNTO 0);
		clk: IN STD_LOGIC
		);
		
END ENTITY;

ARCHITECTURE ex1 OF ex1 IS

	-------------------------------------------
	----- SIGNAL 
	SIGNAL clk_int: STD_LOGIC;
	
BEGIN
	
	-------------------------------------------
	----- COMPONENTES

	--covertendo numero de chaves ligados para um numero
	es1: entity work.espera generic map (MS => TEMPO, PERIODO => PERIODO) 
								   port map (saida_espera => clk_int, clk => clk);
	
	-------------------------------------------
	----- PROCESS

	PROCESS(clk_int)  -- PROCESS(ALL)
		VARIABLE led_ligado: INTEGER range 0 to N_LEDS;
	BEGIN
		IF rising_edge(clk_int) THEN
			leds <= (OTHERS => '0');
			IF led_ligado < N_LEDS-1 THEN
				led_ligado := led_ligado+1;
			ELSE 
				led_ligado := 0;
			END IF;
			leds(led_ligado) <= '1';

		END IF;
	END PROCESS;
	
	-------------------------------------------
	----- CIRCUITO

	
END ARCHITECTURE;  