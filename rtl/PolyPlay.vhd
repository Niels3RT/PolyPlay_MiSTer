--
-- Port to MiSTer by Niels Lueddecke
--
-- Original Copyright notice that came with the kc854 core:
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
-- PolyPlay Toplevel
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PolyPlay is
		generic (
			RESET_DELAY : integer := 100000
		);
		port(
		cpuclk			: in  std_logic;		-- 50Mhz
		vgaclk			: in  std_logic;		-- 8,867238Mhz PAL
		clkLocked		: in  std_logic;
		reset_sig		: in  std_logic;
		
		joystick_0		: in  std_logic_vector(31 downto 0);

		HBlank			: out std_logic;
		HSync				: out std_logic;
		VBlank			: out std_logic;
		VSync				: out std_logic;
		
		VGA_R				: out std_logic_vector(7 downto 0);
		VGA_G				: out std_logic_vector(7 downto 0);
		VGA_B				: out std_logic_vector(7 downto 0);
		
		clk_audio		: in  std_logic;		-- 24.576 MHz
		AUDIO_L			: out std_logic_vector(15 downto 0);
		AUDIO_R			: out std_logic_vector(15 downto 0);
		
		LED_USER			: out std_logic;
		LED_POWER		: out std_logic_vector(1 downto 0);
		LED_DISK			: out std_logic_vector(1 downto 0);
		
		organ				: in  std_logic_vector(1 downto 0);
		
		USER_OUT			: out std_logic_vector(6 downto 0);
		
		dn_addr			: in std_logic_vector(15 downto 0);
		dn_data			: in std_logic_vector(7 downto 0);
		dn_wr				: in std_logic;
		tno				: in std_logic_vector(7 downto 0)
    );
end PolyPlay;

architecture struct of PolyPlay is
	constant NUMINTS		: integer := 2 + 4; -- (PIO + CTC)

	signal cpuReset_n		: std_logic;
	signal cpuAddr			: std_logic_vector(15 downto 0);
	signal cpuDataIn		: std_logic_vector(7 downto 0);
	signal cpuDataOut		: std_logic_vector(7 downto 0);
	signal cpuEn			: std_logic;
	signal cpuWait			: std_logic;
	signal cpuTick			: std_logic;
	signal cpuInt_n		: std_logic := '1';
	signal cpuM1_n			: std_logic;
	signal cpuMReq_n		: std_logic;
	signal cpuRfsh_n		: std_logic;
	signal cpuIorq_n		: std_logic;
	signal cpuRD_n			: std_logic;
	signal cpuWR_n			: std_logic;
	signal cpuRETI_n		: std_logic;
	signal cpuIntEna_n	: std_logic;
	
	signal memDataOut		: std_logic_vector(7 downto 0);

	signal ioSel			: boolean;
    
	signal pioCS_n			: std_logic;
	
	signal pioAIn			: std_logic_vector(7 downto 0);
	signal pioAOut			: std_logic_vector(7 downto 0);
	signal pioARdy			: std_logic;
	signal pioAStb			: std_logic;

	signal pioBIn			: std_logic_vector(7 downto 0);
	signal pioBOut			: std_logic_vector(7 downto 0);
	signal pioBRdy			: std_logic;
	signal pioBStb			: std_logic;

	signal pioDataOut		: std_logic_vector(7 downto 0);

	signal ctcCS_n			: std_logic;	
	signal ctcClk			: std_logic;
	signal nmi100hz		: std_logic;

	signal ctcDataOut		: std_logic_vector(7 downto 0);
	signal ctcClkTrg		: std_logic_vector(3 downto 0);
	signal ctcZcTo			: std_logic_vector(3 downto 0);

	signal intPeriph		: std_logic_vector(NUMINTS-1 downto 0);
	signal intAckPeriph	: std_logic_vector(NUMINTS-1 downto 0);
	
	signal resetDelay		: integer range 0 to RESET_DELAY := RESET_DELAY;
	
	-- chargen
	signal cg_ram_Addr	: std_logic_vector(9 downto 0);
	signal cg_ram_Dataa	: std_logic_vector(7 downto 0);
	signal cg_ram_Datab	: std_logic_vector(7 downto 0);
	signal cg_ram_Datac	: std_logic_vector(7 downto 0);
	signal vid_ram_Addr	: std_logic_vector(10 downto 0);
	signal vid_ram_Data	: std_logic_vector(7 downto 0);
	
	-- TEMP debug output
	signal dbg_out			: std_logic_vector(15 downto 0) := (others => '0');

