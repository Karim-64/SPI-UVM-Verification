import ram_pkg::*;

module RAM_sva(
    input  [9:0] din,
    input  clk,
    input  rst_n, 
    input  rx_valid,
    input reg [7:0] dout,
    input reg tx_valid
	);
// Reset
a_rst_dout: assert property(@(posedge clk) ~rst_n |=> dout == 0);
c_rst_dout: cover property(@(posedge clk) ~rst_n |=> dout == 0);
a_rst_tx_valid: assert property(@(posedge clk) ~rst_n |=> tx_valid == 0);
c_rst_tx_valid: cover property(@(posedge clk) ~rst_n |=> tx_valid == 0);

// tx_valid output
a_tx_low: assert property(@(posedge clk) disable iff(~rst_n)
	din[9:8] inside {WRITE_ADDRESS, WRITE_DATA, READ_ADDRESS} && rx_valid
	|=> ~tx_valid || $fell(tx_valid));
c_tx_low: cover property(@(posedge clk) disable iff(~rst_n)
	din[9:8] inside {WRITE_ADDRESS, WRITE_DATA, READ_ADDRESS} && rx_valid
	|=> ~tx_valid);

a_tx_high: assert property(@(posedge clk) disable iff(~rst_n)
	(din[9:8] == READ_DATA) && rx_valid |=> tx_valid ##1 $fell(tx_valid) [->1]);
c_tx_high: cover property(@(posedge clk) disable iff(~rst_n)
	(din[9:8] == READ_DATA) && rx_valid |=> tx_valid ##1 $fell(tx_valid) [->1]);

// RAM modes
a_write: assert property(@(posedge clk) disable iff(~rst_n)
	din[9:8] == WRITE_ADDRESS |=> (din[9:8] == WRITE_DATA) [->1]);
c_write: cover property(@(posedge clk) disable iff(~rst_n)
	din[9:8] == WRITE_ADDRESS |=> (din[9:8] == WRITE_DATA) [->1]);

a_read: assert property(@(posedge clk) disable iff(~rst_n)
	din[9:8] == READ_ADDRESS |=> (din[9:8] == READ_DATA) [->1]);
c_read: cover property(@(posedge clk) disable iff(~rst_n)
	din[9:8] == READ_ADDRESS |=> (din[9:8] == READ_DATA) [->1]);
		
endmodule : RAM_sva