package spi_slave_scoreboard_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import spi_slave_seq_item_pkg::*;

    class spi_slave_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(spi_slave_scoreboard)
        uvm_analysis_export #(spi_slave_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(spi_slave_seq_item) sb_fifo;
        spi_slave_seq_item seq_item_sb;

        int error_count=0;
        int correct_count=0;

        function new (string name="spi_slave_scoreboard", uvm_component parent=null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export=new("sb_export",this);
            sb_fifo=new("sb_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                if (seq_item_sb.MISO !== seq_item_sb.MISO_exp || seq_item_sb.rx_valid !== seq_item_sb.rx_valid_exp
                || seq_item_sb.rx_data != seq_item_sb.rx_data_exp) begin
                    error_count++;
                    `uvm_error("run_phase",$sformatf("Error:Transaction:%s",seq_item_sb.convert2string));
                end else begin
                    correct_count++;
                    `uvm_info("run_phase",$sformatf("Error:Transaction:%s",seq_item_sb.convert2string),UVM_HIGH);
                end
            end
            
        endtask

        function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase",$sformatf("Total successful transactions:%0d",correct_count),UVM_MEDIUM);
			`uvm_info("report_phase",$sformatf("Total failed transactions:%0d",error_count),UVM_MEDIUM);
		endfunction : report_phase



    endclass

endpackage