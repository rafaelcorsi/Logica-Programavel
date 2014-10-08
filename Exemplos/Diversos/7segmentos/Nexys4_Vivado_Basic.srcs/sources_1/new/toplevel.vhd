------------------------------------------------------------------------------
-- Title      : controlador_7s  
-- Project    : Aula 1
-------------------------------------------------------------------------------
-- File       : toplevel.vhd
-- Author     : Rafael Corsi Ferrao - corsiferrao@gmail.com/ rafael.corsi@maua.br
-- Company    : Instituto Mauá de Tecnologia - NSEE
-- Created    : 29-08-2014
-- Last update: 
-- Platform   : Nexys 4
-- Standard   : VHDL'93/02 
-------------------------------------------------------------------------------
-- Description: Controlador 7 segmentos:
-- 
-- Implementa um controlador para os displays de 7 segementos da placa 
-- onde um valor estático é associado a cada display
--
-- O controlador_7s implementa toda a lógica de chaveamento nos displays
-- já que são catodos comuns.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 02.22.2013  1.0      corsi   Created
-- 03-05-2013           corsi   Comentarios e correção tabela 7s
-------------------------------------------------------------------------------
-- TODO : Fazer um exemplo com um contador
--
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.all; 

entity SS_controller is
    generic(
        fclk    : Natural := 100;   -- Mhz
        f7s     : natural := 100    -- Khz
    );
	port(
	   SW 		: in  STD_LOGIC_VECTOR (15 downto 0);
	   CLK 		: in  STD_LOGIC;
	   LED 		: out  STD_LOGIC_VECTOR (15 downto 0);
	   SSEG_CA 	: out  STD_LOGIC_VECTOR (7 downto 0) := X"00";
	   SSEG_AN 	: out  STD_LOGIC_VECTOR (7 downto 0) := X"00"
	);
end SS_controller;

architecture Behavioral of SS_controller is

    signal s_SSEG_CA : STD_LOGIC_VECTOR (7 downto 0);
    signal s_SSEG_AN : STD_LOGIC_VECTOR (7 downto 0);
    
    component controlador_7s is
    	generic(
    		    CLK_in_f    : natural; --MHz
    		    CLK_7s_f    : natural  -- Hz
    	    );
    	port(
                CLK       : in  STD_LOGIC; --100Mhz
                SSEG_CA   : out STD_LOGIC_VECTOR (7 downto 0);
                SSEG_AN   : out STD_LOGIC_VECTOR (7 downto 0);
                SSEG_1    : in  STD_LOGIC_VECTOR (3 downto 0);
                SSEG_2    : in  STD_LOGIC_VECTOR (3 downto 0);
                SSEG_3    : in  STD_LOGIC_VECTOR (3 downto 0);
                SSEG_4    : in  STD_LOGIC_VECTOR (3 downto 0);
                SSEG_5    : in  STD_LOGIC_VECTOR (3 downto 0);
                SSEG_6    : in  STD_LOGIC_VECTOR (3 downto 0);
                SSEG_7    : in  STD_LOGIC_VECTOR (3 downto 0);
                SSEG_8    : in  STD_LOGIC_VECTOR (3 downto 0)
    	    );
   end component;
   
   
begin

    LED(15 downto 0) <= SW(15 downto 0);
    
    Controlador_1 : controlador_7s
        generic map (CLK_in_f => fclk, CLK_7s_f => 400)
        port map (
		CLK => CLK, SSEG_CA => s_SSEG_CA , SSEG_AN => s_SSEG_AN , 
        	SSEG_1 => X"1", SSEG_2 => x"2" ,
        	SSEG_3 => x"3", SSEG_4 => x"4" ,
        	SSEG_5 => x"5", SSEG_6 => x"6" ,
        	SSEG_7 => x"7", SSEG_8 => x"8"
	);  

    SSEG_CA <= s_SSEG_CA;
    --SSEG_CA <= NOT "00000110";
    SSEG_AN <= s_SSEG_AN;
    
end Behavioral;
