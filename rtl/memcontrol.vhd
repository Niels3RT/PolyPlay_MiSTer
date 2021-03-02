--
-- complete rewrite by Niels Lueddecke in 2021
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
-- Speicher-Controller fuer KC85/4
--   fuer SRAM mit 256kx16
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memcontrol is
	port (
	clk				: in  std_logic;
	vgaclk			: in  std_logic;
	reset_n			: in  std_logic;

	cpuAddr			: in  std_logic_vector(15 downto 0);
	cpuDOut			: out std_logic_vector(7 downto 0);
	cpuDIn			: in  std_logic_vector(7 downto 0);

	cpuWR_n			: in  std_logic;
	cpuRD_n			: in  std_logic;
	cpuM1_n			: in  std_logic;
	cpuMREQ_n		: in  std_logic;
	cpuIORQ_n		: in  std_logic;

	cpuEn				: out std_logic;
	cpuWait			: out std_logic;

	cpuTick			: in  std_logic;

	cg_ram_Addr		: in  std_logic_vector(9 downto 0);
	cg_ram_Dataa	: out std_logic_vector(7 downto 0);
	cg_ram_Datab	: out std_logic_vector(7 downto 0);
	cg_ram_Datac	: out std_logic_vector(7 downto 0);
	vid_ram_Addr	: in  std_logic_vector(10 downto 0);
	vid_ram_Data	: out std_logic_vector(7 downto 0)
		
	);
end memcontrol;

architecture rtl of memcontrol is
	type   state_type is ( idle, idle_wait, do_idle, read_wait, do_read, write_wait, do_write, finish );
	signal mem_state    		: state_type := idle;
	
	signal tmp_adr				: std_logic_vector(15 downto 0);
	signal tmp_data_in		: std_logic_vector(7 downto 0);

	-- video read stuff
	signal vid_state			: std_logic_vector(1 downto 0) := (others => '0');
	signal vid_adr_old		: std_logic_vector(13 downto 0) := (others => '1');
	
	-- work ram
	signal ram_work_do		: std_logic_vector(7 downto 0);
	signal ram_work_we_n		: std_logic;
	
	-- char ram
	signal ram_char_do_1a	: std_logic_vector(7 downto 0);
	signal ram_char_we_n_1a	: std_logic;
	signal ram_char_do_1b	: std_logic_vector(7 downto 0);
	signal ram_char_we_n_1b	: std_logic;
	signal ram_char_do_1c	: std_logic_vector(7 downto 0);
	signal ram_char_we_n_1c	: std_logic;
	
	-- video ram
	signal ram_vid_do_1		: std_logic_vector(7 downto 0);
	signal ram_vid_we_n_1	: std_logic;
	--signal ram_vid_do_2		: std_logic_vector(7 downto 0);
	
	-- roms
	signal rom_zre_00_dat	: std_logic_vector(7 downto 0);
	signal rom_zre_04_dat	: std_logic_vector(7 downto 0);
	signal rom_zre_08_dat	: std_logic_vector(7 downto 0);
	signal rom_char1_e8_dat	: std_logic_vector(7 downto 0);
	signal rom_10_dat			: std_logic_vector(7 downto 0);
	signal rom_14_dat			: std_logic_vector(7 downto 0);
	signal rom_18_dat			: std_logic_vector(7 downto 0);
	signal rom_1c_dat			: std_logic_vector(7 downto 0);
	signal rom_20_dat			: std_logic_vector(7 downto 0);
	signal rom_24_dat			: std_logic_vector(7 downto 0);
	signal rom_28_dat			: std_logic_vector(7 downto 0);
	signal rom_2c_dat			: std_logic_vector(7 downto 0);
	signal rom_30_dat			: std_logic_vector(7 downto 0);
	signal rom_34_dat			: std_logic_vector(7 downto 0);
	signal rom_38_dat			: std_logic_vector(7 downto 0);
	signal rom_3c_dat			: std_logic_vector(7 downto 0);
	signal rom_40_dat			: std_logic_vector(7 downto 0);
	signal rom_44_dat			: std_logic_vector(7 downto 0);
	signal rom_48_dat			: std_logic_vector(7 downto 0);
	signal rom_4c_dat			: std_logic_vector(7 downto 0);
	signal rom_50_dat			: std_logic_vector(7 downto 0);
	signal rom_54_dat			: std_logic_vector(7 downto 0);
	signal rom_58_dat			: std_logic_vector(7 downto 0);
	signal rom_5c_dat			: std_logic_vector(7 downto 0);
	signal rom_60_dat			: std_logic_vector(7 downto 0);
	signal rom_64_dat			: std_logic_vector(7 downto 0);
	signal rom_68_dat			: std_logic_vector(7 downto 0);
	signal rom_6c_dat			: std_logic_vector(7 downto 0);
	signal rom_70_dat			: std_logic_vector(7 downto 0);
	signal rom_74_dat			: std_logic_vector(7 downto 0);
	signal rom_78_dat			: std_logic_vector(7 downto 0);
	signal rom_7c_dat			: std_logic_vector(7 downto 0);
	signal rom_80_dat			: std_logic_vector(7 downto 0);
	signal rom_84_dat			: std_logic_vector(7 downto 0);
	signal rom_88_dat			: std_logic_vector(7 downto 0);
	signal rom_8c_dat			: std_logic_vector(7 downto 0);

