-------------------------------
-- Gera um pulso se o botÃ£o estiver apertado. SÃ³ comparar
-- se b_out vale '1' num IF para utilizar.
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
	PROCESS(clk)
		VARIABLE temp: INTEGER RANGE MINIMO TO MAXIMO;
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