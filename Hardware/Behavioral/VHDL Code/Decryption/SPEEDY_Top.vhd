library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPEEDY_Top is
    Port ( clk : in STD_LOGIC;
           Ciphertext : in STD_LOGIC_VECTOR (191 downto 0);
           Key : in STD_LOGIC_VECTOR (191 downto 0);
           Plaintext : out STD_LOGIC_VECTOR (191 downto 0));
end SPEEDY_Top;

architecture Behavioral of SPEEDY_Top is

    component SPEEDY is
        Generic ( Rounds : integer := 6);
        Port ( Ciphertext : in STD_LOGIC_VECTOR (191 downto 0);
               Key : in STD_LOGIC_VECTOR (191 downto 0);
               Plaintext : out STD_LOGIC_VECTOR (191 downto 0));
    end component;

    signal reg_in, reg_key, reg_out : STD_LOGIC_VECTOR(191 downto 0);

begin

    SPEEDY_instance : SPEEDY generic map (7) port map (reg_in, reg_key, reg_out);

    REGs : process(clk)
    begin
        if rising_edge(clk) then
            reg_in <= Ciphertext;
            reg_key <= Key;
            Plaintext <= reg_out;
        end if;
    end process;

end Behavioral;