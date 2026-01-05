vlib work
vlog -f src_file.list +define+SIM +cover -covercells
vsim -voptargs=+acc work.SPI_wrapper_top -classdebug -uvmcontrol=all -cover
run 0
#add wave -position insertpoint  \
#sim:/uvm_root/uvm_test_top/read_seq.seq_item
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/read_write_seq.seq_item
do wave.do
run -all