------------------------------------------------------------------------------
-- Title      : controlador_7s  
-- Project    : Aula 1
-------------------------------------------------------------------------------
-- File       : controlador_7s.vhd
-- Author     : Rafael Corsi Ferrao - corsiferrao@gmail.com/ rafael.corsi@maua.br
-- Company    : Instituto Mauá de Tecnologia - NSEE
-- Created    : 02-22-2013
-- Last update: 03-05-2013
-- Platform   : 
-- Standard   : VHDL'93/02 
-------------------------------------------------------------------------------
-- Description: Controlador 7 segmentos:
--
-- Nomenclatura: 
--   o cnt_ = Contador
--   o pnt_ = Ponteiro
--   o XXX_ : Capslock = Constante
--
--
-- Os displays de 7 segmentos aqui utilizados, possuem em comum os Catodos (CA)
-- e independentes os Anodos (AN) como mostrado na pg. 18 do documento: 
-- Nexys4TM FPGA Board Reference Manual 
-- Ambos CA e AN são acionados por transistors NPN em lógica  
--
-- Esse modulo descreve um controlador para oito displays de 7 segments 
-- utilizando um contador de clock para realizar o sincronismo da mudança
-- dos valores mostrados nos displas.
-- 
-- -> Conta até cnt_max -> pnt_CA++ ->      SSEG_CA <= look-up-table(SSEG_x)
-- ^_________________________________|	    SSEG_AN <= 0xFE << pnt_CA
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 02.22.2013  1.0      corsi   Created
-- 03-05-2013           corsi   Comentarios e correção tabela 7s
-------------------------------------------------------------------------------
-- TODO : Corrigir problema com número 2
--
------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity controlador_7s is
	generic(
		    CLK_in_f    : natural := 100; -- Frequência do clk em MHz
		    CLK_7s_f    : natural := 100  -- Frequência da atualização 7s em Hz
	    );
	port(
		    CLK 	    : in  STD_LOGIC; --100Mhz
		    SSEG_CA 	: out STD_LOGIC_VECTOR (7 downto 0) := X"00";
		    SSEG_AN 	: out STD_LOGIC_VECTOR (7 downto 0) := X"00";
		    SSEG_1	    : in  STD_LOGIC_VECTOR (3 downto 0);
		    SSEG_2	    : in  STD_LOGIC_VECTOR (3 downto 0);
		    SSEG_3	    : in  STD_LOGIC_VECTOR (3 downto 0);
		    SSEG_4	    : in  STD_LOGIC_VECTOR (3 downto 0);
		    SSEG_5	    : in  STD_LOGIC_VECTOR (3 downto 0);
		    SSEG_6	    : in  STD_LOGIC_VECTOR (3 downto 0);
		    SSEG_7	    : in  STD_LOGIC_VECTOR (3 downto 0);
		    SSEG_8	    : in  STD_LOGIC_VECTOR (3 downto 0)
	 );
end controlador_7s;

architecture Behavioral of controlador_7s is

    -- Utiliza-se de uma tabela gravada em uma memória como look-up-table 
    -- Defini memória com n= 15 elementos e tamanho de 8 bits
    type mem is array ( 0 to 2**4 - 1) of std_logic_vector(7 downto 0);
    -- Inicializa memoria com a tabela de converção Hex -> 7s
    constant tabela_7s : mem := 
    (
        0  => "00111111",  -- 0
        1  => "00000110",  -- 1
        2  => "01011101",  -- 2
        3  => "01001111",  -- 3
        4  => "01100110",  -- 4
        5  => "01101101",  -- 5
        6  => "01111101",  -- 6
        7  => "00000111",  -- 7
        8  => "01111111",  -- 8
        9  => "01110011",  -- 9
        10 => "01000111",  -- A
        11 => "01111100",  -- B
        12 => "01111001",  -- C
        13 => "00111110",  -- D
        14 => "01111001",  -- E
        15 => "01100001"   -- F
    );  
    
    -- Valor máximo que contador deve atingir antes de alterar
    -- o valor mostrado, esse é o tempo em que cada display fica
    -- aceso  
    constant MAX_CNT : natural := (CLK_in_f*1_000_000/CLK_7s_f);
    
    -- Sinal utilziado para armazenar o contador do clock
    signal   cnt_clk : natural range 0 to (MAX_CNT + 1) := 0;

    -- Sinal utilizado para indicar qual 7s é o da vez
    signal pnt_CA : natural range 0 to 7 := 0 ;
   
    -- Sinal utilizado para armazenar valor em Hex do 7s da vez
    signal pnt_LT : std_logic_Vector(3 downto 0);
   
    -- Sinal utilziado para mudança de variavel
    -- TODO : Remover
    signal shf_dis_AN : unsigned(7 downto 0);

begin

----------------------------------------------------------
------                Controle de clock            -------
----------------------------------------------------------
-- Devemos diminuir a frequência do clock para algo entre
-- 60 e 300 Hz, para tanto, utilizamos um contador que 
-- conta entre 0 e o valor máximo (cnt_max). Quando o valor
-- máximo é atingido, incrementa-se o ponteiro do Catatodo
-- (pnt_CA) e zera-se o valor do contador
----------------------------------------------------------

	clk_contador : process(CLK)
	begin
		if (rising_edge(CLK)) then
			if(cnt_clk >= MAX_CNT) then
				cnt_clk <= 0;				
				if 	pnt_CA < 7 then
				    pnt_CA <= pnt_CA + 1;
				else
				    pnt_CA <= 0;
				end if;		
			else
			     cnt_clk <= cnt_clk + 1;
			end if;
		end if;	
	end process;

----------------------------------------------------------
------           7-Seg Display Control             -------
----------------------------------------------------------

   -- Atualiza pnt_LT com o valor a ser mostrado
   with pnt_CA select
          pnt_LT <= SSEG_1 when 0,
                    SSEG_2 when 1,
                    SSEG_3 when 2,
                    SSEG_4 when 3,
                    SSEG_5 when 4,
                    SSEG_6 when 5,
                    SSEG_7 when 6,
                    SSEG_8 when 7,
                    (others => '1') when others;
			
    -- Utiliza o valor do pnt_LT como input para a look-up-table
    -- de converção Hex -> 7s
    SSEG_CA <= NOT tabela_7s(CONV_INTEGER(pnt_LT));

    -- Utiliza o valor do pnt_CA como index de rotacionamento, criando
    -- a seguinte ordem
    -- 0000001
    -- 0000010
    -- 0000100
    -- Onde somente um display é acionado por vez
    shf_dis_AN <= NOT shift_left(to_unsigned(1,8), pnt_CA);  
    SSEG_AN <= std_logic_vector(shf_dis_AN);
    
end Behavioral;
