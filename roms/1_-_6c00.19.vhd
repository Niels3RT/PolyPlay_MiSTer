library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom1_6c00 is
    generic(
        ADDR_WIDTH   : integer := 10
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end rom1_6c00;

architecture rtl of rom1_6c00 is
    type rom1024x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom1024x8 := (
         x"e0",  x"e0",  x"f9",  x"ff",  x"ff",  x"70",  x"30",  x"30", -- 0000
         x"70",  x"73",  x"f3",  x"f3",  x"f3",  x"00",  x"00",  x"00", -- 0008
         x"00",  x"c0",  x"c0",  x"c0",  x"c0",  x"3c",  x"00",  x"00", -- 0010
         x"00",  x"00",  x"00",  x"00",  x"00",  x"ff",  x"7f",  x"39", -- 0018
         x"00",  x"00",  x"00",  x"00",  x"00",  x"f3",  x"e0",  x"c0", -- 0020
         x"00",  x"00",  x"00",  x"00",  x"00",  x"c0",  x"00",  x"00", -- 0028
         x"00",  x"00",  x"00",  x"00",  x"00",  x"e0",  x"c0",  x"c0", -- 0030
         x"e0",  x"e0",  x"f9",  x"ff",  x"ff",  x"70",  x"30",  x"30", -- 0038
         x"70",  x"73",  x"f3",  x"f3",  x"f3",  x"08",  x"00",  x"15", -- 0040
         x"00",  x"00",  x"00",  x"00",  x"00",  x"fe",  x"fe",  x"fe", -- 0048
         x"00",  x"00",  x"00",  x"00",  x"00",  x"07",  x"07",  x"07", -- 0050
         x"00",  x"00",  x"00",  x"00",  x"00",  x"f0",  x"f0",  x"f0", -- 0058
         x"00",  x"00",  x"01",  x"03",  x"07",  x"03",  x"03",  x"07", -- 0060
         x"00",  x"00",  x"ff",  x"ff",  x"fc",  x"f0",  x"f0",  x"fc", -- 0068
         x"00",  x"00",  x"ff",  x"9f",  x"03",  x"00",  x"00",  x"03", -- 0070
         x"00",  x"00",  x"f8",  x"fc",  x"fe",  x"fc",  x"fc",  x"fe", -- 0078
         x"03",  x"01",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0080
         x"ff",  x"ff",  x"00",  x"00",  x"fe",  x"fe",  x"fe",  x"00", -- 0088
         x"9f",  x"ff",  x"00",  x"00",  x"07",  x"07",  x"07",  x"00", -- 0090
         x"fc",  x"f8",  x"00",  x"00",  x"f0",  x"f0",  x"f0",  x"00", -- 0098
         x"00",  x"00",  x"ff",  x"ff",  x"fc",  x"f0",  x"f0",  x"fc", -- 00A0
         x"00",  x"00",  x"ff",  x"9f",  x"03",  x"00",  x"00",  x"03", -- 00A8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"01",  x"07",  x"0f", -- 00B0
         x"07",  x"0f",  x"1f",  x"0f",  x"02",  x"00",  x"83",  x"c7", -- 00B8
         x"c0",  x"e0",  x"8f",  x"3f",  x"7f",  x"ff",  x"ff",  x"83", -- 00C0
         x"00",  x"00",  x"80",  x"e0",  x"f0",  x"f8",  x"f8",  x"f8", -- 00C8
         x"1f",  x"0e",  x"04",  x"01",  x"01",  x"01",  x"01",  x"00", -- 00D0
         x"8f",  x"7f",  x"78",  x"fc",  x"fc",  x"ff",  x"ff",  x"ff", -- 00D8
         x"83",  x"03",  x"1f",  x"3f",  x"3e",  x"fc",  x"f8",  x"c4", -- 00E0
         x"f8",  x"e4",  x"cf",  x"1f",  x"7f",  x"3e",  x"08",  x"00", -- 00E8
         x"08",  x"00",  x"0d",  x"7f",  x"3f",  x"00",  x"00",  x"00", -- 00F0
         x"00",  x"00",  x"00",  x"8e",  x"3f",  x"7e",  x"fc",  x"30", -- 00F8
         x"00",  x"00",  x"00",  x"00",  x"80",  x"00",  x"00",  x"00", -- 0100
         x"00",  x"00",  x"00",  x"8f",  x"7f",  x"78",  x"fc",  x"fc", -- 0108
         x"ff",  x"ff",  x"ff",  x"83",  x"03",  x"1f",  x"3f",  x"3e", -- 0110
         x"fc",  x"f8",  x"c4",  x"00",  x"00",  x"01",  x"07",  x"0f", -- 0118
         x"1f",  x"1f",  x"1f",  x"03",  x"07",  x"f1",  x"f0",  x"fe", -- 0120
         x"ff",  x"ff",  x"c1",  x"e0",  x"f0",  x"f8",  x"f0",  x"40", -- 0128
         x"00",  x"c1",  x"63",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0130
         x"80",  x"e0",  x"f0",  x"1f",  x"4e",  x"f3",  x"f0",  x"fe", -- 0138
         x"3c",  x"10",  x"00",  x"c0",  x"c0",  x"f0",  x"e0",  x"7c", -- 0140
         x"3f",  x"0f",  x"23",  x"31",  x"7e",  x"1e",  x"3f",  x"3f", -- 0148
         x"ff",  x"ff",  x"ff",  x"fc",  x"78",  x"20",  x"80",  x"80", -- 0150
         x"80",  x"80",  x"00",  x"08",  x"00",  x"02",  x"7f",  x"fe", -- 0158
         x"7f",  x"3e",  x"08",  x"00",  x"00",  x"00",  x"fe",  x"fc", -- 0160
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"08",  x"00", -- 0168
         x"02",  x"c0",  x"c0",  x"f0",  x"e0",  x"7c",  x"3f",  x"0f", -- 0170
         x"23",  x"31",  x"7e",  x"1e",  x"3f",  x"3f",  x"ff",  x"ff", -- 0178
         x"ff",  x"58",  x"00",  x"01",  x"00",  x"f0",  x"f0",  x"0f", -- 0180
         x"0f",  x"00",  x"00",  x"00",  x"28",  x"00",  x"02",  x"00", -- 0188
         x"00",  x"00",  x"00",  x"00",  x"3f",  x"7f",  x"ff",  x"00", -- 0190
         x"00",  x"00",  x"00",  x"00",  x"c0",  x"f0",  x"f0",  x"08", -- 0198
         x"00",  x"03",  x"00",  x"03",  x"00",  x"00",  x"00",  x"00", -- 01A0
         x"00",  x"00",  x"ff",  x"ff",  x"f9",  x"e0",  x"e0",  x"f0", -- 01A8
         x"f0",  x"e0",  x"f0",  x"fc",  x"f0",  x"70",  x"70",  x"f0", -- 01B0
         x"f0",  x"70",  x"08",  x"00",  x"03",  x"00",  x"00",  x"03", -- 01B8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"e0",  x"f9",  x"ff", -- 01C0
         x"ff",  x"ff",  x"7f",  x"3f",  x"00",  x"70",  x"f0",  x"fc", -- 01C8
         x"f0",  x"f0",  x"e0",  x"c0",  x"00",  x"08",  x"00",  x"02", -- 01D0
         x"ff",  x"ff",  x"f9",  x"e0",  x"e6",  x"ff",  x"ff",  x"e6", -- 01D8
         x"f0",  x"fc",  x"f0",  x"70",  x"70",  x"f0",  x"f0",  x"70", -- 01E0
         x"20",  x"00",  x"0a",  x"01",  x"01",  x"1f",  x"3f",  x"7f", -- 01E8
         x"7f",  x"7f",  x"7f",  x"00",  x"00",  x"ff",  x"ff",  x"c6", -- 01F0
         x"00",  x"00",  x"c6",  x"08",  x"08",  x"ff",  x"ff",  x"3f", -- 01F8
         x"0f",  x"0f",  x"3f",  x"00",  x"00",  x"80",  x"c0",  x"e0", -- 0200
         x"e0",  x"e0",  x"e0",  x"3f",  x"1f",  x"01",  x"01",  x"00", -- 0208
         x"00",  x"00",  x"00",  x"ff",  x"ff",  x"00",  x"00",  x"00", -- 0210
         x"00",  x"00",  x"00",  x"ff",  x"ff",  x"08",  x"08",  x"00", -- 0218
         x"00",  x"00",  x"00",  x"c0",  x"80",  x"00",  x"00",  x"00", -- 0220
         x"00",  x"00",  x"00",  x"00",  x"00",  x"ff",  x"ff",  x"c6", -- 0228
         x"1f",  x"1f",  x"c6",  x"08",  x"08",  x"ff",  x"ff",  x"3f", -- 0230
         x"8f",  x"8f",  x"3f",  x"08",  x"00",  x"02",  x"00",  x"00", -- 0238
         x"00",  x"00",  x"00",  x"00",  x"04",  x"0f",  x"00",  x"00", -- 0240
         x"00",  x"00",  x"00",  x"00",  x"f8",  x"fe",  x"08",  x"00", -- 0248
         x"07",  x"00",  x"00",  x"00",  x"00",  x"00",  x"1f",  x"0f", -- 0250
         x"1f",  x"07",  x"0f",  x"3f",  x"78",  x"f8",  x"f0",  x"81", -- 0258
         x"c3",  x"ff",  x"ff",  x"ff",  x"3f",  x"3f",  x"3e",  x"ff", -- 0260
         x"f2",  x"00",  x"80",  x"80",  x"80",  x"80",  x"00",  x"00", -- 0268
         x"00",  x"1f",  x"1f",  x"1f",  x"0f",  x"07",  x"03",  x"00", -- 0270
         x"00",  x"c3",  x"ff",  x"ff",  x"fc",  x"fe",  x"f4",  x"00", -- 0278
         x"00",  x"e0",  x"c0",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0280
         x"00",  x"08",  x"00",  x"02",  x"07",  x"0f",  x"3f",  x"78", -- 0288
         x"fc",  x"ff",  x"9f",  x"cb",  x"ff",  x"ff",  x"ff",  x"3f", -- 0290
         x"3f",  x"be",  x"ff",  x"f2",  x"08",  x"00",  x"02",  x"00", -- 0298
         x"00",  x"00",  x"00",  x"00",  x"00",  x"1f",  x"7f",  x"00", -- 02A0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"20",  x"f0",  x"08", -- 02A8
         x"00",  x"04",  x"00",  x"01",  x"01",  x"01",  x"01",  x"00", -- 02B0
         x"00",  x"00",  x"ff",  x"ff",  x"ff",  x"fc",  x"fc",  x"7c", -- 02B8
         x"ff",  x"4f",  x"e0",  x"f0",  x"fc",  x"1e",  x"1f",  x"0f", -- 02C0
         x"81",  x"c3",  x"00",  x"00",  x"00",  x"00",  x"00",  x"f8", -- 02C8
         x"f0",  x"f8",  x"08",  x"00",  x"08",  x"07",  x"03",  x"00", -- 02D0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"c3",  x"ff",  x"ff", -- 02D8
         x"3f",  x"7f",  x"2f",  x"00",  x"00",  x"f8",  x"f8",  x"f8", -- 02E0
         x"f0",  x"e0",  x"c0",  x"00",  x"00",  x"ff",  x"ff",  x"ff", -- 02E8
         x"fc",  x"fc",  x"7d",  x"ff",  x"4f",  x"e0",  x"f0",  x"fc", -- 02F0
         x"1e",  x"3f",  x"ff",  x"f9",  x"d3",  x"00",  x"00",  x"00", -- 02F8
         x"00",  x"00",  x"03",  x"00",  x"00",  x"00",  x"3f",  x"7f", -- 0300
         x"ff",  x"ff",  x"ff",  x"f9",  x"e0",  x"00",  x"c0",  x"f0", -- 0308
         x"f0",  x"f0",  x"fc",  x"f0",  x"70",  x"08",  x"00",  x"03", -- 0310
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"03",  x"00", -- 0318
         x"e0",  x"f0",  x"f0",  x"e0",  x"e0",  x"f9",  x"ff",  x"ff", -- 0320
         x"70",  x"f0",  x"f0",  x"70",  x"70",  x"f0",  x"fc",  x"f0", -- 0328
         x"10",  x"00",  x"02",  x"ff",  x"7f",  x"3f",  x"00",  x"00", -- 0330
         x"00",  x"00",  x"00",  x"f0",  x"e0",  x"c0",  x"00",  x"00", -- 0338
         x"00",  x"00",  x"00",  x"08",  x"00",  x"02",  x"e6",  x"ff", -- 0340
         x"ff",  x"e6",  x"e0",  x"f9",  x"ff",  x"ff",  x"70",  x"f0", -- 0348
         x"f0",  x"70",  x"70",  x"f0",  x"fc",  x"f0",  x"20",  x"00", -- 0350
         x"0a",  x"00",  x"00",  x"01",  x"03",  x"07",  x"07",  x"07", -- 0358
         x"07",  x"10",  x"10",  x"ff",  x"ff",  x"fc",  x"f0",  x"f0", -- 0360
         x"fc",  x"00",  x"00",  x"ff",  x"ff",  x"63",  x"00",  x"00", -- 0368
         x"63",  x"80",  x"80",  x"f8",  x"fc",  x"fe",  x"fe",  x"fe", -- 0370
         x"fe",  x"03",  x"01",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0378
         x"00",  x"ff",  x"ff",  x"10",  x"10",  x"00",  x"00",  x"00", -- 0380
         x"00",  x"ff",  x"ff",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0388
         x"00",  x"fc",  x"f8",  x"80",  x"80",  x"00",  x"00",  x"00", -- 0390
         x"00",  x"10",  x"10",  x"ff",  x"ff",  x"fc",  x"f1",  x"f1", -- 0398
         x"fc",  x"00",  x"00",  x"ff",  x"ff",  x"63",  x"f8",  x"f8", -- 03A0
         x"63",  x"08",  x"00",  x"07",  x"00",  x"00",  x"00",  x"00", -- 03A8
         x"00",  x"00",  x"03",  x"07",  x"00",  x"00",  x"4f",  x"ff", -- 03B0
         x"7f",  x"ff",  x"ff",  x"83",  x"00",  x"00",  x"80",  x"e0", -- 03B8
         x"f0",  x"f8",  x"f8",  x"f8",  x"00",  x"01",  x"00",  x"01", -- 03C0
         x"01",  x"01",  x"01",  x"00",  x"0f",  x"ff",  x"f8",  x"fc", -- 03C8
         x"fc",  x"ff",  x"ff",  x"ff",  x"83",  x"03",  x"1f",  x"3f", -- 03D0
         x"3e",  x"fc",  x"f0",  x"c0",  x"f8",  x"e0",  x"f0",  x"20", -- 03D8
         x"00",  x"00",  x"00",  x"00",  x"08",  x"00",  x"02",  x"7f", -- 03E0
         x"3f",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"e0", -- 03E8
         x"40",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"08", -- 03F0
         x"00",  x"05",  x"0f",  x"ff",  x"f9",  x"fc",  x"fc",  x"ff"  -- 03F8
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;