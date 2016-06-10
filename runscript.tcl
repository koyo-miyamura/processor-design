# command : dc_shell-t -f runscript.tcl
set search_path [concat "/home/abe/hit18-lib/kyoto_lib/synopsys/" $search_path]
set LIB_MAX_FILE {HIT018.db}
set link_library $LIB_MAX_FILE
set target_library $LIB_MAX_FILE

##read_verilog module
read_verilog "/home/kakibuka/processor/EXEStage/SpeculativeAddr.v"
read_verilog "/home/kakibuka/processor/ProgramCounter.v" 
read_verilog "/home/kakibuka/processor/IFStage/IFUnit.v" 
read_verilog "/home/kakibuka/processor/DW_ram_2r_w_s_dff.v" 
read_verilog "/home/kakibuka/processor/rf32x32.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/ALUOp.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/ALUSrc.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/AddressingMode.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/BranchCondition.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/FwUnitALUSrc.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/FwUnitBranchCond.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/FwUnitMemWData.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/MemRW.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/MemSize.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/MemSign.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/MemToReg.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/RegDst.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/RegWrite.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/StUnitEXStage.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/StallControl.v" 
read_verilog "/home/kakibuka/processor/ControlUnit/Nop.v" 
read_verilog "/home/kakibuka/processor/PRegIFID.v" 
read_verilog "/home/kakibuka/processor/PRegIDEX.v" 
read_verilog "/home/kakibuka/processor/PRegEXMEM.v" 
read_verilog "/home/kakibuka/processor/PRegMEMWB.v" 
read_verilog "/home/kakibuka/processor/IDStage/IDUnit.v" 
read_verilog "/home/kakibuka/processor/EXEStage/EXEUnit_improve.v" 
read_verilog "/home/kakibuka/processor/MEMStage/MEMWrapper.v" 
read_verilog "/home/kakibuka/processor/MEMStage/MEMUnit.v" 
read_verilog "/home/kakibuka/processor/WBStage/WBUnit.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/CatchRfe.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/EXEException.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/ExceptionCtrl.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/IDException.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/IDPrivilegeInst.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/IFException.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/InterruptVecComp.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/MEMException.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/MemProtection.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/Misalignment.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/StatusRegister.v" 
read_verilog "/home/kakibuka/processor/ExceptionControl/UndefinedInstruction.v" 
read_verilog "/home/kakibuka/processor/CopReg/break.v"
read_verilog "/home/kakibuka/processor/CopReg/reg_access_wrapper.v"
read_verilog "/home/kakibuka/processor/ControlUnit/BreakPoint.v"
read_verilog "/home/kakibuka/processor/top.v" 


current_design "top"
#read_verilog topmodule
##current_design "TOP_MODULE_NAME"

set_max_area 0
set_max_fanout 64 [current_design]

create_clock -period 5.71 clk
set_clock_uncertainty -setup 0.0 [get_clock clk]
set_clock_uncertainty -hold 0.0 [get_clock clk]
set_input_delay  0.0 -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.0 -clock clk [remove_from_collection [all_outputs] clk]

# added ungroup
ungroup -all -flatten
compile -inc -map_ef high

# compile -map_effort medium -area_effort high -incremental_mapping

report_timing -max_paths 1
report_area
report_power

write -hier -format verilog -output HOGEHOGE_PROC.vnet
write -hier -output HOGEHOGE_PROC.db

quit

