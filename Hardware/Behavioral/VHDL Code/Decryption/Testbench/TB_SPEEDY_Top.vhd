library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_SPEEDY_Top is
end TB_SPEEDY_Top;

architecture Behavioral of TB_SPEEDY_Top is

    component SPEEDY_Top is
        Port ( clk : in STD_LOGIC;
               Ciphertext : in STD_LOGIC_VECTOR (191 downto 0);
               Key : in STD_LOGIC_VECTOR (191 downto 0);
               Plaintext : out STD_LOGIC_VECTOR (191 downto 0));
    end component;
           
    constant clk_period : time := 10 ns;
    
    signal clk : STD_LOGIC;
    signal Ciphertext, Key, Plaintext : STD_LOGIC_VECTOR(191 downto 0);
    
begin

    UUT : SPEEDY_Top Port Map (clk, Ciphertext, Key, Plaintext);

    -- Clock Process
    clk_proc : process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;

    -- Stimulation Process
    stim_proc : process
    begin

        Ciphertext <= x"ED3D0EA11C427BD32570DF41C6FD66EBBF4916E760ED0943";
        Key <= x"764C4F6254E1BFF208E95862428FAED01584F4207A7E8477";

        wait for 3*clk_period;

        if (Plaintext = x"A13A632451070E4382A27F26A40682F3FE9FF68028D24FDB") then
            report "SUCCESS";
        else
            report "FAILURE";
        end if;

        wait;
    end process;

end Behavioral;
