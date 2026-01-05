package SPI_wrapper_score_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_wrapper_agent_pkg::*;
    import SPI_wrapper_seq_item_pkg::*;

    class SPI_wrapper_score extends uvm_scoreboard;
        `uvm_component_utils(SPI_wrapper_score)
        uvm_analysis_export   #(SPI_wrapper_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(SPI_wrapper_seq_item) sb_fifo;
        SPI_wrapper_seq_item sb_seq_item;

        int error_count   = 0;
        int correct_count = 0;

        function new(string name = "SPI_wrapper_score", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo   = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(sb_seq_item);
                if( sb_seq_item.MISO != sb_seq_item.MISO_ref) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, MISO_ref = %b | MISO = %b", sb_seq_item.MISO_ref, sb_seq_item.MISO));
                    error_count ++;
                end
                else begin
                    correct_count++;
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


