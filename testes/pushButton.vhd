-------------------------------
-- transforma um botão em Push Botton
----------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
----------------------------------
ENTITY pushButton IS
	GENERIC(TEMPO_DEBOUNCE:  INTEGER := 50;--milissegundos
			PERIODO: INTEGER := 50000
			);

	PORT (b_in: IN STD_LOGIC;
		  clk: IN STD_LOGIC;
		  b_out: OUT STD_LOGIC);
END ENTITY;
----------------------------------
ARCHITECTURE pushButton OF pushButton IS
	SIGNAL event_b: STD_LOGIC;
	
BEGIN
							  
	eb1: entity work.EventButton generic map (TEMPO_DEBOUNCE => TEMPO_DEBOUNCE, PERIODO => PERIODO) 
											port map (b_in => b_in, b_out => event_b,clk=>clk);
											
	PROCESS(all)
		VARIABLE ant: STD_LOGIC := '0';
	BEGIN
		IF rising_edge(clk) AND event_b = '1' AND ant = '0' THEN
			ant := '1';
			b_out <= '1';
		ELSIF rising_edge(clk) AND event_b = '1' AND ant = '1' THEN 
			ant := '0';
			b_out <= '0';
		END IF;
	END PROCESS;

END ARCHITECTURE;