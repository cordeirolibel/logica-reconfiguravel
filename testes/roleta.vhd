-------------------------------
-- Cria um ciclo de roleta de 
-- MINIMO ate MAXIMO para cada clk
----------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
----------------------------------
ENTITY roleta IS
	GENERIC(
			MINIMO: INTEGER := 0;
			MAXIMO: INTEGER := 7
		);
		
	PORT (clk: IN STD_LOGIC;
		   r_num: OUT INTEGER);
END ENTITY;
----------------------------------
ARCHITECTURE roleta OF roleta IS

BEGIN
	PROCESS(all)
		VARIABLE temp: INTEGER := MINIMO;
	BEGIN
		IF (rising_edge(clk)) THEN
			IF(temp >= MAXIMO) THEN
				temp := MINIMO;
			ELSE
				temp := temp + 1;
			END IF;
			r_num <= temp;
		END IF;
	END PROCESS;
END ARCHITECTURE;