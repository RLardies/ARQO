library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity hazard_detection_unit is
	port (
		MemRead_EX : in std_logic;
		Branch_AND : in std_logic;
		Rt_EX : in std_logic_vector(31 downto 0);
		Rt_ID : in std_logic_vector(31 downto 0);
		Rs_ID : in std_logic_vector(31 downto 0);
		PCWrite : out std_logic;
		ID_Write : out std_logic;
		Nop_ID : out std_logic;
		Nop_IF : out std_logic
	) ;

end hazard_detection_unit;

architecture rtl of hazard_detection_unit is

begin
	process(MemRead_EX,Rt_EX,Rs_ID,Rt_ID)
	begin

		if (MemRead_EX = '1') and ((Rt_EX = Rs_ID) or (Rt_EX = Rt_ID)) then
			Nop_ID <= '1';
			Nop_IF <= '0';
			ID_Write <= '0';
			PCWrite <= '0';
		elsif(Branch_AND = '1') then
			Nop_ID <= '1';
			Nop_IF <= '1';
			PCWrite <= '1';
			ID_Write <= '1';
		else
			Nop_ID <= '0';
			Nop_IF <= '0';
			PCWrite <= '1';
			ID_Write <= '1';
		end if;

	end process;

end  rtl;