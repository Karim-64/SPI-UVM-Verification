module spi_slave_sva(
input MOSI, clk, rst_n, SS_n, tx_valid,
input      [7:0] tx_data,
input [9:0] rx_data,
input       rx_valid, MISO
);

property p_rx_valid_wr_add;
    @(posedge clk) disable iff (~rst_n) ($fell(SS_n)##1(~MOSI)[*3]) |-> ##10 ($rose(rx_valid) && SS_n[->1]);
endproperty
assert property(p_rx_valid_wr_add);
cover property (p_rx_valid_wr_add);

property p_rx_valid_wr_data;
    @(posedge clk) disable iff (~rst_n) ($fell(SS_n)##1(~MOSI)[*2] ##1 (MOSI)) |-> ##10 ($rose(rx_valid) && SS_n[->1]);
endproperty
assert property(p_rx_valid_wr_data);
cover property (p_rx_valid_wr_data);

property p_rx_valid_rd_add;
    @(posedge clk) disable iff (~rst_n) ($fell(SS_n)##1(MOSI)[*2] ##1 (~MOSI)) |-> ##10 ($rose(rx_valid) && SS_n[->1]);
endproperty
assert property(p_rx_valid_rd_add);
cover property (p_rx_valid_rd_add);


property p_rx_valid_rd_data;
    @(posedge clk) disable iff (~rst_n) ($fell(SS_n)##1(MOSI)[*3]) |-> ##10 ($rose(rx_valid) && SS_n[->1]);
endproperty
assert property(p_rx_valid_rd_data);
cover property (p_rx_valid_rd_data);

property p_reset;
    @(posedge clk) (~rst_n) |=> (MISO==0 && rx_data==0 && rx_valid==0);
endproperty
assert property (p_reset);
cover property (p_reset);


endmodule