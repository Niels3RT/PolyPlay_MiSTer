library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom1_7c00 is
    generic(
        ADDR_WIDTH   : integer := 10
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end rom1_7c00;

architecture rtl of rom1_7c00 is
    type rom1024x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom1024x8 := (
         x"44",  x"45",  x"53",  x"20",  x"44",  x"55",  x"52",  x"43", -- 0000
         x"48",  x"20",  x"44",  x"52",  x"55",  x"45",  x"43",  x"4b", -- 0008
         x"45",  x"4e",  x"20",  x"44",  x"45",  x"52",  x"51",  x"fc", -- 0010
         x"0c",  x"41",  x"4b",  x"54",  x"49",  x"4f",  x"4e",  x"53", -- 0018
         x"54",  x"41",  x"53",  x"54",  x"45",  x"d0",  x"fc",  x"2c", -- 0020
         x"41",  x"4b",  x"55",  x"53",  x"54",  x"49",  x"53",  x"43", -- 0028
         x"48",  x"45",  x"20",  x"48",  x"49",  x"4c",  x"46",  x"45", -- 0030
         x"53",  x"54",  x"45",  x"4c",  x"4c",  x"55",  x"4e",  x"47", -- 0038
         x"20",  x"28",  x"54",  x"4f",  x"4e",  x"51",  x"55",  x"45", -- 0040
         x"4c",  x"4c",  x"45",  x"2d",  x"52",  x"41",  x"48",  x"4d", -- 0048
         x"45",  x"4e",  x"29",  x"3a",  x"50",  x"fd",  x"2b",  x"2d", -- 0050
         x"53",  x"54",  x"45",  x"55",  x"45",  x"52",  x"4b",  x"4e", -- 0058
         x"55",  x"45",  x"50",  x"50",  x"45",  x"4c",  x"20",  x"4e", -- 0060
         x"41",  x"43",  x"48",  x"20",  x"52",  x"45",  x"43",  x"48", -- 0068
         x"54",  x"53",  x"20",  x"2d",  x"3e",  x"20",  x"57",  x"49", -- 0070
         x"45",  x"44",  x"45",  x"52",  x"48",  x"4f",  x"4c",  x"55", -- 0078
         x"4e",  x"47",  x"91",  x"fd",  x"22",  x"44",  x"45",  x"52", -- 0080
         x"20",  x"54",  x"4f",  x"4e",  x"46",  x"4f",  x"4c",  x"47", -- 0088
         x"45",  x"20",  x"44",  x"45",  x"52",  x"20",  x"56",  x"45", -- 0090
         x"52",  x"44",  x"45",  x"43",  x"4b",  x"54",  x"45",  x"4e", -- 0098
         x"20",  x"42",  x"49",  x"4c",  x"44",  x"45",  x"52",  x"10", -- 00A0
         x"fe",  x"2b",  x"2d",  x"53",  x"54",  x"45",  x"55",  x"45", -- 00A8
         x"52",  x"4b",  x"4e",  x"55",  x"45",  x"50",  x"50",  x"45", -- 00B0
         x"4c",  x"20",  x"4e",  x"41",  x"43",  x"48",  x"20",  x"4c", -- 00B8
         x"49",  x"4e",  x"4b",  x"53",  x"20",  x"2d",  x"3e",  x"20", -- 00C0
         x"54",  x"4f",  x"4e",  x"20",  x"44",  x"45",  x"53",  x"20", -- 00C8
         x"44",  x"55",  x"52",  x"43",  x"48",  x"51",  x"fe",  x"21", -- 00D0
         x"47",  x"52",  x"55",  x"45",  x"4e",  x"45",  x"4e",  x"20", -- 00D8
         x"50",  x"46",  x"45",  x"49",  x"4c",  x"20",  x"41",  x"4e", -- 00E0
         x"47",  x"45",  x"57",  x"41",  x"45",  x"48",  x"4c",  x"54", -- 00E8
         x"45",  x"4e",  x"20",  x"42",  x"49",  x"4c",  x"44",  x"45", -- 00F0
         x"53",  x"05",  x"53",  x"45",  x"4b",  x"2e",  x"3d",  x"90", -- 00F8
         x"01",  x"00",  x"10",  x"93",  x"00",  x"10",  x"9c",  x"00", -- 0100
         x"10",  x"af",  x"00",  x"10",  x"c4",  x"00",  x"10",  x"dc", -- 0108
         x"00",  x"10",  x"e9",  x"00",  x"8f",  x"01",  x"48",  x"12", -- 0110
         x"82",  x"01",  x"08",  x"e9",  x"82",  x"01",  x"08",  x"c4", -- 0118
         x"82",  x"01",  x"20",  x"93",  x"ff",  x"01",  x"00",  x"0c", -- 0120
         x"83",  x"87",  x"01",  x"0c",  x"83",  x"87",  x"01",  x"0c", -- 0128
         x"83",  x"87",  x"01",  x"30",  x"c4",  x"ff",  x"01",  x"00", -- 0130
         x"3f",  x"40",  x"ff",  x"01",  x"20",  x"dc",  x"82",  x"01", -- 0138
         x"20",  x"dc",  x"82",  x"01",  x"20",  x"c4",  x"82",  x"01", -- 0140
         x"20",  x"c4",  x"82",  x"01",  x"10",  x"e9",  x"82",  x"01", -- 0148
         x"10",  x"e9",  x"82",  x"01",  x"10",  x"00",  x"82",  x"01", -- 0150
         x"10",  x"e9",  x"82",  x"01",  x"20",  x"dc",  x"82",  x"01", -- 0158
         x"60",  x"12",  x"87",  x"01",  x"20",  x"dc",  x"82",  x"01", -- 0160
         x"20",  x"dc",  x"82",  x"01",  x"20",  x"c4",  x"82",  x"01", -- 0168
         x"20",  x"c4",  x"82",  x"01",  x"10",  x"e9",  x"82",  x"01", -- 0170
         x"10",  x"e9",  x"82",  x"01",  x"10",  x"00",  x"82",  x"01", -- 0178
         x"10",  x"e9",  x"82",  x"01",  x"3f",  x"dc",  x"ff",  x"01", -- 0180
         x"00",  x"10",  x"dc",  x"82",  x"01",  x"10",  x"dc",  x"82", -- 0188
         x"01",  x"10",  x"c4",  x"82",  x"01",  x"10",  x"c4",  x"82", -- 0190
         x"01",  x"08",  x"e9",  x"82",  x"01",  x"08",  x"e9",  x"82", -- 0198
         x"01",  x"08",  x"00",  x"82",  x"01",  x"08",  x"e9",  x"82", -- 01A0
         x"01",  x"10",  x"dc",  x"82",  x"01",  x"58",  x"12",  x"ff", -- 01A8
         x"01",  x"00",  x"40",  x"00",  x"04",  x"00",  x"00",  x"ff", -- 01B0
         x"ff",  x"ff",  x"ff",  x"ff",  x"ff",  x"00",  x"00",  x"ff", -- 01B8
         x"ff",  x"ff",  x"ff",  x"ff",  x"ff",  x"ff",  x"ff",  x"ff", -- 01C0
         x"ff",  x"ff",  x"ff",  x"00",  x"00",  x"ff",  x"ff",  x"ff", -- 01C8
         x"ff",  x"ff",  x"ff",  x"00",  x"00",  x"20",  x"00",  x"08", -- 01D0
         x"00",  x"00",  x"ff",  x"ff",  x"ff",  x"f0",  x"f0",  x"f0", -- 01D8
         x"00",  x"00",  x"ff",  x"ff",  x"ff",  x"0f",  x"0f",  x"0f", -- 01E0
         x"f0",  x"f0",  x"f0",  x"ff",  x"ff",  x"ff",  x"00",  x"00", -- 01E8
         x"0f",  x"0f",  x"0f",  x"ff",  x"ff",  x"ff",  x"00",  x"00", -- 01F0
         x"00",  x"7f",  x"3f",  x"1f",  x"0f",  x"07",  x"03",  x"01", -- 01F8
         x"00",  x"fe",  x"fc",  x"f8",  x"f0",  x"e0",  x"c0",  x"80", -- 0200
         x"01",  x"03",  x"07",  x"0f",  x"1f",  x"3f",  x"7f",  x"00", -- 0208
         x"80",  x"c0",  x"e0",  x"f0",  x"f8",  x"fc",  x"fe",  x"00", -- 0210
         x"20",  x"00",  x"04",  x"00",  x"03",  x"0c",  x"18",  x"18", -- 0218
         x"00",  x"00",  x"00",  x"00",  x"e0",  x"18",  x"0c",  x"0c", -- 0220
         x"0c",  x"18",  x"30",  x"00",  x"01",  x"01",  x"01",  x"00", -- 0228
         x"00",  x"01",  x"01",  x"c0",  x"80",  x"80",  x"80",  x"00", -- 0230
         x"00",  x"80",  x"80",  x"c0",  x"02",  x"02",  x"00",  x"7e", -- 0238
         x"42",  x"42",  x"42",  x"42",  x"7e",  x"00",  x"ff",  x"e7", -- 0240
         x"c3",  x"81",  x"00",  x"81",  x"c3",  x"e7",  x"30",  x"00", -- 0248
         x"04",  x"00",  x"00",  x"00",  x"01",  x"03",  x"03",  x"07", -- 0250
         x"0f",  x"00",  x"00",  x"00",  x"80",  x"c0",  x"c0",  x"e0", -- 0258
         x"f0",  x"1f",  x"1f",  x"3f",  x"7f",  x"ff",  x"00",  x"00", -- 0260
         x"00",  x"f8",  x"f8",  x"fc",  x"fe",  x"ff",  x"00",  x"00", -- 0268
         x"00",  x"40",  x"00",  x"08",  x"01",  x"03",  x"07",  x"0f", -- 0270
         x"1f",  x"3f",  x"7f",  x"ff",  x"80",  x"c0",  x"e0",  x"f0", -- 0278
         x"f8",  x"fc",  x"fe",  x"ff",  x"ff",  x"7f",  x"3f",  x"1f", -- 0280
         x"0f",  x"07",  x"03",  x"01",  x"ff",  x"fe",  x"fc",  x"f8", -- 0288
         x"f0",  x"e0",  x"c0",  x"80",  x"00",  x"00",  x"ff",  x"ff", -- 0290
         x"ff",  x"f0",  x"f0",  x"f0",  x"00",  x"00",  x"ff",  x"ff", -- 0298
         x"ff",  x"0f",  x"0f",  x"0f",  x"f0",  x"f0",  x"f0",  x"ff", -- 02A0
         x"ff",  x"ff",  x"00",  x"00",  x"0f",  x"0f",  x"0f",  x"ff", -- 02A8
         x"ff",  x"ff",  x"00",  x"00",  x"20",  x"00",  x"08",  x"00", -- 02B0
         x"00",  x"00",  x"04",  x"08",  x"10",  x"20",  x"40",  x"00", -- 02B8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"ff", -- 02C0
         x"40",  x"20",  x"10",  x"08",  x"04",  x"00",  x"00",  x"ff", -- 02C8
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 02D0
         x"03",  x"0c",  x"18",  x"18",  x"00",  x"00",  x"00",  x"00", -- 02D8
         x"e0",  x"18",  x"0c",  x"0c",  x"0c",  x"18",  x"30",  x"00", -- 02E0
         x"01",  x"01",  x"01",  x"00",  x"00",  x"01",  x"01",  x"c0", -- 02E8
         x"80",  x"80",  x"80",  x"00",  x"00",  x"80",  x"80",  x"c0", -- 02F0
         x"02",  x"01",  x"00",  x"66",  x"7e",  x"24",  x"24",  x"7e", -- 02F8
         x"66",  x"00",  x"18",  x"00",  x"04",  x"00",  x"7e",  x"7e", -- 0300
         x"7e",  x"7e",  x"7e",  x"7e",  x"7e",  x"7e",  x"7e",  x"7e", -- 0308
         x"7e",  x"7e",  x"7e",  x"7e",  x"00",  x"00",  x"7f",  x"7f", -- 0310
         x"7f",  x"7f",  x"7f",  x"7f",  x"00",  x"00",  x"fe",  x"fe", -- 0318
         x"fe",  x"fe",  x"fe",  x"fe",  x"00",  x"20",  x"00",  x"04", -- 0320
         x"00",  x"00",  x"01",  x"0f",  x"3f",  x"7f",  x"ff",  x"ff", -- 0328
         x"00",  x"00",  x"80",  x"f0",  x"fc",  x"fe",  x"ff",  x"ff", -- 0330
         x"ff",  x"ff",  x"7f",  x"3f",  x"0f",  x"01",  x"00",  x"00", -- 0338
         x"ff",  x"ff",  x"fe",  x"fc",  x"f0",  x"80",  x"00",  x"00", -- 0340
         x"20",  x"00",  x"04",  x"01",  x"03",  x"07",  x"0f",  x"1f", -- 0348
         x"3f",  x"7f",  x"ff",  x"80",  x"c0",  x"e0",  x"f0",  x"f8", -- 0350
         x"fc",  x"fe",  x"ff",  x"ff",  x"7f",  x"3f",  x"1f",  x"0f", -- 0358
         x"07",  x"03",  x"01",  x"ff",  x"fe",  x"fc",  x"f8",  x"f0", -- 0360
         x"e0",  x"c0",  x"80",  x"20",  x"00",  x"04",  x"00",  x"7f", -- 0368
         x"3f",  x"1f",  x"0f",  x"07",  x"03",  x"01",  x"00",  x"fe", -- 0370
         x"fc",  x"f8",  x"f0",  x"e0",  x"c0",  x"80",  x"01",  x"03", -- 0378
         x"07",  x"0f",  x"1f",  x"3f",  x"7f",  x"00",  x"80",  x"c0", -- 0380
         x"e0",  x"f0",  x"f8",  x"fc",  x"fe",  x"00",  x"20",  x"00", -- 0388
         x"04",  x"ff",  x"80",  x"80",  x"80",  x"80",  x"80",  x"80", -- 0390
         x"80",  x"ff",  x"01",  x"01",  x"01",  x"01",  x"01",  x"01", -- 0398
         x"01",  x"80",  x"80",  x"80",  x"80",  x"80",  x"80",  x"80", -- 03A0
         x"ff",  x"01",  x"01",  x"01",  x"01",  x"01",  x"01",  x"01", -- 03A8
         x"ff",  x"c0",  x"02",  x"08",  x"00",  x"00",  x"00",  x"18", -- 03B0
         x"18",  x"00",  x"00",  x"00",  x"00",  x"18",  x"3c",  x"7e", -- 03B8
         x"ff",  x"7e",  x"3c",  x"18",  x"7e",  x"7e",  x"7e",  x"7e", -- 03C0
         x"7e",  x"7e",  x"7e",  x"7e",  x"00",  x"ff",  x"ff",  x"ff", -- 03C8
         x"ff",  x"ff",  x"ff",  x"00",  x"00",  x"7e",  x"7e",  x"7e", -- 03D0
         x"7e",  x"7e",  x"7e",  x"7e",  x"7e",  x"7e",  x"7e",  x"7e", -- 03D8
         x"7e",  x"7e",  x"7e",  x"00",  x"00",  x"7f",  x"7f",  x"7f", -- 03E0
         x"7f",  x"7f",  x"7f",  x"00",  x"00",  x"fe",  x"fe",  x"fe", -- 03E8
         x"fe",  x"fe",  x"fe",  x"00",  x"0e",  x"ff",  x"ff",  x"ff", -- 03F0
         x"ff",  x"ff",  x"ff",  x"ff",  x"ff",  x"ff",  x"ff",  x"ff"  -- 03F8
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;
