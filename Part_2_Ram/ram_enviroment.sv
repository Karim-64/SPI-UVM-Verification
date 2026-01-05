package ram_enviroment_pkg;
	import uvm_pkg::*;
	import ram_agent_pkg::*;
	import ram_coverage_pkg::*;
	import ram_scoreboard_pkg::*;
	
	`include "uvm_macros.svh"

	class ram_enviroment extends uvm_env;
		`uvm_component_utils(ram_enviroment);

		ram_agent agent;
		ram_scoreboard sb;
		ram_coverage cov;

		function new(string name = "ram_enviroment", uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			agent = ram_agent::type_id::create("agent",this);
			sb = ram_scoreboard::type_id::create("sb",this);
			cov = ram_coverage::type_id::create("cov",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			agent.agt_ap.connect(sb.sb_export);
			agent.agt_ap.connect(cov.cov_export);
		endfunction : connect_phase

	endclass : ram_enviroment
endpackage : ram_enviroment_pkg