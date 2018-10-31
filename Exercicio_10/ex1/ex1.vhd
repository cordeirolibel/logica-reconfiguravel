-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------

entity ex1 is
port (
	clk, rst: 	in std_logic;
	CE, CD, CA				: 	in std_logic;
	ledE, ledD, ledR		: 		out std_logic);
end entity;
-------------------------------------------------------------

architecture ex1 of ex1 is
	type state is (ini, direita, esquerda, alerta);
	signal pr_state, nx_state: state;
	attribute enum_encoding: string; --optional, see comments
	attribute enum_encoding of state: type is "sequential";

begin
	--FSM state register:
	process (clk, rst)
	begin
		if rst='0' then --see Note 2 above on boolean tests
			pr_state <= ini;
				ledR <= '1';
		elsif rising_edge(clk) then
			pr_state <= nx_state;
			ledR <= '0';
		end if;
	end process;

	--FSM combinational logic:
	process (all) --see Note 2 above on "all" keyword
		begin
		case pr_state is 
		when ini =>
			ledE <= '0';
			ledD <= '0';
			--...
			if    CE = '0' and CD = '0' and CA = '0' then
				nx_state <= ini;
	 		elsif CE = '0' and CD = '0' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '0' and CD = '1' and CA = '0' then
				nx_state <= direita;
	 		elsif CE = '0' and CD = '1' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '1' and CD = '0' and CA = '0' then
				nx_state <= esquerda;
	 		elsif CE = '1' and CD = '0' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '1' and CD = '1' and CA = '0' then
				nx_state <= ini;
			else -- 1 1 1
				nx_state <= alerta;
			end if;
		when alerta =>
			ledE <= '1';
			ledD <= '1';
			--...
			if    CE = '0' and CD = '0' and CA = '0' then
				nx_state <= ini;
	 		elsif CE = '0' and CD = '0' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '0' and CD = '1' and CA = '0' then
				nx_state <= direita;
	 		elsif CE = '0' and CD = '1' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '1' and CD = '0' and CA = '0' then
				nx_state <= esquerda;
	 		elsif CE = '1' and CD = '0' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '1' and CD = '1' and CA = '0' then
				nx_state <= ini;
			else -- 1 1 1
				nx_state <= alerta;
			end if;
		when esquerda =>
			ledE <= '1';
			ledD <= '0';
			--...
			if    CE = '0' and CD = '0' and CA = '0' then
				nx_state <= ini;
	 		elsif CE = '0' and CD = '0' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '0' and CD = '1' and CA = '0' then
				nx_state <= direita;
	 		elsif CE = '0' and CD = '1' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '1' and CD = '0' and CA = '0' then
				nx_state <= esquerda;
	 		elsif CE = '1' and CD = '0' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '1' and CD = '1' and CA = '0' then
				nx_state <= ini;
			else -- 1 1 1
				nx_state <= alerta;
			end if;
		when direita =>
			ledE <= '0';
			ledD <= '1';
			--...
			if    CE = '0' and CD = '0' and CA = '0' then
				nx_state <= ini;
	 		elsif CE = '0' and CD = '0' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '0' and CD = '1' and CA = '0' then
				nx_state <= direita;
	 		elsif CE = '0' and CD = '1' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '1' and CD = '0' and CA = '0' then
				nx_state <= esquerda;
	 		elsif CE = '1' and CD = '0' and CA = '1' then
				nx_state <= alerta;
	 		elsif CE = '1' and CD = '1' and CA = '0' then
				nx_state <= ini;
			else -- 1 1 1
				nx_state <= alerta;
			end if;
		end case;
	end process;
end architecture;
-------------------------------------------------------------  