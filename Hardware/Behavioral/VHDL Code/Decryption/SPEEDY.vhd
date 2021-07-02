library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPEEDY is
    Generic ( Rounds : integer := 6);
    Port ( Ciphertext : in STD_LOGIC_VECTOR (191 downto 0);
           Key : in STD_LOGIC_VECTOR (191 downto 0);
           Plaintext : out STD_LOGIC_VECTOR (191 downto 0));
end SPEEDY;

architecture Behavioral of SPEEDY is
    
    component SB is
        Port ( input : in STD_LOGIC_VECTOR (5 downto 0);
               output : out STD_LOGIC_VECTOR (5 downto 0));
    end component;
    
    component MC_ARK_ARC is
        Port ( datainput : in STD_LOGIC_VECTOR (191 downto 0);
               keyinput : in STD_LOGIC_VECTOR (191 downto 0);
               output : out STD_LOGIC_VECTOR (191 downto 0));
    end component;
    
    type RoundKey is array (0 to Rounds) of STD_LOGIC_VECTOR (191 downto 0);
    signal RK : RoundKey;
    type RoundConstants is array (0 to 7) of STD_LOGIC_VECTOR (191 downto 0);
    constant RC : RoundConstants := (   x"243f6a8885a308d313198a2e03707344a4093822299f31d0",
                                        x"082efa98ec4e6c89452821e638d01377be5466cf34e90c6c",
                                        x"c0ac29b7c97c50dd3f84d5b5b54709179216d5d98979fb1b",
                                        x"d1310ba698dfb5ac2ffd72dbd01adfb7b8e1afed6a267e96",
                                        x"ba7c9045f12c7f9924a19947b3916cf70801f2e2858efc16",
                                        x"636920d871574e69a458fea3f4933d7e0d95748f728eb658",
                                        x"718bcd5882154aee7b54a41dc25a59b59c30d5392af26013",
                                        x"c5d1b023286085f0ca417918b8db38ef8e79dcb0603a180e" );
    type RoundKeyConstants is array (0 to (Rounds-2)) of STD_LOGIC_VECTOR (191 downto 0);
    signal RKC : RoundKey;
    type RoundState is array (0 to (Rounds-1)) of STD_LOGIC_VECTOR (191 downto 0);
    signal RI1, RI2, RI3, RI4, RI5 : RoundState;

begin

    -- Key schedule
    RK(0) <= Key;
    KeySchedule : for i in 0 to (Rounds-1) generate
        PB_rows : for j in 0 to 31 generate
            PB_columns : for k in 0 to 5 generate
                RK(i+1)(191-(j*6+k)) <= RK(i)(191-((7*(j*6+k)+1) mod 192));
            end generate;
        end generate;
    end generate;
    
    -- Round constants
    AddRoundConstants : for i in 0 to (Rounds-2) generate
        RKC(i) <= RK(i+1) XOR RC(i);
    end generate;

    -- First Round (of Decryption)
	-- ARK
    RI1(0) <= Ciphertext XOR RK(Rounds);
    
    -- SB^-1
    SB1_rows : for j in 0 to 31 generate
        SB1 : SB port map (RI1(0)(191-j*6 downto 186-j*6), RI2(0)(191-j*6 downto 186-j*6));
    end generate;

    -- SC^-1
    SC1_rows : for j in 0 to 31 generate
        SC1_columns : for k in 0 to 5 generate
            RI3(0)(191-((j*6+k*7) mod 192)) <= RI2(0)(191-(j*6+k));
        end generate;
    end generate;

    -- SB^-1
    SB2_rows : for j in 0 to 31 generate
        SB2 : SB port map (RI3(0)(191-j*6 downto 186-j*6), RI5(0)(191-j*6 downto 186-j*6));
    end generate;

    -- Round function
    RoundFunction : for i in 1 to (Rounds-1) generate
    begin

        -- MC^-1 + ARK + ARC
        MC_ARK_ARC_1 : MC_ARK_ARC port map (RI5(i-1), RKC(Rounds-i-1), RI1(i));

        -- SC^-1
        SC2_rows : for j in 0 to 31 generate
            SC2_columns : for k in 0 to 5 generate
                RI2(i)(191-((j*6+k*7) mod 192)) <= RI1(i)(191-(j*6+k));
            end generate;
        end generate;

        -- SB^-1
        SB3_rows : for j in 0 to 31 generate
            SB3 : SB port map (RI2(i)(191-j*6 downto 186-j*6), RI3(i)(191-j*6 downto 186-j*6));
        end generate;

        -- SC^-1
        SC3_rows : for j in 0 to 31 generate
            SC3_columns : for k in 0 to 5 generate
                RI4(i)(191-((j*6+k*7) mod 192)) <= RI3(i)(191-(j*6+k));
            end generate;
        end generate;

        -- SB^-1
        SB4_rows : for j in 0 to 31 generate
            SB4 : SB port map (RI4(i)(191-j*6 downto 186-j*6), RI5(i)(191-j*6 downto 186-j*6));
        end generate;

    end generate;

	-- ARK
    Plaintext <= RI5(Rounds-1) XOR RK(0);

end Behavioral;