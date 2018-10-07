--1)	Crie	um	circuito	que	faça	o	debounce	de	um	botão.	O	tempo	de	
--debounce	deve	ser	100ms.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY debounce IS
	
	GENERIC(
			TEMPO:  INTEGER := 100;--milissegundos
			PERIODO: INTEGER := 50000
		);
		
	PORT (		
		botao_out: OUT STD_LOGIC;
		botao_in: IN STD_LOGIC;
		clk: IN STD_LOGIC
		);
		
END ENTITY;

ARCHITECTURE debounce OF debounce IS

	-------------------------------------------
	----- SIGNAL 
	SIGNAL clk_int: STD_LOGIC;
BEGIN
	
	-------------------------------------------
	----- COMPONENTES

	--inverte o sinal de saida depois do time
	es1: entity work.EventEspera generic map (MS => 1, PERIODO => PERIODO) 
							port map (saida => clk_int, clk => clk, enable => '1');

	-------------------------------------------
	----- PROCESS

	PROCESS(all)  -- PROCESS(ALL)

		VARIABLE ant: STD_LOGIC := '0';
		VARIABLE count: INTEGER := 0;
	BEGIN
		IF rising_edge(clk_int)  THEN
			count := count + 1;
			--mudar a saida - 100ms
			IF count = TEMPO THEN 
				botao_out <= NOT botao_in;
				count := 0;
			END IF;
			IF botao_in = ant THEN
				ant := botao_in;
			ELSE
				count := 0;
				ant := botao_in;
			END IF;
		END IF;


	END PROCESS;
	
	-------------------------------------------
	----- CIRCUITO


	
END ARCHITECTURE;    