library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom2_2c00 is
    generic(
        ADDR_WIDTH   : integer := 10
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end rom2_2c00;

architecture rtl of rom2_2c00 is
    type rom1024x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom1024x8 := (
         x"0c",  x"3c",  x"32",  x"c5",  x"0c",  x"3a",  x"c7",  x"0c", -- 0000
         x"3c",  x"fe",  x"03",  x"38",  x"02",  x"3e",  x"03",  x"32", -- 0008
         x"c7",  x"0c",  x"c9",  x"cd",  x"17",  x"2c",  x"c9",  x"2a", -- 0010
         x"cb",  x"0c",  x"7e",  x"e6",  x"f0",  x"fe",  x"f8",  x"cc", -- 0018
         x"e5",  x"2d",  x"fe",  x"f0",  x"20",  x"08",  x"cd",  x"28", -- 0020
         x"32",  x"cd",  x"73",  x"2e",  x"18",  x"c6",  x"23",  x"7e", -- 0028
         x"e6",  x"f0",  x"fe",  x"f8",  x"cc",  x"e5",  x"2d",  x"fe", -- 0030
         x"f0",  x"20",  x"08",  x"cd",  x"1a",  x"32",  x"cd",  x"73", -- 0038
         x"2e",  x"18",  x"b1",  x"09",  x"7e",  x"e6",  x"f0",  x"fe", -- 0040
         x"f8",  x"cc",  x"e5",  x"2d",  x"fe",  x"f0",  x"20",  x"08", -- 0048
         x"cd",  x"46",  x"32",  x"cd",  x"73",  x"2e",  x"18",  x"9c", -- 0050
         x"2b",  x"7e",  x"e6",  x"f0",  x"fe",  x"f8",  x"cc",  x"e5", -- 0058
         x"2d",  x"fe",  x"f0",  x"20",  x"84",  x"cd",  x"36",  x"32", -- 0060
         x"cd",  x"73",  x"2e",  x"18",  x"87",  x"23",  x"23",  x"7e", -- 0068
         x"fe",  x"e6",  x"20",  x"03",  x"09",  x"18",  x"14",  x"e6", -- 0070
         x"f0",  x"fe",  x"d0",  x"ca",  x"bc",  x"2b",  x"7e",  x"09", -- 0078
         x"e6",  x"f0",  x"fe",  x"f0",  x"28",  x"41",  x"fe",  x"f8", -- 0080
         x"cc",  x"e5",  x"2d",  x"7e",  x"fe",  x"e7",  x"28",  x"12", -- 0088
         x"e6",  x"f0",  x"fe",  x"d0",  x"ca",  x"bc",  x"2b",  x"7e", -- 0090
         x"fe",  x"e0",  x"28",  x"1b",  x"fe",  x"e5",  x"28",  x"1f", -- 0098
         x"fe",  x"e7",  x"cc",  x"47",  x"2e",  x"e6",  x"f0",  x"fe", -- 00A0
         x"f0",  x"28",  x"1c",  x"fe",  x"f8",  x"cc",  x"e5",  x"2d", -- 00A8
         x"af",  x"ed",  x"42",  x"2b",  x"c3",  x"e0",  x"2b",  x"cd", -- 00B0
         x"ee",  x"2d",  x"cd",  x"36",  x"32",  x"18",  x"f1",  x"cd", -- 00B8
         x"10",  x"2e",  x"cd",  x"36",  x"32",  x"18",  x"e9",  x"2b", -- 00C0
         x"cd",  x"46",  x"32",  x"cd",  x"73",  x"2e",  x"c3",  x"fa", -- 00C8
         x"2b",  x"2b",  x"7e",  x"e6",  x"f0",  x"fe",  x"d0",  x"ca", -- 00D0
         x"c7",  x"2b",  x"7e",  x"09",  x"e6",  x"f0",  x"fe",  x"f0", -- 00D8
         x"28",  x"4b",  x"fe",  x"f8",  x"cc",  x"e5",  x"2d",  x"7e", -- 00E0
         x"e6",  x"f0",  x"fe",  x"d0",  x"ca",  x"c7",  x"2b",  x"7e", -- 00E8
         x"fe",  x"e9",  x"28",  x"29",  x"fe",  x"e4",  x"28",  x"2d", -- 00F0
         x"e6",  x"f0",  x"fe",  x"f0",  x"28",  x"2f",  x"fe",  x"f8", -- 00F8
         x"cc",  x"e5",  x"2d",  x"09",  x"7e",  x"fe",  x"e9",  x"28", -- 0100
         x"05",  x"af",  x"ed",  x"42",  x"18",  x"09",  x"cd",  x"ee", -- 0108
         x"2d",  x"cd",  x"46",  x"32",  x"af",  x"ed",  x"42",  x"af", -- 0110
         x"ed",  x"42",  x"c3",  x"e0",  x"2b",  x"cd",  x"ee",  x"2d", -- 0118
         x"cd",  x"46",  x"32",  x"18",  x"f2",  x"cd",  x"10",  x"2e", -- 0120
         x"cd",  x"46",  x"32",  x"18",  x"ea",  x"23",  x"cd",  x"36", -- 0128
         x"32",  x"cd",  x"73",  x"2e",  x"c3",  x"fa",  x"2b",  x"af", -- 0130
         x"ed",  x"42",  x"7e",  x"e6",  x"f0",  x"fe",  x"d0",  x"ca", -- 0138
         x"d2",  x"2b",  x"7e",  x"23",  x"e6",  x"f0",  x"fe",  x"f0", -- 0140
         x"28",  x"35",  x"fe",  x"f8",  x"cc",  x"e5",  x"2d",  x"7e", -- 0148
         x"e6",  x"f0",  x"fe",  x"d0",  x"ca",  x"d2",  x"2b",  x"7e", -- 0150
         x"fe",  x"e9",  x"28",  x"13",  x"fe",  x"e4",  x"28",  x"17", -- 0158
         x"e6",  x"f0",  x"fe",  x"f0",  x"28",  x"19",  x"fe",  x"f8", -- 0160
         x"cc",  x"e5",  x"2d",  x"2b",  x"c3",  x"e0",  x"2b",  x"cd", -- 0168
         x"ee",  x"2d",  x"cd",  x"46",  x"32",  x"18",  x"f4",  x"cd", -- 0170
         x"10",  x"2e",  x"cd",  x"46",  x"32",  x"18",  x"ec",  x"01", -- 0178
         x"40",  x"00",  x"09",  x"cd",  x"1a",  x"32",  x"cd",  x"73", -- 0180
         x"2e",  x"c3",  x"fa",  x"2b",  x"09",  x"09",  x"7e",  x"e6", -- 0188
         x"f0",  x"fe",  x"d0",  x"ca",  x"13",  x"2c",  x"7e",  x"23", -- 0190
         x"e6",  x"f0",  x"fe",  x"f0",  x"28",  x"38",  x"fe",  x"f8", -- 0198
         x"cc",  x"e5",  x"2d",  x"7e",  x"e6",  x"f0",  x"fe",  x"d0", -- 01A0
         x"ca",  x"13",  x"2c",  x"7e",  x"fe",  x"e1",  x"28",  x"16", -- 01A8
         x"fe",  x"e2",  x"28",  x"1a",  x"e6",  x"f0",  x"fe",  x"f0", -- 01B0
         x"28",  x"1c",  x"fe",  x"f8",  x"cc",  x"e5",  x"2d",  x"2b", -- 01B8
         x"af",  x"ed",  x"42",  x"c3",  x"e0",  x"2b",  x"cd",  x"ee", -- 01C0
         x"2d",  x"cd",  x"1a",  x"32",  x"18",  x"f1",  x"cd",  x"10", -- 01C8
         x"2e",  x"cd",  x"1a",  x"32",  x"18",  x"e9",  x"af",  x"01", -- 01D0
         x"40",  x"00",  x"ed",  x"42",  x"cd",  x"46",  x"32",  x"cd", -- 01D8
         x"73",  x"2e",  x"c3",  x"fa",  x"2b",  x"3a",  x"cd",  x"0c", -- 01E0
         x"00",  x"32",  x"cd",  x"0c",  x"af",  x"c9",  x"ed",  x"5b", -- 01E8
         x"18",  x"0c",  x"3a",  x"c8",  x"0c",  x"13",  x"3d",  x"ed", -- 01F0
         x"53",  x"18",  x"0c",  x"32",  x"c8",  x"0c",  x"01",  x"40", -- 01F8
         x"00",  x"3a",  x"cd",  x"0c",  x"cb",  x"47",  x"c0",  x"e5", -- 0200
         x"21",  x"2b",  x"3f",  x"cd",  x"d4",  x"01",  x"e1",  x"c9", -- 0208
         x"ed",  x"5b",  x"18",  x"0c",  x"3a",  x"c8",  x"0c",  x"13", -- 0210
         x"13",  x"13",  x"13",  x"13",  x"3d",  x"ed",  x"53",  x"18", -- 0218
         x"0c",  x"32",  x"c8",  x"0c",  x"01",  x"40",  x"00",  x"e5", -- 0220
         x"21",  x"2e",  x"3f",  x"cd",  x"d4",  x"01",  x"06",  x"03", -- 0228
         x"21",  x"68",  x"0c",  x"23",  x"23",  x"23",  x"23",  x"23", -- 0230
         x"cb",  x"d6",  x"23",  x"10",  x"f6",  x"3a",  x"cd",  x"0c", -- 0238
         x"cb",  x"c7",  x"32",  x"cd",  x"0c",  x"e1",  x"c9",  x"ed", -- 0240
         x"5b",  x"18",  x"0c",  x"13",  x"13",  x"13",  x"13",  x"13", -- 0248
         x"13",  x"13",  x"ed",  x"53",  x"18",  x"0c",  x"3e",  x"dc", -- 0250
         x"32",  x"98",  x"fb",  x"3a",  x"cd",  x"0c",  x"cb",  x"47", -- 0258
         x"20",  x"09",  x"e5",  x"21",  x"6a",  x"3f",  x"cd",  x"d4", -- 0260
         x"01",  x"e1",  x"c9",  x"13",  x"13",  x"13",  x"ed",  x"53", -- 0268
         x"18",  x"0c",  x"c9",  x"3a",  x"1a",  x"0c",  x"3d",  x"fe", -- 0270
         x"04",  x"38",  x"01",  x"af",  x"32",  x"1a",  x"0c",  x"3e", -- 0278
         x"ff",  x"32",  x"e5",  x"0c",  x"cd",  x"b8",  x"29",  x"cd", -- 0280
         x"65",  x"32",  x"cd",  x"30",  x"2b",  x"21",  x"4e",  x"3f", -- 0288
         x"cd",  x"e0",  x"01",  x"cd",  x"de",  x"2a",  x"c9",  x"21", -- 0290
         x"9a",  x"34",  x"11",  x"00",  x"f8",  x"01",  x"40",  x"00", -- 0298
         x"ed",  x"b0",  x"62",  x"6b",  x"13",  x"36",  x"00",  x"01", -- 02A0
         x"bf",  x"07",  x"ed",  x"b0",  x"11",  x"40",  x"f8",  x"21", -- 02A8
         x"da",  x"34",  x"01",  x"00",  x"04",  x"ed",  x"b0",  x"cd", -- 02B0
         x"56",  x"32",  x"c9",  x"21",  x"43",  x"0c",  x"35",  x"c0", -- 02B8
         x"36",  x"02",  x"3a",  x"c7",  x"0c",  x"47",  x"21",  x"68", -- 02C0
         x"0c",  x"dd",  x"21",  x"d1",  x"0c",  x"22",  x"93",  x"0c", -- 02C8
         x"22",  x"97",  x"0c",  x"c5",  x"cd",  x"e4",  x"2e",  x"c1", -- 02D0
         x"2a",  x"93",  x"0c",  x"23",  x"23",  x"23",  x"23",  x"23", -- 02D8
         x"23",  x"10",  x"ea",  x"c9",  x"2a",  x"93",  x"0c",  x"cd", -- 02E0
         x"f6",  x"31",  x"cd",  x"06",  x"2f",  x"cd",  x"92",  x"0c", -- 02E8
         x"cd",  x"28",  x"32",  x"cd",  x"2f",  x"33",  x"cd",  x"ce", -- 02F0
         x"32",  x"cd",  x"92",  x"0c",  x"cd",  x"f0",  x"32",  x"cd", -- 02F8
         x"30",  x"2b",  x"cd",  x"17",  x"2c",  x"c9",  x"0e",  x"00", -- 0300
         x"11",  x"40",  x"00",  x"cd",  x"92",  x"0c",  x"23",  x"23", -- 0308
         x"06",  x"d0",  x"7e",  x"fe",  x"e6",  x"28",  x"05",  x"e6", -- 0310
         x"f0",  x"b8",  x"20",  x"02",  x"cb",  x"c1",  x"fe",  x"f0", -- 0318
         x"20",  x"02",  x"cb",  x"c1",  x"19",  x"7e",  x"e6",  x"f0", -- 0320
         x"b8",  x"20",  x"02",  x"cb",  x"c1",  x"fe",  x"f0",  x"20", -- 0328
         x"02",  x"cb",  x"c1",  x"2b",  x"2b",  x"2b",  x"7e",  x"fe", -- 0330
         x"df",  x"20",  x"02",  x"cb",  x"c9",  x"fe",  x"de",  x"20", -- 0338
         x"02",  x"cb",  x"e1",  x"e6",  x"f0",  x"fe",  x"f0",  x"20", -- 0340
         x"02",  x"cb",  x"c9",  x"af",  x"ed",  x"52",  x"7e",  x"fe", -- 0348
         x"df",  x"20",  x"02",  x"cb",  x"c9",  x"fe",  x"de",  x"20", -- 0350
         x"02",  x"cb",  x"e1",  x"e6",  x"f0",  x"fe",  x"f0",  x"20", -- 0358
         x"02",  x"cb",  x"c9",  x"23",  x"af",  x"ed",  x"52",  x"7e", -- 0360
         x"e6",  x"f0",  x"b8",  x"20",  x"02",  x"cb",  x"d1",  x"fe", -- 0368
         x"f0",  x"20",  x"02",  x"cb",  x"d1",  x"23",  x"7e",  x"e6", -- 0370
         x"f0",  x"b8",  x"20",  x"02",  x"cb",  x"d1",  x"fe",  x"f0", -- 0378
         x"20",  x"02",  x"cb",  x"d1",  x"19",  x"19",  x"19",  x"7e", -- 0380
         x"e6",  x"f0",  x"b8",  x"20",  x"02",  x"cb",  x"d9",  x"fe", -- 0388
         x"f0",  x"20",  x"02",  x"cb",  x"d9",  x"2b",  x"7e",  x"e6", -- 0390
         x"f0",  x"b8",  x"20",  x"02",  x"cb",  x"d9",  x"fe",  x"f0", -- 0398
         x"20",  x"02",  x"cb",  x"d9",  x"2a",  x"93",  x"0c",  x"23", -- 03A0
         x"23",  x"23",  x"23",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03A8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03B0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03B8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03C0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03C8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03D0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03D8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03E0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03E8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 03F0
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00"  -- 03F8
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;
