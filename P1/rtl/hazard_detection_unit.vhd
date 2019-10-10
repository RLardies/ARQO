library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity hazard_detection_unit is
	port (
		MemRead_EX : in std_logic;
		Rt_EX : in std_logic_vector(31 downto 0);
		Rt_ID : in std_logic_vector(31 downto 0);
		Rs_ID : in std_logic_vector(31 downto 0);
		PCWrite : out std_logic;
		ID_Write : out std_logic;
		Nop_Signal : out std_logic
	) ;

end hazard_detection_unit;

architecture rtl of hazard_detection_unit is

begin
	process(MemRead_EX,Rt_EX,Rs_ID,Rt_ID)
	begin

		if (MemRead_EX = '1') and ((Rt_EX = Rs_ID) or (Rt_EX = Rt_ID)) then
			Nop_Signal <= '1';
			ID_Write <= '0';
			PCWrite <= '0';
		else
			Nop_Signal <= '0';
			ID_Write <= '1';
			PCWrite <= '1';
		end if;

end  rtl;