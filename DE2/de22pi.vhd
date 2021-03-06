-- Implements a simple Nios II system for the DE2 board.
-- Inputs:  SW7 - 0 are parallel port inputs to the Nios II system.
--          CLOCK_50 is the system clock.
--          KEY0 is the active-low system reset.
-- Outputs: LEDG7 - 0 are parallel port outputs from the Nios II system.
--          SDRAM ports correspond to the signals in Figure 2; their names are those
--          used in the DE2 User Manual.
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY de22pi IS
    PORT (
        SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        CLOCK_50 : IN STD_LOGIC;
        LEDG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        DRAM_CLK, DRAM_CKE : OUT STD_LOGIC;
        DRAM_ADDR : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        DRAM_BA_0, DRAM_BA_1 : BUFFER STD_LOGIC;
        DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_WE_N : OUT STD_LOGIC;
        DRAM_DQ : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        DRAM_UDQM, DRAM_LDQM : BUFFER STD_LOGIC;
		  LCD_DATA : inout STD_LOGIC_VECTOR(7 downto 0);
		  LCD_ON, LCD_BLON, LCD_EN, LCD_RS, LCD_RW : out STD_LOGIC;
		  SD_CMD, SD_DAT, SD_DAT3 : INOUT STD_LOGIC;
		  SD_CLK : OUT STD_LOGIC;
		  SRAM_DQ : INOUT STD_LOGIC_VECTOR(15 downto 0);
		  SRAM_ADDR : OUT STD_LOGIC_VECTOR(17 downto 0);
		  SRAM_LB_N, SRAM_UB_N, SRAM_CE_N, SRAM_OE_N, SRAM_WE_N : OUT STD_LOGIC;
		  VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC : out STD_LOGIC;
		  VGA_R : out STD_LOGIC_VECTOR(9 downto 0);
		  VGA_G : out STD_LOGIC_VECTOR(9 downto 0);
		  VGA_B : out STD_LOGIC_VECTOR(9 downto 0);
		  I2C_SDAT : inout STD_LOGIC;
		  I2C_SCLK : out STD_LOGIC;
		  AUD_ADCLRCK, AUD_ADCDAT, AUD_DACLRCK, AUD_BCLK : in STD_LOGIC;
		  AUD_DACDAT : out STD_LOGIC;
		  AUD_XCK : out STD_LOGIC;
		  CLOCK_27 : IN STD_LOGIC;
		  GPIO_0 : inout STD_LOGIC_VECTOR(31 downto 0);
		  UART_RXD : in STD_LOGIC;
		  UART_TXD : out STD_LOGIC
		  );
END de22pi;

