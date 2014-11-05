library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port(
		addr	: in natural range 0 to 255;
		clk		: in std_logic;
		q		: out std_logic_vector(7 downto 0)
	);
	
end entity;

architecture rtl of rom is

	-- Build a 2-D array type for the RoM
	type memory_t is array(7 downto 0) of std_logic_vector(7 downto 0);
		
	-- Declare the ROM signal and specify a default value.	
	signal rom : memory_t := (X"00", X"01", X"02", X"03", X"04", X"05", X"06", X"07" );
	
begin
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			q <= rom(addr);
		end if;
	end process;
		
end rtl;