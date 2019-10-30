--------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2019-2020
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity processor_seg is
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
end processor_seg;

architecture rtl of processor_seg is 

--General signals
signal immEx : std_logic_vector(31 downto 0);
signal PcIn : std_logic_vector(31 downto 0);
signal PcOut : std_logic_vector(31 downto 0);

-- Control Unit Signals
signal Branch : std_logic;
signal Jump : std_logic;
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

--Forwarding_unit
signal ForwardA : std_logic_vector(1 downto 0);
signal ForwardB : std_logic_vector(1 downto 0);
signal OpB_FW : std_logic_vector(31 downto 0);

--Hazard_detection_unit

signal PCWrite : std_logic;
signal Nop_ID : std_logic;
signal ID_Write : std_logic;

-- IF signals
signal PCOut_IF : std_logic_vector(31 downto 0);
signal IDataIn_IF : std_logic_vector(31 downto 0);

-- ID signals
signal PCOut_ID : std_logic_vector(31 downto 0);
signal IDataIn_ID : std_logic_vector(31 downto 0);
signal Rd2_ID : std_logic_vector(31 downto 0);
signal Rd1_ID : std_logic_vector(31 downto 0);
signal Branch_ID : std_logic;
signal Jump_ID : std_logic;
signal MemToReg_ID : std_logic;
signal MemWrite_ID : std_logic;
signal MemRead_ID : std_logic;
signal ALUSrc_ID : std_logic;
signal ALUOp_ID : std_logic_vector(2 downto 0);
signal RegWrite_ID : std_logic;
signal RegDst_ID : std_logic;

-- EX signals
signal PcOut_EX : std_logic_vector(31 downto 0);
signal PcIn_EX : std_logic_vector(31 downto 0);
signal Rd1_EX : std_logic_vector(31 downto 0);
signal Rd2_EX : std_logic_vector(31 downto 0);
signal A3_EX : std_logic_vector(4 downto 0);
signal IDataIn_EX : std_logic_vector(31 downto 0);
signal Branch_EX : std_logic;
signal MemToReg_EX : std_logic;
signal MemWrite_EX : std_logic;
signal MemRead_EX : std_logic;
signal ALUSrc_EX : std_logic;
signal ALUOp_EX : std_logic_vector(2 downto 0);
signal RegWrite_EX : std_logic;
signal RegDst_EX : std_logic;
signal Result_EX : std_logic_vector(31 downto 0);
signal ZFlag_EX : std_logic;

-- MEM signals
signal PcIn_MEM : std_logic_vector(31 downto 0);
signal Rd2_MEM : std_logic_vector(31 downto 0);
signal A3_MEM : std_logic_vector(4 downto 0);
signal MemToReg_MEM : std_logic;
signal MemWrite_MEM : std_logic;
signal MemRead_MEM : std_logic;
signal RegWrite_MEM : std_logic;
signal Result_MEM : std_logic_vector(31 downto 0);
signal DDataIn_MEM : std_logic_vector(31 downto 0);

-- WD signals
signal A3_WB : std_logic_vector(4 downto 0);
signal MemToReg_WB : std_logic;
signal RegWrite_WB : std_logic;
signal Result_WB : std_logic_vector(31 downto 0);
signal DDataIn_WB : std_logic_vector(31 downto 0);


