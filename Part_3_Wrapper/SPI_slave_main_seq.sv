package spi_slave_main_seq_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import spi_slave_seq_item_pkg::*;

    class spi_slave_main_seq extends uvm_sequence #(spi_slave_seq_item);
        `uvm_object_utils(spi_slave_main_seq);
        spi_slave_seq_item seq_item;

        function new (string name="spi_slave_main_seq");
            super.new(name);    
        endfunction

task body();
            seq_item = spi_slave_seq_item::type_id::create("seq_item");
            //seq_item.mosi_state_con2.constraint_mode(0);
            seq_item.rst_n.rand_mode(0);
            seq_item.rst_n=1;
            //prev_mode=0;

            repeat(1000)begin
            start_item(seq_item);
            // if (prev_mode==3'b110) begin
            //    seq_item.mosi_state_con1.constraint_mode(0);
            //    seq_item.mosi_state_con2.constraint_mode(1);
            // end else if (prev_mode==3'b111) begin
            //     seq_item.mosi_state_con2.constraint_mode(0);
            //    seq_item.mosi_state_con1.constraint_mode(1);
            // end

            assert(seq_item.randomize());
            //prev_mode=seq_item.mosi_arr [10:8];
            //seq_item.update_mosi_constraints;
            //seq_item.tx_valid=1;
            //seq_item.MOSI.randomize();
            finish_item(seq_item);
            end
endtask
    endclass
    
endpackage