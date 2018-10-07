---
--- Projeto para testes simples 
---

LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.numeric_std.all;
USE ieee.std_logic_signed.all;
--use IEEE.math_real.all;
--USE ieee.Std_Logic_Arith.ALL;

ENTITY testes IS
		
	PORT (		
		botao1: IN STD_LOGIC;
		botao2: IN STD_LOGIC;
		chave: IN STD_LOGIC;
		clk: IN STD_LOGIC;
		led1: OUT STD_LOGIC;
		led2: OUT STD_LOGIC;
		led3: OUT STD_LOGIC;
		led4: OUT STD_LOGIC;
		led5: OUT STD_LOGIC:='0';
		led6: OUT STD_LOGIC
		);
		
END ENTITY;

ARCHITECTURE testes OF testes IS
	
	-------------------------------------------
	----- SIGNAL 
	SIGNAL s_roleta: INTEGER;
	
BEGIN
	
	-------------------------------------------
	----- COMPONENTES
	rl1: entity work.roleta port map (clk => clk, r_num => s_roleta);

							  
	-------------------------------------------
	----- PROCESS
	PROCESS(all)  -- PROCESS(ALL)
		variable tmp: INTEGER:=0;
		variable ant: STD_LOGIC :='0';
	BEGIN
		IF rising_edge(clk) AND s_roleta = 4 THEN
			tmp := tmp + 1;
			if tmp = 1000000 THEN 
				if ant='0' then
					ant := '1';
					led4 <= '1';
				else
					ant := '0';
					led4 <= '0';
				end if;
				tmp := 0;
			END IF;
		END IF;
		IF rising_edge(clk) AND s_roleta = 5  AND botao1 = '1' THEN
			led5 <= '1';
		ELSIF rising_edge(clk) AND botao1 = '0' THEN 
			led5 <= '0';
		END IF;
	END PROCESS;
	
	-------------------------------------------
	----- CIRCUITO
	led1 <= '1' WHEN s_roleta = 0 ELSE
			  '0';
	led2 <= '1' WHEN s_roleta = 1 ELSE
			  '0';
	led3 <= '1' WHEN s_roleta = 2 ELSE
			  '0';
	
	led6 <= '1' WHEN s_roleta <= 1 ELSE
			  '0';

END ARCHITECTURE;      