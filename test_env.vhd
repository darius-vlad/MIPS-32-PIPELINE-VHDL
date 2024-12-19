----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2024 06:22:39 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0); --Nexys
           -- an : out STD_LOGIC_VECTOR (3 downto 0); --Basys
           cat : out STD_LOGIC_VECTOR (6 downto 0));
         
end test_env;

architecture Behavioral of test_env is
component MPG
Port ( en : out  STD_LOGIC; 
input : in STD_LOGIC; 
clock : in  STD_LOGIC); 
end component; 


component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component reg_file
port ( clk : in std_logic;
ra1 : in std_logic_vector(4 downto 0);
ra2 : in std_logic_vector(4 downto 0);
wa : in std_logic_vector(4 downto 0);
wd : in std_logic_vector(31 downto 0);
regwr : in std_logic;
rd1 : out std_logic_vector(31 downto 0);
rd2 : out std_logic_vector(31 downto 0));
end component;

component ram_wr_1st
port ( clk : in std_logic;
we : in std_logic;
en : in std_logic;
addr : in std_logic_vector(5 downto 0);
di : in std_logic_vector(31 downto 0);
do : out std_logic_vector(31 downto 0));
end component;

component IFetch
Port (
  jump: in std_logic;
  jumpAdress: in std_logic_vector(31 downto 0);
  PcSrc: in std_logic;
  BranchAdress: in std_logic_vector(31 downto 0);
  en: in std_logic;
  rst: in std_logic;
  clk : in std_logic;
  instruction: out std_logic_vector(31 downto 0);
  pc_4 : out std_logic_vector(31 downto 0));
   end component;

component ID 
Port(clk : in std_logic;
instr : in std_logic_vector(25 downto 0 );
regwr: in std_logic;
extop: in std_logic;
enable : in std_logic;
rd1 : out std_logic_vector(31 downto 0);
rd2 : out std_logic_vector(31 downto 0);
wd : in std_logic_vector(31 downto 0);
ext_imm : out std_logic_vector(31 downto 0);
func : out std_logic_vector(5 downto 0);
sa : out std_logic_vector(4 downto 0);
write_adress : in std_logic_vector(4 downto 0));
end component;



component EX 
 Port (
 RD1 : in std_logic_vector(31 downto 0);
 ALUSrc : in std_logic;
 RD2: in std_logic_vector(31 downto 0);
 Ext_imm : in std_logic_vector(31 downto 0);
 sa : in std_logic_vector(4 downto 0);
 func : in std_logic_vector(5 downto 0);
 AluOp : in std_logic_vector(1 downto 0);
 PCplus : in std_logic_vector(31 downto 0);
 zero : out std_logic;
 AluRes : out std_logic_vector(31 downto 0);
 BranchAdress: out std_logic_vector(31 downto 0));
end component;

