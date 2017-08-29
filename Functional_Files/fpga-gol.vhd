library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FPGAGoL is
port(
    --System Clocks:
    logic_clock : in std_logic;
    video_clock : in std_logic;
    
    --Memory Port A0:
    a0_address : out std_logic_vector (19 downto 0);
    a0_data_to : out std_logic_vector (0 downto 0);
    a0_data_from : in std_logic_vector (0 downto 0);
    a0_port_en : out std_logic;
    a0_write_en : out std_logic_vector (0 downto 0);
    
    --Memory Port B0:
    b0_address : out std_logic_vector (19 downto 0);
    b0_data_to : out std_logic_vector (0 downto 0);
    b0_data_from : in std_logic_vector (0 downto 0);
    b0_port_en : out std_logic;
    b0_write_en : out std_logic_vector (0 downto 0);
    
    --Memory Port A1:
    a1_address : out std_logic_vector (19 downto 0);
    a1_data_to : out std_logic_vector (0 downto 0);
    a1_data_from : in std_logic_vector (0 downto 0);
    a1_port_en : out std_logic;
    a1_write_en : out std_logic_vector (0 downto 0);
    
    --Memory Port B1:
    b1_address : out std_logic_vector (19 downto 0);
    b1_data_to : out std_logic_vector (0 downto 0);
    b1_data_from : in std_logic_vector (0 downto 0);
    b1_port_en : out std_logic;
    b1_write_en : out std_logic_vector (0 downto 0);
    
    --Video Port:
    vga_vs : out std_logic;
    vga_hs : out std_logic;
    vga_r : out std_logic_vector (4 downto 0);
    vga_g : out std_logic_vector (5 downto 0);
    vga_b : out std_logic_vector (4 downto 0)
);
end FPGAGoL;

architecture Behavioral of FPGAGoL is
    --Internal Read-Only Logic Memory Port:
    signal read_an_address : std_logic_vector (19 downto 0) := (others => '0');
    signal read_an_data_from : std_logic_vector (0 downto 0) := "0";
    signal read_an_port_en : std_logic := '0';
    
    --Internal Write-Only Logic Memory Port:
    signal write_an_address : std_logic_vector (19 downto 0) := (others => '0');
    signal write_an_data_to : std_logic_vector (0 downto 0) := "0";
    signal write_an_port_en : std_logic := '0';
    
    --Internal Read-Only Video Memory Port:
    signal read_bn_address : std_logic_vector (19 downto 0) := (others => '0');
    signal read_bn_data_from : std_logic_vector (0 downto 0) := "0";
    signal read_bn_port_en : std_logic := '0';
    
    --Current Read Buffer Selected:
    signal read_select : std_logic := '0';
    
    --Video Active:
    signal video_active : std_logic := '0';
    
	--Signals To Prevent Incorrect Synthesis Warning:
	signal dummy_0 : std_logic_vector (0 downto 0);
	signal dummy_1 : std_logic_vector (0 downto 0);
