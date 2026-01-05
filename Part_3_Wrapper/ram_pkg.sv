package ram_pkg;
	typedef enum logic[1:0] {WRITE_ADDRESS = 2'b00, WRITE_DATA = 2'b01,
							READ_ADDRESS = 2'b10, READ_DATA = 2'b11} e_mode;
endpackage : ram_pkg