package spi_slave_reset_seq_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import spi_slave_seq_item_pkg::*;

    class spi_slave_reset_seq extends uvm_sequence #(spi_slave_seq_item);
        `uvm_object_utils (spi_slave_reset_seq)
        spi_slave_seq_item seq_item;
    
    function new (string name="spi_slave_reset_seq");
        super.new(name);    
    endfunction

    task body();
       seq_item=spi_slave_seq_item::type_id::create("spi_slave_reset_seq");
       start_item(seq_item);
       seq_item.rst_n=0;
       {seq_item.SS_n,seq_item.tx_valid
       ,seq_item.tx_data,seq_item.MOSI}=$random;
       finish_item(seq_item);
       
    endtask

    endclass
    
endpackage