ARCHITECTURE Structure OF de22pi IS
    COMPONENT nios_system
        PORT (
            clk_clk : IN STD_LOGIC;
            reset_reset_n : IN STD_LOGIC;
            sdram_clk_clk : OUT STD_LOGIC;
            leds_export : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				keys_export : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            switches_export : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            sdram_wire_addr : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            sdram_wire_ba : BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
            sdram_wire_cas_n : OUT STD_LOGIC;
            sdram_wire_cke : OUT STD_LOGIC;
            sdram_wire_cs_n : OUT STD_LOGIC;
            sdram_wire_dq : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            sdram_wire_dqm : BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
            sdram_wire_ras_n : OUT STD_LOGIC;
            sdram_wire_we_n : OUT STD_LOGIC;
				lcd_data_DATA : inout STD_LOGIC_VECTOR(7 downto 0);
				lcd_data_ON : out STD_LOGIC;
				lcd_data_BLON : out STD_LOGIC;
				lcd_data_EN : out STD_LOGIC;
				lcd_data_RS : out STD_LOGIC;
				lcd_data_RW : out STD_LOGIC;
				sdcard_wire_b_SD_cmd : inout STD_LOGIC;
				sdcard_wire_b_SD_dat : inout STD_LOGIC;
				sdcard_wire_b_SD_dat3 : inout STD_LOGIC;
				sdcard_wire_o_SD_clock : out STD_LOGIC;
				pixel_buffer0_DQ: inout STD_LOGIC_VECTOR(15 downto 0);
				pixel_buffer0_ADDR: out STD_LOGIC_VECTOR(17 downto 0);
				pixel_buffer0_LB_N : out STD_LOGIC;
				pixel_buffer0_UB_N : out STD_LOGIC;
				pixel_buffer0_CE_N : out STD_LOGIC;
				pixel_buffer0_OE_N : out STD_LOGIC;
				pixel_buffer0_WE_N : out STD_LOGIC;
				vga_controller_CLK : out STD_LOGIC;
				vga_controller_HS : out STD_LOGIC;
				vga_controller_VS : out STD_LOGIC;
				vga_controller_BLANK : out STD_LOGIC;
				vga_controller_SYNC : out STD_LOGIC;
				vga_controller_R : out STD_LOGIC_VECTOR(9 downto 0);
				vga_controller_G : out STD_LOGIC_VECTOR(9 downto 0);
				vga_controller_B : out STD_LOGIC_VECTOR(9 downto 0);
				av_config_SDAT : inout STD_LOGIC;
				av_config_SCLK : out STD_LOGIC;
				audio_ADCDAT : in STD_LOGIC;
				audio_ADCLRCK : in STD_LOGIC;
				audio_BCLK : in STD_LOGIC;
				audio_DACDAT : out STD_LOGIC;
				audio_DACLRCK : in STD_LOGIC;
				audio_clk_in_clk : in STD_LOGIC;
				audio_clk_out_clk : out STD_LOGIC;
				--parallel_port_0_export : inout STD_LOGIC_VECTOR(31 downto 0);
				--pi_memory_address : in std_LOGIC_VECTOR(10 downto 0);
				--pi_memory_chipselect : in STD_LOGIC;
				--pi_memory_clken : in STD_LOGIC;
				--pi_memory_write : in STD_LOGIC;
				--pi_memory_readdata : out STD_LOGIC_VECTOR(7 downto 0);
				--pi_memory_writedata : in STD_LOGIC_VECTOR(7 downto 0);
				pi_serial_rxd : in STD_LOGIC;
				pi_serial_txd : out STD_LOGIC
				--up_serial_RXD : in STD_LOGIC;
				--up_serial_TXD : out STD_LOGIC
				);
    END COMPONENT;
    SIGNAL DQM : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL BA : STD_LOGIC_VECTOR(1 DOWNTO 0);
	 SIGNAL RESET_COMBO : STD_LOGIC;
    BEGIN
        DRAM_BA_0 <= BA(0);
        DRAM_BA_1 <= BA(1);
        DRAM_UDQM <= DQM(1);
        DRAM_LDQM <= DQM(0);
		  RESET_COMBO <= KEY(0) OR KEY(1) OR KEY(2) OR KEY(3);
    -- Instantiate the Nios II system entity generated by the Qsys tool.

    NiosII: nios_system
    PORT MAP (
        clk_clk => CLOCK_50,
        reset_reset_n => RESET_COMBO,
        sdram_clk_clk => DRAM_CLK,
        leds_export => LEDG,
		  keys_export => KEY,
        switches_export => SW,
        sdram_wire_addr => DRAM_ADDR,
        sdram_wire_ba => BA,
        sdram_wire_cas_n => DRAM_CAS_N,
        sdram_wire_cke => DRAM_CKE,
        sdram_wire_cs_n => DRAM_CS_N,
        sdram_wire_dq => DRAM_DQ,
        sdram_wire_dqm => DQM,
        sdram_wire_ras_n => DRAM_RAS_N,
        sdram_wire_we_n => DRAM_WE_N,
		  lcd_data_DATA => LCD_DATA,
		  lcd_data_ON => LCD_ON,
		  lcd_data_BLON => LCD_BLON,
		  lcd_data_EN => LCD_EN,
		  lcd_data_RS => LCD_RS,
		  lcd_data_RW => LCD_RW,
		  sdcard_wire_b_SD_cmd => SD_CMD,
		  sdcard_wire_b_SD_dat => SD_DAT,
		  sdcard_wire_b_SD_dat3 => SD_DAT3,
		  sdcard_wire_o_SD_clock => SD_CLK,
		  pixel_buffer0_DQ => SRAM_DQ,
		  pixel_buffer0_ADDR => SRAM_ADDR,
		  pixel_buffer0_LB_N => SRAM_LB_N,
		  pixel_buffer0_UB_N => SRAM_UB_N,
		  pixel_buffer0_CE_N => SRAM_CE_N,
		  pixel_buffer0_OE_N => SRAM_OE_N,
		  pixel_buffer0_WE_N => SRAM_WE_N,
		  vga_controller_CLK => VGA_CLK,
		  vga_controller_HS => VGA_HS,
		  vga_controller_VS => VGA_VS,
		  vga_controller_BLANK => VGA_BLANK,
		  vga_controller_SYNC => VGA_SYNC,
		  vga_controller_R => VGA_R,
		  vga_controller_G => VGA_G,
		  vga_controller_B => VGA_B,
		  av_config_SCLK => I2C_SCLK,
		  av_config_SDAT => I2C_SDAT,
		  audio_ADCDAT => AUD_ADCDAT,
		  audio_ADCLRCK => AUD_ADCLRCK,
		  audio_BCLK => AUD_BCLK,
		  audio_DACDAT => AUD_DACDAT,
		  audio_DACLRCK => AUD_DACLRCK,
		  audio_clk_in_clk => CLOCK_27,
		  audio_clk_out_clk => AUD_XCK,
		  --parallel_port_0_export => GPIO_0(31 downto 0),
		  --pi_memory_address => GPIO_0(31 downto 21),
		  --pi_memory_chipselect => GPIO_0(20),
		  --pi_memory_clken => GPIO_0(19),
		  --pi_memory_write => GPIO_0(10),
		  --pi_memory_readdata => GPIO_0(18 downto 11),
		  --pi_memory_writedata => GPIO_0(10 downto 3),
		  pi_serial_rxd => UART_RXD,
		  pi_serial_txd => UART_TXD
		  --up_serial_RXD => UART_RXD,
		  --up_serial_TXD => UART_TXD
		  );
END Structure;
