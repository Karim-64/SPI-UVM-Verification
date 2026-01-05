module spi_slave_top();
import uvm_pkg::*;
`include"uvm_macros.svh"
import spi_slave_test_pkg::*;

    bit clk;

    initial begin 
        clk=0; 
        forever begin 
            #1 clk=~clk; 
        end 
    end 

    spi_slave_if SLAVEif (clk);
    SLAVE DUT (SLAVEif.MOSI, SLAVEif.MISO, SLAVEif.SS_n, SLAVEif.clk, SLAVEif.rst_n, 
    SLAVEif.rx_data, SLAVEif.rx_valid, SLAVEif.tx_data, SLAVEif.tx_valid);

    spi_slave_ref GM (SLAVEif.MOSI, SLAVEif.SS_n, SLAVEif.clk, SLAVEif.rst_n, SLAVEif.tx_data,
    SLAVEif.tx_valid, SLAVEif.MISO_exp, SLAVEif.rx_data_exp, SLAVEif.rx_valid_exp);

    bind SLAVE spi_slave_sva spi_sva_inst (SLAVEif.MOSI, SLAVEif.clk, SLAVEif.rst_n, SLAVEif.SS_n, SLAVEif.tx_valid, 
    SLAVEif.tx_data, SLAVEif.rx_data, SLAVEif.rx_valid, SLAVEif.MISO);

    initial begin
        uvm_config_db#(virtual spi_slave_if)::set(null,"uvm_test_top","SLAVE_IF",SLAVEif);
        run_test("spi_slave_test");
    end

endmodule