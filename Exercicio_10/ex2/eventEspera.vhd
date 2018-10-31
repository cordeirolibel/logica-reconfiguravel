-------------------------------
-- Gera um pulso de 1 clock depois do tempo em ms.
-- Só conferir se saida_eventEspera = '1' para utilizar.
----------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
----------------------------------
ENTITY eventEspera IS
	-- ms é quantos ms você quer esperar
	GENERIC(ms: INTEGER := 100;
			  periodo: INTEGER := 50000
			  );
	
	PORT (clk: IN STD_LOGIC;
		  enable: IN STD_LOGIC;
			saida: OUT STD_LOGIC);
END ENTITY;
----------------------------------
ARCHITECTURE eventEspera OF eventEspera IS
	SIGNAL sig: STD_LOGIC;
BEGIN
	PROCESS(clk)
		--50000 porque a frequência é 50 MHz. Em 50000 clocks ele faz 1 ms
		VARIABLE counter: INTEGER := 0;
	BEGIN
		IF (rising_edge(clk) AND enable='1')  THEN
			IF counter = (integer(ms*periodo)-1) THEN
				saida <= '1';
				counter := 0;
			ELSE
				saida <= '0';
				counter := counter + 1;
			END IF;
		END IF;	
	END PROCESS;
END ARCHITECTURE;