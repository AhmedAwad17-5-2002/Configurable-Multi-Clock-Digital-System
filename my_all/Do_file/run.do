vlib work
vlog ref_model.cpp
vlog -f RTL1.list +cover -covercells
vlog -f ENV.list +cover -covercells
vlog Assertions.sv RF_Asser.sv FIFO_Asser.sv UART_Assertions.sv
vlog CTRL_Assertions.sv
vsim -voptargs="+acc" work.SYS_UVM_TOP -cover
add wave -position insertpoint sim:/SYS_UVM_TOP/*
add wave -position insertpoint sim:/SYS_UVM_TOP/MY_IF/*
add wave -position insertpoint sim:/SYS_UVM_TOP/MY_IF/RegFile
coverage save SYS.ucdb -onexit -du SYS_TOP
run -all
quit -sim
vcover report SYS.ucdb -all -annotate -details -output COVERAGE.txt