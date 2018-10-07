-- 2)	Projete	um	jogo	onde	um	LED	acende	de	cada	vez	e	o	
-- jogador	precisa	apertar	o	botão	enquanto	o	LED	acesso	é	a	
-- posição	selecionada	daquela	rodada.
-- O	jogo	só	começa	depois	do	aperto	do	botão	start_game.
-- A	pontuação	sobe	com	cada	acerto	e	deve	ser	mostrada	ao	
-- jogador.
-- O	jogo	termina	se	o	jogador	errar	o	aperto	ou	não	apertar	
-- dentro	de	uma	janela	de	tempo	curta	depois	de	acender	o	
-- LED	e	esse	"game	over"	deve	ser	indicado	de	alguma	forma.	
-- O	jogo	só	deve	reiniciar	após	apertar	o	start_game	novamente.
-- Essa	posição	selecionada	de	cada	rodada	é	indicada	como	um	
-- número	em	decimal	e	deve	ser	escolhida	aleatoriamente.
-- O	tamanho	do	tabuleiro	é	8	posições	e,	a	cada	acerto,	a	
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
			TEMPO_DELTA := 100 --ms
		);
		
	PORT (		
		botao_start: IN STD_LOGIC;
		botao: IN STD_LOGIC;
		ssd_rand: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		ssd_pts: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		leds: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		led_game_over: OUT STD_LOGIC := '0';
		led_win: OUT STD_LOGIC := '0'
		);
		
END ENTITY;

ARCHITECTURE ex2 OF ex2 IS
	
	
	-------------------------------------------
	----- SIGNAL 
	SIGNAL pb_botao_start: STD_LOGIC;
	SIGNAL s_botao: STD_LOGIC;
	SIGNAL pontos: INTEGER:=0;
	SIGNAL rand: INTEGER:=0;
	SIGNAL pos_leds: INTEGER:=0;
	SIGNAL roleta: INTEGER;

BEGIN
	
	-------------------------------------------
	----- COMPONENTES
	--da um pulso de um clk em MS
	es1: entity work.espera generic map (MS => tempo) 
							port map (saida_espera => clk_int, clk => clk, enable => '1');


	-- Botoes
	pb1: entity work.eventButton port map (b_in => botao_start, b_out => pb_botao_start,clk=>clk);
	db1: entity work.debounce port map (botao_in => botao, botao_out => s_botao,clk=>clk);

	-- SSDs
	qs1: entity work.quebraSSDs port map (o_ssds => ssd_rand, valor => rand);
	qs2: entity work.quebraSSDs port map (o_ssds => ssd_pts, valor => pontos);

	qs2: entity work.roleta port map (clk => clk, r_num => roleta);

	-------------------------------------------
	----- PROCESS
	PROCESS(clk)  -- PROCESS(ALL)
		VARIABLE in_game: STD_LOGIC := '0';
	BEGIN
		IF pb_botao_start = '1' AND in_game = '0' THEN
			--inicia jogo
			in_game = '1';
			rand = roleta;
			pontos = 0;
			pos_leds <= 0;
			led_game_over <= '0';
			led_win <= '0';
		END IF;

		IF clk_int = '1' AND in_game = '1' THEN
			----> Andar <----
			pos_leds += 1;

			IF  pos_leds > rand THEN
				--passou do objetivo, game over
				in_game = '0';
				pos_leds <= 0;
				led_game_over <= '1';
			END IF;
			--ELSE 
			--- andar

		END IF;
		IF botao = '1' AND in_game = '1' THEN
			----> Apertou <----
			IF   THEN
				--antes do objetivo, game over
				in_game = '0';
				pos_leds <= 0;
				led_game_over <= '1';
			ELSIF   
				--no objetivo

			END IF;
		END IF;
	END PROCESS;
	
	-------------------------------------------
	----- CIRCUITO

	leds <= (pos_leds=>'1', OTHERS => '0');
	tempo <= (MAX_POINTS - pontos+2)*TEMPO_DELTA; --empirico

END ARCHITECTURE;      