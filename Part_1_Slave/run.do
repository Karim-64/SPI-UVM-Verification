vlib work
vlog -f src_files.list +define+SIM +cover -covercells
vsim -voptargs=+acc work.spi_slave_top -classdebug -uvmcontrol=all -cover
add wave /spi_slave_top/SLAVEif/*
coverage save SLAVE.ucdb -onexit 
coverage report -detail -cvg -directive -comments -output slave_report.txt {}
run 0
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/main_seq.seq_item
do wave.do
run -all
#vcover report SLAVE.ucdb -details -annotate -all -output Slave_coverage.txt