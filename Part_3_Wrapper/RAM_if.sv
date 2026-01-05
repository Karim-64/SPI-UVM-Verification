import ram_pkg::*;

interface RAM_if(input clk);

	parameter MEM_DEPTH = 256;
	parameter ADDR_SIZE = 8;

	logic  [9:0] din;
    logic  rst_n;		// synchronus active low
    logic  rx_valid;
    logic  tx_valid;
    logic  [7:0] dout;
    logic  [7:0] dout_ref;
    logic  tx_valid_ref;

endinterface : RAM_if