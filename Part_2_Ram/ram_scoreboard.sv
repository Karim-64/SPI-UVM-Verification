package ram_scoreboard_pkg;
	import uvm_pkg::*;
	import ram_sequence_item_pkg::*;
	`include "uvm_macros.svh"

	class ram_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(ram_scoreboard)
		uvm_analysis_export #(ram_sequence_item) sb_export;
		uvm_tlm_analysis_fifo #(ram_sequence_item) sb_fifo;
		ram_sequence_item sb_seq_item;

		int correct_count = 0;
		int error_count = 0;

		function new(string name = "ram_scoreboard", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export = new("sb_export",this);
			sb_fifo = new("sb_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_fifo.get(sb_seq_item);
				if(sb_seq_item.dout === sb_seq_item.dout_ref
					&& sb_seq_item.tx_valid == sb_seq_item.tx_valid_ref)
						correct_count++;
				else
						error_count++;
			end
		endtask : run_phase

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase",$sformatf("Total successful transactions:%0d",correct_count),UVM_MEDIUM);
			`uvm_info("report_phase",$sformatf("Total failed transactions:%0d",error_count),UVM_MEDIUM);
		endfunction : report_phase

	endclass
endpackage : ram_scoreboard_pkg