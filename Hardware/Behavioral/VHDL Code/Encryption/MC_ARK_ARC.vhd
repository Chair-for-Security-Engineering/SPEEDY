library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MC_ARK_ARC is
    Port ( datainput : in STD_LOGIC_VECTOR (191 downto 0);
           keyinput : in STD_LOGIC_VECTOR (191 downto 0);
           output : out STD_LOGIC_VECTOR (191 downto 0));
end MC_ARK_ARC;

architecture Behavioral of MC_ARK_ARC is

begin

    Rows : for i in 0 to 31 generate
        Columns : for j in 0 to 5 generate
            output(191-(i*6+j)) <= datainput(191-(i*6+j)) XOR datainput(191-(((i+1) mod 32)*6+j)) XOR datainput(191-(((i+5) mod 32)*6+j)) XOR datainput(191-(((i+9) mod 32)*6+j)) XOR datainput(191-(((i+15) mod 32)*6+j)) XOR datainput(191-(((i+21) mod 32)*6+j)) XOR datainput(191-(((i+26) mod 32)*6+j)) XOR keyinput(191-(i*6+j));
        end generate;
    end generate;

end Behavioral;