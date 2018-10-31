-- 2)	Cofre	EletrÃ´nico
-- Crie	um	cofre	eletrÃ´nico	de	cÃ³digo	secreto	genÃ©rico,	com	3	
-- nÃºmeros	(ex:	915).	A	cada	nÃºmero	inserido,	uma	luz	deve	
-- acender	para	indicar	quantos	valores	jÃ¡	foram	lidos.	Deve	
-- haver	uma	mensagem	indicando	se	o	cofre	estÃ¡	aberto	ou	
-- fechado.	O	cofre	sÃ³	aceita	o	cÃ³digo	secreto	novamente	uma	
-- vez	que	for	fechado.	Resolva	esse	exercÃ­cio	utilizando	
-- FSM,	seguindo	o	template,	e	desenhe	o	diagrama.


-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------

entity ex2 is
generic (
	C1: std_logic_vector(3 DOWNTO 0) := "0101" ;
	C2: std_logic_vector(3 DOWNTO 0) := "0101" ;
	C3: std_logic_vector(3 DOWNTO 0) := "0101" );
port (
	clk, rst: in std_logic;
	dig: in std_logic_vector(3 DOWNTO 0);
	bt,bd: in std_logic;
	ab,l1,l2,l3,led_rst: out std_logic);
end entity;
-------------------------------------------------------------

architecture ex2 of ex2 is
	type state is (aberto,fechado,digito1,digito2,falha1,falha2);
	signal pr_state, nx_state: state;
	signal bd_s, bt_s: std_logic;

begin

eb1: entity work.eventButton port map (b_in => bd, b_out => bd_s,clk => clk);

----------------------------------------------------------
--FSM state register:
process (clk, rst)
begin
	if rst = '0' then --see Note 2 above on boolean tests
		pr_state <= aberto;
		led_rst <= '1';
	elsif rising_edge(clk) then
		pr_state <= nx_state;
		led_rst <= '0';
	end if;
end process;

--FSM combinational logic:
process (all) --see Note 2 above on "all" keyword
	begin
	case pr_state is 
	--------------------------
	when aberto =>
		--saidas
		ab <= '1';
		l1 <= '1';
		l2 <= '1';
		l3 <= '1';

		--proximos estados
		if bt_s = '1' then
			nx_state <= fechado;
		else
			nx_state <= aberto;
		end if;
	--------------------------
	when fechado =>
		--saidas
		ab <= '0';
		l1 <= '0';
		l2 <= '0';
		l3 <= '0';

		--proximos estados
		if bt_s = '1' then
			nx_state <= fechado;
		elsif bd_s = '0' then 
			nx_state <= fechado;
		elsif dig = C1 then 
			nx_state <= digito1;
		else
			nx_state <= falha1;
		end if;
	--------------------------
	when digito1 =>
		--saidas
		ab <= '0';
		l1 <= '1';
		l2 <= '0';
		l3 <= '0';

		--proximos estados
		if bt_s = '1' then
			nx_state <= fechado;
		elsif bd_s = '0' then 
			nx_state <= digito1;
		elsif dig = C2 then 
			nx_state <= digito2;
		else
			nx_state <= falha2;
		end if;
	--------------------------
	when digito2 =>
		--saidas
		ab <= '0';
		l1 <= '1';
		l2 <= '1';
		l3 <= '0';

		--proximos estados
		if bt_s = '1' then
			nx_state <= fechado;
		elsif bd_s = '0' then 
			nx_state <= digito2;
		elsif dig = C3 then 
			nx_state <= aberto;
		else
			nx_state <= fechado;
		end if;
	--------------------------
	when falha1 =>
		--saidas
		ab <= '0';
		l1 <= '1';
		l2 <= '0';
		l3 <= '0';

		--proximos estados
		if bt_s = '1' then
			nx_state <= fechado;
		elsif bd_s = '0' then 
			nx_state <= falha1;
		else
			nx_state <= falha2;
		end if;
	--------------------------
	when falha2 =>
		--saidas
		ab <= '0';
		l1 <= '1';
		l2 <= '1';
		l3 <= '0';

		--proximos estados
		if bt_s = '1' then
			nx_state <= fechado;
		elsif bd_s = '0' then 
			nx_state <= falha2;
		else
			nx_state <= fechado;
		end if;
	end case;
end process;
	
	bt_s <= NOT bt;
end architecture;
-------------------------------------------------------------  