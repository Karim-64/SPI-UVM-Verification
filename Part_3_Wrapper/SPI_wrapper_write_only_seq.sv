package SPI_wrapper_write_only_seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_wrapper_seq_item_pkg::*;
    
    class SPI_wrapper_write_only_seq extends uvm_sequence #(SPI_wrapper_seq_item);
        `uvm_object_utils(SPI_wrapper_write_only_seq);
        SPI_wrapper_seq_item seq_item;

        function new(string name = "SPI_wrapper_write_only_seq");
            super.new(name);
        endfunction

        task body;
            seq_item = SPI_wrapper_seq_item::create_item("seq_item", WRITE_ONLY);
            repeat(2000) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage