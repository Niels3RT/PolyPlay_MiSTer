--
-- reworked for PolyPlay by Niels Lueddecke in 2021
--
-- Copyright (c) 2015, $ME
-- All rights reserved.
--
-- Redistribution and use in source and synthezised forms, with or without modification, are permitted 
-- provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice, this list of conditions 
--    and the following disclaimer.
--
-- 2. Redistributions in synthezised form must reproduce the above copyright notice, this list of conditions
--    and the following disclaimer in the documentation and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
-- WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
-- PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR 
-- ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
-- TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
-- POSSIBILITY OF SUCH DAMAGE.
--
--
-- Erzeugung der Takte fuer KC
--   CPU+CTC
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sysclock is
	port (
		clk			: in std_logic;

		cpuClkEn		: out std_logic;	-- 2,4576 MHz
		ctcClk		: out std_logic;	-- cpuClkEn / 4 
		nmi100hz		: out std_logic	-- 100hz from power supply
	);
end sysclock;

architecture rtl of sysclock is

	constant c_DIVIDER		: unsigned(7 downto 0) := x"14";	-- 20
	constant c_FRACT_DIVIER	: unsigned(7 downto 0) := x"03";	-- 3
	
	signal DIVIDER				: unsigned(7 downto 0);
	signal FRACT_DIVIER		: unsigned(7 downto 0);
	
	signal DIVIDER100hz		: unsigned(19 downto 0) := x"7a11f";	-- 499999
	signal divide100			: unsigned(19 downto 0) := (others => '0');

	signal mainDivider		: unsigned(7 downto 0) := (others => '0');
	signal fractDivider		: unsigned(7 downto 0) := (others => '0');
	
	signal mainClkEn			: std_logic;
	
	signal ctcClk_cnt			: unsigned(3 downto 0) := (others => '0');
 
begin
	cpuClkEn <= mainClkEn;

	-- Ziel: 2,4576 MHz
	-- genauer Teiler: 20,34505
	-- 50 MHz durch 20,333333 dividieren
	--  --> 2,459 MHz
	cpuClk : process 
	begin
		wait until rising_edge(clk);

		-- turbo setting
		DIVIDER      <= c_DIVIDER;
		FRACT_DIVIER <= c_FRACT_DIVIER;

		-- for cpu, multiplied by turbo
		if (mainDivider > 0) then
			mainDivider <= mainDivider - 1;
			mainClkEn <= '0';
		else
			if (fractDivider>0) then
				mainDivider <= DIVIDER - 1;
				fractDivider <= fractDivider - 1;
			else
				mainDivider <= DIVIDER;
				fractDivider <= FRACT_DIVIER-1;
			end if;
			mainClkEn <= '1';
			ctcClk <= ctcClk_cnt(1);
			ctcClk_cnt <= ctcClk_cnt + 1;
		end if;
		
		-- 100hz
		nmi100hz <= '1';
		if divide100 > 0 then
			divide100 <= divide100 - 1;
			if divide100 < 10000 then
				nmi100hz <= '0';
			end if;
		else
			divide100 <= DIVIDER100hz;
		end if;
	end process;
    
end;

