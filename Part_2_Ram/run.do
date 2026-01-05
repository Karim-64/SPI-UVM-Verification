quit -sim
vdel -all
vlib work
vlog -f src_files.list +cover
vsim -voptargs=+acc work.RAM_top -classdebug -uvmcontrol=all -cover
run 0
add wave -group "RAM Interface" /RAM_top/ram_if/*
add wave -group "Scoreboard Counters" sim:/uvm_root/uvm_test_top/env/sb/error_count \
sim:/uvm_root/uvm_test_top/env/sb/correct_count
add wave -group "Assertions" /RAM_top/DUT/ram/a_rst_dout\
/RAM_top/DUT/ram/a_rst_tx_valid \
/RAM_top/DUT/ram/a_tx_low \
/RAM_top/DUT/ram/a_tx_high \
/RAM_top/DUT/ram/a_write \
/RAM_top/DUT/ram/a_read
run -all
coverage exclude -src RAM.v -line 26 -code s
coverage exclude -src RAM.v -line 26 -code b
coverage save RAM_top.ucdb

# vcover report RAM_top.ucdb -details -annotate -all -output RAM_coverage_report.txt