-------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------------------------------
ENTITY ex01b IS
	generic (
	TAM_MAX: integer := 7; -- tamanho do balde
	TEMPO: integer := 100000000; --tempo para a animacao (1seg)
	FIFO_DEPTH: integer := 8);
	port (
		clk, rst: in std_logic;
		bt_mais, bt_menos: in std_logic;
		leds: out std_logic_vector(TAM_MAX-1 DOWNTO 0);
		led_rst: out std_logic);
END ENTITY;
-------------------------------------------------------------
ARCHITECTURE ex01b OF ex01b IS

	SIGNAL s_bt_mais, s_bt_menos : STD_LOGIC;

BEGIN

	eb1: entity work.eventButton port map (b_in => bt_mais, b_out => s_bt_mais,clk => clk);
	eb2: entity work.eventButton port map (b_in => bt_menos, b_out => s_bt_menos,clk => clk);

	--Timer:
	PROCESS (clk, rst)
	BEGIN
		IF(rst = '0') THEN
			t <= 0;
			pr_state <= VAZIO;
			led_rst <= '1';
		ELSIF (clk'EVENT and clk = '1') THEN
			IF pr_state /= nx_state THEN
				t <= 0;
				pr_state <= nx_state;
			ELSIF t /= tmax THEN
				t <= t + 1;
			END IF;
			led_rst <= '0';
		END IF;
	END PROCESS;

	
	
end architecture;
-------------------------------------------------------------  