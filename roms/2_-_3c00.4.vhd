library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom2_3c00 is
    generic(
        ADDR_WIDTH   : integer := 10
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end rom2_3c00;

architecture rtl of rom2_3c00 is
    type rom1024x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom1024x8 := (
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df", -- 0000
         x"df",  x"df",  x"df",  x"00",  x"00",  x"df",  x"df",  x"df", -- 0008
         x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"df",  x"00", -- 0010
         x"00",  x"df",  x"df",  x"e8",  x"e1",  x"00",  x"e3",  x"e2", -- 0018
         x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8", -- 0020
         x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00", -- 0028
         x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1", -- 0030
         x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8", -- 0038
         x"e1",  x"00",  x"e3",  x"e2",  x"00",  x"e8",  x"e1",  x"00", -- 0040
         x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1", -- 0048
         x"00",  x"e8",  x"e1",  x"00",  x"e8",  x"e1",  x"00",  x"e8", -- 0050
         x"e1",  x"df",  x"df",  x"e0",  x"e9",  x"00",  x"e5",  x"e4", -- 0058
         x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0", -- 0060
         x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00", -- 0068
         x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9", -- 0070
         x"00",  x"e0",  x"e9",  x"00",  x"e0",  x"e9",  x"00",  x"e0", -- 0078
         x"e9",  x"00",  x"e5",  x"e4",  x"00",  x"e0",  x"e9",  x"00", -- 0080
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
         x"df",  x"df",  x"df",  x"00",  x"00",  x"00",  x"e0",  x"e0", -- 00D8
         x"c0",  x"c0",  x"80",  x"00",  x"00",  x"00",  x"03",  x"03", -- 00E0
         x"03",  x"03",  x"07",  x"80",  x"00",  x"00",  x"00",  x"00", -- 00E8
         x"00",  x"00",  x"00",  x"07",  x"07",  x"07",  x"0e",  x"0e", -- 00F0
         x"00",  x"00",  x"00",  x"00",  x"08",  x"08",  x"1c",  x"1c", -- 00F8
         x"1c",  x"3e",  x"3e",  x"7e",  x"7f",  x"7f",  x"7e",  x"3c", -- 0100
         x"08",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0108
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0110
         x"00",  x"00",  x"00",  x"00",  x"04",  x"0e",  x"0e",  x"0f", -- 0118
         x"07",  x"03",  x"07",  x"0f",  x"1f",  x"1f",  x"1f",  x"0e", -- 0120
         x"07",  x"03",  x"00",  x"00",  x"10",  x"38",  x"38",  x"78", -- 0128
         x"70",  x"60",  x"f0",  x"f8",  x"fc",  x"fc",  x"fc",  x"38", -- 0130
         x"f0",  x"e0",  x"00",  x"00",  x"00",  x"00",  x"1e",  x"3f", -- 0138
         x"77",  x"63",  x"f0",  x"f8",  x"fc",  x"fc",  x"fc",  x"38", -- 0140
         x"70",  x"e0",  x"00",  x"00",  x"00",  x"00",  x"03",  x"07", -- 0148
         x"06",  x"06",  x"0f",  x"4f",  x"7f",  x"3f",  x"28",  x"01", -- 0150
         x"0b",  x"1e",  x"00",  x"00",  x"00",  x"00",  x"c0",  x"c0", -- 0158
         x"e4",  x"fc",  x"fc",  x"b8",  x"fe",  x"3e",  x"3e",  x"e6", -- 0160
         x"c0",  x"00",  x"00",  x"00",  x"00",  x"00",  x"03",  x"07", -- 0168
         x"06",  x"06",  x"0f",  x"4f",  x"7f",  x"3f",  x"38",  x"03", -- 0170
         x"1f",  x"00",  x"00",  x"00",  x"40",  x"c0",  x"e4",  x"e4", -- 0178
         x"ec",  x"bc",  x"b8",  x"f8",  x"fe",  x"fe",  x"fe",  x"f2", -- 0180
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"03",  x"07", -- 0188
         x"06",  x"06",  x"0f",  x"4f",  x"7f",  x"3f",  x"28",  x"01", -- 0190
         x"0b",  x"1e",  x"00",  x"00",  x"00",  x"00",  x"c0",  x"c0", -- 0198
         x"e4",  x"fc",  x"fc",  x"b8",  x"fe",  x"3e",  x"3e",  x"e6", -- 01A0
         x"c0",  x"00",  x"00",  x"00",  x"00",  x"00",  x"03",  x"07", -- 01A8
         x"06",  x"06",  x"0f",  x"4f",  x"7f",  x"3f",  x"38",  x"03", -- 01B0
         x"1f",  x"00",  x"00",  x"00",  x"40",  x"c0",  x"e4",  x"e4", -- 01B8
         x"ec",  x"bc",  x"b8",  x"f8",  x"fe",  x"fe",  x"fe",  x"f2", -- 01C0
         x"00",  x"00",  x"00",  x"30",  x"f0",  x"30",  x"f0",  x"30", -- 01C8
         x"f0",  x"30",  x"f0",  x"aa",  x"55",  x"aa",  x"55",  x"aa", -- 01D0
         x"55",  x"aa",  x"55",  x"07",  x"03",  x"01",  x"00",  x"00", -- 01D8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 01E0
         x"80",  x"c0",  x"e0",  x"00",  x"00",  x"c0",  x"00",  x"00", -- 01E8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"01",  x"00",  x"00", -- 01F0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 01F8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0200
         x"00",  x"00",  x"00",  x"00",  x"08",  x"08",  x"1c",  x"1c", -- 0208
         x"1c",  x"3e",  x"3e",  x"7e",  x"7f",  x"7f",  x"7e",  x"3c", -- 0210
         x"08",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0218
         x"01",  x"03",  x"07",  x"e0",  x"c0",  x"80",  x"00",  x"00", -- 0220
         x"00",  x"00",  x"00",  x"00",  x"04",  x"0e",  x"0e",  x"0f", -- 0228
         x"07",  x"03",  x"07",  x"0d",  x"18",  x"1d",  x"1f",  x"0e", -- 0230
         x"07",  x"03",  x"00",  x"00",  x"10",  x"38",  x"38",  x"78", -- 0238
         x"70",  x"60",  x"f0",  x"d8",  x"8c",  x"dc",  x"fc",  x"38", -- 0240
         x"f0",  x"e0",  x"00",  x"00",  x"00",  x"00",  x"1e",  x"3f", -- 0248
         x"77",  x"63",  x"f0",  x"d8",  x"ac",  x"dc",  x"fc",  x"38", -- 0250
         x"70",  x"e0",  x"00",  x"30",  x"f0",  x"30",  x"f0",  x"30", -- 0258
         x"f0",  x"30",  x"f0",  x"aa",  x"55",  x"aa",  x"55",  x"aa", -- 0260
         x"55",  x"aa",  x"55",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0268
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0270
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0278
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0280
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0288
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0290
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0298
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02A0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02A8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02B0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02B8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02C0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02C8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02D0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02D8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02E0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"03",  x"07", -- 02E8
         x"06",  x"06",  x"0f",  x"4f",  x"7f",  x"3f",  x"28",  x"01", -- 02F0
         x"0b",  x"1e",  x"00",  x"00",  x"00",  x"00",  x"c0",  x"c0", -- 02F8
         x"e4",  x"fc",  x"fc",  x"b8",  x"fe",  x"3e",  x"3e",  x"e6", -- 0300
         x"c0",  x"00",  x"00",  x"00",  x"00",  x"00",  x"03",  x"07", -- 0308
         x"06",  x"06",  x"0f",  x"4f",  x"7f",  x"3f",  x"38",  x"03", -- 0310
         x"1f",  x"00",  x"00",  x"00",  x"40",  x"c0",  x"e4",  x"e4", -- 0318
         x"ec",  x"bc",  x"b8",  x"f8",  x"fe",  x"fe",  x"fe",  x"f2", -- 0320
         x"00",  x"00",  x"00",  x"04",  x"20",  x"00",  x"10",  x"20", -- 0328
         x"10",  x"30",  x"10",  x"20",  x"10",  x"30",  x"10",  x"40", -- 0330
         x"10",  x"20",  x"10",  x"20",  x"10",  x"40",  x"00",  x"87", -- 0338
         x"01",  x"87",  x"01",  x"0c",  x"c0",  x"87",  x"01",  x"0c", -- 0340
         x"90",  x"87",  x"01",  x"30",  x"c0",  x"00",  x"10",  x"af", -- 0348
         x"82",  x"01",  x"10",  x"af",  x"82",  x"01",  x"20",  x"83", -- 0350
         x"82",  x"01",  x"00",  x"10",  x"10",  x"10",  x"20",  x"10", -- 0358
         x"30",  x"10",  x"20",  x"10",  x"40",  x"10",  x"10",  x"10", -- 0360
         x"20",  x"00",  x"10",  x"30",  x"10",  x"20",  x"00",  x"18", -- 0368
         x"00",  x"82",  x"01",  x"08",  x"00",  x"82",  x"01",  x"20", -- 0370
         x"c4",  x"82",  x"01",  x"20",  x"9c",  x"82",  x"01",  x"18", -- 0378
         x"9c",  x"82",  x"01",  x"08",  x"af",  x"82",  x"01",  x"10", -- 0380
         x"af",  x"82",  x"01",  x"10",  x"c4",  x"82",  x"01",  x"20", -- 0388
         x"af",  x"82",  x"01",  x"00",  x"10",  x"af",  x"82",  x"01", -- 0390
         x"10",  x"af",  x"82",  x"01",  x"10",  x"9c",  x"82",  x"01", -- 0398
         x"10",  x"9c",  x"82",  x"01",  x"20",  x"af",  x"82",  x"01", -- 03A0
         x"20",  x"d0",  x"82",  x"01",  x"00",  x"c1",  x"3c",  x"c3", -- 03A8
         x"3c",  x"c3",  x"3c",  x"c1",  x"3c",  x"c1",  x"3c",  x"c1", -- 03B0
         x"3c",  x"c3",  x"3c",  x"c1",  x"3c",  x"c1",  x"3c",  x"df", -- 03B8
         x"3c",  x"c3",  x"3c",  x"c1",  x"3c",  x"c1",  x"3c",  x"c1", -- 03C0
         x"3c",  x"c3",  x"3c",  x"c1",  x"3c",  x"c1",  x"3c",  x"c1", -- 03C8
         x"3c",  x"c3",  x"3c",  x"c3",  x"3c",  x"c1",  x"3c",  x"c1", -- 03D0
         x"3c",  x"c3",  x"3c",  x"c3",  x"3c",  x"c1",  x"3c",  x"c1", -- 03D8
         x"3c",  x"c3",  x"3c",  x"c3",  x"3c",  x"c1",  x"3c",  x"c1", -- 03E0
         x"3c",  x"c1",  x"3c",  x"c1",  x"3c",  x"c1",  x"3c",  x"c1", -- 03E8
         x"3c",  x"c3",  x"3c",  x"c3",  x"3c",  x"c1",  x"3c",  x"c1", -- 03F0
         x"3c",  x"c1",  x"3c",  x"c1",  x"3c",  x"c1",  x"3c",  x"c1"  -- 03F8
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;