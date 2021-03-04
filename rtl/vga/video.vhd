--
-- modified for PolyPlay by Niels Lueddecke in 2021
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
-- kc87 video controller
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity video is
    generic (
		-- clock: 8.xy MHz
		H_DISP				: integer := 512;
		H_SYNC_START		: integer := 512+10;
		H_SYNC_END			: integer := 512+10+20;
		H_VID_END			: integer := 512+10+20+25;
		H_SYNC_ACTIVE		: std_logic := '1';
		H_BLANK_ACTIVE		: std_logic := '1';

		V_DISP				: integer := 256;
		V_SYNC_START		: integer := 256+7;
		V_SYNC_END			: integer := 256+7+14;
		V_VID_END			: integer := 256+7+14+36;
		V_SYNC_ACTIVE		: std_logic := '1';
		V_BLANK_ACTIVE		: std_logic := '1';

		CHAR_X_SIZE			: integer := 8;
		CHAR_Y_SIZE			: integer := 8;
		CHAR_PER_LINE		: integer := 64;

		SYNC_DELAY			: integer := 3
		);
	port (
		clk				: in  std_logic;
		cpuclk			: in  std_logic;

		red				: out std_logic_vector(7 downto 0);
		green				: out std_logic_vector(7 downto 0);
		blue				: out std_logic_vector(7 downto 0);
		hsync				: out std_logic;
		vsync				: out std_logic;
		hblank			: out std_logic;
		vblank			: out std_logic;
		
		cg_ram_Addr		: out std_logic_vector(9 downto 0);
		cg_ram_Dataa	: in  std_logic_vector(7 downto 0);
		cg_ram_Datab	: in  std_logic_vector(7 downto 0);
		cg_ram_Datac	: in  std_logic_vector(7 downto 0);
		vid_ram_Addr	: out std_logic_vector(10 downto 0);
		vid_ram_Data	: in  std_logic_vector(7 downto 0);
		
		dn_addr			: in std_logic_vector(15 downto 0);
		dn_data			: in std_logic_vector(7 downto 0);
		dn_wr				: in std_logic;
		tno				: in std_logic_vector(7 downto 0)
	); 
end video;

architecture rtl of video is

	signal countH			: integer range 0 to H_VID_END-1 := 0;
	signal countV			: integer range 0 to V_VID_END-1 := 0;
	signal display			: boolean;

	signal cg_rom_Addr	: std_logic_vector(9 downto 0);
	signal cg_rom_Data	: std_logic_vector(7 downto 0);
	signal cg_rom_cs		: std_logic;

	signal outputa			: std_logic_vector(7 downto 0);
	signal outputb			: std_logic_vector(7 downto 0);
	signal outputc			: std_logic_vector(7 downto 0);
    
	signal vSyncDelay		: std_logic_vector(SYNC_DELAY-1 downto 0) := (others => not(V_SYNC_ACTIVE));
	
begin
	vsync <= vSyncDelay(SYNC_DELAY-1);

	cg_ram_Addr <= vid_ram_Data(6 downto 0) & std_logic_vector(to_unsigned(countV, 3));
	cg_rom_Addr <= vid_ram_Data(6 downto 0) & std_logic_vector(to_unsigned(countV, 3));
	vid_ram_Addr <= std_logic_vector(to_unsigned(countH/CHAR_X_SIZE + countV/CHAR_Y_SIZE * CHAR_PER_LINE, 11));
 
	-- timing
	process
	begin 
		wait until rising_edge(clk);

		if (countH < H_VID_END-1) then
			countH <= countH + 1;

			if ((countH mod CHAR_X_SIZE) = 2) then
				if vid_ram_Data(7) = '0' then
					outputa <= cg_rom_Data;
					outputb <= cg_rom_Data;
					outputc <= cg_rom_Data;
				else
					outputa <= cg_ram_Dataa;
					outputb <= cg_ram_Datab;
					outputc <= cg_ram_Datac;
				end if;
			elsif ((countH mod (CHAR_X_SIZE/8)) = 0) then
				outputa <= outputa(6 downto 0) & "0";
				outputb <= outputb(6 downto 0) & "0";
				outputc <= outputc(6 downto 0) & "0";
			end if;
		else
			countH <= 0;

			if (countV < V_VID_END-1) then
				countV <= countV + 1;
			else
				countV <= 0;
			end if;
		end if;
	end process;
  
	-- sync+blanking
	process 
	begin
		wait until rising_edge(clk);

		display <= false;
		if (countV < V_DISP) and (countH >= SYNC_DELAY-1) and (countH < H_DISP+SYNC_DELAY-1) then
			display <= true;
		end if;

		-- sync
		hsync <= not(H_SYNC_ACTIVE);
		if (countH >= H_SYNC_START+SYNC_DELAY-1) and (countH <= H_SYNC_END+SYNC_DELAY-1) then 
			hsync <= H_SYNC_ACTIVE;
		end if;

		vSyncDelay(0) <= not(V_SYNC_ACTIVE);
		if (countV >= V_SYNC_START) and (countV <= V_SYNC_END) then
			vSyncDelay(0) <= V_SYNC_ACTIVE;
		end if;

		-- blank
		hblank <= not(H_BLANK_ACTIVE);
		if (countH >= H_DISP + SYNC_DELAY-1) or (countH < SYNC_DELAY-1) then 
			hblank <= H_BLANK_ACTIVE;
		end if;

		vblank <= not(V_BLANK_ACTIVE);
		if (countV >= V_DISP) then 
			vblank <= V_BLANK_ACTIVE;
		end if;

		vSyncDelay(SYNC_DELAY-1 downto 1) <= vSyncDelay(SYNC_DELAY-2 downto 0);
	end process;
 
	-- color+output
	process (display, outputa, outputb, outputc, countV)
	begin
		if display then
			red   <= (others => outputc(7));
			green <= (others => outputb(7));
			blue  <= (others => outputa(7));
		else
			red   <= (others => '0');
			green <= (others => '0');
			blue  <= (others => '0');
		end if;
	end process;
 
	-- character rom, e800h - ebffh, 1k
	cg_rom_cs <= '0' when dn_addr(15 downto 10) = b"000000" and tno = x"00" else	-- polyplay
					 '0' when dn_addr(15 downto 10) = b"110000" and tno = x"01" else	-- polyplay 2
					 '1';
	rom_char : entity work.dualsram
		generic map (
			AddrWidth => 10
		)
		port map (
			clk1  => clk,
			addr1 => cg_rom_Addr(9 downto 0),
			din1  => x"00",
			dout1 => cg_rom_Data,
			cs1_n => '0', 
			wr1_n => '1',

			clk2  => cpuclk,
			addr2 => dn_addr(9 downto 0),
			din2  => dn_data,
			dout2 => open,
			cs2_n => cg_rom_cs,
			wr2_n => not dn_wr
		);
end rtl;
