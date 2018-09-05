
------------------------------------------------------------------
-- 1) Construa um circuito que adicione um bit de paridade a 
-- um vetor de entrada de tamanho DATA_SIZE. Utilize uma 
-- entrada como seletor de paridade,         i.e., que 
-- configura o circuito a definir a paridade como par ou 
-- ímpar.
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY parity_detector IS
	GENERIC(
		DATA_SIZE: INTEGER := 4
		);
	PORT (
		entrada		: IN STD_LOGIC_VECTOR ((DATA_SIZE - 1) DOWNTO 0);
		parity_sel	: IN STD_LOGIC;
		saida			: OUT STD_LOGIC_VECTOR (DATA_SIZE DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE parity_detector OF parity_detector IS
	SIGNAL parity_tree: STD_LOGIC_VECTOR ((DATA_SIZE - 2) DOWNTO 0);
BEGIN
	parity_tree(0) <= entrada(0) XOR entrada(1);
	G1: FOR i IN 2 TO (DATA_SIZE - 1) GENERATE
		parity_tree(i - 1) <= parity_tree(i - 2) XOR entrada(i);
	END GENERATE;
	
	saida <= entrada & parity_tree(data_size - 2) WHEN parity_sel = '1' ELSE
				entrada & NOT parity_tree(data_size - 2);
	
END ARCHITECTURE;