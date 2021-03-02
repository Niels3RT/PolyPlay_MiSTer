library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom2_1c00 is
    generic(
        ADDR_WIDTH   : integer := 10
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end rom2_1c00;

architecture rtl of rom2_1c00 is
    type rom1024x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom1024x8 := (
         x"cd",  x"b7",  x"02",  x"21",  x"10",  x"00",  x"11",  x"69", -- 0000
         x"24",  x"01",  x"60",  x"01",  x"cd",  x"c8",  x"02",  x"21", -- 0008
         x"10",  x"00",  x"11",  x"c9",  x"25",  x"01",  x"43",  x"01", -- 0010
         x"cd",  x"ce",  x"02",  x"11",  x"0c",  x"27",  x"21",  x"18", -- 0018
         x"00",  x"01",  x"01",  x"00",  x"cd",  x"d4",  x"02",  x"21", -- 0020
         x"22",  x"00",  x"03",  x"cd",  x"d4",  x"02",  x"21",  x"2d", -- 0028
         x"00",  x"0e",  x"03",  x"cd",  x"d4",  x"02",  x"21",  x"32", -- 0030
         x"00",  x"0e",  x"03",  x"cd",  x"d4",  x"02",  x"21",  x"35", -- 0038
         x"00",  x"0e",  x"08",  x"cd",  x"d4",  x"02",  x"21",  x"c3", -- 0040
         x"0c",  x"11",  x"ae",  x"0c",  x"b7",  x"ed",  x"52",  x"44", -- 0048
         x"4d",  x"13",  x"21",  x"ae",  x"0c",  x"36",  x"00",  x"ed", -- 0050
         x"b0",  x"3e",  x"80",  x"32",  x"56",  x"0c",  x"cd",  x"b7", -- 0058
         x"01",  x"3e",  x"04",  x"cd",  x"3e",  x"1d",  x"21",  x"00", -- 0060
         x"f8",  x"11",  x"40",  x"00",  x"19",  x"54",  x"5d",  x"13", -- 0068
         x"36",  x"20",  x"01",  x"3f",  x"00",  x"ed",  x"b0",  x"21", -- 0070
         x"70",  x"23",  x"11",  x"b9",  x"0c",  x"01",  x"06",  x"00", -- 0078
         x"ed",  x"b0",  x"3e",  x"0a",  x"32",  x"c2",  x"0c",  x"cd", -- 0080
         x"60",  x"1f",  x"af",  x"32",  x"bf",  x"0c",  x"3c",  x"32", -- 0088
         x"c0",  x"0c",  x"cd",  x"47",  x"21",  x"21",  x"00",  x"f8", -- 0090
         x"11",  x"40",  x"04",  x"19",  x"11",  x"57",  x"22",  x"eb", -- 0098
         x"01",  x"40",  x"00",  x"ed",  x"b0",  x"eb",  x"01",  x"40", -- 00A0
         x"00",  x"09",  x"eb",  x"01",  x"27",  x"00",  x"ed",  x"b0", -- 00A8
         x"eb",  x"01",  x"59",  x"00",  x"09",  x"eb",  x"01",  x"36", -- 00B0
         x"00",  x"ed",  x"b0",  x"eb",  x"01",  x"4a",  x"00",  x"09", -- 00B8
         x"eb",  x"01",  x"38",  x"00",  x"ed",  x"b0",  x"eb",  x"01", -- 00C0
         x"48",  x"00",  x"09",  x"eb",  x"01",  x"22",  x"00",  x"ed", -- 00C8
         x"b0",  x"eb",  x"01",  x"76",  x"00",  x"09",  x"eb",  x"01", -- 00D0
         x"10",  x"00",  x"ed",  x"b0",  x"eb",  x"01",  x"aa",  x"00", -- 00D8
         x"09",  x"eb",  x"21",  x"0a",  x"03",  x"01",  x"1c",  x"00", -- 00E0
         x"ed",  x"b0",  x"cd",  x"9a",  x"01",  x"c2",  x"f1",  x"00", -- 00E8
         x"cd",  x"04",  x"1e",  x"cd",  x"c7",  x"01",  x"cd",  x"c7", -- 00F0
         x"01",  x"3a",  x"03",  x"0c",  x"b7",  x"28",  x"eb",  x"cd", -- 00F8
         x"76",  x"1d",  x"3e",  x"80",  x"32",  x"56",  x"0c",  x"21", -- 0100
         x"00",  x"24",  x"cd",  x"d4",  x"01",  x"21",  x"00",  x"f8", -- 0108
         x"11",  x"0b",  x"04",  x"19",  x"11",  x"30",  x"22",  x"01", -- 0110
         x"27",  x"00",  x"eb",  x"ed",  x"b0",  x"eb",  x"2b",  x"3e", -- 0118
         x"01",  x"cd",  x"ca",  x"01",  x"54",  x"5d",  x"1b",  x"01", -- 0120
         x"26",  x"00",  x"ed",  x"b8",  x"3e",  x"01",  x"cd",  x"ca", -- 0128
         x"01",  x"3a",  x"59",  x"0c",  x"b7",  x"20",  x"d6",  x"af", -- 0130
         x"32",  x"03",  x"0c",  x"c3",  x"f1",  x"00",  x"21",  x"f0", -- 0138
         x"21",  x"11",  x"00",  x"f8",  x"01",  x"40",  x"00",  x"ed", -- 0140
         x"b0",  x"21",  x"5e",  x"23",  x"f5",  x"01",  x"00",  x"f8", -- 0148
         x"5e",  x"23",  x"56",  x"23",  x"eb",  x"09",  x"36",  x"ab", -- 0150
         x"eb",  x"3d",  x"20",  x"f4",  x"21",  x"00",  x"f8",  x"f1", -- 0158
         x"01",  x"40",  x"00",  x"09",  x"44",  x"4d",  x"21",  x"5e", -- 0160
         x"23",  x"5e",  x"23",  x"56",  x"23",  x"eb",  x"09",  x"36", -- 0168
         x"ac",  x"eb",  x"3d",  x"20",  x"f4",  x"c9",  x"cd",  x"b7", -- 0170
         x"01",  x"21",  x"00",  x"00",  x"22",  x"18",  x"0c",  x"22", -- 0178
         x"b9",  x"0c",  x"2a",  x"00",  x"0c",  x"23",  x"22",  x"00", -- 0180
         x"0c",  x"3e",  x"09",  x"cd",  x"3e",  x"1d",  x"21",  x"ab", -- 0188
         x"23",  x"11",  x"ae",  x"0c",  x"01",  x"05",  x"00",  x"ed", -- 0190
         x"b0",  x"11",  x"00",  x"f8",  x"2a",  x"ae",  x"0c",  x"19", -- 0198
         x"22",  x"ae",  x"0c",  x"cd",  x"2e",  x"20",  x"cd",  x"04", -- 01A0
         x"1e",  x"21",  x"0a",  x"00",  x"22",  x"1c",  x"0c",  x"af", -- 01A8
         x"32",  x"bf",  x"0c",  x"3e",  x"0a",  x"3c",  x"32",  x"c0", -- 01B0
         x"0c",  x"3e",  x"19",  x"32",  x"c4",  x"0c",  x"cd",  x"47", -- 01B8
         x"21",  x"21",  x"c3",  x"23",  x"cd",  x"e0",  x"01",  x"3e", -- 01C0
         x"e0",  x"32",  x"56",  x"0c",  x"cd",  x"5a",  x"21",  x"cd", -- 01C8
         x"04",  x"1e",  x"cd",  x"c7",  x"01",  x"21",  x"c3",  x"0c", -- 01D0
         x"7e",  x"b7",  x"28",  x"01",  x"35",  x"cd",  x"ad",  x"1f", -- 01D8
         x"cd",  x"81",  x"20",  x"20",  x"e7",  x"3a",  x"1c",  x"0c", -- 01E0
         x"b7",  x"28",  x"05",  x"cd",  x"fa",  x"20",  x"18",  x"dc", -- 01E8
         x"2a",  x"06",  x"0c",  x"ed",  x"5b",  x"18",  x"0c",  x"b7", -- 01F0
         x"ed",  x"52",  x"30",  x"04",  x"ed",  x"53",  x"06",  x"0c", -- 01F8
         x"cd",  x"47",  x"21",  x"c9",  x"cd",  x"c6",  x"1e",  x"21", -- 0200
         x"c2",  x"0c",  x"7e",  x"b7",  x"28",  x"0c",  x"35",  x"3e", -- 0208
         x"05",  x"be",  x"c0",  x"21",  x"88",  x"23",  x"cd",  x"63", -- 0210
         x"1f",  x"c9",  x"3e",  x"0a",  x"77",  x"2a",  x"b9",  x"0c", -- 0218
         x"7c",  x"b7",  x"20",  x"4e",  x"db",  x"83",  x"47",  x"e6", -- 0220
         x"60",  x"0e",  x"01",  x"28",  x"3d",  x"0e",  x"1d",  x"fe", -- 0228
         x"20",  x"28",  x"37",  x"0e",  x"00",  x"fe",  x"40",  x"28", -- 0230
         x"02",  x"0e",  x"3d",  x"78",  x"e6",  x"0e",  x"87",  x"20", -- 0238
         x"01",  x"3c",  x"47",  x"ed",  x"43",  x"48",  x"0c",  x"db", -- 0240
         x"83",  x"e6",  x"07",  x"32",  x"bd",  x"0c",  x"db",  x"83", -- 0248
         x"e6",  x"78",  x"0f",  x"0f",  x"0f",  x"32",  x"be",  x"0c", -- 0250
         x"cd",  x"6a",  x"20",  x"21",  x"46",  x"0c",  x"11",  x"b9", -- 0258
         x"0c",  x"01",  x"04",  x"00",  x"ed",  x"b0",  x"cd",  x"60", -- 0260
         x"1f",  x"c9",  x"78",  x"41",  x"e6",  x"1e",  x"87",  x"4f", -- 0268
         x"18",  x"d1",  x"3a",  x"be",  x"0c",  x"b7",  x"20",  x"0c", -- 0270
         x"db",  x"83",  x"e6",  x"07",  x"32",  x"bd",  x"0c",  x"db", -- 0278
         x"83",  x"e6",  x"0f",  x"3c",  x"3d",  x"32",  x"be",  x"0c", -- 0280
         x"3a",  x"bd",  x"0c",  x"e6",  x"07",  x"87",  x"21",  x"b0", -- 0288
         x"23",  x"85",  x"6f",  x"30",  x"01",  x"24",  x"3a",  x"bb", -- 0290
         x"0c",  x"86",  x"e6",  x"3f",  x"fe",  x"3e",  x"30",  x"f9", -- 0298
         x"32",  x"48",  x"0c",  x"23",  x"3a",  x"bc",  x"0c",  x"86", -- 02A0
         x"e6",  x"1f",  x"fe",  x"01",  x"38",  x"f9",  x"fe",  x"1e", -- 02A8
         x"30",  x"f5",  x"32",  x"49",  x"0c",  x"cd",  x"6a",  x"20", -- 02B0
         x"cd",  x"44",  x"1f",  x"cd",  x"90",  x"1f",  x"28",  x"9b", -- 02B8
         x"af",  x"32",  x"be",  x"0c",  x"18",  x"a0",  x"3a",  x"ba", -- 02C0
         x"0c",  x"b7",  x"c8",  x"cd",  x"04",  x"1f",  x"c8",  x"2a", -- 02C8
         x"18",  x"0c",  x"23",  x"22",  x"18",  x"0c",  x"21",  x"1c", -- 02D0
         x"0c",  x"34",  x"21",  x"56",  x"0c",  x"7e",  x"fe",  x"03", -- 02D8
         x"38",  x"03",  x"35",  x"35",  x"35",  x"cd",  x"5a",  x"21", -- 02E0
         x"2a",  x"b9",  x"0c",  x"11",  x"9a",  x"23",  x"cd",  x"72", -- 02E8
         x"1f",  x"21",  x"47",  x"24",  x"cd",  x"e0",  x"01",  x"21", -- 02F0
         x"00",  x"00",  x"cd",  x"44",  x"1f",  x"21",  x"00",  x"00", -- 02F8
         x"22",  x"b9",  x"0c",  x"c9",  x"21",  x"88",  x"23",  x"3a", -- 0300
         x"c2",  x"0c",  x"fe",  x"05",  x"28",  x"05",  x"38",  x"03", -- 0308
         x"21",  x"76",  x"23",  x"11",  x"00",  x"00",  x"3a",  x"bd", -- 0310
         x"0c",  x"cb",  x"47",  x"28",  x"03",  x"11",  x"09",  x"00", -- 0318
         x"19",  x"eb",  x"2a",  x"b9",  x"0c",  x"01",  x"3e",  x"00", -- 0320
         x"cd",  x"36",  x"1f",  x"c0",  x"09",  x"cd",  x"36",  x"1f", -- 0328
         x"c0",  x"09",  x"cd",  x"36",  x"1f",  x"c9",  x"1a",  x"be", -- 0330
         x"c0",  x"13",  x"23",  x"1a",  x"be",  x"c0",  x"13",  x"23", -- 0338
         x"1a",  x"13",  x"be",  x"c9",  x"2a",  x"b9",  x"0c",  x"7c", -- 0340
         x"b7",  x"c8",  x"af",  x"01",  x"3e",  x"00",  x"cd",  x"5a", -- 0348
         x"1f",  x"09",  x"cd",  x"5a",  x"1f",  x"09",  x"cd",  x"5a", -- 0350
         x"1f",  x"c9",  x"77",  x"23",  x"77",  x"23",  x"77",  x"c9", -- 0358
         x"21",  x"76",  x"23",  x"11",  x"00",  x"00",  x"3a",  x"bd", -- 0360
         x"0c",  x"cb",  x"47",  x"28",  x"03",  x"11",  x"09",  x"00", -- 0368
         x"19",  x"eb",  x"2a",  x"b9",  x"0c",  x"01",  x"3e",  x"00", -- 0370
         x"cd",  x"84",  x"1f",  x"09",  x"cd",  x"84",  x"1f",  x"09", -- 0378
         x"cd",  x"84",  x"1f",  x"c9",  x"1a",  x"77",  x"13",  x"23", -- 0380
         x"1a",  x"77",  x"13",  x"23",  x"1a",  x"77",  x"13",  x"c9", -- 0388
         x"2a",  x"46",  x"0c",  x"01",  x"3e",  x"00",  x"af",  x"cd", -- 0390
         x"a5",  x"1f",  x"c0",  x"09",  x"cd",  x"a5",  x"1f",  x"c0", -- 0398
         x"09",  x"cd",  x"a5",  x"1f",  x"c9",  x"be",  x"c0",  x"23", -- 03A0
         x"be",  x"c0",  x"23",  x"be",  x"c9",  x"21",  x"c1",  x"0c", -- 03A8
         x"7e",  x"b7",  x"28",  x"02",  x"35",  x"c9",  x"21",  x"ae", -- 03B0
         x"0c",  x"11",  x"46",  x"0c",  x"01",  x"05",  x"00",  x"ed", -- 03B8
         x"b0",  x"db",  x"84",  x"e6",  x"1e",  x"c8",  x"01",  x"01", -- 03C0
         x"00",  x"1e",  x"00",  x"cb",  x"4f",  x"cc",  x"0d",  x"20", -- 03C8
         x"1e",  x"01",  x"01",  x"ff",  x"00",  x"cb",  x"57",  x"cc", -- 03D0
         x"0d",  x"20",  x"1e",  x"02",  x"01",  x"00",  x"ff",  x"cb", -- 03D8
         x"5f",  x"cc",  x"11",  x"20",  x"1e",  x"03",  x"01",  x"00", -- 03E0
         x"01",  x"cb",  x"67",  x"cc",  x"11",  x"20",  x"cd",  x"6a", -- 03E8
         x"20",  x"cd",  x"4b",  x"20",  x"cd",  x"5a",  x"20",  x"20", -- 03F0
         x"10",  x"01",  x"05",  x"00",  x"11",  x"ae",  x"0c",  x"21"  -- 03F8
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;
