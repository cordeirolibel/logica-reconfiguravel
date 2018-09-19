LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY buscaPadrao IS
	GENERIC(
			M: INTEGER := 4; -- tamanho da máscara que quer buscar
			N: INTEGER := 6 -- tamanho do vetor onde está buscando
		);
	PORT (
		ent: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		busca: IN STD_LOGIC_VECTOR (M-1 DOWNTO 0);
		saida: OUT STD_LOGIC_VECTOR (N-M DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE buscaPadrao OF buscaPadrao IS
	TYPE aux_type is array(N - M DOWNTO 0) of STD_LOGIC_VECTOR(M-1 DOWNTO 0);
	TYPE sig_and_type is array (N - M DOWNTO 0) of STD_LOGIC_VECTOR(M - 2 DOWNTO 0);
	SIGNAL aux: aux_type;
	SIGNAL and_tree: sig_and_type;
BEGIN	
	
	G1: FOR i IN 0 TO (N - M) GENERATE
	
		G_AUX: FOR k IN 0 TO (M - 1) GENERATE
			aux(i)(k) <= NOT(ent(k+i) XOR busca(k));
		END GENERATE G_AUX;
	
		and_tree(i)(0) <= aux(i)(0) AND aux(i)(1);
		G2: FOR j IN 1 TO (M-2) GENERATE
			and_tree(i)(j) <= (and_tree(i)(j - 1) AND aux(i)(j + 1));
		END GENERATE G2;
		saida(i) <= and_tree(i)(M-2);
	END GENERATE G1;
			 
END ARCHITECTURE;
