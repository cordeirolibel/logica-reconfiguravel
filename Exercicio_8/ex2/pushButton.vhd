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
	SIGNAL s_b_in: STD_LOGIC;
	
BEGIN

	db1: entity work.debounce generic map (TEMPO => TEMPO_DEBOUNCE, PERIODO => PERIODO) 
							  port map (botao_out => s_b_in, clk => clk, botao_in => b_in);
	PROCESS(all)
		VARIABLE ant: STD_LOGIC := '0';
	BEGIN
		IF rising_edge(s_b_in) THEN
			IF ant = '0' THEN
				ant := '1';
				b_out <= '1';
			ELSE
				ant := '0';
				b_out <= '0';
			END IF;
		END IF;
	END PROCESS;

END ARCHITECTURE;