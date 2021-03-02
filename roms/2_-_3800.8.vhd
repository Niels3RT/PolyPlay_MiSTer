library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom2_3800 is
    generic(
        ADDR_WIDTH   : integer := 10
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end rom2_3800;

architecture rtl of rom2_3800 is
    type rom1024x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom1024x8 := (
         x"df",  x"df",  x"df",  x"df",  x"df",  x"00",  x"00",  x"df", -- 0000
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 0008
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"00", -- 0010
         x"00",  x"df",  x"df",  x"e8",  x"e1",  x"df",  x"00",  x"00", -- 0018
         x"00",  x"00",  x"00",  x"df",  x"e8",  x"e1",  x"00",  x"e8", -- 0020
         x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00", -- 0028
         x"e8",  x"e1",  x"dc",  x"df",  x"00",  x"00",  x"00",  x"00", -- 0030
         x"00",  x"00",  x"00",  x"df",  x"e8",  x"e1",  x"00",  x"e8", -- 0038
         x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00", -- 0040
         x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1", -- 0048
         x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8", -- 0050
         x"e1",  x"df",  x"df",  x"e0",  x"e9",  x"df",  x"00",  x"00", -- 0058
         x"00",  x"00",  x"00",  x"df",  x"e0",  x"e9",  x"00",  x"e0", -- 0060
         x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00", -- 0068
         x"e0",  x"e9",  x"dc",  x"df",  x"00",  x"00",  x"00",  x"00", -- 0070
         x"00",  x"00",  x"00",  x"df",  x"e0",  x"e9",  x"00",  x"e0", -- 0078
         x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00", -- 0080
         x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9", -- 0088
         x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0", -- 0090
         x"e9",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 0098
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 00A0
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 00A8
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 00B0
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 00B8
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 00C0
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 00C8
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 00D0
         x"df",  x"df",  x"df",  x"00",  x"00",  x"df",  x"00",  x"00", -- 00D8
         x"00",  x"00",  x"00",  x"df",  x"00",  x"00",  x"df",  x"df", -- 00E0
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 00E8
         x"00",  x"00",  x"df",  x"df",  x"00",  x"00",  x"00",  x"00", -- 00F0
         x"00",  x"00",  x"00",  x"df",  x"00",  x"00",  x"df",  x"df", -- 00F8
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 0100
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 0108
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"00", -- 0110
         x"00",  x"df",  x"df",  x"e8",  x"e1",  x"df",  x"00",  x"00", -- 0118
         x"00",  x"00",  x"00",  x"df",  x"e8",  x"e1",  x"df",  x"00", -- 0120
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 0128
         x"e8",  x"e1",  x"df",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0130
         x"00",  x"00",  x"00",  x"df",  x"e8",  x"e1",  x"df",  x"00", -- 0138
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0140
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0148
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df",  x"e8", -- 0150
         x"e1",  x"df",  x"df",  x"e0",  x"e9",  x"df",  x"00",  x"00", -- 0158
         x"00",  x"00",  x"00",  x"df",  x"e0",  x"e9",  x"df",  x"00", -- 0160
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 0168
         x"e0",  x"e9",  x"df",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0170
         x"00",  x"00",  x"00",  x"df",  x"e0",  x"e9",  x"df",  x"00", -- 0178
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0180
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0188
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df",  x"e0", -- 0190
         x"e9",  x"df",  x"df",  x"00",  x"00",  x"df",  x"df",  x"df", -- 0198
         x"df",  x"df",  x"df",  x"df",  x"00",  x"00",  x"df",  x"00", -- 01A0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 01A8
         x"00",  x"00",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 01B0
         x"df",  x"df",  x"df",  x"df",  x"00",  x"00",  x"df",  x"df", -- 01B8
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 01C0
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 01C8
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"00", -- 01D0
         x"00",  x"df",  x"df",  x"e8",  x"e1",  x"00",  x"e8",  x"e1", -- 01D8
         x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"df",  x"00", -- 01E0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 01E8
         x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1", -- 01F0
         x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8", -- 01F8
         x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00", -- 0200
         x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1", -- 0208
         x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8", -- 0210
         x"e1",  x"df",  x"df",  x"e0",  x"e9",  x"00",  x"e0",  x"e9", -- 0218
         x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"df",  x"00", -- 0220
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 0228
         x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9", -- 0230
         x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0", -- 0238
         x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00", -- 0240
         x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9", -- 0248
         x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0", -- 0250
         x"e9",  x"df",  x"df",  x"00",  x"00",  x"df",  x"df",  x"df", -- 0258
         x"df",  x"df",  x"df",  x"df",  x"00",  x"00",  x"df",  x"00", -- 0260
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 0268
         x"00",  x"00",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 0270
         x"df",  x"df",  x"df",  x"df",  x"00",  x"00",  x"df",  x"df", -- 0278
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 0280
         x"df",  x"df",  x"df",  x"00",  x"00",  x"df",  x"df",  x"df", -- 0288
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"00", -- 0290
         x"00",  x"df",  x"df",  x"e8",  x"e1",  x"df",  x"00",  x"00", -- 0298
         x"00",  x"00",  x"00",  x"df",  x"e8",  x"e1",  x"df",  x"00", -- 02A0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 02A8
         x"e8",  x"e1",  x"df",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02B0
         x"00",  x"00",  x"00",  x"df",  x"e8",  x"e1",  x"df",  x"00", -- 02B8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02C0
         x"00",  x"00",  x"df",  x"e8",  x"e1",  x"df",  x"00",  x"00", -- 02C8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df",  x"e8", -- 02D0
         x"e1",  x"df",  x"df",  x"e0",  x"e9",  x"df",  x"00",  x"00", -- 02D8
         x"00",  x"00",  x"00",  x"df",  x"e0",  x"e9",  x"df",  x"00", -- 02E0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 02E8
         x"e0",  x"e9",  x"df",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02F0
         x"00",  x"00",  x"00",  x"df",  x"e0",  x"e9",  x"df",  x"00", -- 02F8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0300
         x"00",  x"00",  x"df",  x"e0",  x"e9",  x"df",  x"00",  x"00", -- 0308
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df",  x"e0", -- 0310
         x"e9",  x"df",  x"df",  x"00",  x"00",  x"df",  x"00",  x"00", -- 0318
         x"00",  x"00",  x"00",  x"df",  x"00",  x"00",  x"df",  x"00", -- 0320
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 0328
         x"00",  x"00",  x"df",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0330
         x"00",  x"00",  x"00",  x"df",  x"00",  x"00",  x"df",  x"00", -- 0338
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0340
         x"00",  x"00",  x"df",  x"00",  x"00",  x"df",  x"00",  x"00", -- 0348
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df",  x"00", -- 0350
         x"00",  x"00",  x"00",  x"e8",  x"e1",  x"df",  x"00",  x"00", -- 0358
         x"00",  x"00",  x"00",  x"df",  x"e8",  x"e1",  x"df",  x"00", -- 0360
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 0368
         x"e8",  x"e1",  x"df",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0370
         x"00",  x"00",  x"00",  x"df",  x"e8",  x"e1",  x"df",  x"00", -- 0378
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0380
         x"00",  x"00",  x"df",  x"e8",  x"e1",  x"df",  x"00",  x"00", -- 0388
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df",  x"e8", -- 0390
         x"e1",  x"00",  x"00",  x"e0",  x"e9",  x"df",  x"00",  x"00", -- 0398
         x"00",  x"00",  x"00",  x"df",  x"e0",  x"e9",  x"df",  x"00", -- 03A0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df", -- 03A8
         x"e0",  x"e9",  x"df",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03B0
         x"00",  x"00",  x"00",  x"df",  x"e0",  x"e9",  x"df",  x"00", -- 03B8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03C0
         x"00",  x"00",  x"df",  x"e0",  x"e9",  x"df",  x"00",  x"00", -- 03C8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"df",  x"e0", -- 03D0
         x"e9",  x"df",  x"df",  x"00",  x"00",  x"df",  x"df",  x"df", -- 03D8
         x"df",  x"df",  x"df",  x"df",  x"00",  x"00",  x"df",  x"df", -- 03E0
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 03E8
         x"00",  x"00",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 03F0
         x"df",  x"df",  x"df",  x"df",  x"00",  x"00",  x"df",  x"df"  -- 03F8
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;