begin
	
	-- serve cpu
	cpuserv : process
	begin
		wait until rising_edge(clk);
		
		cpuWait	<= '1';
		cpuEn		<= '0';
		
		if reset_n = '0' then
			mem_state <= idle;
		end if;
		
		-- memory state machine
		case mem_state is
			when idle =>
				if (reset_n='0') then
					--cpuDOut <= romE_caos_data;	-- ROM CAOS E reset vector
				elsif cpuTick = '1' then
					mem_state <= idle_wait;
					-- write memory
					if		(cpuMREQ_n = '0' and cpuWR_n = '0') then
						mem_state <= write_wait;
						if		cpuAddr(15 downto 8) < x"10" then ram_work_we_n    <= '0';	-- work ram
						elsif	cpuAddr(15 downto 8) < x"f0" then ram_char_we_n_1a <= '0';	-- character ram a
						elsif	cpuAddr(15 downto 8) < x"f4" then ram_char_we_n_1b <= '0';	-- character ram b
						elsif	cpuAddr(15 downto 8) < x"f8" then ram_char_we_n_1c <= '0';	-- character ram c
						else												 ram_vid_we_n_1   <= '0';	-- video ram
						end if;
					-- read memory
					elsif (cpuMREQ_n='0' and cpuRD_n='0') then
						mem_state <= read_wait;
					end if;
				end if;
			when read_wait =>
				mem_state <= do_read;
			when do_read =>
				mem_state <= finish;
				-- decide which DO to send to cpu
				if		cpuAddr(15 downto 8) < x"04" then cpuDOut <= rom_zre_00_dat;	-- OS ROM                         (0000 - 03ff)
				elsif	cpuAddr(15 downto 8) < x"08" then cpuDOut <= rom_zre_04_dat;	-- Game ROM used for Abfahrtslauf (0400 - 07ff)
				elsif	cpuAddr(15 downto 8) < x"0c" then cpuDOut <= rom_zre_08_dat;	-- Menu Screen ROM                (0800 - 0bff)
				elsif	cpuAddr(15 downto 8) < x"10" then cpuDOut <= ram_work_do;		-- Work RAM                       (0c00 - 0fff)
				elsif	cpuAddr(15 downto 8) < x"14" then cpuDOut <= rom_10_dat;			-- Abfahrtslauf                   (1000 - 1bff)
				elsif	cpuAddr(15 downto 8) < x"18" then cpuDOut <= rom_14_dat;			-- Abfahrtslauf                   (1000 - 1bff)
				elsif	cpuAddr(15 downto 8) < x"1c" then cpuDOut <= rom_18_dat;			-- Abfahrtslauf                   (1000 - 1bff)
				elsif	cpuAddr(15 downto 8) < x"20" then cpuDOut <= rom_1c_dat;			-- Hirschjagd                     (1c00 - 27ff)
				elsif	cpuAddr(15 downto 8) < x"24" then cpuDOut <= rom_20_dat;			-- Hirschjagd                     (1c00 - 27ff)
				elsif	cpuAddr(15 downto 8) < x"28" then cpuDOut <= rom_24_dat;			-- Hirschjagd                     (1c00 - 27ff)
				elsif	cpuAddr(15 downto 8) < x"2c" then cpuDOut <= rom_28_dat;			-- Hase und Wolf                  (2800 - 3fff)
				elsif	cpuAddr(15 downto 8) < x"30" then cpuDOut <= rom_2c_dat;			-- Hase und Wolf                  (2800 - 3fff)
				elsif	cpuAddr(15 downto 8) < x"34" then cpuDOut <= rom_30_dat;			-- Hase und Wolf                  (2800 - 3fff)
				elsif	cpuAddr(15 downto 8) < x"38" then cpuDOut <= rom_34_dat;			-- Hase und Wolf                  (2800 - 3fff)
				elsif	cpuAddr(15 downto 8) < x"3c" then cpuDOut <= rom_38_dat;			-- Hase und Wolf                  (2800 - 3fff)
				elsif	cpuAddr(15 downto 8) < x"40" then cpuDOut <= rom_3c_dat;			-- Hase und Wolf                  (2800 - 3fff)
				elsif	cpuAddr(15 downto 8) < x"44" then cpuDOut <= rom_40_dat;			-- Schmetterlingsfang             (4000 - 4fff)
				elsif	cpuAddr(15 downto 8) < x"48" then cpuDOut <= rom_44_dat;			-- Schmetterlingsfang             (4000 - 4fff)
				elsif	cpuAddr(15 downto 8) < x"4c" then cpuDOut <= rom_48_dat;			-- Schmetterlingsfang             (4000 - 4fff)
				elsif	cpuAddr(15 downto 8) < x"50" then cpuDOut <= rom_4c_dat;			-- Schmetterlingsfang             (4000 - 4fff)
				elsif	cpuAddr(15 downto 8) < x"54" then cpuDOut <= rom_50_dat;			-- Schiessbude                    (5000 - 5fff)
				elsif	cpuAddr(15 downto 8) < x"58" then cpuDOut <= rom_54_dat;			-- Schiessbude                    (5000 - 5fff)
				elsif	cpuAddr(15 downto 8) < x"5c" then cpuDOut <= rom_58_dat;			-- Schiessbude                    (5000 - 5fff)
				elsif	cpuAddr(15 downto 8) < x"60" then cpuDOut <= rom_5c_dat;			-- Schiessbude                    (5000 - 5fff)
				elsif	cpuAddr(15 downto 8) < x"64" then cpuDOut <= rom_60_dat;			-- Autorennen                     (6000 - 73ff)
				elsif	cpuAddr(15 downto 8) < x"68" then cpuDOut <= rom_64_dat;			-- Autorennen                     (6000 - 73ff)
				elsif	cpuAddr(15 downto 8) < x"6c" then cpuDOut <= rom_68_dat;			-- Autorennen                     (6000 - 73ff)
				elsif	cpuAddr(15 downto 8) < x"70" then cpuDOut <= rom_6c_dat;			-- Autorennen                     (6000 - 73ff)
				elsif	cpuAddr(15 downto 8) < x"74" then cpuDOut <= rom_70_dat;			-- Autorennen                     (6000 - 73ff)
				elsif	cpuAddr(15 downto 8) < x"78" then cpuDOut <= rom_74_dat;			-- opto-akust. Merkspiel          (7400 - 7fff)
				elsif	cpuAddr(15 downto 8) < x"7c" then cpuDOut <= rom_78_dat;			-- opto-akust. Merkspiel          (7400 - 7fff)
				elsif	cpuAddr(15 downto 8) < x"80" then cpuDOut <= rom_7c_dat;			-- opto-akust. Merkspiel          (7400 - 7fff)
				elsif	cpuAddr(15 downto 8) < x"84" then cpuDOut <= rom_80_dat;			-- Wasserrohrbruch                (8000 - 8fff)
				elsif	cpuAddr(15 downto 8) < x"88" then cpuDOut <= rom_84_dat;			-- Wasserrohrbruch                (8000 - 8fff)
				elsif	cpuAddr(15 downto 8) < x"8c" then cpuDOut <= rom_88_dat;			-- Wasserrohrbruch                (8000 - 8fff)
				elsif	cpuAddr(15 downto 8) < x"90" then cpuDOut <= rom_8c_dat;			-- Wasserrohrbruch                (8000 - 8fff)
				
				elsif	cpuAddr(15 downto 8) < x"ec" then cpuDOut <= rom_char1_e8_dat;	-- e800 - ebff ABS   Character ROM (chr 00..7f) 1 bit per pixel
				elsif	cpuAddr(15 downto 8) < x"f0" then cpuDOut <= ram_char_do_1a;	-- ec00 - f7ff ABS   Character RAM (chr 80..ff) 3 bit per pixel
				elsif	cpuAddr(15 downto 8) < x"f4" then cpuDOut <= ram_char_do_1b;	-- ec00 - f7ff ABS   Character RAM (chr 80..ff) 3 bit per pixel
				elsif	cpuAddr(15 downto 8) < x"f8" then cpuDOut <= ram_char_do_1c;	-- ec00 - f7ff ABS   Character RAM (chr 80..ff) 3 bit per pixel
				else												 cpuDOut <= ram_vid_do_1;		-- f800 - ffff FAZ   Video RAM
				end if;
			when write_wait =>
				mem_state <= do_write;
			when do_write =>
				mem_state <= finish;
				ram_work_we_n    <= '1';
				ram_char_we_n_1a <= '1';
				ram_char_we_n_1b <= '1';
				ram_char_we_n_1c <= '1';
				ram_vid_we_n_1   <= '1';
				cpuDOut <= tmp_data_in;
			when idle_wait =>
				mem_state <= do_idle;
			when do_idle =>
				mem_state <= finish;
			when finish =>
				mem_state <= idle;
				cpuEn		<= '1';
			end case;
	end process;
	 
	-- work ram 0c00h - 0fffh, 1k module
	ram_work : entity work.sram
		generic map (
			AddrWidth => 10,
			DataWidth => 8
		)
		port map (
			clk  => clk,
			addr => cpuAddr(9 downto 0),
			din  => cpuDIn,
			dout => ram_work_do,
			ce_n => '0', 
			we_n => ram_work_we_n
		);
	
	-- character ram ec00h - f7ffh, 3x1k module
	ram_chara : entity work.dualsram
		generic map (
			AddrWidth => 10
		)
		port map (
			clk1  => clk,
			addr1 => cpuAddr(9 downto 0),
			din1  => cpuDIn,
			dout1 => ram_char_do_1a,
			cs1_n => '0', 
			wr1_n => ram_char_we_n_1a,

			clk2  => vgaclk,
			addr2 => cg_ram_Addr(9 downto 0),
			din2  => (others => '0'),
			dout2 => cg_ram_Dataa,
			cs2_n => '0',
			wr2_n => '1'
		);
	ram_charb : entity work.dualsram
		generic map (
			AddrWidth => 10
		)
		port map (
			clk1  => clk,
			addr1 => cpuAddr(9 downto 0),
			din1  => cpuDIn,
			dout1 => ram_char_do_1b,
			cs1_n => '0', 
			wr1_n => ram_char_we_n_1b,

			clk2  => vgaclk,
			addr2 => cg_ram_Addr(9 downto 0),
			din2  => (others => '0'),
			dout2 => cg_ram_Datab,
			cs2_n => '0',
			wr2_n => '1'
		);
	ram_charc : entity work.dualsram
		generic map (
			AddrWidth => 10
		)
		port map (
			clk1  => clk,
			addr1 => cpuAddr(9 downto 0),
			din1  => cpuDIn,
			dout1 => ram_char_do_1c,
			cs1_n => '0', 
			wr1_n => ram_char_we_n_1c,

			clk2  => vgaclk,
			addr2 => cg_ram_Addr(9 downto 0),
			din2  => (others => '0'),
			dout2 => cg_ram_Datac,
			cs2_n => '0',
			wr2_n => '1'
		);
	
	-- video ram f800h - ffffh, 2k module
	ram_vid : entity work.dualsram
		generic map (
			AddrWidth => 11
		)
		port map (
			clk1  => clk,
			addr1 => cpuAddr(10 downto 0),
			din1  => cpuDIn,
			dout1 => ram_vid_do_1,
			cs1_n => '0', 
			wr1_n => ram_vid_we_n_1,

			clk2  => vgaclk,
			addr2 => vid_ram_Addr(10 downto 0),
			din2  => (others => '0'),
			dout2 => vid_ram_Data,
			cs2_n => '0',
			wr2_n => '1'
		);

	-- zre rom, 0000h - 03ffh, 1k
	rom_zre_00 : entity work.rom_zre_0000
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_zre_00_dat
		);
	
	-- zre rom, 0400h - 07ffh, 1k
	rom_zre_04 : entity work.rom_zre_0400
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_zre_04_dat
		);
	
	-- zre rom, 0800h - 0bffh, 1k
	rom_zre_08 : entity work.rom_zre_0800
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_zre_08_dat
		);
		
	-- character rom, e800h - ebffh, 1k
	rom_char1_e8 : entity work.rom_char1
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_char1_e8_dat
		);
	
	-- pfs rom, 1000h - 13ffh, 1k
	rom_10 : entity work.rom2_1000
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_10_dat
		);
	
	-- pfs rom, 1400h - 17ffh, 1k
	rom_14 : entity work.rom2_1400
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_14_dat
		);
		
	-- pfs rom, 1800h - 1bffh, 1k
	rom_18 : entity work.rom2_1800
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_18_dat
		);
	
	-- pfs rom, 1c00h - 1fffh, 1k
	rom_1c : entity work.rom2_1c00
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_1c_dat
		);
		
	-- pfs rom, 2000h - 23ffh, 1k
	rom_20 : entity work.rom2_2000
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_20_dat
		);
	
	-- pfs rom, 2400h - 27ffh, 1k
	rom_24 : entity work.rom2_2400
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_24_dat
		);
		
	-- pfs rom, 2800h - 2bffh, 1k
	rom_28 : entity work.rom2_2800
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_28_dat
		);
	
	-- pfs rom, 2c00h - 2fffh, 1k
	rom_2c : entity work.rom2_2c00
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_2c_dat
		);
		
	-- pfs rom, 3000h - 33ffh, 1k
	rom_30 : entity work.rom2_3000
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_30_dat
		);
	
	-- pfs rom, 3400h - 37ffh, 1k
	rom_34 : entity work.rom2_3400
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_34_dat
		);
		
	-- pfs rom, 3800h - 3bffh, 1k
	rom_38 : entity work.rom2_3800
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_38_dat
		);
	
	-- pfs rom, 3c00h - 3fffh, 1k
	rom_3c : entity work.rom2_3c00
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_3c_dat
		);
	
	-- pfs rom, 4000h - 43ffh, 1k
	rom_40 : entity work.rom2_4000
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_40_dat
		);
	
	-- pfs rom, 4400h - 47ffh, 1k
	rom_44 : entity work.rom2_4400
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_44_dat
		);
		
	-- pfs rom, 4800h - 4bffh, 1k
	rom_48 : entity work.rom2_4800
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_48_dat
		);
	
	-- pfs rom, 4c00h - 4fffh, 1k
	rom_4c : entity work.rom2_4c00
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_4c_dat
		);
	
	-- pfs rom, 5000h - 53ffh, 1k
	rom_50 : entity work.rom1_5000
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_50_dat
		);
	
	-- pfs rom, 5400h - 57ffh, 1k
	rom_54 : entity work.rom1_5400
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_54_dat
		);
		
	-- pfs rom, 5800h - 5bffh, 1k
	rom_58 : entity work.rom1_5800
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_58_dat
		);
	
	-- pfs rom, 5c00h - 5fffh, 1k
	rom_5c : entity work.rom1_5c00
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_5c_dat
		);
	
	-- pfs rom, 6000h - 63ffh, 1k
	rom_60 : entity work.rom1_6000
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_60_dat
		);
	
	-- pfs rom, 6400h - 67ffh, 1k
	rom_64 : entity work.rom1_6400
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_64_dat
		);
		
	-- pfs rom, 6800h - 6bffh, 1k
	rom_68 : entity work.rom1_6800
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_68_dat
		);
	
	-- pfs rom, 6c00h - 6fffh, 1k
	rom_6c : entity work.rom1_6c00
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_6c_dat
		);
	
	-- pfs rom, 7000h - 73ffh, 1k
	rom_70 : entity work.rom1_7000
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_70_dat
		);
	
	-- pfs rom, 7400h - 77ffh, 1k
	rom_74 : entity work.rom1_7400
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_74_dat
		);
		
	-- pfs rom, 7800h - 7bffh, 1k
	rom_78 : entity work.rom1_7800
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_78_dat
		);
	
	-- pfs rom, 7c00h - 7fffh, 1k
	rom_7c : entity work.rom1_7c00
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_7c_dat
		);
	
	-- pfs rom, 8000h - 83ffh, 1k
	rom_80 : entity work.rom1_8000
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_80_dat
		);
	
	-- pfs rom, 8400h - 87ffh, 1k
	rom_84 : entity work.rom1_8400
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_84_dat
		);
		
	-- pfs rom, 8800h - 8bffh, 1k
	rom_88 : entity work.rom1_8800
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_88_dat
		);
	
	-- pfs rom, 8c00h - 8fffh, 1k
	rom_8c : entity work.rom1_8c00
		port map (
			clk => clk,
			addr => cpuAddr(9 downto 0),
			data => rom_8c_dat
		);
end;
