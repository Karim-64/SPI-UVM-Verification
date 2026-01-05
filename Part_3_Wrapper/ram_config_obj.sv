package ram_config_obj_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_config_obj extends uvm_object;
		`uvm_object_utils(ram_config_obj);

		virtual RAM_if ram_cfg_vif;
		uvm_active_passive_enum is_active;

		function new(string name = "ram_config");
			super.new(name);
		endfunction : new
	endclass 
endpackage 