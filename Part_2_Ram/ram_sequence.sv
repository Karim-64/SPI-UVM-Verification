package ram_sequence_pkg;
	import uvm_pkg::*;
	import ram_sequence_item_pkg::*;
	import ram_pkg::*;
	`include "uvm_macros.svh"

	logic[1:0] prev_mode = WRITE_ADDRESS;

	class ram_rst_seq extends uvm_sequence #(ram_sequence_item);
		`uvm_object_utils(ram_rst_seq)
		ram_sequence_item seq_item;

		function new(string name = "ram_rst_seq");
			super.new(name);
		endfunction : new

		task body();
			seq_item = ram_sequence_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst_n = 0;
			finish_item(seq_item);
		endtask : body
	endclass : ram_rst_seq

	class ram_write_only_seq extends uvm_sequence #(ram_sequence_item);
		`uvm_object_utils(ram_write_only_seq)
		ram_sequence_item seq_item;

		function new(string name = "ram_write_only_seq");
			super.new(name);
		endfunction : new

		task body();
			repeat(1000) begin
				seq_item = ram_sequence_item::type_id::create("seq_item");
				start_item(seq_item);
					seq_item.prev = e_mode'(prev_mode);
					seq_item.c_write_only.constraint_mode(1);
					seq_item.c_read_only.constraint_mode(0);
					seq_item.c_write_read.constraint_mode(0);
					assert(seq_item.randomize());
					prev_mode = seq_item.din[9:8];
				finish_item(seq_item);
			end
		endtask : body
	endclass : ram_write_only_seq

	class ram_read_only_seq extends uvm_sequence #(ram_sequence_item);
		`uvm_object_utils(ram_read_only_seq)
		ram_sequence_item seq_item;

		function new(string name = "ram_read_only_seq");
			super.new(name);
		endfunction : new

		task body();
			repeat(1000) begin
				seq_item = ram_sequence_item::type_id::create("seq_item");
				start_item(seq_item);
					seq_item.prev = e_mode'(prev_mode);
					seq_item.c_write_only.constraint_mode(0);
					seq_item.c_read_only.constraint_mode(1);
					seq_item.c_write_read.constraint_mode(0);
					assert(seq_item.randomize());
					prev_mode = seq_item.din[9:8];
				finish_item(seq_item);
			end
		endtask : body
	endclass : ram_read_only_seq

	class ram_write_read_seq extends uvm_sequence #(ram_sequence_item);
		`uvm_object_utils(ram_write_read_seq)
		ram_sequence_item seq_item;

		function new(string name = "ram_write_read_seq");
			super.new(name);
		endfunction : new

		task body();
			repeat(1000) begin
				seq_item = ram_sequence_item::type_id::create("seq_item");
				start_item(seq_item);
					seq_item.prev = e_mode'(prev_mode);
					seq_item.c_read_only.constraint_mode(0);
					seq_item.c_write_only.constraint_mode(0);
					seq_item.c_write_read.constraint_mode(1);
					assert(seq_item.randomize());
					prev_mode = seq_item.din[9:8];
				finish_item(seq_item);
			end
		endtask : body
	endclass : ram_write_read_seq

endpackage : ram_sequence_pkg