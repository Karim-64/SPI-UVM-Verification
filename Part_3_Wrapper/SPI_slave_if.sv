interface spi_slave_if(clk);
input logic clk;
logic  MOSI, rst_n, SS_n, tx_valid;
logic  [7:0] tx_data;
logic  [9:0] rx_data;
logic  rx_valid, MISO;
logic  rx_valid_exp, MISO_exp;
logic  [9:0] rx_data_exp;

// modport DUT (
// input MOSI, clk, rst_n, SS_n, tx_valid, tx_data, rx_data,
// output rx_valid, MISO
// );
  
endinterface