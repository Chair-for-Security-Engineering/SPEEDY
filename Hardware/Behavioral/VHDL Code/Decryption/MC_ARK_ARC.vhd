library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MC_ARK_ARC is
    Port ( datainput : in STD_LOGIC_VECTOR (191 downto 0);
           keyinput : in STD_LOGIC_VECTOR (191 downto 0);
           output : out STD_LOGIC_VECTOR (191 downto 0));
end MC_ARK_ARC;

architecture Behavioral of MC_ARK_ARC is

    signal data_key_xor : STD_LOGIC_VECTOR (191 downto 0);
    
begin

    data_key_xor <= datainput XOR keyinput;
    
    Rows : for i in 0 to 31 generate
        Columns : for j in 0 to 5 generate
            output(191-(i*6+j)) <= data_key_xor(191-(i*6+j)) XOR data_key_xor(191-(((i+4) mod 32)*6+j)) XOR data_key_xor(191-(((i+5) mod 32)*6+j)) XOR data_key_xor(191-(((i+6) mod 32)*6+j)) XOR data_key_xor(191-(((i+7) mod 32)*6+j)) XOR data_key_xor(191-(((i+10) mod 32)*6+j)) XOR data_key_xor(191-(((i+12) mod 32)*6+j))  XOR data_key_xor(191-(((i+14) mod 32)*6+j)) XOR data_key_xor(191-(((i+15) mod 32)*6+j)) XOR data_key_xor(191-(((i+16) mod 32)*6+j)) XOR data_key_xor(191-(((i+18) mod 32)*6+j)) XOR data_key_xor(191-(((i+19) mod 32)*6+j)) XOR data_key_xor(191-(((i+20) mod 32)*6+j)) XOR data_key_xor(191-(((i+21) mod 32)*6+j)) XOR data_key_xor(191-(((i+22) mod 32)*6+j)) XOR data_key_xor(191-(((i+23) mod 32)*6+j)) XOR data_key_xor(191-(((i+24) mod 32)*6+j)) XOR data_key_xor(191-(((i+25) mod 32)*6+j)) XOR data_key_xor(191-(((i+28) mod 32)*6+j));
        end generate;
    end generate;

end Behavioral;