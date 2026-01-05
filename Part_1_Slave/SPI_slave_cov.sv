package spi_slave_coverage_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import spi_slave_seq_item_pkg::*;

    class spi_slave_coverage extends uvm_component;
        `uvm_component_utils(spi_slave_coverage)
        uvm_analysis_export #(spi_slave_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(spi_slave_seq_item) cov_fifo;
        spi_slave_seq_item seq_item_cov;

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            cov_export=new("cov_export",this);
            cov_fifo=new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                cvr_grp.sample();
            end
        endtask

        covergroup cvr_grp;
            SS_n_cp: coverpoint seq_item_cov.SS_n {option.weight=0;}
            MOSI_cp: coverpoint seq_item_cov.MOSI {option.weight=0;}

            //SLAVE_2, SLAVE_3, SLAVE_4, SLAVE_5
            rx_data_cp: coverpoint seq_item_cov.rx_data [9:8] {
                bins rx_data_val[]={[0:3]}; 
                bins rx_data_trans[]=([0:3]=>[0:3]);
                ignore_bins ignore_trans = (0 => 3), (3 => 0), (1 => 2), (2 => 1);
            }

            //SLAVE_7
            SS_n_trans_cp: coverpoint seq_item_cov.SS_n {
                bins full_transaction     = (1=>0[*13]=>1);
                bins extended_transaction = (1=>0[*23]=>1);
                bins start_of_comm = (1 => 0 => 0);
            }

            //SLAVE_2, SLAVE_3, SLAVE_4, SLAVE_5
            mosi_trans_cp: coverpoint seq_item_cov.MOSI {
                bins wr_add_trans  = (0 => 0 => 0);
                bins wr_data_trans = (0 => 0 => 1);
                bins rd_add_trans  = (1 => 1 => 0);
                bins rd_data_trans = (1 => 1 => 1);
            }

            //SLAVE_7
            ss_mosi_cross_cvr: cross SS_n_trans_cp, mosi_trans_cp {
                option.cross_auto_bin_max = 0;

                // write operations
                bins WRITE_DATA_OP = binsof(SS_n_trans_cp.start_of_comm) &&
                                     binsof(mosi_trans_cp.wr_data_trans);
                bins WRITE_ADD_OP  = binsof(SS_n_trans_cp.start_of_comm) &&
                                     binsof(mosi_trans_cp.wr_add_trans);

                // read operations
                bins READ_ADD_OP  = binsof(SS_n_trans_cp.start_of_comm) &&
                                    binsof(mosi_trans_cp.rd_add_trans);
                bins READ_DATA_OP = binsof(SS_n_trans_cp.start_of_comm) &&
                                    binsof(mosi_trans_cp.rd_data_trans);
            }
        endgroup

        function new (string name="spi_slave_coverage", uvm_component parent=null);
            super.new(name,parent);
            cvr_grp=new();    
        endfunction
    endclass

endpackage