component MEM is
Port (
   MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal cnt: STD_LOGIC_VECTOR(5 downto 0);
signal enable : STD_LOGIC;
signal digits : std_logic_vector(31 downto 0);
signal jump : std_logic;
signal pcsrc : std_logic;
signal mux_sel : std_logic_vector(2 downto 0);
signal jumpAdress  : std_logic_vector(31 downto 0);
signal AluRes :  std_logic_vector(31 downto 0);
signal BranchAdress:  std_logic_vector(31 downto 0);
signal reset : std_logic;
signal instruction: std_logic_vector(31 downto 0);
signal PCplus : std_logic_vector(31 downto 0);
signal regwr: std_logic;
signal regdst : std_logic;
signal extop : std_logic;
signal rd1: std_logic_vector(31 downto 0);
signal rd2: std_logic_Vector(31 downto 0);
signal write_data : std_logic_vector(31 downto 0);
signal ext_imm : std_logic_vector(31 downto 0);
signal fc : std_logic_vector(5 downto 0);
signal sa : std_logic_vector(4 downto 0);
signal alusrc : std_logic;
signal aluop : std_logic_vector(1 downto 0);
signal zero : std_logic;
signal memWrite : std_logic;
signal mem_data : std_logic_vector(31 downto 0);
signal branch : std_logic;
signal bgtz : std_logic;
signal memToReg : std_logic;



--pipeline
signal PC_IF_ID : std_logic_vector(31 downto 0);
signal instruction_IF_ID : std_logic_vector(31 downto 0);


signal PC_ID_EX : std_logic_vector(31 downto 0);
signal RD1_ID_EX : std_logic_vector(31 downto 0);
signal RD2_ID_EX : std_logic_vector(31 downto 0);
signal EXT_IMM_ID_EX : std_logic_vector(31 downto 0);
signal RT_ID_EX : std_logic_vector(4 downto 0);
signal RD_ID_EX : std_logic_vector(4 downto 0);
signal SA_ID_EX : std_logic_vector(4 downto 0);
signal FUNC_ID_EX :  std_logic_vector(5 downto 0);
signal WB_ID_EX : std_logic_vector(1 downto 0);
signal M_ID_EX : std_logic_vector(1 downto 0);
signal EX_ID_EX : std_logic_vector(3 downto 0);


signal WB_EX_MEM : std_logic_vector(1 downto 0);
signal M_EX_MEM  : std_logic_vector(1 downto 0);
signal PC_EX_MEM : std_logic_vector(31 downto 0);
signal ZERO_EX_MEM : std_logic;
signal ALU_OUT_EX_MEM : std_logic_vector(31 downto 0);
signal RD2_EX_MEM : std_logic_vector(31 downto 0);
signal WRITE_ADDRESS_EX_MEM : std_logic_vector(4 downto 0);
signal BRANCH_ADDR_EX_MEM : std_logic_vector(31 downto 0);


signal WB_MEM_WB : std_logic_vector(1 downto 0);
signal READ_DATA_MEM_WB : std_logic_vector(31 downto 0);
signal ALU_OUT_MEM_WB : std_logic_vector(31 downto 0);
signal WRITE_ADDRESS_MEM_WB : std_logic_vector(4 downto 0);
signal MEM_DATA_MEM_WB : std_logic_vector(31 downto 0);


begin
c1 : MPG port map(enable,btn(0),clk);

c2 : SSD port map(clk,digits,an,cat);

C3: IFetch port map(jump , jumpAdress , pcsrc , BRANCH_ADDR_EX_MEM , enable , btn(1) , clk , instruction ,PCplus );

C4: ID port map(clk,instruction_IF_ID(25 downto 0),WB_MEM_WB(1),extop,enable,rd1,rd2,write_data,EXT_IMM ,fc ,SA,WRITE_ADDRESS_MEM_WB);

c5: EX port map(RD1_ID_EX,EX_ID_EX(2),RD2_ID_EX,EXT_IMM_ID_EX,SA_ID_EX,FUNC_ID_EX,EX_ID_EX(1 downto 0),PC_ID_EX,ZERO,ALU_OUT_EX_MEM ,BranchAdress);

C6: MEM port map(M_EX_MEM(0) , ALU_OUT_EX_MEM , RD2_EX_MEM , clk , enable ,MEM_DATA_MEM_WB, ALU_OUT_MEM_WB);

mux_sel <= sw(15) & sw(14) & sw(13);
led <= sw;
 jumpAdress <= PC_IF_ID(31 downto 28) & instruction_IF_ID(25 downto 0) & "00";

process(mux_sel,instruction,PCPlus,RD1_ID_EX,RD2_ID_EX,EXT_IMM_ID_EX)
begin
case mux_sel is
when "000" => digits<= instruction;
when "001" => digits <=PcPlus;
when "010" => digits <=RD1_ID_EX;
when "011" => digits <=RD2_ID_EX;
when "100" => digits <= EXT_IMM_ID_EX;
when "101" => digits <= AluRes ;
when "110" => digits <= mem_data;
when "111" => digits <= write_data;
end case;
end process;

process(instruction_IF_ID)
begin

jump <= '0';
regdst <= '0';
regwr <= '0';
extop <= '0';
alusrc <= '0';
branch <= '0';
bgtz <= '0';
memWrite <= '0';
memToReg <= '0';
aluop <= "00";
case instruction_IF_ID(31 downto 26) is
when "000000" => regdst <= '1';
                 regwr <= '1';
                 extop <= 'X';
                aluop <= "10";
                
when "000001" => extop <= '1';
                 alusrc <= '1';
                 regwr <= '1';
                 aluop <= "00";   
                    
when "000010" => extop <= '1';
                 alusrc <= '1';
                 memToReg <= '1';
                 regwr <= '1';
                 aluop <= "00";
                 
when "000011" => regdst <= 'X';
                 extop <= '1';
                 alusrc <= '1';
                 memWrite <= '1';
                 memToReg <= 'X';
                 aluop <= "00";
                 
when "000100" => regdst <= 'X';
                 extop <= '1';
                 branch <= '1';
                 memToReg <= 'X';
                 aluop <= "01";
                 
when "000101" => alusrc <= '1';
                regwr <= '1';
                extop <= '1';
                regdst <= '1';
                aluop <= "11";
                
when "000110" => regdst <= 'X';
                 extop <= '1';
                 bgtz <= '1';
                 memToReg <= 'X';
                 aluop <= "01";
                 
when "000111" => regdst <= 'X';
                 extop <= 'X';
                 alusrc <= 'X';
                 jump <= '1';
                 memToReg <= 'X';
                 aluop <= "10";
                                                 
 when others => jump <= 'X';
regdst <= 'X';
regwr <= 'X';
extop <= 'X';
alusrc <= 'X';
branch <= 'X';
bgtz <= 'X';
memWrite <= 'X';
memToReg <= 'X';
aluop <= "XX";
 end case;
 end process;


process(WB_MEM_WB(0)) 
begin 
if WB_MEM_WB(0) = '0' then
write_data <= ALU_OUT_MEM_WB ;
else
write_data <= MEM_DATA_MEM_WB ;
end if;
end process;

process(branch , zero)
begin
pcsrc <= M_EX_MEM(1) and ZERO_EX_MEM;
end process;

process(EX_ID_EX ,clk)
begin
if EX_ID_EX(3) = '0' then
WRITE_ADDRESS_EX_MEM <= RT_ID_EX;
else
WRITE_ADDRESS_EX_MEM <= RD_ID_EX;
end if;
end process;

process(clk , enable)
begin 
if rising_edge(clk) then
    if enable = '1' then
    
    --IF_ID
    PC_IF_ID <= PCplus;    
 instruction_IF_ID <= instruction;
 
    --ID_EX
     PC_ID_EX <= PC_IF_ID;
 RD1_ID_EX <= rd1;
 RD2_ID_EX <= rd2;
 SA_ID_EX <= sa;
 RT_ID_EX <= instruction_IF_ID(20 downto 16);
 RD_ID_EX <= instruction_IF_ID(15 downto 11);
 FUNC_ID_EX <= instruction_IF_ID(5 downto 0);
 EXT_IMM_ID_EX <= ext_imm;
 WB_ID_EX(0) <= memToReg;
 WB_ID_EX(1) <= regwr;
 M_ID_EX(0) <= memWrite;
 M_ID_EX(1) <= branch;
 EX_ID_EX(1 downto 0) <= AluOp;
 EX_ID_EX(2) <= AluSrc;
 EX_ID_EX(3) <= regdst;
 
    --EX_MEM
    WB_EX_MEM <= WB_ID_EX;
 M_EX_MEM <= WB_ID_EX;
 PC_EX_MEM <= PC_ID_EX;
 ZERO_EX_MEM <= zero;
 ALU_OUT_EX_MEM <= AluRes;
 RD2_EX_MEM <= RD2_ID_EX;
 
    --MEM_WB
    WB_MEM_WB <= WB_EX_MEM;
 READ_DATA_MEM_WB <= mem_data;
 ALU_OUT_MEM_WB <= ALU_OUT_EX_MEM;
 WRITE_ADDRESS_MEM_WB <= WRITE_ADDRESS_EX_MEM;
 
 end if;
 end if;
 end process;
    


 
 
 
 
end Behavioral;
