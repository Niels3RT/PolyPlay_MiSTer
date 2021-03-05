--
-- complete rewrite for Poly-Play by Niels Lueddecke in 2021
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
		vid_ram_Data	: out std_logic_vector(7 downto 0);
		
		dn_addr			: in std_logic_vector(15 downto 0);
		dn_data			: in std_logic_vector(7 downto 0);
		dn_wr				: in std_logic;
		tno				: in std_logic_vector(7 downto 0)
	);
end memcontrol;

architecture rtl of memcontrol is
	type   state_type is ( idle, idle_wait, do_idle, read_wait, do_read, write_wait, do_write, finish );
	signal mem_state    		: state_type := idle;
	
	-- ram
	signal ram_adr				: std_logic_vector(15 downto 0);
	signal ram_data_in		: std_logic_vector(7 downto 0);
	
	-- main ram block
	signal ram_main_do		: std_logic_vector(7 downto 0);
	signal ram_main_we_n		: std_logic := '1';
	signal ram_main_we_n_t	: std_logic := '1';
	
	-- char ram
	signal ram_char_do_1a	: std_logic_vector(7 downto 0);
	signal ram_char_we_n_1a	: std_logic := '1';
	signal ram_char_do_1b	: std_logic_vector(7 downto 0);
	signal ram_char_we_n_1b	: std_logic := '1';
	signal ram_char_do_1c	: std_logic_vector(7 downto 0);
	signal ram_char_we_n_1c	: std_logic := '1';
	
	-- video ram
	signal ram_vid_do_1		: std_logic_vector(7 downto 0);
	signal ram_vid_we_n_1	: std_logic := '1';
	
	-- video read stuff
	signal vid_state			: std_logic_vector(1 downto 0) := (others => '0');
	signal vid_adr_old		: std_logic_vector(13 downto 0) := (others => '1');
	
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
				if cpuTick = '1' then
					mem_state <= idle_wait;
					-- write memory
					if		(cpuMREQ_n = '0' and cpuWR_n = '0') then
						mem_state   <= write_wait;
						if		cpuAddr >= x"0c00" and cpuAddr < x"1000" and tno = x"00" then ram_main_we_n_t  <= '0';	-- polyplay main ram
						elsif	cpuAddr >= x"c000" and cpuAddr < x"d000" and tno = x"01" then ram_main_we_n_t  <= '0';	-- polyplay 2 lower ram
						elsif	cpuAddr >= x"ea00" and cpuAddr < x"ec00" and tno = x"01" then ram_main_we_n_t  <= '0';	-- polyplay 2 higher ram
						elsif	cpuAddr >= x"ec00" and cpuAddr < x"f000" then ram_char_we_n_1a <= '0';	-- character ram a
						elsif	cpuAddr >= x"f000" and cpuAddr < x"f400" then ram_char_we_n_1b <= '0';	-- character ram b
						elsif	cpuAddr >= x"f400" and cpuAddr < x"f800" then ram_char_we_n_1c <= '0';	-- character ram c
						elsif	cpuAddr >= x"f800" then ram_vid_we_n_1   <= '0';	-- video ram
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
				if		cpuAddr < x"ec00" then cpuDOut <= ram_main_do;		-- main ram
				elsif	cpuAddr < x"f000" then cpuDOut <= ram_char_do_1a;	-- character ram a
				elsif	cpuAddr < x"f400" then cpuDOut <= ram_char_do_1b;	-- character ram b
				elsif	cpuAddr < x"f800" then cpuDOut <= ram_char_do_1c;	-- character ram c
				else								  cpuDOut <= ram_vid_do_1;		-- video ram
				end if;
			when write_wait =>
				mem_state <= do_write;
			when do_write =>
				mem_state <= finish;
				ram_main_we_n_t  <= '1';
				ram_char_we_n_1a <= '1';
				ram_char_we_n_1b <= '1';
				ram_char_we_n_1c <= '1';
				ram_vid_we_n_1   <= '1';
				cpuDOut <= ram_data_in;
			when idle_wait =>
				mem_state <= do_idle;
			when do_idle =>
				mem_state <= finish;
			when finish =>
				mem_state <= idle;
				cpuEn		<= '1';
			end case;
	end process;
	
	-- rom filling from mra
	ram_main_we_n <=  '0' when dn_wr = '1' and dn_addr >= x"0400" and tno = x"00" else 	-- polyplay
							'0' when dn_wr = '1' and dn_addr <  x"c000" and tno = x"01" else	-- polyplay 2
							ram_main_we_n_t;
	ram_data_in <= dn_data when dn_wr = '1' else cpuDIn;
	ram_adr <=	b"000000" & dn_addr(9 downto 0) when dn_addr(15 downto 10) = b"000001" and dn_wr = '1' and tno = x"00" else		-- polyplay zre_00
					b"000001" & dn_addr(9 downto 0) when dn_addr(15 downto 10) = b"000010" and dn_wr = '1' and tno = x"00" else		-- polyplay zre_04
					b"000010" & dn_addr(9 downto 0) when dn_addr(15 downto 10) = b"000011" and dn_wr = '1' and tno = x"00" else		-- polyplay zre_08
					dn_addr when                                                               dn_wr = '1' and tno = x"00" else		-- polyplay game roms
					dn_addr when dn_addr < x"c000"                                         and dn_wr = '1' and tno = x"01" else		-- polyplay 2 roms 1:1
					cpuAddr;																																			-- done rom fill, use cpu addr
	
	-- main ram block 0000h - dfffh, 64k module
	ram_main : entity work.sram
		generic map (
			AddrWidth => 16,
			DataWidth => 8
		)
		port map (
			clk  => clk,
			addr => ram_adr,
			din  => ram_data_in,
			dout => ram_main_do,
			ce_n => '0', 
			we_n => ram_main_we_n
		);
	
	-- character ram ec00h - f7ffh, 3x1k module
	ram_chara : entity work.dualsram
		generic map (
			AddrWidth => 10
		)
		port map (
			clk1  => clk,
			addr1 => ram_adr(9 downto 0),
			din1  => ram_data_in,
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
			addr1 => ram_adr(9 downto 0),
			din1  => ram_data_in,
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
			addr1 => ram_adr(9 downto 0),
			din1  => ram_data_in,
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
			addr1 => ram_adr(10 downto 0),
			din1  => ram_data_in,
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
end;
