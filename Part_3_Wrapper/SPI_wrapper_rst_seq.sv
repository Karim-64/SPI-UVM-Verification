package SPI_wrapper_rst_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import SPI_wrapper_seq_item_pkg::*;
    //import SPI_wrapper_shared_pkg::*;
    class SPI_wrapper_rst_seq extends uvm_sequence #(SPI_wrapper_seq_item);
        `uvm_object_utils(SPI_wrapper_rst_seq);
        SPI_wrapper_seq_item seq_item;

        function new(string name = "SPI_wrapper_rst_seq");
            super.new(name);
        endfunction

        task body;
            seq_item = SPI_wrapper_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0;
            seq_item.SS_n  = 1;
            seq_item.MOSI = 0;
            finish_item(seq_item);
        endtask
    endclass
endpackage