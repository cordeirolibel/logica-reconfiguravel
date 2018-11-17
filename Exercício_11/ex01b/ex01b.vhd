-------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------------------------------
ENTITY ex01b IS
	generic (
	TAM_MAX: integer := 9; -- tamanho do balde
	TEMPO_ANIMA: integer := 1500; --tempo para a animacao (1seg)
	CLOCK: integer := 50000000;
	FIFO_DEPTH: integer := 8);
	port (
		clk, rst: in std_logic;
		bt_mais, bt_menos: in std_logic;
		leds: out std_logic_vector(TAM_MAX-1 DOWNTO 0);
		led_rst: out std_logic);
END ENTITY;
-------------------------------------------------------------
ARCHITECTURE ex01b OF ex01b IS
	
	CONSTANT T_TOTAL_ANIMACAO: INTEGER := TEMPO_ANIMA*(CLOCK/1000);
	CONSTANT T_ANIMACAO: INTEGER := T_TOTAL_ANIMACAO/TAM_MAX;

	SIGNAL s_bt_menos,s_bt_mais: STD_LOGIC;
	
	SIGNAL anima_menos,anima_mais, anima: STD_LOGIC;
	SIGNAL time_anima: STD_LOGIC;
	SIGNAL tam_balde: INTEGER;
	SIGNAL t_count: INTEGER;
	SIGNAL gota_pos: INTEGER;

	--FIFO
	SIGNAL fifo    : STD_LOGIC_VECTOR (FIFO_DEPTH - 1 downto 0) := (OTHERS=>'0');
	SIGNAL tam_fifo: INTEGER;
	SIGNAL li_fifo	: STD_LOGIC;
	SIGNAL empty,full	: STD_LOGIC;
	
	
BEGIN
	---------------------------------------------------------------------------
	-- Componentes

	eb1: entity work.eventButton port map (b_in => bt_mais, b_out => s_bt_mais,clk => clk);
	eb2: entity work.eventButton port map (b_in => bt_menos, b_out => s_bt_menos,clk => clk);

	---------------------------------------------------------------------------
	-- Processos
	---------------------------------------------------------------------------
	
	---------------------------------
	-- leitura da FIFO e inicio de animacao
	PROCESS (all)
		TYPE state IS (MAIS, MENOS, NULO);
		VARIABLE pop: state:= NULO;	
	BEGIN
		IF(rst = '0') THEN
			led_rst <= '1';
			tam_balde <= 0;
			anima_mais <= '0';
			anima_menos <= '0';
			li_fifo <= '0';
			pop := NULO;

		ELSIF (clk'EVENT and clk = '1') THEN
			led_rst <= '0';

			---------------------------------
			-- lendo fila
			IF pop = NULO AND empty='0' AND anima = '0' THEN
				IF fifo(0) = '1' THEN 
					pop := MAIS;
				ELSE
					pop := MENOS;
				END IF;
				li_fifo <= '1';
			ELSE
				li_fifo <= '0';
			END IF;

			
			---------------------------------
			--Acabou a animacao
			IF t_count >= T_TOTAL_ANIMACAO THEN 
				IF anima_mais = '1' THEN 
					tam_balde <= tam_balde + 1;
				END IF;
				anima_mais <= '0';
				anima_menos <= '0';
			END IF;
			
			---------------------------------
			-- Inicia animacao
			-- inicia animacao se tem o pedido na fila e nao esta acontecendo uma animacao
			IF pop = MAIS THEN 
				IF tam_balde < TAM_MAX THEN 
					anima_mais <= '1';
				END IF;
				pop := NULO;
			ELSIF pop = MENOS THEN 
				IF tam_balde > 0 THEN 
					tam_balde <= tam_balde - 1;
					anima_menos <= '1';
				END IF;
				pop := NULO;	
			END IF;
		END IF;
	END PROCESS;
	
	---------------------------------
	--time
	PROCESS (clk, rst)
	BEGIN
		IF rst='0' THEN
			t_count <= 0;
		ELSIF (clk'EVENT and clk = '1') THEN
			IF (anima = '1') THEN
				t_count <= t_count+1;
			ELSE
				t_count <= 0;
			END IF;
		END IF;
	END PROCESS;
	
	---------------------------------
	-- animacao

	---------------------------------
	--Controle da FIFO
	PROCESS (all)
	BEGIN
		IF(rst = '0') THEN
			tam_fifo <= 0;
		ELSIF  (clk'EVENT and clk = '1') THEN
			-- botoes para FIFO 
			IF ((s_bt_menos = '1') AND (full = '0')) THEN 
				fifo(tam_fifo) <= '0';--menos
				tam_fifo <= tam_fifo + 1;
			ELSIF ((s_bt_mais = '1') AND (full = '0')) THEN
				fifo(tam_fifo) <= '1';--mais
				tam_fifo <= tam_fifo + 1;
			END IF;
			IF li_fifo = '1' AND tam_fifo>0 THEN 
				fifo(FIFO_DEPTH-2 DOWNTO 0) <= fifo(FIFO_DEPTH-1 DOWNTO 1);
				tam_fifo <= tam_fifo - 1;
			END IF;
		END IF;
	END PROCESS;

	---------------------------------------------------------------------------
	-- Circuitos
	gota_pos <= (TAM_MAX-1)-t_count/T_ANIMACAO 	WHEN anima_mais  = '1' ELSE
				tam_balde  +t_count/T_ANIMACAO	WHEN anima_menos = '1' ELSE
				TAM_MAX; -- fora do balde, liga nada

	-- leds ligados do balde
	G1: FOR i IN 0 TO TAM_MAX-1 GENERATE
		leds(i) <= '1' WHEN tam_balde>i OR gota_pos=i OR(i=tam_balde and gota_pos<tam_balde)  ELSE
				   '0';
	END GENERATE G1;

	anima <= anima_menos OR anima_mais;
	full <=  '1' WHEN tam_fifo>=FIFO_DEPTH ELSE
			 '0';
	empty <= '1' WHEN tam_fifo<=0 ELSE
			 '0';
			 
end architecture;
-------------------------------------------------------------  