-------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------------------------------
ENTITY <entity_name> IS
	generic (
	param1: std_logic_vector(...) := < value > ;
	param2: std_logic_vector(...) := < value > );
	port (
		clk, rst: in std_logic;
		input1, input2, ...: in std_logic_vector(...);
		output1, output2, ...: out std_logic_vector(...);
END ENTITY;
-------------------------------------------------------------
ARCHITECTURE <archit_name> OF <entity_name> IS

	--FSM-related declarations:
	type state is (A, B, C, ...);
	signal pr_state, nx_state: state;

	--Timer-related declarations:
	CONSTANT T1: NATURAL := <value>;
	CONSTANT T2: NATURAL := <value>; ...
	CONSTANT tmax: NATURAL := <value>;
	SIGNAL t: NATURAL RANGE 0 TO tmax;

BEGIN
	--Timer:
	PROCESS (clk, rst)
	BEGIN
		IF(rst = '0') THEN
			t <= 0;
			pr_state <= A;
		ELSIF (clk'EVENT and clk = '1') THEN
			IF pr_state /= nx_state THEN
				t <= 0;
			ELSIF t /= tmax THEN
				t <= t + 1;
			END IF;
			pr_state <= nx_state;
		END IF;
	END PROCESS;

	--FSM combinational logic:
	process (all) --see Note 2 above on "all" keyword
		begin
		case pr_state is 
		when A = >
			output1 < = < value > ;
			output2 < = < value > ;
			--...
			if < condition >then
				nx_state < = B;
	 		elsif < condition >then
	 			nx_state < = ...;
			else
				nx_state < = A;
			end if;
		when B = >
			output1 < = < value > ;
			output2 < = < value > ;
			--...
			if < condition >then
				nx_state < = C;
			elsif < condition >then
				nx_state < = ...;
			else
				nx_state < = B;
			end if;
		when C = >
			--...
		end case;
	end process;


end architecture;
------------------------------------------------------------- 

