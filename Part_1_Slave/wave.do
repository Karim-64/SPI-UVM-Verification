onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {SLAVE Interface}
add wave -noupdate /spi_slave_top/SLAVEif/clk
add wave -noupdate /spi_slave_top/SLAVEif/rst_n
add wave -noupdate /spi_slave_top/SLAVEif/SS_n
add wave -noupdate /spi_slave_top/SLAVEif/MOSI
add wave -noupdate /spi_slave_top/SLAVEif/rx_data
add wave -noupdate /spi_slave_top/SLAVEif/rx_data_exp
add wave -noupdate /spi_slave_top/SLAVEif/rx_valid
add wave -noupdate /spi_slave_top/SLAVEif/rx_valid_exp
add wave -noupdate /spi_slave_top/SLAVEif/tx_valid
add wave -noupdate /spi_slave_top/SLAVEif/tx_data
add wave -noupdate /spi_slave_top/SLAVEif/MISO
add wave -noupdate /spi_slave_top/SLAVEif/MISO_exp
add wave -noupdate /spi_slave_top/DUT/cs
add wave -noupdate /spi_slave_top/GM/cs
add wave -noupdate -divider Assertions
add wave -noupdate /spi_slave_main_seq_pkg::spi_slave_main_seq::body/#ublk#223710487#17/immed__19
add wave -noupdate /spi_slave_top/DUT/assert__chk_to_states_trans
add wave -noupdate /spi_slave_top/DUT/assert__p_idle_chk_trans
add wave -noupdate /spi_slave_top/DUT/assert__p_to_idle_trans
add wave -noupdate /spi_slave_top/DUT/spi_sva_inst/assert__p_reset
add wave -noupdate /spi_slave_top/DUT/spi_sva_inst/assert__p_rx_valid_rd_add
add wave -noupdate /spi_slave_top/DUT/spi_sva_inst/assert__p_rx_valid_rd_data
add wave -noupdate /spi_slave_top/DUT/spi_sva_inst/assert__p_rx_valid_wr_add
add wave -noupdate /spi_slave_top/DUT/spi_sva_inst/assert__p_rx_valid_wr_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3951 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 218
configure wave -valuecolwidth 100
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
WaveRestoreZoom {3934 ns} {4002 ns}
