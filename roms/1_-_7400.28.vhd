library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom1_7400 is
    generic(
        ADDR_WIDTH   : integer := 10
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end rom1_7400;

architecture rtl of rom1_7400 is
    type rom1024x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom1024x8 := (
         x"cd",  x"b7",  x"01",  x"cd",  x"b7",  x"02",  x"11",  x"00", -- 0000
         x"ec",  x"21",  x"b2",  x"7d",  x"3a",  x"f4",  x"7f",  x"47", -- 0008
         x"c5",  x"4e",  x"23",  x"46",  x"23",  x"7e",  x"23",  x"eb", -- 0010
         x"09",  x"eb",  x"47",  x"c5",  x"01",  x"08",  x"00",  x"ed", -- 0018
         x"b0",  x"c1",  x"10",  x"f7",  x"c1",  x"10",  x"e9",  x"fd", -- 0020
         x"21",  x"2a",  x"0d",  x"fd",  x"36",  x"00",  x"00",  x"cd", -- 0028
         x"b7",  x"01",  x"3e",  x"5a",  x"32",  x"00",  x"0d",  x"3e", -- 0030
         x"4d",  x"32",  x"bf",  x"0c",  x"3e",  x"03",  x"32",  x"24", -- 0038
         x"0d",  x"06",  x"22",  x"af",  x"32",  x"2e",  x"0d",  x"32", -- 0040
         x"56",  x"0c",  x"32",  x"23",  x"0d",  x"21",  x"01",  x"0d", -- 0048
         x"77",  x"23",  x"10",  x"fc",  x"cd",  x"55",  x"77",  x"ca", -- 0050
         x"7a",  x"2a",  x"12",  x"0c",  x"22",  x"3d",  x"0c",  x"21", -- 0058
         x"0c",  x"f8",  x"22",  x"3f",  x"0c",  x"cd",  x"70",  x"02", -- 0060
         x"21",  x"1e",  x"f8",  x"22",  x"3f",  x"0c",  x"2a",  x"18", -- 0068
         x"0c",  x"22",  x"3d",  x"0c",  x"cd",  x"70",  x"02",  x"cd", -- 0070
         x"a8",  x"77",  x"fd",  x"cb",  x"00",  x"46",  x"20",  x"5d", -- 0078
         x"cd",  x"55",  x"77",  x"59",  x"7b",  x"dd",  x"21",  x"c8", -- 0080
         x"7a",  x"3e",  x"9c",  x"cd",  x"88",  x"77",  x"3e",  x"03", -- 0088
         x"cd",  x"e2",  x"79",  x"06",  x"09",  x"21",  x"95",  x"7b", -- 0090
         x"c5",  x"cd",  x"5d",  x"77",  x"c1",  x"10",  x"f9",  x"11", -- 0098
         x"52",  x"ff",  x"21",  x"0a",  x"03",  x"01",  x"1b",  x"00", -- 00A0
         x"ed",  x"b0",  x"06",  x"13",  x"11",  x"40",  x"00",  x"21", -- 00A8
         x"0e",  x"fb",  x"36",  x"88",  x"19",  x"10",  x"fb",  x"cd", -- 00B0
         x"9a",  x"01",  x"c2",  x"f1",  x"00",  x"cd",  x"f9",  x"79", -- 00B8
         x"3a",  x"03",  x"0c",  x"b7",  x"28",  x"f1",  x"21",  x"00", -- 00C0
         x"00",  x"22",  x"18",  x"0c",  x"ed",  x"73",  x"2b",  x"0d", -- 00C8
         x"fd",  x"36",  x"00",  x"01",  x"21",  x"89",  x"7d",  x"cd", -- 00D0
         x"e0",  x"01",  x"c3",  x"2f",  x"74",  x"af",  x"cd",  x"e2", -- 00D8
         x"79",  x"06",  x"1c",  x"21",  x"5e",  x"fb",  x"3e",  x"f9", -- 00E0
         x"77",  x"23",  x"10",  x"fc",  x"06",  x"1c",  x"21",  x"5e", -- 00E8
         x"fc",  x"77",  x"23",  x"10",  x"fc",  x"06",  x"1c",  x"21", -- 00F0
         x"5e",  x"fd",  x"77",  x"23",  x"10",  x"fc",  x"06",  x"1c", -- 00F8
         x"21",  x"5e",  x"fe",  x"77",  x"23",  x"10",  x"fc",  x"11", -- 0100
         x"40",  x"00",  x"06",  x"0b",  x"21",  x"9e",  x"fb",  x"77", -- 0108
         x"19",  x"10",  x"fc",  x"21",  x"b9",  x"fb",  x"06",  x"0b", -- 0110
         x"77",  x"19",  x"10",  x"fc",  x"cd",  x"55",  x"77",  x"0c", -- 0118
         x"7b",  x"cd",  x"55",  x"77",  x"1b",  x"7b",  x"cd",  x"55", -- 0120
         x"77",  x"2a",  x"7b",  x"21",  x"28",  x"00",  x"22",  x"27", -- 0128
         x"0d",  x"3a",  x"24",  x"0d",  x"47",  x"21",  x"12",  x"0d", -- 0130
         x"dd",  x"21",  x"95",  x"7a",  x"cd",  x"5a",  x"78",  x"77", -- 0138
         x"cd",  x"95",  x"79",  x"cd",  x"88",  x"77",  x"23",  x"e5", -- 0140
         x"eb",  x"cd",  x"5a",  x"79",  x"e1",  x"dd",  x"2b",  x"dd", -- 0148
         x"2b",  x"cd",  x"90",  x"79",  x"dd",  x"23",  x"dd",  x"23", -- 0150
         x"10",  x"e2",  x"36",  x"00",  x"cd",  x"1d",  x"79",  x"3e", -- 0158
         x"05",  x"32",  x"25",  x"0d",  x"cd",  x"7b",  x"78",  x"28", -- 0160
         x"2c",  x"21",  x"25",  x"0d",  x"af",  x"be",  x"28",  x"2c", -- 0168
         x"35",  x"20",  x"f1",  x"3a",  x"24",  x"0d",  x"47",  x"dd", -- 0170
         x"21",  x"95",  x"7a",  x"3e",  x"9c",  x"cd",  x"88",  x"77", -- 0178
         x"10",  x"f9",  x"32",  x"2e",  x"0d",  x"21",  x"7d",  x"7a", -- 0180
         x"22",  x"2f",  x"0d",  x"21",  x"01",  x"0d",  x"e5",  x"3a", -- 0188
         x"24",  x"0d",  x"32",  x"26",  x"0d",  x"3a",  x"25",  x"0d", -- 0190
         x"b7",  x"c2",  x"02",  x"76",  x"0e",  x"00",  x"db",  x"84", -- 0198
         x"cb",  x"47",  x"20",  x"6e",  x"3e",  x"08",  x"32",  x"2d", -- 01A0
         x"0d",  x"cd",  x"69",  x"79",  x"3a",  x"23",  x"0d",  x"07", -- 01A8
         x"07",  x"c6",  x"80",  x"e1",  x"77",  x"23",  x"e5",  x"f5", -- 01B0
         x"dd",  x"2a",  x"2f",  x"0d",  x"cd",  x"88",  x"77",  x"dd", -- 01B8
         x"22",  x"2f",  x"0d",  x"f1",  x"11",  x"10",  x"00",  x"19", -- 01C0
         x"be",  x"c2",  x"98",  x"76",  x"3a",  x"26",  x"0d",  x"fe", -- 01C8
         x"01",  x"20",  x"04",  x"af",  x"32",  x"2e",  x"0d",  x"3a", -- 01D0
         x"23",  x"0d",  x"cd",  x"47",  x"78",  x"dd",  x"2a",  x"2f", -- 01D8
         x"0d",  x"dd",  x"2b",  x"dd",  x"2b",  x"cd",  x"95",  x"79", -- 01E0
         x"cd",  x"5a",  x"79",  x"cd",  x"90",  x"79",  x"21",  x"26", -- 01E8
         x"0d",  x"35",  x"ca",  x"9c",  x"76",  x"cd",  x"c7",  x"01", -- 01F0
         x"cd",  x"84",  x"01",  x"cb",  x"47",  x"28",  x"f9",  x"c3", -- 01F8
         x"64",  x"75",  x"db",  x"84",  x"e6",  x"1f",  x"fe",  x"1f", -- 0200
         x"ca",  x"64",  x"75",  x"af",  x"32",  x"25",  x"0d",  x"c3", -- 0208
         x"73",  x"75",  x"e6",  x"1e",  x"fe",  x"1e",  x"ca",  x"64", -- 0210
         x"75",  x"cb",  x"57",  x"20",  x"02",  x"0e",  x"01",  x"cb", -- 0218
         x"4f",  x"20",  x"17",  x"11",  x"12",  x"0d",  x"dd",  x"21", -- 0220
         x"95",  x"7a",  x"3a",  x"24",  x"0d",  x"47",  x"1a",  x"13", -- 0228
         x"c5",  x"cd",  x"c6",  x"79",  x"c1",  x"10",  x"f7",  x"c3", -- 0230
         x"64",  x"75",  x"cb",  x"5f",  x"28",  x"17",  x"cb",  x"67", -- 0238
         x"3a",  x"23",  x"0d",  x"20",  x"35",  x"fe",  x"05",  x"28", -- 0240
         x"31",  x"cd",  x"47",  x"78",  x"cd",  x"81",  x"77",  x"3a", -- 0248
         x"23",  x"0d",  x"3c",  x"18",  x"10",  x"3a",  x"23",  x"0d", -- 0250
         x"b7",  x"28",  x"1f",  x"cd",  x"47",  x"78",  x"cd",  x"81", -- 0258
         x"77",  x"3a",  x"23",  x"0d",  x"3d",  x"32",  x"23",  x"0d", -- 0260
         x"cd",  x"47",  x"78",  x"3e",  x"98",  x"cd",  x"88",  x"77", -- 0268
         x"e5",  x"21",  x"ff",  x"7c",  x"cd",  x"5a",  x"79",  x"e1", -- 0270
         x"18",  x"08",  x"cd",  x"47",  x"78",  x"3e",  x"98",  x"cd", -- 0278
         x"88",  x"77",  x"cb",  x"41",  x"ca",  x"64",  x"75",  x"01", -- 0280
         x"0a",  x"00",  x"dd",  x"09",  x"cd",  x"95",  x"79",  x"cd", -- 0288
         x"5a",  x"79",  x"cd",  x"90",  x"79",  x"c3",  x"64",  x"75", -- 0290
         x"af",  x"32",  x"2e",  x"0d",  x"f1",  x"dd",  x"21",  x"95", -- 0298
         x"7a",  x"21",  x"12",  x"0d",  x"11",  x"01",  x"0d",  x"3a", -- 02A0
         x"24",  x"0d",  x"47",  x"0e",  x"00",  x"1a",  x"be",  x"28", -- 02A8
         x"02",  x"cb",  x"c1",  x"13",  x"7e",  x"23",  x"cd",  x"88", -- 02B0
         x"77",  x"10",  x"f2",  x"3a",  x"24",  x"0d",  x"cb",  x"41", -- 02B8
         x"c2",  x"3f",  x"77",  x"f5",  x"3a",  x"29",  x"0d",  x"47", -- 02C0
         x"3a",  x"00",  x"0d",  x"80",  x"fe",  x"5b",  x"38",  x"02", -- 02C8
         x"3e",  x"5a",  x"32",  x"00",  x"0d",  x"ed",  x"4b",  x"27", -- 02D0
         x"0d",  x"2a",  x"18",  x"0c",  x"09",  x"22",  x"18",  x"0c", -- 02D8
         x"22",  x"3d",  x"0c",  x"21",  x"1e",  x"f8",  x"22",  x"3f", -- 02E0
         x"0c",  x"cd",  x"70",  x"02",  x"c5",  x"e1",  x"cb",  x"38", -- 02E8
         x"cb",  x"19",  x"09",  x"22",  x"27",  x"0d",  x"f1",  x"21", -- 02F0
         x"14",  x"7d",  x"3c",  x"32",  x"24",  x"0d",  x"cd",  x"5a", -- 02F8
         x"79",  x"3e",  x"03",  x"21",  x"c0",  x"f9",  x"cd",  x"56", -- 0300
         x"7a",  x"dd",  x"21",  x"95",  x"7a",  x"21",  x"12",  x"0d", -- 0308
         x"3a",  x"24",  x"0d",  x"fe",  x"0d",  x"20",  x"10",  x"3e", -- 0310
         x"0c",  x"32",  x"24",  x"0d",  x"3e",  x"03",  x"21",  x"00", -- 0318
         x"f9",  x"cd",  x"56",  x"7a",  x"c3",  x"31",  x"75",  x"3a", -- 0320
         x"19",  x"0c",  x"fe",  x"11",  x"30",  x"ee",  x"7e",  x"b7", -- 0328
         x"28",  x"08",  x"23",  x"e5",  x"cd",  x"c6",  x"79",  x"e1", -- 0330
         x"18",  x"ed",  x"06",  x"01",  x"c3",  x"3c",  x"75",  x"21", -- 0338
         x"27",  x"7d",  x"3e",  x"03",  x"32",  x"24",  x"0d",  x"cd", -- 0340
         x"5a",  x"79",  x"3e",  x"06",  x"21",  x"00",  x"f9",  x"cd", -- 0348
         x"56",  x"7a",  x"c3",  x"2b",  x"75",  x"e1",  x"5e",  x"23", -- 0350
         x"56",  x"23",  x"e5",  x"d5",  x"e1",  x"5e",  x"23",  x"56", -- 0358
         x"23",  x"4e",  x"06",  x"00",  x"23",  x"ed",  x"b0",  x"c9", -- 0360
         x"eb",  x"c5",  x"4e",  x"23",  x"06",  x"00",  x"ed",  x"b0", -- 0368
         x"eb",  x"c1",  x"c9",  x"3e",  x"4d",  x"32",  x"bf",  x"0c", -- 0370
         x"3a",  x"bf",  x"0c",  x"b7",  x"20",  x"fa",  x"10",  x"f3", -- 0378
         x"c9",  x"d5",  x"16",  x"00",  x"3e",  x"20",  x"18",  x"03", -- 0380
         x"d5",  x"16",  x"01",  x"e5",  x"c5",  x"01",  x"3f",  x"00", -- 0388
         x"dd",  x"6e",  x"00",  x"dd",  x"66",  x"01",  x"dd",  x"23", -- 0390
         x"dd",  x"23",  x"77",  x"82",  x"23",  x"77",  x"82",  x"09", -- 0398
         x"77",  x"82",  x"23",  x"77",  x"c1",  x"e1",  x"d1",  x"c9", -- 03A0
         x"dd",  x"e5",  x"e5",  x"d5",  x"c5",  x"06",  x"01",  x"dd", -- 03A8
         x"21",  x"ad",  x"7a",  x"21",  x"5e",  x"f8",  x"3a",  x"00", -- 03B0
         x"0d",  x"b7",  x"3e",  x"5d",  x"28",  x"60",  x"3a",  x"00", -- 03B8
         x"0d",  x"dd",  x"46",  x"00",  x"dd",  x"5e",  x"01",  x"dd", -- 03C0
         x"56",  x"02",  x"cb",  x"38",  x"38",  x"13",  x"19",  x"36", -- 03C8
         x"fe",  x"23",  x"36",  x"ff",  x"3d",  x"28",  x"20",  x"10", -- 03D0
         x"f5",  x"dd",  x"23",  x"dd",  x"23",  x"dd",  x"23",  x"18", -- 03D8
         x"e0",  x"19",  x"36",  x"fc",  x"11",  x"40",  x"00",  x"19", -- 03E0
         x"36",  x"fd",  x"dd",  x"5e",  x"01",  x"dd",  x"56",  x"02", -- 03E8
         x"3d",  x"28",  x"08",  x"10",  x"ec",  x"18",  x"e2",  x"0e", -- 03F0
         x"01",  x"18",  x"02",  x"0e",  x"00",  x"3a",  x"00",  x"0d"  -- 03F8
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;