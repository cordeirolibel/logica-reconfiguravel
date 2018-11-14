-------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------------------------------
ENTITY ex02 IS
port (
	clk, rst							: 	in std_logic;
	b1, b2							: 	in std_logic;
	g1, g2, y1, y2, r1, r2, lr	: 	out std_logic);
END ENTITY;
-------------------------------------------------------------
ARCHITECTURE ex02 OF ex02 IS

	--FSM-related declarations:
	type state is (aberto1, espera1, amarelo1, aberto2, espera2, amarelo2);
	signal pr_state, nx_state: state;
	attribute enum_encoding: string; --optional, see comments
	attribute enum_encoding of state: type is "sequential";

	--Timer-related declarations:
	CONSTANT tmax: NATURAL := 50000000*3;
	SIGNAL t: NATURAL RANGE 0 TO tmax;

BEGIN
	--Timer:
	PROCESS (clk, rst)
	BEGIN
		IF(rst = '0') THEN
			t <= 0;
			lr <= '1';
			pr_state <= aberto1;
	ELSIF (clk'EVENT and clk = '1') THEN
		pr_state <= nx_state;
		lr <= '0';
		IF pr_state /= nx_state THEN
		t <= 0;
		ELSIF t /= tmax THEN
			t <= t + 1;
			lr <= '0';
		END IF;
	END IF;
END PROCESS;

	--FSM combinational logic:
	process (all) --see Note 2 above on "all" keyword
		begin
		case pr_state is 
		when aberto1 =>
			g1 <= '1';
			y1 <= '0';
			r1 <= '0';
			g2 <= '0';
			y2 <= '0';
			r2 <= '1';
			--...
			if b1 = '0' then
				nx_state <= espera1;
			else
				nx_state <= aberto1;
			end if;
		when espera1 =>
			g1 <= '1';
			y1 <= '0';
			r1 <= '0';
			g2 <= '0';
			y2 <= '0';
			r2 <= '1';
			--...
			if t < tmax then
				nx_state <= espera1;
			else
				nx_state <= amarelo1;
			end if;
		when amarelo1 =>
			g1 <= '0';
			y1 <= '1';
			r1 <= '0';
			g2 <= '0';
			y2 <= '0';
			r2 <= '1';
			--...
			if t < (tmax*6/10) then
				nx_state <= amarelo1;
			else
				nx_state <= aberto2;
			end if;
		when aberto2 =>
			g1 <= '0';
			y1 <= '0';
			r1 <= '1';
			g2 <= '1';
			y2 <= '0';
			r2 <= '0';
			--...
			if b2 = '0' then
				nx_state <= espera2;
			else
				nx_state <= aberto2;
			end if;
		when espera2 => 
			g1 <= '0';
			y1 <= '0';
			r1 <= '1';
			g2 <= '1';
			y2 <= '0';
			r2 <= '0';
			--...
			if t < tmax then
				nx_state <= espera2;
			else
				nx_state <= amarelo2;
			end if;
		when amarelo2 => 
			g1 <= '0';
			y1 <= '0';
			r1 <= '1';
			g2 <= '0';
			y2 <= '1';
			r2 <= '0';
			--...
			if t < (tmax*6/10) then
				nx_state <= amarelo2;
			else
				nx_state <= aberto1;
			end if;
		end case;
	end process;
end architecture;