begin
	-- debug output
	USER_OUT(6 downto 3) <= dbg_out(3 downto 0);

	-- reset
	cpuReset_n <= '0' when resetDelay /= 0 else '1';
	--LED_USER <= cpuReset_n;
	--LED_USER <= tno(0);

	reset : process
	begin
		wait until rising_edge(cpuclk);

		-- delay reset
		if resetDelay > 0 then -- Reset verzoegern?
			resetDelay <= resetDelay - 1;
		end if;

		-- begin reset
		if clkLocked = '0' or reset_sig = '1' then -- Reset
			resetDelay <= RESET_DELAY;
		end if;
	end process;

	-- vga-controller
	video : entity work.video
		port map (
			clk    => vgaclk,
			cpuclk => cpuclk,
			red    => VGA_R,
			green  => VGA_G,
			blue   => VGA_B,
			hsync  => HSync,
			vsync  => VSync,
			hblank => HBlank,
			vblank => VBlank,
			
			cg_ram_Addr  => cg_ram_Addr,
			cg_ram_Dataa => cg_ram_Dataa,
			cg_ram_Datab => cg_ram_Datab,
			cg_ram_Datac => cg_ram_Datac,
			vid_ram_Addr => vid_ram_Addr,
			vid_ram_Data => vid_ram_Data,
			
			dn_addr => dn_addr,
			dn_data => dn_data,
			dn_wr   => dn_wr,
			tno     => tno
		);

	-- memory controller
	memcontrol : entity work.memcontrol
		port map (
			clk			=> cpuclk,
			vgaclk		=> vgaclk,
			reset_n		=> cpuReset_n,

			cpuAddr		=> cpuAddr,
			cpuDOut		=> memDataOut,
			cpuDIn		=> cpuDataOut,

			cpuWR_n		=> cpuWR_n,
			cpuRD_n		=> cpuRD_n,
			cpuMREQ_n	=> cpuMReq_n,
			cpuM1_n		=> cpuM1_n,
			cpuIORQ_n	=> cpuIorq_n,

			cpuEn			=> cpuEn,
			cpuWait		=> cpuWait,

			cpuTick		=> cpuTick,
			
			cg_ram_Addr  => cg_ram_Addr,
			cg_ram_Dataa => cg_ram_Dataa,
			cg_ram_Datab => cg_ram_Datab,
			cg_ram_Datac => cg_ram_Datac,
			vid_ram_Addr => vid_ram_Addr,
			vid_ram_Data => vid_ram_Data,
			
			dn_addr => dn_addr,
			dn_data => dn_data,
			dn_wr   => dn_wr,
			tno     => tno
		);

	-- CPU data-in multiplexer
	cpuDataIn <= 
			ctcDataOut when ctcCS_n='0' or intAckPeriph(3 downto 0) /= "0000" else
			pioDataOut when pioCS_n='0' or intAckPeriph(5 downto 4) /= "00"   else
			memDataOut;

	-- T80 CPU
	cpu : entity work.T80se
		generic map(Mode => 1, T2Write => 1, IOWait => 0)
		port map(
			RESET_n => cpuReset_n,
			CLK_n   => cpuclk,
			CLKEN   => cpuEn,
			WAIT_n  => cpuWait,
			INT_n   => cpuInt_n,
			NMI_n   => nmi100hz,
			BUSRQ_n => '1',
			M1_n    => cpuM1_n,
			MREQ_n  => cpuMReq_n,
			IORQ_n  => cpuIorq_n,
			RD_n    => cpuRD_n,
			WR_n    => cpuWR_n,
			RFSH_n  => open,
			HALT_n  => open,
			BUSAK_n => open,
			A       => cpuAddr,
			DI      => cpuDataIn,
			DO      => cpuDataOut,
			IntE    => cpuIntEna_n,
			RETI_n  => cpuRETI_n
		);
		
	ioSel   <= cpuIorq_n = '0' and cpuM1_n='1';

	-- PIO: 84H-87H
	pioCS_n <= '0' when cpuAddr(7 downto 2) = "100001"  and ioSel else '1';

	pioAStb <= '1';
	pioBStb <= '1';
	pioBIn  <= (others => '0');

	pio : entity work.pio
		port map (
			clk     => cpuclk,
			res_n   => cpuReset_n,
			dIn     => cpuDataOut,
			dOut    => pioDataOut,
			baSel   => cpuAddr(0),
			cdSel   => cpuAddr(1),
			cs_n    => pioCS_n,
			m1_n    => cpuM1_n,
			iorq_n  => cpuIorq_n,
			rd_n    => cpuRD_n,
			intAck  => intAckPeriph(5 downto 4),
			int     => intPeriph(5 downto 4),
			aIn     => joystick_0(5) & b"11" & not joystick_0(2) & not joystick_0(3) & not joystick_0(1) & not joystick_0(0) & not joystick_0(4),
			aOut    => pioAOut,
			aRdy    => pioARdy,
			aStb    => pioAStb,
			bIn     => pioBIn,
			bOut    => pioBOut,
			bRdy    => pioBRdy,
			bStb    => pioBStb
		);

	-- audio output
	audio_out : entity work.audio
		port map (
			clk			=> clk_audio,
			reset_n		=> cpuReset_n,
			AUDIO_L		=> AUDIO_L,
			AUDIO_R		=> AUDIO_R,
			ctcTcTo		=> ctcZcTo(1 downto 0)
		);
	
	-- system clocks
	sysclock : entity work.sysclock
		port map (
			clk      => cpuclk,
			cpuClkEn => cpuTick,
			ctcClk   => ctcClk,
			nmi100hz	=> nmi100hz
		);
	
	-- CTC: 80H-83H
	ctcCS_n <= '0' when cpuAddr(7 downto 2) = "100000"  and ioSel else '1';

	ctcClkTrg(0) <= ctcClk;
	ctcClkTrg(1) <= ctcClk;
	ctcClkTrg(2) <= ctcClk;
	ctcClkTrg(3) <= ctcClk;

	ctc : entity work.ctc
		port map (
			clk     => cpuclk,
			sysClkEn => cpuTick,
			res_n   => cpuReset_n,
			cs      => ctcCS_n,
			dIn     => cpuDataOut,
			dOut    => ctcDataOut,
			chanSel => cpuAddr(1 downto 0),
			m1_n    => cpuM1_n,
			iorq_n  => cpuIorq_n,
			rd_n    => cpuRD_n,
			int     => intPeriph(3 downto 0),
			intAck  => intAckPeriph(3 downto 0),
			clk_trg => ctcClkTrg,
			zc_to   => ctcZcTo
		);
	
	-- interrupt controller
	intController : entity work.intController
		generic map (
			NUMINTS => NUMINTS
		)
		port map (
			clk       => cpuclk,
			res_n     => cpuReset_n,
			int_n     => cpuInt_n,
			intPeriph => intPeriph,
			intAck    => intAckPeriph,
			m1_n      => cpuM1_n,
			iorq_n    => cpuIorq_n,
			rd_n      => cpuRD_n,
			reti_n    => cpuRETI_n,
			intEna_n  => cpuIntEna_n
		);
		
	-- light organ
	lights : entity work.lights
		port map (
			clk			=> clk_audio,
			reset_n		=> cpuReset_n,
			pioBOut		=> pioBOut,
			LED_USER		=> LED_USER,
			LED_POWER	=> LED_POWER,
			LED_DISK		=> LED_DISK,
			organ			=> organ,
			USER_OUT		=> USER_OUT(2 downto 0)
		);
end;
