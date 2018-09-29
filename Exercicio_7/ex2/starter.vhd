-------------------------------
-- Starter
-- cria um sinal pequeno (3 clks) e zera 
-- pode ser usado como um reset inicial
-- 0 0 1 1 1 0 0 0 0 0 0 0 .....
----------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
----------------------------------
ENTITY Starter IS
	PORT (clk: IN STD_LOGIC;
		  saida: OUT STD_LOGIC);
END ENTITY;

----------------------------------
ARCHITECTURE Starter OF Starter IS

BEGIN
	PROCESS(clk)
		VARIABLE counter: INTEGER := 0;
	BEGIN
		IF (rising_edge(clk))  THEN
			IF (2 <= counter) AND (counter <= 4) THEN
				saida <= '1';
			ELSE
				saida <= '0';
			END IF;
			IF (counter < 5) THEN 
				counter := counter + 1;
			END IF;
		END IF;	
	END PROCESS;
END ARCHITECTURE;