component control_unit is
   port (
      -- Entrada = codigo de operacion en la instruccion:
      OpCode  : in  std_logic_vector (5 downto 0);
      -- Seniales para el PC
      Branch : out  std_logic; -- 1 = Ejecutandose instruccion branch
      Jump : out std_logic;
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

component forwarding_unit is
   port(
      ForwardA : out std_logic_vector(1 downto 0);
      ForwardB : out std_logic_vector(1 downto 0);
      Rt_EX : in std_logic_vector(4 downto 0);
      Rs_EX : in std_logic_vector(4 downto 0);
      A3_MEM : in std_logic_vector(4 downto 0);
      A3_WB : in std_logic_vector(31 downto 0)
      RegWrite_MEM : in std_logic;
      RegWrite_WB : in std_logic
      );
end component;

component hazard_detection_unit is
   port(
      MemRead_EX : in std_logic;
      Rt_EX : in std_logic_vector(31 downto 0);
      Rt_ID : in std_logic_vector(31 downto 0);
      Rs_ID : in std_logic_vector(31 downto 0);
      PCWrite : out std_logic;
      ID_Write : out std_logic;
      Nop_ID : out std_logic
      );
end component;

begin

   immEx(15 downto 0) <= IDataIn_EX(15 downto 0);
   immEx(31 downto 16) <= (others => IDataIn_EX(15));

   CU : control_unit port map (
      OpCode => IDataIn_ID(31 downto 26),
      Branch => Branch_ID,
      Jump => Jump_ID,
      MemToReg => MemToReg_ID,
      MemWrite => MemWrite_ID,
      MemRead => MemRead_ID,
      ALUSrc => ALUSrc_ID,
      ALUOp => ALUOp_ID,
      RegWrite => RegWrite_ID,
      RegDst => RegDst_ID
      );

   RB : reg_bank port map (
      Clk => Clk,
      Reset => Reset,
      A1 => IDataIn_ID(25 downto 21),
      A2 => IDataIn_ID(20 downto 16),
      A3 => A3_WB,
      Wd3 => Wd3s,
      We3 => RegWrite_WB,
      Rd1 => Rd1_ID,
      Rd2 => Rd2_ID
      );

   ALU_C : alu_control port map (
      Funct => IDataIn_EX(5 downto 0),
      ALUOp => ALUOp_EX,
      ALUControl => ALUControl
      );

   AL : alu port map (
      OpB => OpB,
      OpA => OpA,
      Control => ALUControl,
      Result => Result_EX,
      ZFlag => ZFlag_EX
      );

   FW : forwarding_unit port map(
      ForwardA => ForwardA,
      ForwardB => ForwardB,
      Rt_EX => IDataIn_EX(20 downto 16),
      Rs_EX => IDataIn_EX(15 downto 11),
      A3_MEM => A3_MEM,
      A3_WB => A3_WB,
      RegWrite_MEM => RegWrite_MEM,
      RegWrite_WB => RegWrite_WB
      );

   HD : hazard_detection_unit port map(
      MemRead_EX => MemRead_EX,
      Rt_EX => Rt_EX,
      Rt_ID => Rt_ID,
      Rs_ID => Rs_ID,
      PCWrite => PCWrite,
      ID_Write => ID_Write,
      Nop_ID => Nop_ID
      );

process(Clk, Reset)
   begin
      if (Reset = '1') then
         PcOut_IF <= (others => '0');
         -- Falta resetear los registros
         IDataIn_ID <= (others => '0');
         PcOut_ID <= (others => '0');

         Rd1_EX <= (others => '0');
         Rd2_EX <= (others => '0');
         IDataIn_EX <= (others => '0');
         PcOut_EX <= (others => '0');
         Branch_EX <= '0';
         ALUSrc_EX <= '0';
         MemWrite_EX <= '0';
         MemRead_EX <= '0';
         MemToReg_EX <= '0';
         RegWrite_EX <= '0';

         MemToReg_MEM <= '0';
         PcIn_MEM <= (others => '0');
         Rd2_MEM <= (others => '0');
         MemRead_MEM <= '0';
         MemWrite_MEM <= '0';
         RegWrite_MEM <= '0';
         Result_MEM <= (others => '0');
         A3_MEM <= (others => '0');

         MemToReg_WB <= '0';
         RegWrite_WB <= '0';
         Result_WB <= (others => '0');
         A3_WB <= (others => '0');
         DDataIn_WB <= (others => '0');

      elsif rising_edge(Clk) then
        -- MEM -> WB
         MemToReg_WB <= MemToReg_MEM;
         RegWrite_WB <= RegWrite_MEM;
         Result_WB <= Result_MEM;
         A3_WB <= A3_MEM;
         DDataIn_WB <= DDataIn_MEM;
         -- EX -> MEM
         PcIn_MEM <= PcIn_EX;
         Rd2_MEM <= Rd2_EX;
         MemWrite_MEM <= MemWrite_EX;
         MemRead_MEM <= MemRead_EX;
         MemToReg_MEM <= MemToReg_EX;
         RegWrite_MEM <= RegWrite_EX;
         Result_MEM <= Result_EX;
         A3_MEM <= A3_EX;
         -- ID -> EX

         PcOut_EX <= PcOut_ID;
         Rd1_EX <= Rd1_ID;
         Rd2_EX <= Rd2_ID;
         DataIn_EX <= IDataIn_ID;

         if Nop_ID = '0' then
            ALUSrc_EX <= ALUSrc_ID;
            ALUOp_EX <= ALUOp_ID;
            RegDst_EX <= RegDst_ID;
            Branch_EX <= Branch_ID;
            MemWrite_EX <= MemWrite_ID;
            MemRead_EX <= MemRead_ID;
            MemToReg_EX <= MemToReg_ID;
            RegWrite_EX <= RegWrite_ID;

         else
            ALUSrc_EX <= '0';
            ALUOp_EX <= '0';
            RegDst_EX <= '0';
            Branch_EX <= '0';
            MemWrite_EX <= '0';
            MemRead_EX <= '0';
            MemToReg_EX <= '0';
            RegWrite_EX <= '0';
         end if;

         -- IF -> ID

         if ID_Write = '1' then
            PcOut_ID <= PcOut_IF;
            IDataIn_ID <= IDataIn_IF;
         end if;

         PcOut_IF <= PcIn; 

      end if;

end process;

process(Clk, Branch_EX, ZFlag_EX)
begin

   if PCWrite = '1' then

      if Branch_EX AND ZFlag_EX then
         PcIn <= PcIn_EX;
      elsif (Jump_ID = '1') then
         PcIn <= PcOut_ID(31 downto 28) & (IDataIn_ID(25 downto 0) & "00");
      else
         PcIn <= PcOut_IF + 4;
      end if;
   end if;

end process;

process(Clk, PCOut_EX, immEx)
begin
   PcIn_EX <= PcOut_EX + 4 + (immEx(29 downto 0) & "00");

end process;

process(Clk, RegDst_EX, IDataIn_EX)
begin
   case RegDst_EX is
      when '0' => A3_EX <= IDataIn_EX(20 downto 16);
      when '1' => A3_EX <= IDataIn_EX(15 downto 11);
      when others => A3_EX <= (others => '0');
   end case;

end process;

process(Clk, MemToReg_WB, Result_WB, DDataIn_WB)
begin
   case MemToReg_WB is
      when '0' => Wd3s <= Result_WB;
      when '1' => Wd3s <= DDataIn_WB;
      when others => Wd3s <= (others => '0');
   end case;

end process;

process(Clk, ALUSrc_EX, Rd2_EX, immEx)
begin

      case ALUSrc_EX is
         when '0' => OpB <= OpB_FW;
         when '1' => OpB <= immEx;
         when others => OpB <= (others => '0');
      end case;

end process;

process(Clk,ForwardA,Result_MEM,Result_WB,Rd1_EX)
   begin
      case ForwardA is
         when '10' => OpA <= Result_MEM;
         when '01' => OpA <= Result_WB;
         when others => OpA <= Rd1_EX;
      end case;
   end process;

process(Clk, ForwardB,Result_MEM,Result_WB,Rd2_EX)
   begin
      case ForwardB is
         when '10' => OpB_FW <= Result_MEM;
         when '01' => OpB_FW <= Result_WB;
         when others => OpB_FW <= Rd2_EX;
      end case;
   end process;


   DWrEn <= MemWrite_MEM;
   DRdEn <= MemRead_MEM;
   DDataOut <= Rd2_MEM;
   DDataIn_MEM <= DDataIn;
   DAddr <= Result_MEM;
   IAddr <= PcOut_IF;
   IDataIn_IF <= IDataIn;
 
end architecture;