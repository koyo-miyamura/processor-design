set search_path [concat "/home/abe/hit18-lib/kyoto_lib/synopsys/" $search_path]
set LIB_MAX_FILE {HIT018.db}
set link_library $LIB_MAX_FILE
set target_library $LIB_MAX_FILE

##read_verilog module
read_verilog "/home/koyo/verilog/top.v"
read_verilog "/home/koyo/verilog/alu_control.v"
read_verilog "/home/koyo/verilog/alu.v"
read_verilog "/home/koyo/verilog/branch.v"
read_verilog "/home/koyo/verilog/control.v"
read_verilog "/home/koyo/verilog/DW_ram_2r_w_s_dff.v"
read_verilog "/home/koyo/verilog/Exception.v"
read_verilog "/home/koyo/verilog/ex_mem_reg.v"
read_verilog "/home/koyo/verilog/ex_stage.v"
read_verilog "/home/koyo/verilog/forward.v"
read_verilog "/home/koyo/verilog/hazard.v"
read_verilog "/home/koyo/verilog/IAR.v"
read_verilog "/home/koyo/verilog/id_ex_reg.v"
read_verilog "/home/koyo/verilog/id_stage.v"
read_verilog "/home/koyo/verilog/if_id_reg.v"
read_verilog "/home/koyo/verilog/if_stage.v"
read_verilog "/home/koyo/verilog/Iv_ex.v"
read_verilog "/home/koyo/verilog/Iv_id.v"
read_verilog "/home/koyo/verilog/Iv_if.v"
read_verilog "/home/koyo/verilog/Iv_mem.v"
read_verilog "/home/koyo/verilog/mem_stage.v"
read_verilog "/home/koyo/verilog/mem_wb_reg.v"
read_verilog "/home/koyo/verilog/mux_4.v"
read_verilog "/home/koyo/verilog/pc.v"
read_verilog "/home/koyo/verilog/rf32x32.v"
read_verilog "/home/koyo/verilog/SR.v"
read_verilog "/home/koyo/verilog/top.v"
read_verilog "/home/koyo/verilog/wb_stage.v"



current_design "top"
#read_verilog topmodule
##current_design "TOP_MODULE_NAME"

group_path -to find(cell,"ex_mem_reg/regdst_out_reg*/D") -name clk -weight 10 
#group_path -to find(cell,"id_ex_reg/id_ex_rt_reg[1]/Q")  -name clk -weight 10

set_max_area 0 -ignore_tns
set_max_fanout 64 [current_design]

create_clock -period 3.60 -w {0 1.8} clk
set_clock_uncertainty -setup 0.0 [get_clock clk]
set_clock_uncertainty -hold 0.0 [get_clock clk]
set_input_delay  0.0 -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.0 -clock clk [remove_from_collection [all_outputs] clk]
set_flatten true -ph true -effort high
set_structure -boolean true

##compile -map_effort medium -area_effort high -incremental_mapping
#ungroup forward -flatten
#ungroup ex_stage -flatten
compile
ungroup -all -flatten
compile -inc -map_ef high

#report_timing -net -input_pins -max_paths 1
#report_timing -path end delay max -max_path 80 -nworsr 1
report_timing -max_paths 1
report_area
report_power

write -hier -format verilog -output HOGEHOGE_PROC.vnet
write -hier -output HOGEHOGE_PROC.db

quit



