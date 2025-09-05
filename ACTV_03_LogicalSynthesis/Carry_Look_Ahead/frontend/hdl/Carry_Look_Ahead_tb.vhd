LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Carry_Look_Ahead_tb IS
END Carry_Look_Ahead_tb;

ARCHITECTURE behavior OF Carry_Look_Ahead_tb IS

  -- -- Componente do DUV
  COMPONENT Carry_Look_Ahead
  PORT(
    clk_i  : IN std_logic;
    rst_i  : IN std_logic;
    A    : IN std_logic_vector(3 downto 0);
    B    : IN std_logic_vector(3 downto 0);
    Cin  : IN std_logic;
    S    : OUT std_logic_vector(3 downto 0);
    Cout : OUT std_logic
  );
  END COMPONENT;

  -- Clock e Reset
  signal clk  : std_logic := '0';
  signal rst  : std_logic := '1';

  -- Entradas
  signal A    : std_logic_vector(3 downto 0) := (others => '0');
  signal B    : std_logic_vector(3 downto 0) := (others => '0');
  signal Cin  : std_logic := '0';

  -- Saídas
  signal S    : std_logic_vector(3 downto 0);
  signal Cout : std_logic;

  constant CLK_PERIOD : time := 2 ns;

BEGIN

  -- Clock 100 MHz
  clk <= not clk after CLK_PERIOD/2;

  -- Instância do DUV
  duv: Carry_Look_Ahead
  PORT MAP (
    clk_i  => clk,
    rst_i  => rst,
    A    => A,
    B    => B,
    Cin  => Cin,
    S    => S,
    Cout => Cout
  );

  -- Estímulos (mesma estrutura: waits fixos + mais casos)
  stim_proc: process
  begin
    -- Reset inicial alto por 20 ns
    rst <= '1';
    A   <= (others => '0');
    B   <= (others => '0');
    Cin <= '0';
    wait for 20 ns;
    rst <= '0';

    --  1
    wait for 10 ns;
    A   <= "1111";
    B   <= "1111";
    Cin <= '1';

    --  2
    wait for 10 ns;
    A   <= "1010";
    B   <= "0111";
    Cin <= '0';

    --  3
    wait for 10 ns;
    A   <= "1000";
    B   <= "1001";
    Cin <= '0';


    -- 4) zeros
    wait for 10 ns;
    A   <= "0000";
    B   <= "0000";
    Cin <= '0';

    -- 5) 
    wait for 10 ns;
    A   <= "0011";           
    B   <= "0101";          
    Cin <= '0';

    -- 6) 
    wait for 10 ns;
    A   <= "0111";       
    B   <= "0001";           
    Cin <= '0';

    -- 7) 
    wait for 10 ns;
    A   <= "0000";
    B   <= "0001";
    Cin <= '1';              

    -- 8) 
    wait for 10 ns;
    A   <= "0101";           
    B   <= "0011";           
    Cin <= '1';              

    -- 9) 
    wait for 10 ns;
    A   <= "1111";          
    B   <= "1111";           
    Cin <= '1';             

    -- 10) 
    wait for 10 ns;
    A   <= "1010";          
    B   <= "0101";           
    Cin <= '0';

    -- 11) 
    wait for 10 ns;
    A   <= "1001";            
    B   <= "0011";           
    Cin <= '1';               

    -- 12) 
    wait for 10 ns;
    A   <= "1111";           
    B   <= "0000";            
    Cin <= '0';

    -- 13) 
    wait for 10 ns;
    A   <= "1111";           
    B   <= "0000";            
    Cin <= '1';              

    -- 14) 
    wait for 10 ns;
    A   <= "0110";            
    B   <= "1100";            
    Cin <= '0';               

    -- 15) 
    wait for 10 ns;
    A   <= "0010";            
    B   <= "1011";           
    Cin <= '1';              

    -- 16) 
    wait for 10 ns;
    A   <= "0101";           
    B   <= "1010";            
    Cin <= '1';              

    wait;
  end process;

END behavior;
