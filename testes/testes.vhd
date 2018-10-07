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
		led4: OUT STD_LOGIC
		);
		
END ENTITY;

ARCHITECTURE testes OF testes IS
	
	-------------------------------------------
	----- SIGNAL 
	SIGNAL clk_int: STD_LOGIC;
	SIGNAL s_botao1: STD_LOGIC;
	SIGNAL s_botao2: STD_LOGIC;
BEGIN
	
	-------------------------------------------
	----- COMPONENTES
	--da um pulso de um clk em MS
	ee1: entity work.EventEspera generic map (MS => 1000) 
							port map (saida => clk_int, clk => clk, enable => '1');
	-- Botoes
	eb1: entity work.EventButton port map (b_in => botao1, b_out => s_botao1,clk=>clk);
	
	db1: entity work.pushButton port map (b_out => s_botao2, clk => clk, b_in => botao2);
							  
	-------------------------------------------
	----- PROCESS
	PROCESS(all)  -- PROCESS(ALL)
		VARIABLE v_led1: STD_LOGIC;
		VARIABLE v_led2: STD_LOGIC;
		--VARIABLE v_led3: STD_LOGIC;
		--VARIABLE v_led4: STD_LOGIC;
	BEGIN
		--botao1 LED1
		IF rising_edge(clk) AND s_botao1 = '1' AND v_led1 = '0' THEN
			v_led1 := '1';
			led1 <= '1';
		ELSIF rising_edge(clk) AND s_botao1 = '1' AND v_led1 = '1' THEN 
			v_led1 := '0';
			led1 <= '0';
		END IF;
		
		--botao2 LED4
		IF rising_edge(clk) AND s_botao2 = '1' THEN
			led4 <= '1';
		ELSIF rising_edge(clk) AND s_botao2 = '0'  THEN 
			led4 <= '0';
		END IF;
		
		-- espera LED2
		IF rising_edge(clk) AND clk_int = '1' AND v_led2 = '0' THEN
			v_led2 := '1';
			led2 <= '1';
		ELSIF rising_edge(clk) AND clk_int = '1' AND v_led2 = '1' THEN 
			v_led2 := '0';
			led2 <= '0';
		END IF;
		
		-- chave LED3
		IF rising_edge(clk) AND chave = '1' THEN
			led3 <='1';
		ELSIF rising_edge(clk) AND chave = '0' THEN
			led3 <='0';
		END IF;
		
	END PROCESS;
	
	-------------------------------------------
	----- CIRCUITO



END ARCHITECTURE;      