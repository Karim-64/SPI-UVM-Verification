import uvm_pkg::*;
import ram_test_pkg::*;
`include "uvm_macros.svh"

module RAM_top();
	bit clk;
	initial begin
		clk=0;
		forever #1 clk=~clk;
	end

	RAM_if 	ram_if(.clk(clk));
	RAM 	DUT(.clk(ram_if.clk),.rst_n(ram_if.rst_n),.din(ram_if.din),
				.rx_valid(ram_if.rx_valid),.tx_valid(ram_if.tx_valid),
				.dout(ram_if.dout));
	RAM_ref ram_ref(.clk(ram_if.clk),.rst_n(ram_if.rst_n),.din(ram_if.din),
				.rx_valid(ram_if.rx_valid),.tx_valid(ram_if.tx_valid_ref),
				.dout(ram_if.dout_ref));
	bind RAM RAM_sva ram(.clk(ram_if.clk),.rst_n(ram_if.rst_n),.din(ram_if.din),
				.rx_valid(ram_if.rx_valid),.tx_valid(ram_if.tx_valid),
				.dout(ram_if.dout));

	initial begin
		uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "RAM_IF", ram_if);
		run_test("ram_test");
	end
endmodule : RAM_top