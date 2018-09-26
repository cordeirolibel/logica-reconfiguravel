-------------------------------
-- inverte o sinal de saida depois do time
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
		IF rising_edge(clk) THEN
			counter := counter + 1;
			IF counter = (integer(ms*periodo/2)-1) THEN
				IF SIG='0' THEN
					sig <= '1';
				ELSE
					sig <= '0';
				END IF;
				
			END IF;
		END IF;	
	END PROCESS;

	saida_espera <= sig;
END ARCHITECTURE;