package ram_coverage_pkg;
	import uvm_pkg::*;
	import ram_sequence_item_pkg::*;
	import ram_pkg::*;
	`include "uvm_macros.svh"

	class ram_coverage extends uvm_component;
		`uvm_component_utils(ram_coverage)

		uvm_analysis_export #(ram_sequence_item) cov_export;
		uvm_tlm_analysis_fifo #(ram_sequence_item) cov_fifo;
		ram_sequence_item cov_seq_item;

		covergroup cvr_gp;
		din_cp: coverpoint cov_seq_item.din[9:8]{
			bins din_wr_add   = {WRITE_ADDRESS};
			bins din_wr_data  = {WRITE_DATA};
			bins din_rd_add   = {READ_ADDRESS};
			bins din_rd_data  = {READ_DATA};
			bins din_wr_trans = (WRITE_ADDRESS => WRITE_DATA);
			bins din_rd_trans = (READ_ADDRESS =>  READ_DATA);
			bins din_trans    = (WRITE_ADDRESS =>  WRITE_DATA => READ_ADDRESS => READ_DATA);
		}
		rx: coverpoint  cov_seq_item.rx_valid{
		option.weight = 0;
		}
		tx: coverpoint cov_seq_item.tx_valid{
		option.weight = 0;
		}
		rx_cross: cross din_cp, rx{
			ignore_bins rx_ignore = binsof(rx) intersect {0};
			ignore_bins trans_ignore = binsof(din_cp.din_wr_trans) || binsof(din_cp.din_rd_trans) || binsof(din_cp.din_trans);
		}
		tx_cross: cross din_cp, tx{
			option.cross_auto_bin_max = 0;
			bins read_data_tx_high = binsof(din_cp.din_rd_data) && binsof(tx) intersect {1};
		}
		endgroup : cvr_gp

	function new(string name = "ram_coverage", uvm_component parent = null);
		super.new(name, parent);
		cvr_gp = new;
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cov_export = new("cov_export",this);
		cov_fifo = new("cov_fifo",this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		cov_export.connect(cov_fifo.analysis_export);
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			cov_fifo.get(cov_seq_item);
			cvr_gp.sample();
		end
	endtask
endclass
endpackage