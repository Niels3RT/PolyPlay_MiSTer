--
-- 2021, Niels Lueddecke
--
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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity video is
    generic (
		H_SYNC_ACTIVE		: std_logic := '1';
		H_BLANK_ACTIVE		: std_logic := '1';
		V_SYNC_ACTIVE		: std_logic := '1';
		V_BLANK_ACTIVE		: std_logic := '1'
		);
	port (
		--clk				: in  std_logic;		-- orig: 8,867238 MHz / real: 8,865248 MHz
		clk				: in  std_logic;		-- 10,5 MHz
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
	-- pipeline register
	type reg is record
		do_stuff				: std_logic;
		cnt_h					: unsigned(11 downto 0);
		cnt_v					: unsigned(11 downto 0);
		pos_x					: unsigned(11 downto 0);
		pos_y					: unsigned(11 downto 0);
		sync_h				: std_logic;
		sync_v				: std_logic;
		blank_h				: std_logic;
		blank_v				: std_logic;
		use_cg_ram			: std_logic;
	end record;

	signal s0 : reg := ('0', (others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), '0', '0', '0', '0', '0');
	signal s1 : reg := ('0', (others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), '0', '0', '0', '0', '0');
	signal s2 : reg := ('0', (others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), '0', '0', '0', '0', '0');
	signal s3 : reg := ('0', (others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), '0', '0', '0', '0', '0');
	signal s4 : reg := ('0', (others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), '0', '0', '0', '0', '0');
	signal s5 : reg := ('0', (others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), '0', '0', '0', '0', '0');

	-- counter
	signal cnt_h			: unsigned(11 downto 0) := (others => '0');
	signal cnt_v			: unsigned(11 downto 0) := (others => '0');

	-- char rom
	signal cg_rom_Addr	: std_logic_vector(9 downto 0);
	signal cg_rom_Data	: std_logic_vector(7 downto 0);
	signal cg_rom_cs		: std_logic;

begin
	process
	begin 
		wait until rising_edge(clk);

		-- hsync counter
		--if cnt_h < 640 then	-- 10MHz
		if cnt_h < 672 then	-- 10,5MHz
			cnt_h <= cnt_h + 1;
		else
			cnt_h <= x"000";
			-- vsync counter
			if cnt_v < 312 then
				cnt_v <= cnt_v + 1;
			else
				cnt_v <= x"000";
			end if;
		end if;
		-- fill pipeline
		s0.do_stuff <= '1';
		s0.cnt_h    <= cnt_h;
		s0.cnt_v    <= cnt_v;
		s0.sync_h   <= not H_SYNC_ACTIVE;
		s0.sync_v   <= not V_SYNC_ACTIVE;
		s0.blank_h  <= H_BLANK_ACTIVE;
		s0.blank_v  <= V_BLANK_ACTIVE;
		
		-- work the pipe
		-- stage 0
		s1 <= s0;
		if s0.do_stuff = '1' then
			s1.pos_x <= s0.cnt_h - 128; 
			s1.pos_y <= s0.cnt_v - 6;
			-- horizontal sync
			if s0.cnt_h < 40 then		-- B&O syncs ok
				s1.sync_h <= H_SYNC_ACTIVE;
			end if;
			-- vertical sync
			if s0.cnt_v > 280 and s0.cnt_v < 284 then		-- seems ok? B&O seems to like it
				s1.sync_v <= V_SYNC_ACTIVE;
			end if;
		end if;
		-- stage 1
		s2 <= s1;
		if s1.do_stuff = '1' then
			-- blank signals
			if s1.pos_x < 512 then
				s2.blank_h <= not H_BLANK_ACTIVE;
			end if;
			if s1.pos_y < 256 then
				s2.blank_v <= not V_BLANK_ACTIVE;
			end if;
			-- set video ram address, fetch char nr
			vid_ram_Addr <= std_logic_vector(s1.pos_y(7 downto 3) & s1.pos_x(8 downto 3));
		end if;
		-- stage 2
		s3 <= s2;
		-- stage 3
		s4 <= s3;
		if s3.do_stuff = '1' then
			-- set address in char rom/ram
			cg_ram_Addr   <= vid_ram_Data(6 downto 0) & std_logic_vector(s3.pos_y(2 downto 0));
			cg_rom_Addr   <= vid_ram_Data(6 downto 0) & std_logic_vector(s3.pos_y(2 downto 0));
			s4.use_cg_ram <= vid_ram_Data(7);
		end if;
		-- stage 4
		s5 <= s4;
		-- stage 5
		if s5.do_stuff = '1' then
			if s5.blank_h /= H_BLANK_ACTIVE and s5.blank_v /= V_BLANK_ACTIVE then
				if s5.use_cg_ram = '0' then
					if		s5.pos_x(2 downto 0) = b"111" then red <= (others => cg_rom_Data(0)); green <= (others => cg_rom_Data(0)); blue <= (others => cg_rom_Data(0));
					elsif s5.pos_x(2 downto 0) = b"110" then red <= (others => cg_rom_Data(1)); green <= (others => cg_rom_Data(1)); blue <= (others => cg_rom_Data(1));
					elsif s5.pos_x(2 downto 0) = b"101" then red <= (others => cg_rom_Data(2)); green <= (others => cg_rom_Data(2)); blue <= (others => cg_rom_Data(2));
					elsif s5.pos_x(2 downto 0) = b"100" then red <= (others => cg_rom_Data(3)); green <= (others => cg_rom_Data(3)); blue <= (others => cg_rom_Data(3));
					elsif s5.pos_x(2 downto 0) = b"011" then red <= (others => cg_rom_Data(4)); green <= (others => cg_rom_Data(4)); blue <= (others => cg_rom_Data(4));
					elsif s5.pos_x(2 downto 0) = b"010" then red <= (others => cg_rom_Data(5)); green <= (others => cg_rom_Data(5)); blue <= (others => cg_rom_Data(5));
					elsif s5.pos_x(2 downto 0) = b"001" then red <= (others => cg_rom_Data(6)); green <= (others => cg_rom_Data(6)); blue <= (others => cg_rom_Data(6));
					elsif s5.pos_x(2 downto 0) = b"000" then red <= (others => cg_rom_Data(7)); green <= (others => cg_rom_Data(7)); blue <= (others => cg_rom_Data(7));
					end if;
				else
					if		s5.pos_x(2 downto 0) = b"111" then red <= (others => cg_ram_Datac(0)); green <= (others => cg_ram_Datab(0)); blue <= (others => cg_ram_Dataa(0));
					elsif s5.pos_x(2 downto 0) = b"110" then red <= (others => cg_ram_Datac(1)); green <= (others => cg_ram_Datab(1)); blue <= (others => cg_ram_Dataa(1));
					elsif s5.pos_x(2 downto 0) = b"101" then red <= (others => cg_ram_Datac(2)); green <= (others => cg_ram_Datab(2)); blue <= (others => cg_ram_Dataa(2));
					elsif s5.pos_x(2 downto 0) = b"100" then red <= (others => cg_ram_Datac(3)); green <= (others => cg_ram_Datab(3)); blue <= (others => cg_ram_Dataa(3));
					elsif s5.pos_x(2 downto 0) = b"011" then red <= (others => cg_ram_Datac(4)); green <= (others => cg_ram_Datab(4)); blue <= (others => cg_ram_Dataa(4));
					elsif s5.pos_x(2 downto 0) = b"010" then red <= (others => cg_ram_Datac(5)); green <= (others => cg_ram_Datab(5)); blue <= (others => cg_ram_Dataa(5));
					elsif s5.pos_x(2 downto 0) = b"001" then red <= (others => cg_ram_Datac(6)); green <= (others => cg_ram_Datab(6)); blue <= (others => cg_ram_Dataa(6));
					elsif s5.pos_x(2 downto 0) = b"000" then red <= (others => cg_ram_Datac(7)); green <= (others => cg_ram_Datab(7)); blue <= (others => cg_ram_Dataa(7));
					end if;
				end if;
			else	-- B&O likes it
				red   <= x"00";
				green <= x"00";
				blue  <= x"00";
			end if;
		end if;
		hsync  <= s5.sync_h;
		vsync  <= s5.sync_v;
		hblank <= s5.blank_h;
		vblank <= s5.blank_v;

	end process;
 
	-- character rom, e800h - ebffh, 1k
	cg_rom_cs <= '0' when dn_addr(15 downto 10) = b"000000" and tno = x"00" else	-- polyplay
					 '0' when dn_addr(15 downto 10) = b"110000" and tno = x"01" else	-- polyplay 2
					 '1';
	
	-- char rom
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
