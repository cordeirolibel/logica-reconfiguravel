-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------

entity circuit is
generic (
	param1: std_logic_vector(...) := < value > ;
	param2: std_logic_vector(...) := < value > );
port (
	clk, rst: in std_logic;
	input1, input2, ...: in std_logic_vector(...);
	output1, output2, ...: out std_logic_vector(...);
end entity;
-------------------------------------------------------------

architecture moore_fsm of circuit is
	type state is (A, B, C, ...);
	signal pr_state, nx_state: state;
	attribute enum_encoding: string; --optional, see comments
	attribute enum_encoding of state: type is "sequential";

begin
--FSM state register:
process (clk, rst)
begin
	if rst='1' then --see Note 2 above on boolean tests
		pr_state < = A;
	elsif rising_edge(clk) then
		pr_state < = nx_state;
	end if;
end process;

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

 --Optional output register:
 process (clk, rst)
begin
	if rst='1' then --rst generally optional here
		new_output1 < = ...;
		--...
	elsif rising_edge(clk) then
		new_output1 < = output1;
		--...
	end if;
end process;

end architecture;
------------------------------------------------------------- 