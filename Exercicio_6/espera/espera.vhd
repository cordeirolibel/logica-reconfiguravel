----------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
----------------------------------
ENTITY espera IS
	-- ms é quantos ms você quer esperar
	GENERIC(ms: INTEGER := 1000);
	
	PORT (clk: IN STD_LOGIC;
			output: OUT STD_LOGIC);
END ENTITY;
----------------------------------
ARCHITECTURE espera OF espera IS
BEGIN
	PROCESS(clk)
		--50000 porque a frequência é 50 MHz. Em 50000 clocks ele faz 1 ms
		VARIABLE counter: INTEGER RANGE 0 TO ms*50000;
	BEGIN
		IF rising_edge(clk) THEN
			counter := counter + 1;
			IF (counter = ms*50000) THEN
				OUTPUT <= '1';
			ELSE
				OUTPUT <= '0';
			END IF;
		END IF;	
	END PROCESS;
END ARCHITECTURE;