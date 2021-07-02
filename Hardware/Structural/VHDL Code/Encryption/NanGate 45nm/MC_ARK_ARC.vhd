library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MC_ARK_ARC is
    Port ( datainput : in STD_LOGIC_VECTOR (191 downto 0);
           keyinput : in STD_LOGIC_VECTOR (191 downto 0);
           output : out STD_LOGIC_VECTOR (191 downto 0));
end MC_ARK_ARC;

architecture Behavioral of MC_ARK_ARC is

    component BUF_X1 is
        Port ( A : in STD_LOGIC;
               Z : out STD_LOGIC);
    end component;
    
    component XNOR2_X1 is
        Port ( A : in STD_LOGIC;
               B : in STD_LOGIC;
               ZN  : out STD_LOGIC);
    end component;
               
    signal buf_datainput, buf_keyinput : STD_LOGIC_VECTOR (191 downto 0);
    signal temp1, temp2, temp3, temp4, temp5, temp6 : STD_LOGIC_VECTOR (191 downto 0);

begin

    BUF_in_data : for i in 0 to 191 generate
	    BUF : BUF_X1 Port Map (datainput(i), buf_datainput(i));
    end generate;

    BUF_in_key : for i in 0 to 191 generate
	    BUF : BUF_X1 Port Map (keyinput(i), buf_keyinput(i));
    end generate;

    Rows : for i in 0 to 31 generate
        Columns : for j in 0 to 5 generate
            X1 : XNOR2_X1 Port Map (buf_datainput(191-(i*6+j)), buf_datainput(191-(((i+1) mod 32)*6+j)), temp1(191-(i*6+j)));
            X2 : XNOR2_X1 Port Map (buf_datainput(191-(((i+5) mod 32)*6+j)), buf_datainput(191-(((i+9) mod 32)*6+j)), temp2(191-(i*6+j)));
            X3 : XNOR2_X1 Port Map (buf_datainput(191-(((i+15) mod 32)*6+j)), buf_datainput(191-(((i+21) mod 32)*6+j)), temp3(191-(i*6+j)));
            X4 : XNOR2_X1 Port Map (buf_datainput(191-(((i+26) mod 32)*6+j)), buf_keyinput(191-(i*6+j)), temp4(191-(i*6+j)));
            
            X5 : XNOR2_X1 Port Map (temp1(191-(i*6+j)), temp2(191-(i*6+j)), temp5(191-(i*6+j)));
            X6 : XNOR2_X1 Port Map (temp3(191-(i*6+j)), temp4(191-(i*6+j)), temp6(191-(i*6+j)));
            
            X7 : XNOR2_X1 Port Map (temp5(191-(i*6+j)), temp6(191-(i*6+j)), output(191-(i*6+j)));
        end generate;
    end generate;

end Behavioral;