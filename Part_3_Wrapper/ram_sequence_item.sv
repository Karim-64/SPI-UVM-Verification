package ram_sequence_item_pkg;
	import uvm_pkg::*;
	import ram_pkg::*;
	`include "uvm_macros.svh"

	class ram_sequence_item extends uvm_sequence_item;
		`uvm_object_utils(ram_sequence_item)
		rand logic  [9:0] din;
	    rand logic  rst_n;
	    rand logic  rx_valid;
	    logic  		tx_valid;
	    logic  		[7:0] dout;
	    logic  		[7:0] dout_ref;
	    logic 		tx_valid_ref;
	    e_mode 		prev;

		function new(string name = "ram_sequence_item");
			super.new(name);
		endfunction : new

		function string convert2string();
			return $sformatf("%s",
				super.convert2string());
		endfunction : convert2string

		function string convert2string_stimulus();
			return $sformatf(" ");
		endfunction

		constraint c_reset {
			rst_n dist {1:/98, 0:/2};
		}
		constraint c_rx {
			rx_valid dist {1:/90, 0:/10};
		}
		constraint c_write_only {
			(prev == WRITE_ADDRESS) ->
				(din[9:8] inside {WRITE_ADDRESS,WRITE_DATA});

			(prev == WRITE_DATA) -> (din[9:8] == WRITE_ADDRESS);
		}
		constraint c_read_only {
			(prev == READ_ADDRESS) -> (din[9:8] == READ_DATA);
			(prev == READ_DATA) -> (din[9:8] == READ_ADDRESS);
		}
		constraint c_write_read {
			(prev == WRITE_ADDRESS) ->
				(din[9:8] inside {WRITE_ADDRESS,WRITE_DATA});
			(prev == READ_ADDRESS) -> (din[9:8] == READ_DATA);
			(prev == WRITE_DATA) ->
				din[9:8] dist {READ_ADDRESS:/60, WRITE_ADDRESS:/40};
			(prev == READ_DATA) ->
				din[9:8] dist {WRITE_ADDRESS:/60, READ_ADDRESS:/40};
		}
		
		function void post_randomize();
			prev = e_mode'(din[9:8]);
		endfunction : post_randomize

endclass : ram_sequence_item
endpackage