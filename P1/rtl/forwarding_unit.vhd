 --------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2019-2020
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity forwarding_unit is
   port (
      ForwardA : out std_logic_vector(1 downto 0);
      ForwardB : out std_logic_vector(1 downto 0);
      Rt_EX : in std_logic_vector(4 downto 0);
      Rs_EX : in std_logic_vector(4 downto 0);
      A3_MEM : in std_logic_vector(4 downto 0);
      A3_WB : in std_logic_vector(4 downto 0);
      RegWrite_MEM : in std_logic;
      RegWrite_WB : in std_logic
   ) ;
end forwarding_unit;

architecture rtl of forwarding_unit is

begin

   process(A3_MEM, RegWrite_MEM,Rs_EX,Rt_EX)
   begin
      if RegWrite_MEM = '1' and (A3_MEM /= "00000") and (A3_MEM = Rs_EX) then
         ForwardA <= "10";
      elsif RegWrite_WB = '1' and (A3_WB /= "00000") and (A3_WB = Rs_EX) then
         ForwardA <= "01";
      else 
         ForwardA <= "00";
      end if;

      if RegWrite_MEM = '1' and (A3_MEM /= "00000") and (A3_MEM = Rt_EX) then
         ForwardB <= "10";
      elsif RegWrite_WB = '1' and (A3_WB /= "00000") and (A3_WB = Rt_EX) then
         ForwardB <= "01"; 
      else
         ForwardB <= "00";
      end if;

   end process;

end rtl;