begin
    --Concurrent System Routing:
    with read_select select a0_address <= read_an_address when '0', write_an_address when '1';
    with read_select select a0_data_to <= (others => '0') when '0', write_an_data_to when '1';
    with read_select select a0_port_en <= read_an_port_en when '0', write_an_port_en when '1';
    with read_select select a0_write_en <= "0" when '0', "1" when '1';
	
    with read_select select a1_address <= read_an_address when '1', write_an_address when '0';
    with read_select select a1_data_to <= (others => '0') when '1', write_an_data_to when '0';
    with read_select select a1_port_en <= read_an_port_en when '1', write_an_port_en when '0';
    with read_select select a1_write_en <= "0" when '1', "1" when '0';
	
    with read_select select read_an_data_from <= a0_data_from when '0', a1_data_from when '1';
	with read_select select dummy_0 <= a0_data_from when '1', a1_data_from when '0';
	
    with read_select select b0_address <= read_bn_address when '0', (others => '0') when '1';
    with read_select select b0_port_en <= read_bn_port_en when '0', '0' when '1';
    with read_select select b1_address <= read_bn_address when '1', (others => '0') when '0';
    with read_select select b1_port_en <= read_bn_port_en when '1', '0' when '0';
	
    with read_select select read_bn_data_from <= b0_data_from when '0', b1_data_from when '1';
	with read_select select dummy_1 <= b0_data_from when '1', b1_data_from when '0';
    
    --Logic Finite State Machine:
	logic_fsm: process(logic_clock)
		variable state : integer range 0 to 14 := 0;
		variable life_old : std_logic_vector (8 downto 0) := (others => '0');
		variable life_new : std_logic := '0';
		variable x_count : integer range 0 to 1023 := 0;
		variable y_count : integer range 0 to 767 := 0;
		variable read_select_var : std_logic := '0';
	begin
		if rising_edge(logic_clock) then
			case life_old is
				when "000000111" => life_new := '1';
				when "000001011" => life_new := '1';
				when "000001101" => life_new := '1';
				when "000001110" => life_new := '1';
				when "000010011" => life_new := '1';
				when "000010101" => life_new := '1';
				when "000010110" => life_new := '1';
				when "000011001" => life_new := '1';
				when "000011010" => life_new := '1';
				when "000011100" => life_new := '1';
				when "000100011" => life_new := '1';
				when "000100101" => life_new := '1';
				when "000100110" => life_new := '1';
				when "000101001" => life_new := '1';
				when "000101010" => life_new := '1';
				when "000101100" => life_new := '1';
				when "000110001" => life_new := '1';
				when "000110010" => life_new := '1';
				when "000110100" => life_new := '1';
				when "000111000" => life_new := '1';
				when "001000011" => life_new := '1';
				when "001000101" => life_new := '1';
				when "001000110" => life_new := '1';
				when "001001001" => life_new := '1';
				when "001001010" => life_new := '1';
				when "001001100" => life_new := '1';
				when "001010001" => life_new := '1';
				when "001010010" => life_new := '1';
				when "001010100" => life_new := '1';
				when "001011000" => life_new := '1';
				when "001100001" => life_new := '1';
				when "001100010" => life_new := '1';
				when "001100100" => life_new := '1';
				when "001101000" => life_new := '1';
				when "001110000" => life_new := '1';
				when "010000011" => life_new := '1';
				when "010000101" => life_new := '1';
				when "010000110" => life_new := '1';
				when "010001001" => life_new := '1';
				when "010001010" => life_new := '1';
				when "010001100" => life_new := '1';
				when "010010001" => life_new := '1';
				when "010010010" => life_new := '1';
				when "010010100" => life_new := '1';
				when "010011000" => life_new := '1';
				when "010100001" => life_new := '1';
				when "010100010" => life_new := '1';
				when "010100100" => life_new := '1';
				when "010101000" => life_new := '1';
				when "010110000" => life_new := '1';
				when "011000001" => life_new := '1';
				when "011000010" => life_new := '1';
				when "011000100" => life_new := '1';
				when "011001000" => life_new := '1';
				when "011010000" => life_new := '1';
				when "011100000" => life_new := '1';
				when "100000011" => life_new := '1';
				when "100000101" => life_new := '1';
				when "100000110" => life_new := '1';
				when "100000111" => life_new := '1';
				when "100001001" => life_new := '1';
				when "100001010" => life_new := '1';
				when "100001011" => life_new := '1';
				when "100001100" => life_new := '1';
				when "100001101" => life_new := '1';
				when "100001110" => life_new := '1';
				when "100010001" => life_new := '1';
				when "100010010" => life_new := '1';
				when "100010011" => life_new := '1';
				when "100010100" => life_new := '1';
				when "100010101" => life_new := '1';
				when "100010110" => life_new := '1';
				when "100011000" => life_new := '1';
				when "100011001" => life_new := '1';
				when "100011010" => life_new := '1';
				when "100011100" => life_new := '1';
				when "100100001" => life_new := '1';
				when "100100010" => life_new := '1';
				when "100100011" => life_new := '1';
				when "100100100" => life_new := '1';
				when "100100101" => life_new := '1';
				when "100100110" => life_new := '1';
				when "100101000" => life_new := '1';
				when "100101001" => life_new := '1';
				when "100101010" => life_new := '1';
				when "100101100" => life_new := '1';
				when "100110000" => life_new := '1';
				when "100110001" => life_new := '1';
				when "100110010" => life_new := '1';
				when "100110100" => life_new := '1';
				when "100111000" => life_new := '1';
				when "101000001" => life_new := '1';
				when "101000010" => life_new := '1';
				when "101000011" => life_new := '1';
				when "101000100" => life_new := '1';
				when "101000101" => life_new := '1';
				when "101000110" => life_new := '1';
				when "101001000" => life_new := '1';
				when "101001001" => life_new := '1';
				when "101001010" => life_new := '1';
				when "101001100" => life_new := '1';
				when "101010000" => life_new := '1';
				when "101010001" => life_new := '1';
				when "101010010" => life_new := '1';
				when "101010100" => life_new := '1';
				when "101011000" => life_new := '1';
				when "101100000" => life_new := '1';
				when "101100001" => life_new := '1';
				when "101100010" => life_new := '1';
				when "101100100" => life_new := '1';
				when "101101000" => life_new := '1';
				when "101110000" => life_new := '1';
				when "110000001" => life_new := '1';
				when "110000010" => life_new := '1';
				when "110000011" => life_new := '1';
				when "110000100" => life_new := '1';
				when "110000101" => life_new := '1';
				when "110000110" => life_new := '1';
				when "110001000" => life_new := '1';
				when "110001001" => life_new := '1';
				when "110001010" => life_new := '1';
				when "110001100" => life_new := '1';
				when "110010000" => life_new := '1';
				when "110010001" => life_new := '1';
				when "110010010" => life_new := '1';
				when "110010100" => life_new := '1';
				when "110011000" => life_new := '1';
				when "110100000" => life_new := '1';
				when "110100001" => life_new := '1';
				when "110100010" => life_new := '1';
				when "110100100" => life_new := '1';
				when "110101000" => life_new := '1';
				when "110110000" => life_new := '1';
				when "111000000" => life_new := '1';
				when "111000001" => life_new := '1';
				when "111000010" => life_new := '1';
				when "111000100" => life_new := '1';
				when "111001000" => life_new := '1';
				when "111010000" => life_new := '1';
				when "111100000" => life_new := '1';
				when others => life_new := '0';
			end case;
			case state is
				when 0 =>
					state := 1;
				when 1 =>
					life_old(8) := read_an_data_from(0);

					state := 2;
				when 2 =>
					life_old(7) := read_an_data_from(0);

					state := 3;
				when 3 =>
					life_old(6) := read_an_data_from(0);

					state := 4;
				when 4 =>
					life_old(5) := read_an_data_from(0);

					state := 5;
				when 5 =>
					life_old(4) := read_an_data_from(0);

					state := 6;
				when 6 =>
					life_old(3) := read_an_data_from(0);

					state := 7;
				when 7 =>
					life_old(2) := read_an_data_from(0);
					
					state := 8;
				when 8 =>
					life_old(1) := read_an_data_from(0);
					
					state := 9;
				when 9 =>
					life_old(0) := read_an_data_from(0);
					
					state := 10;
                when 10 =>
                    state := 11;
				when 11 =>
					state := 12;
				when 12 =>
					if(x_count < 1023) then
						x_count := x_count + 1;
						state := 0;
					else
						x_count := 0;
						if(y_count < 767) then
							y_count := y_count + 1;
							state := 0;
						else
							y_count := 0;
							state := 13;
						end if;
					end if;
				when 13 =>
					if(video_active = '1') then
						state := 13;
					else
						state := 14;
					end if;
				when 14 =>
					read_select_var := not read_select_var;
					
					state := 0;
			end case;
			read_select <= read_select_var;
		end if;
		if falling_edge(logic_clock) then
			case state is
				when 0 =>
					read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(y_count, 10));
					read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(x_count, 10));
					--read_an_data_from
					read_an_port_en <= '1';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 1 =>
					if (y_count - 1 < 0) then
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(767, 10));
					else
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(y_count - 1, 10));
					end if;
					if (x_count - 1 < 0) then
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(1023, 10));
					else
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(x_count - 1, 10));
					end if;
					read_an_port_en <= '1';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 2 =>
					if (y_count - 1 < 0) then
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(767, 10));
					else
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(y_count - 1, 10));
					end if;
					read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(x_count, 10));
					read_an_port_en <= '1';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 3 =>
					if (y_count - 1 < 0) then
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(767, 10));
					else
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(y_count - 1, 10));
					end if;
					if (x_count + 1 > 1023) then
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(0, 10));
					else
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(x_count + 1, 10));
					end if;
					read_an_port_en <= '1';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 4 =>
					read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(y_count, 10));
					if (x_count - 1 < 0) then
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(1023, 10));
					else
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(x_count - 1, 10));
					end if;
					read_an_port_en <= '1';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 5 =>
					read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(y_count, 10));
					if (x_count + 1 > 1023) then
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(0, 10));
					else
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(x_count + 1, 10));
					end if;
					read_an_port_en <= '1';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 6 =>
					if (y_count + 1 > 767) then
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(0, 10));
					else
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(y_count + 1, 10));
					end if;
					if (x_count - 1 < 0) then
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(1023, 10));
					else
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(x_count - 1, 10));
					end if;
					read_an_port_en <= '1';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 7 =>
					if (y_count + 1 > 767) then
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(0, 10));
					else
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(y_count + 1, 10));
					end if;
					read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(x_count, 10));
					read_an_port_en <= '1';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 8 =>
					if (y_count + 1 > 767) then
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(0, 10));
					else
						read_an_address(19 downto 10) <= std_logic_vector(to_unsigned(y_count + 1, 10));
					end if;
					if (x_count + 1 > 1023) then
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(0, 10));
					else
						read_an_address(9 downto 0) <= std_logic_vector(to_unsigned(x_count + 1, 10));
					end if;
					read_an_port_en <= '1';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 9 =>
					read_an_address <= (others => '0');
					read_an_port_en <= '0';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 10 =>
                    read_an_address <= (others => '0');
                    read_an_port_en <= '0';
                    
                    write_an_address <= (others => '0');
                    write_an_data_to <= "0";
                    write_an_port_en <= '0';	
				when 11 =>
					read_an_address <= (others => '0');
					--read_an_data_from
					read_an_port_en <= '0';
					
					write_an_address(19 downto 10) <= std_logic_vector(to_unsigned(y_count, 10));
					write_an_address(9 downto 0) <= std_logic_vector(to_unsigned(x_count, 10));
					write_an_data_to(0) <= life_new;
					write_an_port_en <= '1';
				when 12 =>
					read_an_address <= (others => '0');
					--read_an_data_from
					read_an_port_en <= '0';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 13 =>
					read_an_address <= (others => '0');
					--read_an_data_from
					read_an_port_en <= '0';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
				when 14 =>
					read_an_address <= (others => '0');
					--read_an_data_from
					read_an_port_en <= '0';
					
					write_an_address <= (others => '0');
					write_an_data_to <= "0";
					write_an_port_en <= '0';
			end case;
		end if;
	end process;
	
    --Video Finite State Machine:
	video_fsm: process(video_clock)
		variable h_count : integer range 0 to 1343 := 0;
		variable v_count : integer range 0 to 805 := 0;
	begin
		if rising_edge(video_clock) then
			if (h_count < 1343) then
				h_count := h_count + 1;
			else
				h_count := 0;
				if (v_count < 805) then
					v_count := v_count + 1;
				else
					v_count := 0;
				end if;
			end if;
			if (h_count < 1048 or h_count > 1184) then
				vga_hs <= '1';
			else
				vga_hs <= '0';
			end if;
			if (v_count < 771 or v_count > 777) then
				vga_vs <= '1';
			else
				vga_vs <= '0';
			end if;
			if (h_count < 1024) then
				read_bn_address(9 downto 0) <= std_logic_vector(to_unsigned(h_count, 10));
			else
				read_bn_address(9 downto 0) <= (others => '0');
			end if;
			if (v_count < 768) then
				read_bn_address(19 downto 10) <= std_logic_vector(to_unsigned(v_count, 10));
				video_active <= '1';
				read_bn_port_en <= '1';
			else
				read_bn_address(19 downto 10) <= (others => '0');
				video_active <= '0';
				read_bn_port_en <= '0';
			end if;
		end if;
	end process;
	
	--B Memory Ports Are Read Only:
	b0_write_en <= "0";
	b0_data_to <= "0";
	b1_write_en <= "0";
	b1_data_to <= "0";
	
	--Video Output Logic:
    vga_r <= (others => read_bn_data_from(0));
	vga_g <= (others => read_bn_data_from(0));
	vga_b <= (others => read_bn_data_from(0));
end Behavioral;
