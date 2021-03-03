library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom2_4400 is
    generic(
        ADDR_WIDTH   : integer := 10
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end rom2_4400;

architecture rtl of rom2_4400 is
    type rom1024x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom1024x8 := (
         x"18",  x"e7",  x"7d",  x"c6",  x"02",  x"e6",  x"3f",  x"20", -- 0000
         x"b9",  x"79",  x"f6",  x"01",  x"4f",  x"18",  x"b3",  x"d5", -- 0008
         x"e5",  x"f5",  x"11",  x"c0",  x"ff",  x"19",  x"7d",  x"dd", -- 0010
         x"cb",  x"02",  x"5e",  x"20",  x"26",  x"11",  x"01",  x"00", -- 0018
         x"c6",  x"fe",  x"6f",  x"cd",  x"35",  x"44",  x"19",  x"cd", -- 0020
         x"35",  x"44",  x"11",  x"40",  x"00",  x"19",  x"cd",  x"35", -- 0028
         x"44",  x"f1",  x"e1",  x"d1",  x"c9",  x"3e",  x"80",  x"be", -- 0030
         x"30",  x"04",  x"3e",  x"91",  x"be",  x"d0",  x"0e",  x"01", -- 0038
         x"f1",  x"18",  x"ee",  x"c6",  x"04",  x"11",  x"ff",  x"ff", -- 0040
         x"18",  x"d8",  x"e5",  x"ed",  x"5f",  x"e6",  x"07",  x"f5", -- 0048
         x"21",  x"c7",  x"47",  x"85",  x"6f",  x"30",  x"01",  x"24", -- 0050
         x"ed",  x"a0",  x"f1",  x"cb",  x"3f",  x"c6",  x"04",  x"12", -- 0058
         x"13",  x"3e",  x"00",  x"12",  x"13",  x"e1",  x"af",  x"12", -- 0060
         x"13",  x"c5",  x"06",  x"04",  x"3e",  x"81",  x"12",  x"13", -- 0068
         x"10",  x"fa",  x"c1",  x"c9",  x"e1",  x"5e",  x"23",  x"56", -- 0070
         x"23",  x"e5",  x"d5",  x"e1",  x"5e",  x"23",  x"56",  x"23", -- 0078
         x"4e",  x"06",  x"00",  x"23",  x"ed",  x"b0",  x"c9",  x"c5", -- 0080
         x"01",  x"ff",  x"06",  x"0b",  x"3a",  x"bf",  x"0c",  x"b7", -- 0088
         x"20",  x"50",  x"3e",  x"4d",  x"32",  x"bf",  x"0c",  x"e5", -- 0090
         x"21",  x"e9",  x"47",  x"cd",  x"d4",  x"01",  x"c5",  x"01", -- 0098
         x"13",  x"00",  x"3e",  x"20",  x"21",  x"40",  x"f8",  x"ed", -- 00A0
         x"b9",  x"23",  x"23",  x"3e",  x"81",  x"be",  x"20",  x"09", -- 00A8
         x"c5",  x"06",  x"0f",  x"2b",  x"36",  x"ce",  x"10",  x"fb", -- 00B0
         x"c1",  x"3a",  x"38",  x"0d",  x"c6",  x"02",  x"2f",  x"e6", -- 00B8
         x"03",  x"e5",  x"21",  x"9d",  x"47",  x"85",  x"6f",  x"30", -- 00C0
         x"01",  x"24",  x"7e",  x"e1",  x"77",  x"c1",  x"21",  x"28", -- 00C8
         x"f8",  x"22",  x"3f",  x"0c",  x"3a",  x"38",  x"0d",  x"3d", -- 00D0
         x"32",  x"38",  x"0d",  x"32",  x"3d",  x"0c",  x"cd",  x"70", -- 00D8
         x"02",  x"e1",  x"78",  x"b1",  x"c2",  x"8b",  x"44",  x"c1", -- 00E0
         x"3a",  x"38",  x"0d",  x"b7",  x"c9",  x"da",  x"2d",  x"46", -- 00E8
         x"fd",  x"36",  x"00",  x"ff",  x"3a",  x"39",  x"0d",  x"b7", -- 00F0
         x"c0",  x"3e",  x"81",  x"cd",  x"1a",  x"43",  x"dd",  x"cb", -- 00F8
         x"02",  x"5e",  x"c2",  x"14",  x"46",  x"21",  x"fd",  x"ff", -- 0100
         x"19",  x"11",  x"39",  x"0d",  x"01",  x"03",  x"00",  x"ed", -- 0108
         x"b0",  x"01",  x"03",  x"00",  x"2b",  x"eb",  x"21",  x"55", -- 0110
         x"48",  x"ed",  x"b8",  x"dd",  x"e5",  x"e5",  x"c5",  x"d5", -- 0118
         x"13",  x"dd",  x"cb",  x"02",  x"5e",  x"28",  x"01",  x"13", -- 0120
         x"06",  x"05",  x"eb",  x"11",  x"0a",  x"00",  x"dd",  x"21", -- 0128
         x"f6",  x"0c",  x"dd",  x"19",  x"dd",  x"7e",  x"00",  x"bd", -- 0130
         x"20",  x"06",  x"dd",  x"7e",  x"01",  x"bc",  x"28",  x"5c", -- 0138
         x"10",  x"f0",  x"eb",  x"21",  x"39",  x"0d",  x"06",  x"03", -- 0140
         x"3e",  x"91",  x"be",  x"30",  x"05",  x"3e",  x"b5",  x"be", -- 0148
         x"30",  x"0f",  x"23",  x"10",  x"f3",  x"d1",  x"c1",  x"e1", -- 0150
         x"dd",  x"e1",  x"21",  x"f3",  x"47",  x"cd",  x"d4",  x"01", -- 0158
         x"c9",  x"7e",  x"eb",  x"01",  x"c0",  x"ff",  x"23",  x"cb", -- 0160
         x"4f",  x"20",  x"01",  x"09",  x"cb",  x"47",  x"28",  x"02", -- 0168
         x"2b",  x"2b",  x"eb",  x"18",  x"b3",  x"dd",  x"e5",  x"dd", -- 0170
         x"21",  x"00",  x"0d",  x"06",  x"05",  x"11",  x"0a",  x"00", -- 0178
         x"dd",  x"36",  x"05",  x"00",  x"dd",  x"19",  x"10",  x"f8", -- 0180
         x"dd",  x"e1",  x"dd",  x"5e",  x"00",  x"dd",  x"56",  x"01", -- 0188
         x"dd",  x"36",  x"03",  x"0f",  x"fd",  x"36",  x"00",  x"ff", -- 0190
         x"cd",  x"2d",  x"46",  x"c9",  x"21",  x"ec",  x"47",  x"cd", -- 0198
         x"e0",  x"01",  x"dd",  x"7e",  x"02",  x"d1",  x"f5",  x"dd", -- 01A0
         x"e5",  x"dd",  x"21",  x"32",  x"0d",  x"cd",  x"8a",  x"45", -- 01A8
         x"eb",  x"dd",  x"e1",  x"cd",  x"ad",  x"42",  x"cd",  x"d3", -- 01B0
         x"46",  x"f1",  x"c1",  x"e1",  x"dd",  x"21",  x"3c",  x"0d", -- 01B8
         x"cd",  x"d0",  x"42",  x"2a",  x"3c",  x"0d",  x"2b",  x"f5", -- 01C0
         x"3e",  x"7f",  x"a5",  x"20",  x"07",  x"7d",  x"d6",  x"41", -- 01C8
         x"6f",  x"30",  x"01",  x"25",  x"f1",  x"2b",  x"36",  x"de", -- 01D0
         x"2b",  x"36",  x"de",  x"22",  x"3c",  x"0d",  x"01",  x"08", -- 01D8
         x"00",  x"21",  x"c7",  x"47",  x"ed",  x"b1",  x"3e",  x"07", -- 01E0
         x"91",  x"fe",  x"04",  x"38",  x"14",  x"fe",  x"06",  x"38", -- 01E8
         x"0c",  x"fe",  x"07",  x"38",  x"04",  x"3e",  x"3c",  x"18", -- 01F0
         x"0a",  x"3e",  x"28",  x"18",  x"06",  x"3e",  x"14",  x"18", -- 01F8
         x"02",  x"3e",  x"0a",  x"4f",  x"06",  x"00",  x"2a",  x"18", -- 0200
         x"0c",  x"09",  x"22",  x"18",  x"0c",  x"dd",  x"e1",  x"cd", -- 0208
         x"75",  x"45",  x"eb",  x"c9",  x"21",  x"03",  x"00",  x"19", -- 0210
         x"11",  x"39",  x"0d",  x"01",  x"03",  x"00",  x"ed",  x"b0", -- 0218
         x"01",  x"03",  x"00",  x"2b",  x"eb",  x"21",  x"58",  x"48", -- 0220
         x"ed",  x"b8",  x"c3",  x"1b",  x"45",  x"3a",  x"39",  x"0d", -- 0228
         x"b7",  x"c8",  x"01",  x"03",  x"00",  x"fd",  x"36",  x"00", -- 0230
         x"ff",  x"d5",  x"dd",  x"cb",  x"02",  x"5e",  x"20",  x"0f", -- 0238
         x"21",  x"fd",  x"ff",  x"19",  x"eb",  x"21",  x"39",  x"0d", -- 0240
         x"ed",  x"b0",  x"e1",  x"cd",  x"8e",  x"43",  x"c9",  x"21", -- 0248
         x"03",  x"00",  x"18",  x"ef",  x"2a",  x"d9",  x"47",  x"af", -- 0250
         x"dd",  x"be",  x"02",  x"20",  x"0e",  x"3e",  x"81",  x"cd", -- 0258
         x"1a",  x"43",  x"dd",  x"36",  x"02",  x"0c",  x"cd",  x"97", -- 0260
         x"46",  x"18",  x"1b",  x"19",  x"3e",  x"81",  x"cd",  x"12", -- 0268
         x"43",  x"06",  x"81",  x"cd",  x"d6",  x"43",  x"38",  x"17", -- 0270
         x"04",  x"cd",  x"d6",  x"43",  x"28",  x"11",  x"dd",  x"75", -- 0278
         x"00",  x"dd",  x"74",  x"01",  x"e5",  x"d1",  x"3e",  x"b6", -- 0280
         x"dd",  x"86",  x"02",  x"cd",  x"f0",  x"42",  x"c9",  x"21", -- 0288
         x"33",  x"48",  x"cd",  x"d4",  x"01",  x"18",  x"ef",  x"06", -- 0290
         x"81",  x"d5",  x"e1",  x"cd",  x"d6",  x"43",  x"d0",  x"f1", -- 0298
         x"dd",  x"cb",  x"02",  x"5e",  x"28",  x"06",  x"dd",  x"36", -- 02A0
         x"02",  x"00",  x"18",  x"e3",  x"dd",  x"36",  x"02",  x"0c", -- 02A8
         x"18",  x"dd",  x"2a",  x"db",  x"47",  x"af",  x"dd",  x"be", -- 02B0
         x"02",  x"28",  x"b0",  x"3e",  x"81",  x"cd",  x"1a",  x"43", -- 02B8
         x"dd",  x"36",  x"02",  x"00",  x"cd",  x"97",  x"46",  x"18", -- 02C0
         x"bd",  x"2a",  x"df",  x"47",  x"18",  x"9d",  x"2a",  x"dd", -- 02C8
         x"47",  x"18",  x"98",  x"ed",  x"5f",  x"47",  x"e6",  x"3f", -- 02D0
         x"21",  x"40",  x"f8",  x"85",  x"6f",  x"30",  x"01",  x"24", -- 02D8
         x"cb",  x"70",  x"28",  x"04",  x"01",  x"40",  x"07",  x"09", -- 02E0
         x"dd",  x"75",  x"00",  x"dd",  x"74",  x"01",  x"dd",  x"e5", -- 02E8
         x"d1",  x"13",  x"13",  x"cd",  x"4a",  x"44",  x"dd",  x"36", -- 02F0
         x"05",  x"2f",  x"dd",  x"36",  x"04",  x"01",  x"c9",  x"00", -- 02F8
         x"f8",  x"31",  x"3d",  x"3d",  x"52",  x"45",  x"4b",  x"4f", -- 0300
         x"52",  x"44",  x"3a",  x"20",  x"30",  x"30",  x"20",  x"3d", -- 0308
         x"3d",  x"3d",  x"3d",  x"3d",  x"50",  x"55",  x"4e",  x"4b", -- 0310
         x"54",  x"45",  x"3a",  x"20",  x"30",  x"30",  x"20",  x"3d", -- 0318
         x"3d",  x"3d",  x"3d",  x"3d",  x"5a",  x"45",  x"49",  x"54", -- 0320
         x"3a",  x"20",  x"31",  x"32",  x"30",  x"20",  x"3d",  x"3d", -- 0328
         x"20",  x"20",  x"20",  x"1b",  x"fc",  x"09",  x"53",  x"50", -- 0330
         x"49",  x"45",  x"4c",  x"45",  x"4e",  x"44",  x"45",  x"18", -- 0338
         x"fc",  x"0c",  x"4e",  x"45",  x"55",  x"45",  x"52",  x"20", -- 0340
         x"52",  x"45",  x"4b",  x"4f",  x"52",  x"44",  x"95",  x"fc", -- 0348
         x"15",  x"53",  x"43",  x"48",  x"4d",  x"45",  x"54",  x"54", -- 0350
         x"45",  x"52",  x"4c",  x"49",  x"4e",  x"47",  x"45",  x"20", -- 0358
         x"46",  x"41",  x"4e",  x"47",  x"45",  x"4e",  x"84",  x"fe", -- 0360
         x"0c",  x"4a",  x"45",  x"20",  x"31",  x"30",  x"20",  x"50", -- 0368
         x"55",  x"4e",  x"4b",  x"54",  x"45",  x"96",  x"fe",  x"0c", -- 0370
         x"4a",  x"45",  x"20",  x"32",  x"30",  x"20",  x"50",  x"55", -- 0378
         x"4e",  x"4b",  x"54",  x"45",  x"a6",  x"fe",  x"09",  x"34", -- 0380
         x"30",  x"20",  x"50",  x"55",  x"4e",  x"4b",  x"54",  x"45", -- 0388
         x"b2",  x"fe",  x"09",  x"36",  x"30",  x"20",  x"50",  x"55", -- 0390
         x"4e",  x"4b",  x"54",  x"45",  x"ce",  x"cf",  x"d0",  x"d1", -- 0398
         x"20",  x"85",  x"f9",  x"26",  x"f9",  x"d4",  x"fa",  x"a0", -- 03A0
         x"fb",  x"a4",  x"fd",  x"06",  x"fe",  x"15",  x"f9",  x"f9", -- 03A8
         x"f9",  x"ed",  x"fa",  x"b1",  x"fc",  x"a6",  x"fd",  x"d4", -- 03B0
         x"fe",  x"17",  x"f9",  x"28",  x"f9",  x"8b",  x"fb",  x"9e", -- 03B8
         x"fb",  x"12",  x"fd",  x"08",  x"fe",  x"cc",  x"fe",  x"9e", -- 03C0
         x"96",  x"9a",  x"a2",  x"a6",  x"aa",  x"ae",  x"b2",  x"8f", -- 03C8
         x"f9",  x"04",  x"fb",  x"30",  x"f9",  x"6a",  x"fb",  x"ba", -- 03D0
         x"fa",  x"01",  x"00",  x"ff",  x"ff",  x"40",  x"00",  x"c0", -- 03D8
         x"ff",  x"c1",  x"ff",  x"41",  x"00",  x"3f",  x"00",  x"bf", -- 03E0
         x"ff",  x"02",  x"20",  x"00",  x"20",  x"50",  x"10",  x"40", -- 03E8
         x"40",  x"30",  x"00",  x"01",  x"ff",  x"00",  x"10",  x"00", -- 03F0
         x"82",  x"01",  x"30",  x"af",  x"82",  x"01",  x"10",  x"c4"  -- 03F8
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;