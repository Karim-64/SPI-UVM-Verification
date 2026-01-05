package SPI_wrapper_sqr_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_wrapper_seq_item_pkg::*;
    
    class SPI_wrapper_sqr extends uvm_sequencer #(SPI_wrapper_seq_item);
        `uvm_component_utils(SPI_wrapper_sqr)

        function new(string name = "SPI_wrapper_sqr", uvm_component parent = null);
            super.new(name, parent);
        endfunction 
    endclass 
endpackage