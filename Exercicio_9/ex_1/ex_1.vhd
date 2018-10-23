-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------

entity ex_1 is
port (
	clk_placa, b_clk, rst: 	in std_logic;
	char, ov: 	in std_logic;
	saida, led: 		out std_logic);
end entity;
-------------------------------------------------------------

architecture ex_1 of ex_1 is
	type state is (ini,SA,SAB, SABA);
	signal pr_state, nx_state: state;
	signal clk: std_logic;
	attribute enum_encoding: string; --optional, see comments
	attribute enum_encoding of state: type is "sequential";

begin
	db1: entity work.debounce 
							  port map (botao_out => clk, clk => clk_placa, botao_in => b_clk);


	--FSM state register:
	process (clk, rst)
	begin
		if rst='0' then --see Note 2 above on boolean tests
			pr_state <= ini;
			led <= '1';
		elsif rising_edge(clk) then
			pr_state <= nx_state;
			led <= '0';
		end if;
	end process;

	--FSM combinational logic:
	process (all) --see Note 2 above on "all" keyword
		begin
		case pr_state is 
		when ini =>
			saida <= '0';
			--...
			if char = '0' and ov = '0' then
				nx_state <= SA;
	 		elsif char = '0' and ov = '1' then
	 			nx_state <= SA;
			elsif char = '1' and ov = '0' then
				nx_state <= ini;
			else -- 1 1
				nx_state <= ini;
			end if;
		when SA =>
			saida <= '0';
			--...
			if char = '0' and ov = '0' then
				nx_state <= SA;
	 		elsif char = '0' and ov = '1' then
	 			nx_state <= SA;
			elsif char = '1' and ov = '0' then
				nx_state <= SAB;
			else -- 1 1
				nx_state <= SAB;
			end if;
		when SAB =>
			saida <= '0';
			--...
			if char = '0' and ov = '0' then
				nx_state <= SABA;
	 		elsif char = '0' and ov = '1' then
	 			nx_state <= SABA;
			elsif char = '1' and ov = '0' then
				nx_state <= ini;
			else -- 1 1
				nx_state <= ini;
			end if;
		when SABA =>
			saida <= '1';
			--...
			if char = '0' and ov = '0' then
				nx_state <= ini;
	 		elsif char = '0' and ov = '1' then
	 			nx_state <= SA;
			elsif char = '1' and ov = '0' then
				nx_state <= ini;
			else -- 1 1
				nx_state <= SAB;
			end if;
		end case;
	end process;

end architecture;
-------------------------------------------------------------  