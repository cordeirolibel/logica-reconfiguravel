-------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------------------------------
ENTITY <entity_name> IS
	(same as for regular machines)
END ENTITY;
-------------------------------------------------------------
ARCHITECTURE <archit_name> OF <entity_name> IS

	--FSM-related declarations:
	(same as for regular machines)

	--Timer-related declarations:
	CONSTANT T1: NATURAL := <value>;
	CONSTANT T2: NATURAL := <value>; ...
	CONSTANT tmax: NATURAL := <value>;
	SIGNAL t: NATURAL RANGE 0 TO tmax;

BEGIN
	--Timer:
	PROCESS (clk, rst)
	BEGIN
		IF(rst = '1') THEN
			t <= 0;
	ELSIF (clk'EVENT and clk = '1') THEN
		IF pr_state /= nx_state THEN
		t <= 0;
		ELSIF t /= tmax THEN
			t <= t + 1;
		END IF;
	END IF;
END PROCESS;