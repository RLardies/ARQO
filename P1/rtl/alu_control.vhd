--------------------------------------------------------------------------------
-- Bloque de control para la ALU. Arq0 2019-2020.
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES, Quitar este mensaje)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu_control is
   port (
      -- Entradas:
      ALUOp  : in std_logic_vector (2 downto 0); -- Codigo de control desde la unidad de control
      Funct  : in std_logic_vector (5 downto 0); -- Campo "funct" de la instruccion
      -- Salida de control para la ALU:
      ALUControl : out std_logic_vector (3 downto 0) -- Define operacion a ejecutar por la ALU
   );
end alu_control;

architecture rtl of alu_control is

   -- Tipo para los codigos de control de la ALU:
   subtype t_aluControl is std_logic_vector (3 downto 0);
   subtype t_functControl is std_logic_vector (5 downto 0);

   constant ALU_OR   : t_aluControl := "0111";   
   constant ALU_NOT  : t_aluControl := "0101";
   constant ALU_AND  : t_aluControl := "0100";
   constant ALU_XOR  : t_aluControl := "0110";
   constant ALU_SUB  : t_aluControl := "0001";
   constant ALU_ADD  : t_aluControl := "0000";
   constant ALU_SLT  : t_aluControl := "1010";
   constant ALU_S16  : t_aluControl := "1101";

   constant FUNCT_OR   : t_functControl := "100101";
   constant FUNCT_XOR  : t_functControl := "100110";
   constant FUNCT_AND  : t_functControl := "100100";
   constant FUNCT_SUB  : t_functControl := "100010";
   constant FUNCT_ADD  : t_functControl := "100000";
   constant FUNCT_NOP  : t_functControl := "000000";
   constant FUNCT_SLT  : t_functControl := "101010";

begin
	
   process(Funct, ALUOp)

   begin

      if ALUOp = "000" then
         case Funct is
            when FUNCT_OR => ALUControl <= ALU_OR;
            when FUNCT_XOR => ALUControl <= ALU_XOR;
            when FUNCT_AND => ALUControl <= ALU_AND;
            when FUNCT_SUB => ALUControl <= ALU_SUB;
	         when FUNCT_SLT => ALUControl <= ALU_SLT;
            when FUNCT_ADD | FUNCT_NOP => ALUControl <= ALU_ADD;
	    when others => ALUControl <= (others => '0');
	 end case;

      elsif ALUOp = "001" then
         ALUControl <= ALU_NOT;
      
      elsif ALUOp = "010" then
         ALUControl <= ALU_SLT;

      elsif ALUOp = "011" then
         ALUControl <= ALU_S16;

      elsif ALUOp = "100" then
         ALUControl <= ALU_SUB;

      elsif ALUOp = "101" then
         ALUControl <= ALU_ADD;
       
      end if;  

   end process;

end architecture;
