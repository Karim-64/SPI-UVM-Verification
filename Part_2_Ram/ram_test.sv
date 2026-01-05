package ram_test_pkg;
	import uvm_pkg::*;
	import ram_enviroment_pkg::*;
	import ram_config_obj_pkg::*;
	import ram_sequence_pkg::*;
	
	`include "uvm_macros.svh"

	class ram_test extends uvm_test();
		`uvm_component_utils(ram_test);

		ram_enviroment env;
		ram_config_obj cfg_ram;
		ram_rst_seq rst_seq;
		ram_write_only_seq wr_seq;
		ram_read_only_seq rd_seq;
		ram_write_read_seq wr_rd_seq;

		function new(string name = "ram_test", uvm_component parent = null);
			super.new(name, parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env = ram_enviroment::type_id::create("env",this);
			cfg_ram = ram_config_obj::type_id::create("cfg_ram");
			rst_seq = ram_rst_seq::type_id::create("rst_seq");
			wr_seq = ram_write_only_seq::type_id::create("wr_seq");
			rd_seq = ram_read_only_seq::type_id::create("rd_seq");
			wr_rd_seq = ram_write_read_seq::type_id::create("wr_rd_seq");
			if(!uvm_config_db#(virtual RAM_if)::get(this, "", "RAM_IF", cfg_ram.ram_cfg_vif))
				`uvm_fatal("build_phase","Unable to get the ram virtual interface - test");
			cfg_ram.is_active = UVM_ACTIVE;
			uvm_config_db#(ram_config_obj)::set(this, "*", "CFG_RAM", cfg_ram);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);

			// RAM_1
			`uvm_info("run_phase","Reset Asserted.",UVM_LOW);
			rst_seq.start(env.agent.sqr);
			`uvm_info("run_phase","Reset Deasserted.",UVM_LOW);

			// RAM_2
			`uvm_info("run_phase","Write Only Stimulus Generation Started.",UVM_LOW);
			wr_seq.start(env.agent.sqr);
			`uvm_info("run_phase","Write Only Stimulus Generation Ended.",UVM_LOW);

			// RAM_3
			`uvm_info("run_phase","Read Only Stimulus Generation Started.",UVM_LOW);
			rd_seq.start(env.agent.sqr);
			`uvm_info("run_phase","Read Only Stimulus Generation Ended.",UVM_LOW);

			// RAM_4
			`uvm_info("run_phase","Write/Read Stimulus Generation Started.",UVM_LOW);
			wr_rd_seq.start(env.agent.sqr);
			`uvm_info("run_phase","Write/Read Stimulus Generation Ended.",UVM_LOW);
			phase.drop_objection(this);
		endtask : run_phase
	endclass : ram_test
endpackage : ram_test_pkg