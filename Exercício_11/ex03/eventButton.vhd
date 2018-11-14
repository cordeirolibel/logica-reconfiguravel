-------------------------------
-- Gera um pulso se o botão estiver apertado. Só comparar
-- se b_out vale '1' num IF para utilizar.
----------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

----------------------------------
ENTITY eventButton IS
	GENERIC(TEMPO_DEBOUNCE:  INTEGER := 50;--milissegundos
			PERIODO: INTEGER := 50000
			);

	PORT (b_in: IN STD_LOGIC;
		  clk: IN STD_LOGIC;
		  b_out: OUT STD_LOGIC);
END ENTITY;
----------------------------------
ARCHITECTURE eventButton OF eventButton IS
	SIGNAL s_b_in: STD_LOGIC;
	
BEGIN
	db1: entity work.debounce generic map (TEMPO => TEMPO_DEBOUNCE, PERIODO => PERIODO) 
							  port map (botao_out => s_b_in, clk => clk, botao_in => b_in);
							  
	PROCESS(all)
		VARIABLE ant: STD_LOGIC:='0';
	BEGIN
		IF (rising_edge(clk) AND s_b_in = '1' AND ant = '0') THEN
			-- apertado e primeiro clk
			b_out <= '1';
			ant := '1';
		ELSIF (rising_edge(clk) AND ant = '1') THEN
			-- apertado e demais clk
			b_out <= '0';
		ELSIF (rising_edge(clk) AND s_b_in = '0') THEN
			-- desapertado
			b_out <= '0';
			ant := '0';
		END IF;	
	END PROCESS;
END ARCHITECTURE;