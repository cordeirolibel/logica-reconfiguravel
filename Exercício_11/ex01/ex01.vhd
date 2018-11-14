-------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------------------------------
ENTITY ex01 IS
	generic (
	TAM_MAX: integer := 7; -- tamanho do balde
	TEMPO: integer := 25000000; --tempo para a animacao (0.5seg)
	DATA_WIDTH: integer := 2;  --fifo
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
	signal writeEn	: STD_LOGIC := '0';
	signal dataIn	: STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
	signal readEn	: STD_LOGIC := '0';
	signal dataOut	: STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
	signal empty: STD_LOGIC;
	signal full	: STD_LOGIC;
	
	signal anim_mais, anim_menos : STD_LOGIC;
	signal pop: STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0) := "00";
BEGIN

	eb1: entity work.eventButton port map (b_in => bt_mais, b_out => s_bt_mais,clk => clk);
	eb2: entity work.eventButton port map (b_in => bt_menos, b_out => s_bt_menos,clk => clk);

	ff1: entity work.fifo generic map(DATA_WIDTH=>DATA_WIDTH,FIFO_DEPTH=>FIFO_DEPTH)
							port map (	writeEn => WriteEn, dataIn => DataIn, readEn=> ReadEn,
											dataOut => DataOut, empty => Empty, full => Full,
											rst => rst,clk => clk);

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
		IF(rst = '0') THEN
			readEn <= '0';
			pop <= "00";-- '00' = null
			nx_state<=VAZIO;
		ELSE
			--ler FIFO 
			IF((empty = '0') and (writeEn = '0') and (pop = "00")) THEN --  "00" - null
				readEn <= '1';
				pop <= DataOut;
			ELSE
				readEn <= '0';
			END IF;
			
			-- Proximos estados
			case pr_state is 
			when VAZIO =>
				--outputs
				anim_mais  <= '1';
				anim_menos <= '1';
				--
				if pop = "01" then -- '01' = mais
					nx_state <= ANIMA_MAIS;
					pop <= "00";-- '00' = null
				elsif pop = "11" then -- '11' = menos
					nx_state <= ANIMA_MENOS;
					pop <= "00";-- '00' = null
				else 
					nx_state <= VAZIO;
				end if;
			when ANIMA_MAIS =>
				anim_mais  <= '1';
				anim_menos <= '0';
				--...
				if t >= 100000000 then
					nx_state <= VAZIO;
				else
					nx_state <= ANIMA_MAIS;
				end if;
			when ANIMA_MENOS =>
				anim_mais  <= '0';
				anim_menos <= '1';
				--...   
				if t >= 100000000 then
					nx_state <= VAZIO;
				else
					nx_state <= ANIMA_MENOS;
				end if;
			when others => 
				anim_mais  <= '0';
				anim_menos <= '0';
			end case;
		END IF;
	end process;

	--botoes para FIFO 
	PROCESS (clk)
	BEGIN
		IF(rst = '0') THEN
			writeEn <= '0';
		ELSE
			IF(s_bt_menos = '1') THEN -- AND(full = '0')
				dataIn <= "11";--menos
				writeEn <= '1';
			ELSIF (s_bt_mais = '1') THEN-- AND(full = '0')
				dataIn <= "01";--mais
				writeEn <= '1';
			ELSE 
				dataIn <= "00";
				writeEn <= '0';
			END IF;
		END IF;
	END PROCESS;

	leds(1) <= anim_menos;
	leds(0) <= anim_mais;
	
	leds(2) <= empty;
	leds(3) <= pop(0);
	leds(4) <= pop(1);
	leds(5) <= dataOut(0);
	leds(6) <= dataOut(1);
end architecture;
-------------------------------------------------------------  