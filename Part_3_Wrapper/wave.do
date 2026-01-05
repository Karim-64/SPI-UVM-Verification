onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Wrapper inteface}
add wave -noupdate /SPI_wrapper_top/wrapper_if/clk
add wave -noupdate -color Sienna /SPI_wrapper_top/wrapper_if/rst_n
add wave -noupdate -color Yellow /SPI_wrapper_top/wrapper_if/SS_n
add wave -noupdate /SPI_wrapper_top/wrapper_if/MOSI
add wave -noupdate /SPI_wrapper_top/wrapper_if/MISO
add wave -noupdate /SPI_wrapper_top/wrapper_if/MISO_ref
add wave -noupdate -divider {Slave interface}
add wave -noupdate /SPI_wrapper_top/SLAVEif/clk
add wave -noupdate -color Sienna /SPI_wrapper_top/SLAVEif/rst_n
add wave -noupdate -color Yellow /SPI_wrapper_top/SLAVEif/SS_n
add wave -noupdate /SPI_wrapper_top/SLAVEif/MOSI
add wave -noupdate /SPI_wrapper_top/SLAVEif/rx_data
add wave -noupdate /SPI_wrapper_top/SLAVEif/rx_data_exp
add wave -noupdate /SPI_wrapper_top/SLAVEif/rx_valid
add wave -noupdate /SPI_wrapper_top/SLAVEif/rx_valid_exp
add wave -noupdate /SPI_wrapper_top/SLAVEif/MISO
add wave -noupdate /SPI_wrapper_top/SLAVEif/MISO_exp
add wave -noupdate /SPI_wrapper_top/SLAVEif/tx_valid
add wave -noupdate /SPI_wrapper_top/SLAVEif/tx_data
add wave -noupdate /SPI_wrapper_top/SPI_slave/cs
add wave -noupdate /SPI_wrapper_top/GM/cs
add wave -noupdate -divider {RAM interface}
add wave -noupdate /SPI_wrapper_top/ram_if/clk
add wave -noupdate -color Sienna /SPI_wrapper_top/ram_if/rst_n
add wave -noupdate /SPI_wrapper_top/ram_if/din
add wave -noupdate /SPI_wrapper_top/ram_if/rx_valid
add wave -noupdate /SPI_wrapper_top/ram_if/tx_valid
add wave -noupdate /SPI_wrapper_top/ram_if/tx_valid_ref
add wave -noupdate /SPI_wrapper_top/ram_if/dout
add wave -noupdate /SPI_wrapper_top/ram_if/dout_ref
add wave -noupdate /SPI_wrapper_read_write_seq_pkg::SPI_wrapper_read_write_seq::body/#ublk#215952055#16/immed__18
add wave -noupdate /SPI_wrapper_write_only_seq_pkg::SPI_wrapper_write_only_seq::body/#ublk#101763687#16/immed__18
add wave -noupdate /SPI_wrapper_read_only_seq_pkg::SPI_wrapper_read_only_seq::body/#ublk#154982439#16/immed__18
add wave -noupdate /SPI_wrapper_top/SPI_slave/assert__p_idle_chk_trans
add wave -noupdate /SPI_wrapper_top/SPI_slave/assert__chk_to_states_trans
add wave -noupdate /SPI_wrapper_top/SPI_slave/assert__p_to_idle_trans
add wave -noupdate /SPI_wrapper_top/SPI_slave/SLAVE_sva_inst/assert__p_rx_valid_wr_add
add wave -noupdate /SPI_wrapper_top/SPI_slave/SLAVE_sva_inst/assert__p_rx_valid_wr_data
add wave -noupdate /SPI_wrapper_top/SPI_slave/SLAVE_sva_inst/assert__p_rx_valid_rd_add
add wave -noupdate /SPI_wrapper_top/SPI_slave/SLAVE_sva_inst/assert__p_rx_valid_rd_data
add wave -noupdate /SPI_wrapper_top/SPI_slave/SLAVE_sva_inst/assert__p_reset
add wave -noupdate /SPI_wrapper_top/SPI_RAM/RAM_sva_inst/a_rst_dout
add wave -noupdate /SPI_wrapper_top/SPI_RAM/RAM_sva_inst/a_rst_tx_valid
add wave -noupdate /SPI_wrapper_top/SPI_RAM/RAM_sva_inst/a_tx_low
add wave -noupdate /SPI_wrapper_top/SPI_RAM/RAM_sva_inst/a_tx_high
add wave -noupdate /SPI_wrapper_top/SPI_RAM/RAM_sva_inst/a_write
add wave -noupdate /SPI_wrapper_top/SPI_RAM/RAM_sva_inst/a_read
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/RAM_instance/RAM_sva_inst/a_rst_dout
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/RAM_instance/RAM_sva_inst/a_rst_tx_valid
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/RAM_instance/RAM_sva_inst/a_tx_low
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/RAM_instance/RAM_sva_inst/a_tx_high
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/RAM_instance/RAM_sva_inst/a_write
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/RAM_instance/RAM_sva_inst/a_read
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/SLAVE_instance/assert__p_idle_chk_trans
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/SLAVE_instance/assert__chk_to_states_trans
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/SLAVE_instance/assert__p_to_idle_trans
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/SLAVE_instance/SLAVE_sva_inst/assert__p_rx_valid_wr_add
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/SLAVE_instance/SLAVE_sva_inst/assert__p_rx_valid_wr_data
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/SLAVE_instance/SLAVE_sva_inst/assert__p_rx_valid_rd_add
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/SLAVE_instance/SLAVE_sva_inst/assert__p_rx_valid_rd_data
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/SLAVE_instance/SLAVE_sva_inst/assert__p_reset
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/WRAPPER_sva_inst/rst_prop
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/WRAPPER_sva_inst/MISO_WRITE_ADD_prop
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/WRAPPER_sva_inst/MISO_WRITE_DATA_prop
add wave -noupdate /SPI_wrapper_top/SPI_wrapper/WRAPPER_sva_inst/MISO_READ_DATA_prop
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34 ns} 0} {{Cursor 3} {6940 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 281
configure wave -valuecolwidth 56
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {94 ns}
