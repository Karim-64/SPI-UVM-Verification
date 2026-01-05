package SPI_wrapper_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_wrapper_config_pkg::*;
    import SPI_wrapper_seq_item_pkg::*;
    //import SPI_wrapper_shared_pkg::*;
    class SPI_wrapper_monitor extends uvm_monitor;
        `uvm_component_utils(SPI_wrapper_monitor)
        virtual SPI_wrapper_if SPI_wrapper_vif;
        SPI_wrapper_seq_item rsp_seq_item;
        uvm_analysis_port #(SPI_wrapper_seq_item) mon_aport;
        
        function new(string name = "SPI_wrapper_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_aport = new("mon_aport", this);
            
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = SPI_wrapper_seq_item::type_id::create("rsp_seq_item");
                @(negedge SPI_wrapper_vif.clk);
                rsp_seq_item.MOSI = SPI_wrapper_vif.MOSI;
                rsp_seq_item.SS_n = SPI_wrapper_vif.SS_n;
                rsp_seq_item.rst_n = SPI_wrapper_vif.rst_n;
                rsp_seq_item.MISO = SPI_wrapper_vif.MISO;
                rsp_seq_item.MISO_ref = SPI_wrapper_vif.MISO_ref;
                mon_aport.write(rsp_seq_item);
            end
        endtask
    endclass //className extends superClassendpackage
endpackage
