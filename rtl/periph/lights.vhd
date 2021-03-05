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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity lights is 
	port (
		clk				: in  std_logic;
		reset_n			: in  std_logic;
		
		pioBOut			: in  std_logic_vector(7 downto 0);
		
		LED_USER			: out std_logic;
		LED_POWER		: out std_logic_vector(1 downto 0);
		LED_DISK			: out std_logic_vector(1 downto 0);
		
		organ				: in  std_logic_vector(1 downto 0);
		
		USER_OUT			: out std_logic_vector(2 downto 0)
	);
end lights;

architecture rtl of lights is
	signal ds			: std_logic_vector(2 downto 0);
	
begin
	process
	begin
		wait until rising_edge(clk);
		
		ds <= pioBOut(2 downto 0);
		
		if reset_n = '0' then
			LED_POWER <= b"10";
			LED_DISK  <= b"10";
			LED_USER  <= '0';
			USER_OUT  <= (others => '1');
		else
			case organ is
				when b"00"  =>		-- output to mister leds
					case ds is
						when b"000" =>
							LED_POWER <= b"10";
							LED_DISK  <= b"11";
							LED_USER  <= '1';
						when b"001" =>
							LED_POWER <= b"11";
							LED_DISK  <= b"10";
							LED_USER  <= '1';
						when b"010" =>
							LED_POWER <= b"11";
							LED_DISK  <= b"11";
							LED_USER  <= '0';
						when others =>
							LED_POWER <= b"11";
							LED_DISK  <= b"11";
							LED_USER  <= '1';
					end case;
				when b"01"  =>		-- output to DS8205D on user port 2:0
					USER_OUT <= pioBOut(2 downto 0);
					LED_POWER <= b"11";
					LED_DISK  <= b"11";
					LED_USER  <= '0';
				when others =>		-- ignore light organ output
					LED_POWER <= b"11";
					LED_DISK  <= b"10";
					LED_USER  <= '1';
					USER_OUT <= (others => '1');
			end case;
		end if;
		
		
	end process;
end;
