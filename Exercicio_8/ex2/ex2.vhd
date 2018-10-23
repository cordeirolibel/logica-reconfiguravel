-- 2)	Projete	um	jogo	onde	um	LED	acende	de	cada	vez	e	o	
-- jogador	precisa	apertar	o	botÃ£o	enquanto	o	LED	acesso	Ã©	a	
-- posiÃ§Ã£o	selecionada	daquela	rodada.
-- O	jogo	sÃ³	comeÃ§a	depois	do	aperto	do	botÃ£o	start_game.
-- A	pontuaÃ§Ã£o	sobe	com	cada	acerto	e	deve	ser	mostrada	ao	
-- jogador.
-- O	jogo	termina	se	o	jogador	errar	o	aperto	ou	nÃ£o	apertar	
-- dentro	de	uma	janela	de	tempo	curta	depois	de	acender	o	
-- LED	e	esse	"game	over"	deve	ser	indicado	de	alguma	forma.	
-- O	jogo	sÃ³	deve	reiniciar	apÃ³s	apertar	o	start_game	novamente.
-- Essa	posiÃ§Ã£o	selecionada	de	cada	rodada	Ã©	indicada	como	um	
-- nÃºmero	em	decimal	e	deve	ser	escolhida	aleatoriamente.
-- O	tamanho	do	tabuleiro	Ã©	8	posiÃ§Ãµes	e,	a	cada	acerto,	a	
-- velocidade	que	o	LED	apaga/acende/"anda"	aumenta.	O	jogo	
-- deve	acabar	em	MAX_POINTS,	de	alguma	forma	indicando	que	o	
-- jogo	acabou.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.numeric_std.all;
USE ieee.std_logic_signed.all;
--use IEEE.math_real.all;
--USE ieee.Std_Logic_Arith.ALL;

ENTITY ex2 IS
	
	GENERIC(
			MAX_POINTS: INTEGER := 3;
			N_LEDS: INTEGER := 8;
			TEMPO_DELTA:INTEGER := 200 --ms
		);
		
	PORT (		
		botao_start: IN STD_LOGIC;
		botao: IN STD_LOGIC;
		clk: IN STD_LOGIC;
		ssd_rand: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		ssd_pts: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		leds: OUT STD_LOGIC_VECTOR(N_LEDS-1 DOWNTO 0);
		led_game_over: OUT STD_LOGIC := '0';
		led_win: OUT STD_LOGIC := '0'
		);
		
END ENTITY;

ARCHITECTURE ex2 OF ex2 IS
	
	
	-------------------------------------------
	----- SIGNAL 
	SIGNAL clk_int: STD_LOGIC;
	SIGNAL s_botao_start: STD_LOGIC;
	SIGNAL s_botao: STD_LOGIC;
	SIGNAL pontos: INTEGER:=0;
	SIGNAL pos_leds: INTEGER:=0;
	SIGNAL s_roleta: INTEGER;
	SIGNAL tempo: INTEGER;
	SIGNAL rand: INTEGER:=0;
BEGIN
	
	-------------------------------------------
	----- COMPONENTES
	--da um pulso de um clk em MS
	es1: entity work.eventEsperaDinamico 
				port map (MS => tempo,saida => clk_int, clk => clk, enable => '1');

	-- Botoes
	eb1: entity work.eventButton port map (b_in => botao_start, b_out => s_botao_start,clk=>clk);
	eb2: entity work.eventButton port map (b_in => botao, b_out => s_botao,clk=>clk);

	-- SSDs
	qs1: entity work.quebraSSDs port map (o_ssds => ssd_rand, valor => rand);
	qs2: entity work.quebraSSDs port map (o_ssds => ssd_pts, valor => pontos);

	--rl1: entity work.roleta port map (clk => clk, r_num => s_roleta);

	-------------------------------------------
	----- PROCESS
	PROCESS(all)  -- PROCESS(ALL)
		VARIABLE in_game: STD_LOGIC := '0';
		--VARIABLE rand: INTEGER:=0;
		VARIABLE roleta: INTEGER:= SEED;
	BEGIN
		
		------------  Inicia jogo  ------------
		IF rising_edge(clk) AND s_botao_start = '1' AND in_game = '0' THEN
			roleta := (roleta*547832+38382) mod 101;
			rand <= roleta mod N_LEDS;
			pontos <= 0;
			pos_leds <= 0;
			led_game_over <= '0';
			led_win <= '0';
			in_game := '1';
		------------  Andar  ------------
		ELSIF rising_edge(clk) AND clk_int = '1' AND in_game = '1' THEN
			pos_leds <= pos_leds+1;
			IF  pos_leds > rand THEN
				--passou do objetivo, game over
				in_game := '0';
				pos_leds <= 0;
				led_game_over <= '1';
			END IF;

		------------  Apertou  ------------
		ELSIF rising_edge(clk) AND s_botao = '1' AND in_game = '1' THEN
			IF (pos_leds<rand)OR(pos_leds>rand) THEN
				--antes ou depois do objetivo, game over
				in_game := '0';
				pos_leds <= 0;
				led_game_over <= '1';
			ELSE
				--no objetivo
				IF pontos >= MAX_POINTS-1 THEN
					--ganhou 
					led_win <= '1';
					in_game := '0';
				ELSE
					roleta := (roleta*547832+38382) mod 101;
					rand <= roleta mod N_LEDS;
				END IF;
				pontos <= pontos + 1;
				pos_leds <= 0;
				
			END IF;
		END IF;
	END PROCESS;
	
	-------------------------------------------
	----- CIRCUITO
	--leds
	G1: FOR i IN 0 TO N_LEDS-1 GENERATE
		leds(i) <= '1' WHEN i=pos_leds ELSE
				   '0';
	END GENERATE G1;
	
	-- [2*TEMPO_DELTA,(MAX_POINTS+2)*TEMPO_DELTA]
	-- [2*TD,5*TEMPO_DELTA]
	tempo <= (MAX_POINTS - pontos+1)*TEMPO_DELTA; --empirico

END ARCHITECTURE;      