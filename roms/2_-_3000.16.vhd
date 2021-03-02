library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom2_3000 is
    generic(
        ADDR_WIDTH   : integer := 10
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end rom2_3000;

architecture rtl of rom2_3000 is
    type rom1024x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom1024x8 := (
         x"23",  x"cb",  x"4e",  x"c2",  x"df",  x"31",  x"2b",  x"3a", -- 0000
         x"cd",  x"0c",  x"cb",  x"47",  x"c2",  x"82",  x"31",  x"79", -- 0008
         x"e6",  x"0f",  x"fe",  x"00",  x"28",  x"47",  x"7e",  x"e6", -- 0010
         x"0f",  x"fe",  x"00",  x"28",  x"40",  x"5f",  x"79",  x"e6", -- 0018
         x"0f",  x"bb",  x"38",  x"39",  x"7e",  x"2b",  x"2b",  x"cb", -- 0020
         x"67",  x"20",  x"1c",  x"cb",  x"6f",  x"20",  x"0d",  x"23", -- 0028
         x"cb",  x"77",  x"20",  x"19",  x"cb",  x"7f",  x"20",  x"1f", -- 0030
         x"23",  x"36",  x"00",  x"c9",  x"cb",  x"49",  x"20",  x"02", -- 0038
         x"35",  x"c9",  x"23",  x"23",  x"36",  x"00",  x"c9",  x"cb", -- 0040
         x"41",  x"20",  x"f7",  x"34",  x"c9",  x"cb",  x"51",  x"20", -- 0048
         x"02",  x"35",  x"c9",  x"23",  x"36",  x"00",  x"c9",  x"cb", -- 0050
         x"59",  x"20",  x"f8",  x"34",  x"c9",  x"79",  x"e6",  x"0f", -- 0058
         x"77",  x"3a",  x"e0",  x"0c",  x"2b",  x"2b",  x"3c",  x"32", -- 0060
         x"e0",  x"0c",  x"cb",  x"47",  x"c2",  x"f6",  x"30",  x"3a", -- 0068
         x"ce",  x"0c",  x"96",  x"ca",  x"f6",  x"30",  x"38",  x"3f", -- 0070
         x"cb",  x"41",  x"20",  x"06",  x"34",  x"23",  x"23",  x"cb", -- 0078
         x"e6",  x"c9",  x"3a",  x"cf",  x"0c",  x"23",  x"96",  x"38", -- 0080
         x"12",  x"cb",  x"59",  x"20",  x"05",  x"34",  x"23",  x"cb", -- 0088
         x"fe",  x"c9",  x"cb",  x"51",  x"20",  x"17",  x"35",  x"23", -- 0090
         x"cb",  x"f6",  x"c9",  x"cb",  x"51",  x"20",  x"05",  x"35", -- 0098
         x"23",  x"cb",  x"f6",  x"c9",  x"cb",  x"59",  x"20",  x"05", -- 00A0
         x"34",  x"23",  x"cb",  x"fe",  x"c9",  x"2b",  x"cb",  x"49", -- 00A8
         x"c0",  x"35",  x"23",  x"23",  x"cb",  x"ee",  x"c9",  x"cb", -- 00B0
         x"49",  x"20",  x"06",  x"35",  x"23",  x"23",  x"cb",  x"ee", -- 00B8
         x"c9",  x"3a",  x"cf",  x"0c",  x"23",  x"96",  x"38",  x"12", -- 00C0
         x"cb",  x"59",  x"20",  x"05",  x"34",  x"23",  x"cb",  x"fe", -- 00C8
         x"c9",  x"cb",  x"51",  x"20",  x"17",  x"35",  x"23",  x"cb", -- 00D0
         x"f6",  x"c9",  x"cb",  x"51",  x"20",  x"05",  x"35",  x"23", -- 00D8
         x"cb",  x"f6",  x"c9",  x"cb",  x"59",  x"20",  x"05",  x"34", -- 00E0
         x"23",  x"cb",  x"fe",  x"c9",  x"2b",  x"cb",  x"41",  x"c0", -- 00E8
         x"34",  x"23",  x"23",  x"cb",  x"e6",  x"c9",  x"3a",  x"cf", -- 00F0
         x"0c",  x"23",  x"96",  x"ca",  x"83",  x"31",  x"38",  x"41", -- 00F8
         x"cb",  x"59",  x"20",  x"05",  x"34",  x"23",  x"cb",  x"fe", -- 0100
         x"c9",  x"3a",  x"ce",  x"0c",  x"2b",  x"96",  x"38",  x"14", -- 0108
         x"cb",  x"41",  x"20",  x"06",  x"34",  x"23",  x"23",  x"cb", -- 0110
         x"e6",  x"c9",  x"cb",  x"49",  x"20",  x"1a",  x"35",  x"23", -- 0118
         x"23",  x"cb",  x"ee",  x"c9",  x"cb",  x"49",  x"20",  x"06", -- 0120
         x"35",  x"23",  x"23",  x"cb",  x"ee",  x"c9",  x"cb",  x"41", -- 0128
         x"20",  x"06",  x"34",  x"23",  x"23",  x"cb",  x"e6",  x"c9", -- 0130
         x"23",  x"cb",  x"51",  x"c0",  x"35",  x"23",  x"cb",  x"f6", -- 0138
         x"c9",  x"cb",  x"51",  x"20",  x"05",  x"35",  x"23",  x"cb", -- 0140
         x"f6",  x"c9",  x"3a",  x"ce",  x"0c",  x"2b",  x"96",  x"38", -- 0148
         x"14",  x"cb",  x"41",  x"20",  x"06",  x"34",  x"23",  x"23", -- 0150
         x"cb",  x"e6",  x"c9",  x"cb",  x"49",  x"20",  x"1a",  x"35", -- 0158
         x"23",  x"23",  x"cb",  x"ee",  x"c9",  x"cb",  x"49",  x"20", -- 0160
         x"06",  x"35",  x"23",  x"23",  x"cb",  x"ee",  x"c9",  x"cb", -- 0168
         x"41",  x"20",  x"06",  x"34",  x"23",  x"23",  x"cb",  x"e6", -- 0170
         x"c9",  x"23",  x"cb",  x"59",  x"c0",  x"34",  x"23",  x"cb", -- 0178
         x"fe",  x"c9",  x"2b",  x"2b",  x"3a",  x"d0",  x"0c",  x"cb", -- 0180
         x"47",  x"20",  x"0d",  x"cb",  x"4f",  x"20",  x"13",  x"cb", -- 0188
         x"57",  x"20",  x"19",  x"cb",  x"5f",  x"20",  x"1f",  x"c9", -- 0190
         x"cb",  x"41",  x"20",  x"06",  x"34",  x"23",  x"23",  x"cb", -- 0198
         x"e6",  x"c9",  x"cb",  x"49",  x"20",  x"06",  x"35",  x"23", -- 01A0
         x"23",  x"cb",  x"ee",  x"c9",  x"cb",  x"51",  x"20",  x"06", -- 01A8
         x"23",  x"35",  x"23",  x"cb",  x"f6",  x"c9",  x"cb",  x"59", -- 01B0
         x"20",  x"06",  x"23",  x"34",  x"23",  x"cb",  x"fe",  x"c9", -- 01B8
         x"cb",  x"51",  x"20",  x"06",  x"23",  x"35",  x"23",  x"cb", -- 01C0
         x"f6",  x"c9",  x"cb",  x"49",  x"20",  x"06",  x"35",  x"23", -- 01C8
         x"23",  x"cb",  x"ee",  x"c9",  x"cb",  x"41",  x"c2",  x"53", -- 01D0
         x"30",  x"34",  x"23",  x"23",  x"cb",  x"e6",  x"c9",  x"2b", -- 01D8
         x"2b",  x"2b",  x"cb",  x"49",  x"c0",  x"cb",  x"61",  x"20", -- 01E0
         x"06",  x"35",  x"23",  x"23",  x"36",  x"2c",  x"c9",  x"35", -- 01E8
         x"23",  x"23",  x"23",  x"cb",  x"8e",  x"c9",  x"db",  x"83", -- 01F0
         x"32",  x"d0",  x"0c",  x"be",  x"c0",  x"21",  x"98",  x"fb", -- 01F8
         x"3e",  x"e6",  x"be",  x"c8",  x"36",  x"e6",  x"21",  x"d8", -- 0200
         x"fb",  x"36",  x"e7",  x"21",  x"6a",  x"3f",  x"cd",  x"d4", -- 0208
         x"01",  x"c9",  x"54",  x"5d",  x"13",  x"36",  x"00",  x"ed", -- 0210
         x"b0",  x"c9",  x"e5",  x"af",  x"77",  x"2b",  x"77",  x"01", -- 0218
         x"40",  x"00",  x"09",  x"77",  x"23",  x"77",  x"e1",  x"c9", -- 0220
         x"e5",  x"af",  x"77",  x"23",  x"77",  x"01",  x"40",  x"00", -- 0228
         x"09",  x"77",  x"2b",  x"77",  x"e1",  x"c9",  x"e5",  x"af", -- 0230
         x"77",  x"23",  x"77",  x"af",  x"01",  x"40",  x"00",  x"ed", -- 0238
         x"42",  x"77",  x"2b",  x"77",  x"e1",  x"c9",  x"e5",  x"af", -- 0240
         x"77",  x"2b",  x"77",  x"af",  x"01",  x"40",  x"00",  x"ed", -- 0248
         x"42",  x"77",  x"23",  x"77",  x"e1",  x"c9",  x"21",  x"0a", -- 0250
         x"f8",  x"22",  x"3f",  x"0c",  x"2a",  x"08",  x"0c",  x"22", -- 0258
         x"3d",  x"0c",  x"cd",  x"70",  x"02",  x"21",  x"1b",  x"f8", -- 0260
         x"22",  x"3f",  x"0c",  x"2a",  x"18",  x"0c",  x"22",  x"3d", -- 0268
         x"0c",  x"cd",  x"70",  x"02",  x"21",  x"2b",  x"f8",  x"22", -- 0270
         x"3f",  x"0c",  x"2a",  x"1a",  x"0c",  x"22",  x"3d",  x"0c", -- 0278
         x"cd",  x"70",  x"02",  x"21",  x"3b",  x"f8",  x"22",  x"3f", -- 0280
         x"0c",  x"3a",  x"e4",  x"0c",  x"26",  x"00",  x"6f",  x"22", -- 0288
         x"3d",  x"0c",  x"cd",  x"70",  x"02",  x"c9",  x"e5",  x"2a", -- 0290
         x"cb",  x"0c",  x"cd",  x"b5",  x"32",  x"ed",  x"43",  x"ce", -- 0298
         x"0c",  x"e1",  x"c9",  x"e5",  x"5e",  x"23",  x"56",  x"eb", -- 02A0
         x"cd",  x"b5",  x"32",  x"e1",  x"23",  x"23",  x"71",  x"23", -- 02A8
         x"70",  x"2b",  x"2b",  x"2b",  x"c9",  x"11",  x"00",  x"f8", -- 02B0
         x"01",  x"00",  x"00",  x"af",  x"ed",  x"52",  x"11",  x"40", -- 02B8
         x"00",  x"af",  x"ed",  x"52",  x"c8",  x"38",  x"03",  x"04", -- 02C0
         x"18",  x"f7",  x"ed",  x"5a",  x"4d",  x"c9",  x"2a",  x"93", -- 02C8
         x"0c",  x"23",  x"23",  x"4e",  x"23",  x"46",  x"21",  x"00", -- 02D0
         x"f8",  x"11",  x"40",  x"00",  x"af",  x"b8",  x"28",  x"05", -- 02D8
         x"05",  x"19",  x"d8",  x"18",  x"f7",  x"09",  x"2b",  x"eb", -- 02E0
         x"2a",  x"93",  x"0c",  x"73",  x"23",  x"72",  x"c9",  x"c9", -- 02E8
         x"7e",  x"dd",  x"36",  x"00",  x"00",  x"fe",  x"ea",  x"30", -- 02F0
         x"03",  x"dd",  x"77",  x"00",  x"dd",  x"23",  x"23",  x"7e", -- 02F8
         x"dd",  x"36",  x"00",  x"00",  x"fe",  x"ea",  x"30",  x"03", -- 0300
         x"dd",  x"77",  x"00",  x"dd",  x"23",  x"01",  x"40",  x"00", -- 0308
         x"09",  x"7e",  x"dd",  x"36",  x"00",  x"00",  x"fe",  x"ea", -- 0310
         x"30",  x"03",  x"dd",  x"77",  x"00",  x"2b",  x"dd",  x"23", -- 0318
         x"7e",  x"dd",  x"36",  x"00",  x"00",  x"fe",  x"ea",  x"30", -- 0320
         x"03",  x"dd",  x"77",  x"00",  x"dd",  x"23",  x"c9",  x"dd", -- 0328
         x"7e",  x"00",  x"77",  x"23",  x"dd",  x"23",  x"dd",  x"7e", -- 0330
         x"00",  x"77",  x"01",  x"40",  x"00",  x"09",  x"dd",  x"23", -- 0338
         x"dd",  x"7e",  x"00",  x"77",  x"dd",  x"23",  x"2b",  x"dd", -- 0340
         x"7e",  x"00",  x"77",  x"dd",  x"2b",  x"dd",  x"2b",  x"dd", -- 0348
         x"2b",  x"c9",  x"21",  x"da",  x"38",  x"11",  x"00",  x"fc", -- 0350
         x"01",  x"00",  x"04",  x"ed",  x"b0",  x"c9",  x"2a",  x"00", -- 0358
         x"00",  x"c9",  x"22",  x"00",  x"00",  x"c9",  x"ed",  x"5b", -- 0360
         x"00",  x"00",  x"c9",  x"ed",  x"53",  x"00",  x"00",  x"c9", -- 0368
         x"20",  x"20",  x"20",  x"20",  x"20",  x"20",  x"20",  x"20", -- 0370
         x"20",  x"20",  x"48",  x"20",  x"41",  x"20",  x"53",  x"20", -- 0378
         x"45",  x"20",  x"20",  x"20",  x"55",  x"20",  x"4e",  x"20", -- 0380
         x"44",  x"20",  x"20",  x"20",  x"57",  x"20",  x"4f",  x"20", -- 0388
         x"4c",  x"20",  x"46",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0390
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0398
         x"00",  x"44",  x"45",  x"52",  x"20",  x"48",  x"41",  x"53", -- 03A0
         x"45",  x"20",  x"4d",  x"55",  x"53",  x"53",  x"20",  x"41", -- 03A8
         x"4c",  x"4c",  x"45",  x"53",  x"20",  x"46",  x"52",  x"45", -- 03B0
         x"53",  x"53",  x"45",  x"4e",  x"2c",  x"20",  x"57",  x"41", -- 03B8
         x"53",  x"20",  x"45",  x"52",  x"20",  x"42",  x"45",  x"4b", -- 03C0
         x"4f",  x"4d",  x"4d",  x"45",  x"4e",  x"20",  x"4b",  x"41", -- 03C8
         x"4e",  x"4e",  x"2e",  x"20",  x"20",  x"20",  x"20",  x"45", -- 03D0
         x"52",  x"20",  x"4d",  x"55",  x"53",  x"53",  x"20",  x"53", -- 03D8
         x"49",  x"43",  x"48",  x"20",  x"56",  x"4f",  x"52",  x"20", -- 03E0
         x"44",  x"45",  x"4d",  x"20",  x"57",  x"4f",  x"4c",  x"46", -- 03E8
         x"20",  x"49",  x"4e",  x"20",  x"41",  x"43",  x"48",  x"54", -- 03F0
         x"20",  x"4e",  x"45",  x"48",  x"4d",  x"45",  x"4e",  x"2c"  -- 03F8
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;
