package spi_slave_monitor_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import spi_slave_seq_item_pkg::*;

    class spi_slave_monitor extends uvm_monitor;
         `uvm_component_utils(spi_slave_monitor);
         virtual spi_slave_if vif;
         spi_slave_seq_item mon_seq_item;
         uvm_analysis_port #(spi_slave_seq_item) mon_ap;

         function new (string name="spi_slave_monitor",uvm_component parent=null);
             super.new(name,parent);
         endfunction

         function void build_phase(uvm_phase phase);
             super.build_phase(phase);
             mon_ap=new("mon_ap",this);
         endfunction

         task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                mon_seq_item=spi_slave_seq_item::type_id::create("mon_seq_item");
                @(negedge vif.clk);
                mon_seq_item.rst_n = vif.rst_n;
                mon_seq_item.SS_n = vif.SS_n;
                mon_seq_item.MOSI = vif.MOSI;
                mon_seq_item.tx_valid = vif.tx_valid;
                mon_seq_item.tx_data = vif.tx_data;
                mon_seq_item.rx_data = vif.rx_data;
                mon_seq_item.rx_valid = vif.rx_valid;
                mon_seq_item.MISO = vif.MISO;
                mon_seq_item.rx_data_exp = vif.rx_data_exp;
                mon_seq_item.rx_valid_exp = vif.rx_valid_exp;
                mon_seq_item.MISO_exp = vif.MISO_exp;

                mon_ap.write(mon_seq_item);
            end
         endtask
       
    endclass
    
endpackage