iverilog -Wall -o processor.mdl processor.v alu/alu.v alu_control/alu_control.v control/control.v data_mem/data_mem.v reg_file/reg_file.v sign_extend/sign_extend.v processor_tb.v
vvp processor.mdl