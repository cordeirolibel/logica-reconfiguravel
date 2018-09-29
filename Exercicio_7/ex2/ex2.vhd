-- 2)	Crie	um	circuito	que	circule	por	uma	trilha	de	LEDs.	O	
-- movimento	deve	ser	em	sentido	horário,	passando	por	todos	os	
-- LEDs	da	trilha.	O	usuário	pode	controlar	a	velocidade	do	
-- movimento	com	3	chaves,	chamadas	“speed”	e	o	sentido	do	
-- movimento,	com	um	botão	chamado	“reverse”.	Speed	controla	a	
-- velocidade	do	deslocamento	e	reverse,	cada	vez	pressionado,	
-- inverte	o	sentido	do	deslocamento.	Existem	duas	últimas	
-- entradas	chamadas	“tail	size	control”.	Esses	dois	botões	
-- controlam	o	tamanho	do	“rabo/rastro”	dos	LEDs.	O	valor	mínimo	é	
-- 1,	o	valor	máximo	é	o	tamanho	da	trilha	menos	um.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY ex2 IS
	
	GENERIC(
			TEMPO_DELTA:  INTEGER := 100;--milissegundos
			N_LEDS: INTEGER := 10;
			PERIODO: INTEGER := 50000 --clocks por milissengundos
		);
		
	PORT (		
		leds: OUT STD_LOGIC_VECTOR (N_LEDS-1 DOWNTO 0):= (0 => '0',OTHERS => '1');
		clk: IN STD_LOGIC;
		chaves_vel:  IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		b1_tam: IN STD_LOGIC;
		b2_tam: IN STD_LOGIC;
		B_reverse: IN STD_LOGIC
		);
		
END ENTITY;

ARCHITECTURE ex2 OF ex2 IS

	-------------------------------------------
	----- SIGNAL 
	SIGNAL clk_int: STD_LOGIC;
	SIGNAL tempo: INTEGER;
	SIGNAL chaves_val: INTEGER;
BEGIN
	
	-------------------------------------------
	----- COMPONENTES

	--inverte o sinal de saida depois do time
	es1: entity work.espera generic map (MS => TEMPO_DELTA, PERIODO => PERIODO) 
								   port map (saida_espera => clk_int, clk => clk, enable => '1');

	--covertendo numero de chaves ligados para um numero
	c2h: entity work.chaves2hex generic map (N_CHAVES => 3) 
								   port map (chaves => chaves_vel, saida => chaves_val);
	-------------------------------------------
	----- PROCESS

	PROCESS(all)  -- PROCESS(ALL)
		--VARIABLE leds: STD_LOGIC_VECTOR (N_LEDS-1 DOWNTO 0) := (0 => '0',OTHERS => '1');
		VARIABLE tam_minhoca: INTEGER RANGE 1 TO N_LEDS-1 := 1;
		VARIABLE head: INTEGER := N_LEDS-1;
		VARIABLE tail: INTEGER := 1;
		VARIABLE tempo_i: INTEGER := 0;
	BEGIN
		IF rising_edge(clk_int) AND (tempo_i = tempo) THEN
			-- atualizar a minhoca
			IF (B_reverse = '1') THEN 
				leds(tail) <= '0';
				IF head = N_LEDS-1 THEN
					head := 0;
				ELSE
					head := (head+1);
				END IF;
				IF tail = N_LEDS-1 THEN
					tail := 0;
				ELSE
					tail := (tail+1);
				END IF;
				leds(head) <= '1';
			ELSE
				leds(head) <= '0';
				IF head = 0 THEN
					head := N_LEDS-1;
				ELSE
					head := (head-1);
				END IF;
				IF tail = 0 THEN
					tail := N_LEDS-1;
				ELSE
					tail := (tail-1);
				END IF;
				leds(tail) <= '1';
			END IF;
		
			IF(b1_tam = '1') THEN
				tam_minhoca := tam_minhoca+1;
				IF(tam_minhoca>N_LEDS-1) THEN
					tam_minhoca := N_LEDS-1;
				ELSE
					leds(head) <= '1';
					head := (head+1)MOD N_LEDS;
				END IF;
			END IF;
			IF(b2_tam='1') THEN
				tam_minhoca := tam_minhoca-1;
				IF(tam_minhoca<=0) THEN
					tam_minhoca := 1;
				ELSE
					head := (head-1)MOD N_LEDS;	
					leds(head) <= '0'; 
				END IF;
			END IF;
			tempo_i := 0;
		ELSIF rising_edge(clk_int) THEN
			tempo_i := tempo_i + TEMPO_DELTA;
		END IF;
		
	END PROCESS;
	
	-------------------------------------------
	----- CIRCUITO

	tempo <= TEMPO_DELTA + chaves_val*TEMPO_DELTA;
	
END ARCHITECTURE;   