package ram_agent_pkg;
	import uvm_pkg::*;
	import ram_driver_pkg::*;
	import ram_config_obj_pkg::*;
	import ram_monitor_pkg::*;
	import ram_sequencer_pkg::*;
	import ram_sequence_item_pkg::*;
	`include "uvm_macros.svh"

	class ram_agent extends uvm_agent;
		`uvm_component_utils(ram_agent);

		ram_driver  	drv;
		ram_sequencer   sqr;
		ram_monitor 	mon;
		ram_config_obj 	cfg;
		uvm_analysis_port #(ram_sequence_item) agt_ap;

		function new(string name = "ram_agent", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db #(ram_config_obj)::get(this,"","RAM_CFG",cfg))
				`uvm_fatal("build_phase","Unable to get configuration object: AGENT");
			if(cfg.is_active == UVM_ACTIVE) begin
				sqr = ram_sequencer::type_id::create("sqr",this);
				drv = ram_driver::type_id::create("srv",this);
			end
			mon = ram_monitor::type_id::create("mon",this);
			agt_ap = new("agt_ap",this);
		endfunction

		function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(cfg.is_active == UVM_ACTIVE) begin
			drv.ram_driver_vif = cfg.ram_cfg_vif;
			drv.seq_item_port.connect(sqr.seq_item_export);
		end
		mon.ram_monitor_vif = cfg.ram_cfg_vif;
		mon.mon_ap.connect(agt_ap);
	endfunction

endclass
endpackage