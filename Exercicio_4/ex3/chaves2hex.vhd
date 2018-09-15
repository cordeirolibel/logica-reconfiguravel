
------------------------------------------------------------
-- Numero de chaves ligadas para hexa 

------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
--USE ieee.numeric_std.ALL;
USE ieee.Std_Logic_Arith.ALL;



------------------------------
ENTITY chaves2hex IS
	GENERIC(
			N_CHAVES:  INTEGER := 4;
			N_SAIDA: INTEGER := 3 -- N_CHAVES/2+1
		);
	PORT (
		chaves: IN STD_LOGIC_VECTOR(N_CHAVES-1 DOWNTO 0);
		saida: OUT STD_LOGIC_VECTOR(N_SAIDA-1 DOWNTO 0)
		);
END ENTITY;

------------------------------
ARCHITECTURE chaves2hex OF chaves2hex IS
	TYPE int_array is array(N_CHAVES-2 DOWNTO 0) of INTEGER;
	
	SIGNAL somas_intermediarias: int_array;
	SIGNAL zero: STD_LOGIC_VECTOR (30 DOWNTO 0);

BEGIN
	zero <= (OTHERS => '0');
	somas_intermediarias(0) <=  conv_integer(unsigned(zero & chaves(0))) +
							          conv_integer(unsigned(zero & chaves(1)));

	G1: FOR i IN 1 TO N_CHAVES-2 GENERATE
		somas_intermediarias(i) <= somas_intermediarias(i-1)+conv_integer(unsigned(zero&chaves(i+1)));
	END GENERATE G1;

	saida <= conv_std_logic_vector(somas_intermediarias(N_CHAVES-2),saida'length);

END ARCHITECTURE;