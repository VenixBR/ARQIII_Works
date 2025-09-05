library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Carry_Look_Ahead is
    Port (
        clk_i   : in  STD_LOGIC;
        rst_i   : in  STD_LOGIC;
        A     : in  STD_LOGIC_VECTOR (3 downto 0);
        B     : in  STD_LOGIC_VECTOR (3 downto 0);
        Cin   : in  STD_LOGIC;
        S     : out STD_LOGIC_VECTOR (3 downto 0);
        Cout  : out STD_LOGIC
    );
end Carry_Look_Ahead;

architecture RTL of Carry_Look_Ahead is

    component Partial_Full_Adder
        Port (
            A   : in  STD_LOGIC;
            B   : in  STD_LOGIC;
            Cin : in  STD_LOGIC;
            S   : out STD_LOGIC;
            P   : out STD_LOGIC;
            G   : out STD_LOGIC
        );
    end component;

    signal c1, c2, c3 : STD_LOGIC;
    signal P, G       : STD_LOGIC_VECTOR(3 downto 0);
    signal sum_int    : STD_LOGIC_VECTOR(3 downto 0);
    signal cout_int   : STD_LOGIC;

    for all : Partial_Full_Adder use entity work.Partial_Full_Adder(Behavioral);
begin

    PFA1: Partial_Full_Adder port map( A(0), B(0), Cin, sum_int(0), P(0), G(0));
    PFA2: Partial_Full_Adder port map( A(1), B(1), c1, sum_int(1), P(1), G(1));
    PFA3: Partial_Full_Adder port map( A(2), B(2), c2, sum_int(2), P(2), G(2));
    PFA4: Partial_Full_Adder port map( A(3), B(3), c3, sum_int(3), P(3), G(3));

    c1 <= G(0) or (P(0) and Cin);
    c2 <= G(1) or (P(1) and G(0)) or (P(1) and P(0) and Cin);
    c3 <= G(2) or (P(2) and G(1)) or (P(2) and P(1) and G(0)) or (P(2) and P(1) and P(0) and Cin);
    cout_int <= G(3) or (P(3) and G(2)) or (P(3) and P(2) and G(1))
             or (P(3) and P(2) and P(1) and G(0))
             or (P(3) and P(2) and P(1) and P(0) and Cin);

    process(clk_i)
    begin
        --if rst_i = '1' then
        --    S    <= (others => '0');
        --    Cout <= '0';
        --els
	if rising_edge(clk_i) then
            S    <= sum_int;
            Cout <= cout_int;
        end if;
    end process;

end RTL;
