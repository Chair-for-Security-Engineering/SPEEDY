library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NAND_TREE_4x3 is
    Port ( input : in STD_LOGIC_VECTOR (11 downto 0);
           output : out STD_LOGIC);
end NAND_TREE_4x3;

architecture Behavioral of NAND_TREE_4x3 is

    component NAND3_X1 is
		Port ( A1 : in STD_LOGIC;
			   A2 : in STD_LOGIC;
			   A3 : in STD_LOGIC;
			   ZN : out STD_LOGIC);
	end component;

    component NAND4_X1 is
		Port ( A1 : in STD_LOGIC;
			   A2 : in STD_LOGIC;
			   A3 : in STD_LOGIC;
			   A4 : in STD_LOGIC;
			   ZN : out STD_LOGIC);
	end component;

    signal NAND4_in : STD_LOGIC_VECTOR(3 downto 0);

begin

	N1 : NAND3_X1 Port Map (input(11), input(10), input(9), NAND4_in(0));
	N2 : NAND3_X1 Port Map (input(8), input(7), input(6), NAND4_in(1));
	N3 : NAND3_X1 Port Map (input(5), input(4), input(3), NAND4_in(2));
	N4 : NAND3_X1 Port Map (input(2), input(1), input(0), NAND4_in(3));

    N5 : NAND4_X1 Port Map (NAND4_in(0), NAND4_in(1), NAND4_in(2), NAND4_in(3), output);

end Behavioral;