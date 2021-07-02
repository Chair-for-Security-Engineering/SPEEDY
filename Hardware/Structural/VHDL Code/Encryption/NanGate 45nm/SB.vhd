library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SB is
    Port ( input : in STD_LOGIC_VECTOR (5 downto 0);
           output : out STD_LOGIC_VECTOR (5 downto 0));
end SB;

architecture Behavioral of SB is

    component NAND_TREE_1x2_3x3 is
        Port ( input : in STD_LOGIC_VECTOR (10 downto 0);
               output : out STD_LOGIC);
    end component;

    component NAND_TREE_4x3 is
        Port ( input : in STD_LOGIC_VECTOR (11 downto 0);
               output : out STD_LOGIC);
    end component;

    component BUF_X1 is
        Port ( A : in STD_LOGIC;
               Z : out STD_LOGIC);
    end component;

    component INV_X1 is
        Port ( A : in STD_LOGIC;
               ZN : out STD_LOGIC);
    end component;

    signal buf_input, inv_input : STD_LOGIC_VECTOR(5 downto 0);
    signal i0, i1, i5 : STD_LOGIC_VECTOR(10 downto 0);
    signal i2, i3, i4 : STD_LOGIC_VECTOR(11 downto 0);

begin

    BUF_in : for i in 0 to 5 generate
        BUF : BUF_X1 Port Map (input(i), buf_input(i));
    end generate;

    INV_in : for i in 0 to 5 generate
        INV : INV_X1 Port Map (input(i), inv_input(i));
    end generate;

    i0 <= buf_input(3) & buf_input(0) & inv_input(3) & inv_input(4) & buf_input(1) & buf_input(3) & buf_input(4) & buf_input(5) & inv_input(4) & buf_input(5) & buf_input(2);
    i1 <= buf_input(5) & inv_input(2) & buf_input(5) & inv_input(1) & inv_input(3) & inv_input(5) & buf_input(1) & buf_input(0) & inv_input(1) & inv_input(3) & buf_input(4);
    i2 <= inv_input(5) & buf_input(3) & inv_input(2) & buf_input(5) & buf_input(3) & buf_input(1) & buf_input(5) & inv_input(3) & buf_input(0) & inv_input(5) & buf_input(2) & buf_input(4);
    i3 <= inv_input(2) & buf_input(5) & buf_input(1) & buf_input(2) & buf_input(5) & buf_input(4) & inv_input(2) & inv_input(1) & buf_input(3) & inv_input(5) & inv_input(3) & inv_input(0);
    i4 <= buf_input(0) & buf_input(2) & inv_input(3) & inv_input(0) & buf_input(2) & inv_input(1) & buf_input(0) & buf_input(3) & buf_input(5) & inv_input(2) & inv_input(5) & buf_input(4);
    i5 <= buf_input(2) & inv_input(0) & buf_input(2) & buf_input(1) & buf_input(3) & inv_input(2) & buf_input(4) & buf_input(5) & buf_input(0) & buf_input(1) & buf_input(4);

    Component_Function_0 : NAND_TREE_1x2_3x3    Port Map (i0, output(0));
    Component_Function_1 : NAND_TREE_1x2_3x3    Port Map (i1, output(1));
    Component_Function_2 : NAND_TREE_4x3        Port Map (i2, output(2));
    Component_Function_3 : NAND_TREE_4x3        Port Map (i3, output(3));
    Component_Function_4 : NAND_TREE_4x3        Port Map (i4, output(4));
    Component_Function_5 : NAND_TREE_1x2_3x3    Port Map (i5, output(5));

end Behavioral;
