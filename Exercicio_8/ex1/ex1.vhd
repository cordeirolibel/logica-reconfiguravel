---1)	FaÃƒÂ§a	um	projeto	onde	cada	vez	que	aperto	um	botÃƒÂ£o,	um	
---nÃƒÂºmero	decrementa	e	ao	apertar	o	outro	botÃƒÂ£o,	incrementa	
---esse	nÃƒÂºmero	em	1.	O	menor	e	o	maior	podem	ser	qualquer	
---coisa,	inclusive	negativos.	Quero	que	o	projeto	todo	seja	
---genÃƒÂ©rico.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.numeric_std.all;
USE ieee.std_logic_signed.all;
use IEEE.math_real.all;
USE ieee.Std_Logic_Arith.ALL;

ENTITY ex1 IS
	
	GENERIC(
			MINIMO: INTEGER := -11;
			MAXIMO: INTEGER := 12
		);
		
	PORT (		
		botao_mais: IN STD_LOGIC;
		botao_menos: IN STD_LOGIC;
		clk: IN STD_LOGIC;
		o_ssds: OUT STD_LOGIC_VECTOR((1+integer(REALMAX(CEIL(LOG(ABS(real(MAXIMO)))/LOG(real(10))), CEIL(LOG(ABS(real(MINIMO)))/LOG(real(10))))))*7-1 DOWNTO 0)
		);
		
END ENTITY;

ARCHITECTURE ex1 OF ex1 IS
	
	CONSTANT N_SSDS: INTEGER := 1+integer(REALMAX(CEIL(LOG(ABS(real(MAXIMO)))/LOG(real(10))), CEIL(LOG(ABS(real(MINIMO)))/LOG(real(10)))));

	-------------------------------------------
	----- SIGNAL 
	SIGNAL pb_botao_mais: STD_LOGIC;
	SIGNAL pd_botao_menos: STD_LOGIC;
	SIGNAL valor: INTEGER := MINIMO;

BEGIN
	
	-------------------------------------------
	----- COMPONENTES

	--debounce
	pb1: entity work.pushButton port map (b_in => botao_mais, b_out => pb_botao_mais,clk=>clk);
	pb2: entity work.pushButton port map (b_in => botao_menos, b_out => pd_botao_menos,clk=>clk);

	-- manda um inteiro positivo e exibe nos SSDs
	-- nÃƒÂ£o mando o ssd de sinal
	qs1: entity work.UquebraSSDs 
	 		generic map ( N_SSDS => N_SSDS) --ALGARISMOS => 10,
			port map (o_ssds => o_ssds , valor => valor);

	-------------------------------------------
	----- PROCESS

	PROCESS(all)  -- PROCESS(ALL)
		VARIABLE ant_botao_mais : STD_LOGIC := '0';
		VARIABLE ant_botao_menos : STD_LOGIC := '0';
	BEGIN
		IF rising_edge(clk)  THEN
			IF (ant_botao_mais /= pb_botao_mais) THEN
				--mais
				ant_botao_mais := pb_botao_mais;
				IF valor<MAXIMO THEN
					valor <= valor+1;
				END IF;
			END IF;
			IF (ant_botao_menos /= pd_botao_menos) THEN
				--menos
				ant_botao_menos := pd_botao_menos;
				IF valor>MINIMO THEN
					valor <= valor-1;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	-------------------------------------------
	----- CIRCUITO

	
END ARCHITECTURE;     