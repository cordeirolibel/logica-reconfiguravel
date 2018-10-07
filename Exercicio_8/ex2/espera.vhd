-------------------------------
-- 	Faz uma clock na frequência desejada, em ms.
----------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
----------------------------------
ENTITY espera IS
	-- ms é quantos ms você quer esperar
	GENERIC(ms: INTEGER := 100;
			  periodo: INTEGER := 50000
			  );
	
	PORT (clk: IN STD_LOGIC;
		  enable: IN STD_LOGIC;
		  saida_espera: OUT STD_LOGIC);
END ENTITY;
----------------------------------
ARCHITECTURE espera OF espera IS
	SIGNAL sig: STD_LOGIC;
BEGIN
	PROCESS(clk)
		--50000 porque a frequência é 50 MHz. Em 50000 clocks ele faz 1 ms
		VARIABLE counter: INTEGER RANGE 0 TO integer(MS*PERIODO/2);
	BEGIN
		IF (rising_edge(clk) AND enable='1')  THEN
			counter := counter + 1;
			IF counter = (integer(ms*periodo/2)-1) THEN
				saida_espera <= 1
			ELSE
				saida_espera <= 0
			END IF;
		END IF;	
	END PROCESS;
END ARCHITECTURE;