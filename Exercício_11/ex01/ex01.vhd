-------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------------------------------
ENTITY ex01 IS
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
ARCHITECTURE ex01 OF ex01 IS

	--FSM-related declarations:
	type state is (VAZIO, PARADO, ANIMA_MAIS, ANIMA_MENOS, CHEIO);
	signal pr_state, nx_state: state;

	--Timer-related declarations:
	CONSTANT T1: NATURAL := TEMPO;
	CONSTANT tmax: NATURAL := 1000000000;
										 
	SIGNAL t: NATURAL RANGE 0 TO tmax;
	
	signal s_bt_mais : std_logic;
	signal s_bt_menos: std_logic;
	
	signal anim_mais, anim_menos : STD_LOGIC;

	--fifo
	--signal memory : STD_LOGIC_VECTOR (FIFO_DEPTH - 1 downto 0);
	--signal tail: integer;
	--signal head: integer;
	--signal empty: std_LOGIC;

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

	--FSM combinational logic:
	process (all) --see Note 2 above on "all" keyword
		variable tail: integer := 0;
		variable head: integer := 0;
		variable memory : STD_LOGIC_VECTOR (FIFO_DEPTH - 1 downto 0):= (Others=>'0');
		variable tam_balde: integer := 0;
		begin
		IF(rst = '0') THEN
			nx_state<=VAZIO;
			tail := 0;
			head := 0;
			tam_balde := 0;
			memory := (Others=>'0');
		ELSIF rising_edge(clk) THEN
			--leitura dos botoes - fila
			IF(s_bt_menos = '1') THEN 
				memory(head) := '0';--menos
				head := (head + 1) mod FIFO_DEPTH; 
				
			ELSIF (s_bt_mais = '1') THEN
				memory(head) := '1';--mais
				head := (head + 1) mod FIFO_DEPTH; 

			
			ELSE				
				-- Proximos estados
				case pr_state is 
				when VAZIO =>
					leds(6) <= '1';
					leds(5) <= '0';
					leds(4) <= '0';
					leds(3) <= '0';
					leds(2) <= '0';
					
					--outputs
					anim_mais  <= '0';
					anim_menos <= '0';
					--
					if head /= tail then 
						if memory(tail) = '1' then --  mais
							tam_balde := tam_balde+1;
							nx_state <= ANIMA_MAIS;
						else
							nx_state <= VAZIO;
						end if;
						tail := (tail + 1) mod FIFO_DEPTH; 
					else 
						nx_state <= VAZIO;
					end if;
				when ANIMA_MAIS =>
					leds(6) <= '0';
					leds(5) <= '1';
					leds(4) <= '0';
					leds(3) <= '0';
					leds(2) <= '0';
					
					anim_mais  <= '1';
					anim_menos <= '0';
					--...
					if t >= T1-1 and tam_balde < TAM_MAX  then
						nx_state <= PARADO;
					elsif t >= T1-1 and tam_balde >= TAM_MAX then
						nx_state <= CHEIO;
					else
						nx_state <= ANIMA_MAIS;
					end if;
				when PARADO =>
					leds(6) <= '0';
					leds(5) <= '0';
					leds(4) <= '0';
					leds(3) <= '1';
					leds(2) <= '0';
					
					anim_mais  <= '0';
					anim_menos <= '0';
					--...
					nx_state <= PARADO;
				when OTHERS =>
					leds(6) <= '0';
					leds(5) <= '0';
					leds(4) <= '0';
					leds(3) <= '0';
					leds(2) <= '1';
					
					anim_mais  <= '1';
					anim_menos <= '1';
					nx_state <= PARADO;
				end case;
			END IF;	
		END IF;
	end process;


	leds(1) <= anim_menos;
	leds(0) <= anim_mais;
	
	
	
end architecture;
-------------------------------------------------------------  