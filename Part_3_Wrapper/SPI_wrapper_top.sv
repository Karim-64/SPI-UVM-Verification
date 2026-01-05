import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_wrapper_test_pkg::*;

module SPI_wrapper_top();
  // Clock generation
  bit clk; 
  initial begin
    forever #1 clk = ~clk;
  end

  // Instantiation the interfaces
  spi_slave_if SLAVEif (clk);
  RAM_if ram_if (clk);
  SPI_wrapper_if wrapper_if(clk);

  // connect the common wires with the slave
  //// connecting inputs of the slave 
  assign SLAVEif.SS_n = wrapper_if.SS_n;

  //// connecting outputs of the slave to the wrapper
  assign SLAVEif.MOSI = wrapper_if.MOSI;

  // connect the commen wires between the slave and the ram
  //// connecting inputs of the slave 
  assign ram_if.din = SLAVEif.rx_data;
  assign ram_if.rx_valid = SLAVEif.rx_valid;
  
  //// connecting outputs of the ram to the slave
  assign SLAVEif.tx_data  = ram_if.dout;
  assign SLAVEif.tx_valid = ram_if.tx_valid;

  // connecting the rst 
  assign SLAVEif.rst_n = wrapper_if.rst_n;
  assign ram_if.rst_n  = wrapper_if.rst_n;

  // Instantiation of the DUTS
  SLAVE SPI_slave (
    SLAVEif.MOSI, SLAVEif.MISO, SLAVEif.SS_n, SLAVEif.clk, SLAVEif.rst_n, 
    SLAVEif.rx_data, SLAVEif.rx_valid, SLAVEif.tx_data, SLAVEif.tx_valid
  );


  spi_slave_ref GM (SLAVEif.MOSI, SLAVEif.SS_n, SLAVEif.clk, SLAVEif.rst_n, SLAVEif.tx_data,
  SLAVEif.tx_valid, SLAVEif.MISO_exp, SLAVEif.rx_data_exp, SLAVEif.rx_valid_exp);

  RAM SPI_RAM (
    .clk(ram_if.clk),.rst_n(ram_if.rst_n),.din(ram_if.din),
    .rx_valid(ram_if.rx_valid),.tx_valid(ram_if.tx_valid),
    .dout(ram_if.dout)
  );

  RAM_ref ram_ref(.clk(ram_if.clk),.rst_n(ram_if.rst_n),.din(ram_if.din),
				.rx_valid(ram_if.rx_valid),.tx_valid(ram_if.tx_valid_ref),
				.dout(ram_if.dout_ref));

  WRAPPER SPI_wrapper (
    .MOSI(wrapper_if.MOSI),.MISO(wrapper_if.MISO),
    .SS_n(wrapper_if.SS_n),.clk(wrapper_if.clk),.rst_n(wrapper_if.rst_n)
  );

  SPI_wrapper_ref REF
  (
    .MOSI(wrapper_if.MOSI),
    .SS_n(wrapper_if.SS_n),
    .clk(wrapper_if.clk),
    .rst_n(wrapper_if.rst_n),
    .MISO(wrapper_if.MISO_ref)
  );

  // binding the interfaces with the duts 
  bind RAM RAM_sva RAM_sva_inst(
    .clk(ram_if.clk),.rst_n(ram_if.rst_n),.din(ram_if.din),
    .rx_valid(ram_if.rx_valid),.tx_valid(ram_if.tx_valid),
    .dout(ram_if.dout)
  );

  bind SLAVE spi_slave_sva SLAVE_sva_inst(
    .MOSI(SLAVEif.MOSI), .clk(SLAVEif.clk), .rst_n(SLAVEif.rst_n), .SS_n(SLAVEif.SS_n),
    .tx_valid(SLAVEif.tx_valid), .tx_data(SLAVEif.tx_data), .rx_data(SLAVEif.rx_data),
    .rx_valid(SLAVEif.rx_valid), .MISO(SLAVEif.MISO)
  );

  bind WRAPPER wrapper_sva WRAPPER_sva_inst(
    .MOSI(wrapper_if.MOSI),
    .SS_n(wrapper_if.SS_n),
    .clk(wrapper_if.clk),
    .rst_n(wrapper_if.rst_n),
    .MISO(wrapper_if.MISO_ref)
  );

  initial begin
    // set the virtual interfaces in the configuration database
    uvm_config_db #(virtual spi_slave_if)::set(null, "uvm_test_top", "SLAVE_IF", SLAVEif);
    uvm_config_db #(virtual RAM_if)      ::set(null, "uvm_test_top", "RAM_IF", ram_if);
    uvm_config_db #(virtual SPI_wrapper_if)  ::set(null, "uvm_test_top", "WRAPPER_IF", wrapper_if);

    // run test using run_test task
    run_test("SPI_wrapper_test");
  end
endmodule