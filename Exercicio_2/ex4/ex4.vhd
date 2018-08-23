 --   0)	Construa	um	conversor	de	binário	para	gray	e	outro	
--   conversor	de	gray	para	binário.	Demonstre	o	funcionamento	
--   do	circuito.

-- gray to binary 

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ex4 IS
	PORT (
		a: IN STD_LOGIC;
		b: IN STD_LOGIC;
		c: IN STD_LOGIC;
		d: IN STD_LOGIC;
		l: OUT STD_LOGIC;
		t: OUT STD_LOGIC;
		f: OUT STD_LOGIC;
		r: OUT STD_LOGIC
		);
		
END ENTITY;

ARCHITECTURE ex4 OF ex4 IS
BEGIN

	l <= a AND B AND (NOT(b AND d));
	t <= a AND B AND (NOT(b AND d));
	f <= c AND (NOT(c AND d)) AND (NOT(b AND d));
	r <= d AND (NOT(c AND d)) AND (NOT(b AND d));

END ARCHITECTURE;
