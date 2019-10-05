 --------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2019-2020
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity processor is
   port(
      Clk         : in  std_logic; -- Reloj activo en flanco subida
      Reset       : in  std_logic; -- Reset asincrono activo nivel alto
      -- Instruction memory
      IAddr      : out std_logic_vector(31 downto 0); -- Direccion Instr
      IDataIn    : in std_logic_vector(31 downto 0); -- Instruccion leida
      -- Data memory
      DAddr      : out std_logic_vector(31 downto 0); -- Direccion
      DRdEn      : out std_logic;                     -- Habilitacion lectura
      DWrEn      : out std_logic;                     -- Habilitacion escritura
      DDataOut   : out std_logic_vector(31 downto 0); -- Dato escrito
      DDataIn    : in  std_logic_vector(31 downto 0)  -- Dato leido
   );
end processor;

architecture rtl of processor is 

--General signals
signal immEx : std_logic_vector(31 downto 0);
signal PcIn : std_logic_vector(31 downto 0);
signal PcOut : std_logic_vector(31 downto 0);

-- Control Unit Signals
signal Branch : std_logic;
signal MemToReg : std_logic;
signal MemWrite : std_logic;
signal MemRead  : std_logic;
signal ALUSrc : std_logic;
signal ALUOp  : std_logic_vector (2 downto 0);
signal RegWrite : std_logic;
signal RegDst   : std_logic;
signal A3s : std_logic_vector(4 downto 0);
signal Wd3s : std_logic_vector(31 downto 0);

--Alu signals
signal Result : std_logic_vector (31 downto 0);
signal OpA : std_logic_vector (31 downto 0);
signal OpB : std_logic_vector (31 downto 0);
signal ALUControl : std_logic_vector (3 downto 0);
signal Zflag : std_logic;

--Reg-bank signals
signal Rd2s : std_logic_vector(31 downto 0);

component control_unit is
   port (
      -- Entrada = codigo de operacion en la instruccion:
      OpCode  : in  std_logic_vector (5 downto 0);
      -- Seniales para el PC
      Branch : out  std_logic; -- 1 = Ejecutandose instruccion branch
      -- Seniales relativas a la memoria
      MemToReg : out  std_logic; -- 1 = Escribir en registro la salida de la mem.
      MemWrite : out  std_logic; -- Escribir la memoria
      MemRead  : out  std_logic; -- Leer la memoria
      -- Seniales para la ALU
      ALUSrc : out  std_logic;                     -- 0 = oper.B es registro, 1 = es valor inm.
      ALUOp  : out  std_logic_vector (2 downto 0); -- Tipo operacion para control de la ALU
      -- Seniales para el GPR
      RegWrite : out  std_logic; -- 1=Escribir registro
      RegDst   : out  std_logic  -- 0=Reg. destino es rt, 1=rd
      );
end component;

component reg_bank is

   port (
      Clk   : in std_logic; -- Reloj activo en flanco de subida
      Reset : in std_logic; -- Reset asíncrono a nivel alto
      A1    : in std_logic_vector(4 downto 0);   -- Dirección para el puerto Rd1
      Rd1   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd1
      A2    : in std_logic_vector(4 downto 0);   -- Dirección para el puerto Rd2
      Rd2   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd2
      A3    : in std_logic_vector(4 downto 0);   -- Dirección para el puerto Wd3
      Wd3   : in std_logic_vector(31 downto 0);  -- Dato de entrada Wd3
      We3   : in std_logic -- Habilitación de la escritura de Wd3
   ); 

end component;

component alu_control is
   port (
      -- Entradas:
      ALUOp  : in std_logic_vector (2 downto 0); -- Codigo de control desde la unidad de control
      Funct  : in std_logic_vector (5 downto 0); -- Campo "funct" de la instruccion
      -- Salida de control para la ALU:
      ALUControl : out std_logic_vector (3 downto 0) -- Define operacion a ejecutar por la ALU
   );
end component;

component alu is
   port (
      OpA     : in  std_logic_vector (31 downto 0); -- Operando A
      OpB     : in  std_logic_vector (31 downto 0); -- Operando B
      Control : in  std_logic_vector ( 3 downto 0); -- Codigo de control=op. a ejecutar
      Result  : out std_logic_vector (31 downto 0); -- Resultado
      ZFlag   : out std_logic                       -- Flag Z
   );
end component;

begin

   immEx(15 downto 0) <= IDataIn(15 downto 0);
   immEx(31 downto 16) <= (others => IDataIn(15));

   CU : control_unit port map (
      OpCode => IDataIn(31 downto 26),
      Branch => Branch,
      MemToReg => MemToReg,
      MemWrite => MemWrite,
      MemRead => MemRead,
      ALUSrc => ALUSrc,
      ALUOp => ALUOp,
      RegWrite => RegWrite,
      RegDst => RegDst
      );

   RB : reg_bank port map (
      Clk => Clk,
      Reset => Reset,
      A1 => IDataIn(25 downto 21),
      A2 => IDataIn(20 downto 16),
      A3 => A3s,
      Wd3 => Wd3s,
      We3 => RegWrite,
      Rd1 => OpA,
      Rd2 => Rd2s
      );

   ALU_C : alu_control port map (
      Funct => IDataIn(5 downto 0),
      ALUOp => ALUOp,
      ALUControl => ALUControl
      );


   AL : alu port map (
      OpB => OpB,
      OpA => OpA,
      Control => ALUControl,
      Result => Result,
      ZFlag => ZFlag
      );

process(Clk, Reset)
   begin
      if (Reset = '1') then
         PcOut <= (others => '0');
      elsif rising_edge(Clk) then 
      	 PcOut <= PcIn;		     
      end if;

end process;

process(Clk, Branch, ZFlag)
begin

   if ((Branch = '1') and (ZFlag = '1')) then
      PcIn <= PcOut + 4 + (immEx(29 downto 0) & "00");
   else 
      PcIn <= PcOut + 4;
   end if;

end process;

process(Clk, RegDst, IDataIn)
begin
   case RegDst is
      when '0' => A3s <= IDataIn(20 downto 16);
      when '1' => A3s <= IDataIn(15 downto 11);
      when others => A3s <= (others => '0');
   end case;

end process;

process(Clk, MemToReg, Result, DDataIn)
begin
   case MemToReg is
      when '0' => Wd3s <= Result;
      when '1' => Wd3s <= DDataIn;
      when others => Wd3s <= (others => '0');
   end case;

end process;

process(Clk, ALUSrc, Rd2s, immEx)
begin

      case ALUSrc is
         when '0' => OpB <= Rd2s;
         when '1' => OpB <= immEx;
         when others => OpB <= (others => '0');
      end case;

end process;

   DWrEn <= MemWrite;
   DRdEn <= MemRead;
   DDataOut <= Rd2s;
   DAddr <= Result;
   IAddr <= PcOut;
 
end architecture;
