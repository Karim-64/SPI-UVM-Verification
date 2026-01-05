package spi_slave_driver_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import spi_slave_seq_item_pkg::*;

    class spi_slave_driver extends uvm_driver #(spi_slave_seq_item);
        `uvm_component_utils(spi_slave_driver)
        virtual spi_slave_if driver_vif;
        spi_slave_seq_item drv_seq_item;

        function new (string name="spi_slave_driver", uvm_component parent=null);
            super.new(name,parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                drv_seq_item=spi_slave_seq_item::type_id::create("drv_seq_item");
                seq_item_port.get_next_item(drv_seq_item);
                driver_vif.rst_n = drv_seq_item.rst_n;
                driver_vif.SS_n = drv_seq_item.SS_n;
                driver_vif.MOSI = drv_seq_item.MOSI;
                driver_vif.tx_valid = drv_seq_item.tx_valid;
                driver_vif.tx_data = drv_seq_item.tx_data;
                @(negedge driver_vif.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase",drv_seq_item.convert2string_stimulus(),UVM_HIGH);              
            end
        endtask
    endclass
   
endpackage