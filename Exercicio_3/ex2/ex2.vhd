
------------------------------------------------------------------
--2) Transformar o nÃºmero de chaves ligadas para um nÃºmero inteiro.
-- Utilize os SSDs para mostrar o valor final.
--
-- chaves -> hexa -> dec -> 2 ssd
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ex2 IS
	PORT (
		chaves: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		ssd1: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		ssd2: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE ex2 OF ex2 IS
	COMPONENT dec2ssd
		PORT (
			ent: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			saida: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT hex2dec 
		PORT (
			hexa: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			saida: OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT chaves2hex
		PORT (
			chaves: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			saida: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL s_hexa: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL s_dec: STD_LOGIC_VECTOR (4 DOWNTO 0);
BEGIN
	
	-- Chaves para hexa
	chaves2bcd1: chaves2hex PORT MAP (
		chaves => chaves,
		saida => s_hexa
		);

	--hexa para decimal
	hex2dec1: hex2dec PORT MAP (
		hexa => s_hexa,
		saida => s_dec
		);

	-- decimal para 2 ssd
	dec2ssd1: dec2ssd PORT MAP (
		ent => s_dec(3 DOWNTO 0),
		saida => ssd1 
		);
	dec2ssd2: dec2ssd PORT MAP (
		ent => "000" & s_dec(4),
		saida => ssd2
		);

END ARCHITECTURE;
