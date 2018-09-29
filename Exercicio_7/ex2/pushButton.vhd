-------------------------------
-- transforma um botão em Push Botton
----------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
----------------------------------
ENTITY pushButton IS
	
	PORT (b_in: IN STD_LOGIC;
		  b_out: OUT STD_LOGIC);
END ENTITY;
----------------------------------
ARCHITECTURE pushButton OF pushButton IS

BEGIN
	PROCESS(all)
		VARIABLE ant: STD_LOGIC := '0';
	BEGIN
		IF rising_edge(b_in) THEN
			IF ant = '0' THEN
				ant := '1';
				b_out <= '1';
			ELSE
				ant := '0';
				b_out <= '0';
			END IF;
		END IF;
	END PROCESS;

END ARCHITECTURE;