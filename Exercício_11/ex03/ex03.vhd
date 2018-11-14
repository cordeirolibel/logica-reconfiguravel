 -------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------------------------------
ENTITY ex03 IS
	generic (
	TIME1: integer := 250000000 ; -- tempo do pomodoro (5 segundos)
	TIME2: integer := 25000000 ); -- tempo de pisca led (0.5 segundos)
	port (
		clk, rst, bt: in std_logic;
		led, led_rst: out std_logic);
END ENTITY;
-------------------------------------------------------------
ARCHITECTURE ex03 OF ex03 IS

	--FSM-related declarations:
	type state is (PARADO, CONTANDO, PISCA1, PISCA2);
	signal pr_state, nx_state: state;

	--Timer-related declarations:
	CONSTANT T1: NATURAL := TIME1;
	CONSTANT T2: NATURAL := TIME2; 
	CONSTANT tmax: NATURAL := 1000000000;
	SIGNAL t: NATURAL RANGE 0 TO tmax;

	signal s_bt: std_logic;
BEGIN

	eb1: entity work.eventButton port map (b_in => bt, b_out => s_bt,clk => clk);

	--Timer:
	PROCESS (clk, rst)
	BEGIN
		IF(rst = '0') THEN
			t <= 0;
			pr_state <= PARADO;
			led_rst <= '1';
		ELSIF (clk'EVENT and clk = '1') THEN
			IF pr_state /= nx_state THEN
				t <= 0;
			ELSIF t /= tmax THEN
				t <= t + 1;
			END IF;
			led_rst <= '0';
			pr_state <= nx_state;
		END IF;
	END PROCESS;

	--FSM combinational logic:
	process (all) --see Note 2 above on "all" keyword
		begin
		case pr_state is 
		when PARADO =>
			--outputs
			LED <= '0';
			--transicoes
			if s_bt = '1' then
				nx_state <= CONTANDO;
			else
				nx_state <= PARADO;
			end if;
		--------------------
		when CONTANDO =>
			--outputs
			LED <= '1';
			--transicoes
			if s_bt = '1' then
				nx_state <= PARADO;
			elsif t >= T1-1 then 
				nx_state <= PISCA1;
			else
				nx_state <= CONTANDO;
			end if;
		--------------------
		when PISCA1 =>
			--outputs
			LED <= '0';
			--transicoes
			if s_bt = '1' then
				nx_state <= PARADO;
			elsif t >= T2-1 then 
				nx_state <= PISCA2;
			else
				nx_state <= PISCA1;
			end if;
		--------------------
		when PISCA2 =>
			--outputs
			LED <= '1';
			--transicoes
			if s_bt = '1' then
				nx_state <= PARADO;
			elsif t >= T2-1 then 
				nx_state <= PISCA1;
			else
				nx_state <= PISCA2;
			end if;
		end case;
	end process;

end architecture;
------------------------------------------------------------- 