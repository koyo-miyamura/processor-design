#!/bin/sh

#ncverilog -s +gui +access+r \
verilog \
	/home/koyo/verilog/*[!t].v \
	/home/koyo/verilog/top_test.v \
	&


<<OUT	"/home/koyo/verilog/alu.v" \
	"/home/koyo/verilog/alu_c.v" \
	"/home/koyo/verilog/branch.v" \
	"/home/koyo/verilog/control.v" \
	"/home/koyo/verilog/ex_mem.v" \
	"/home/koyo/verilog/exstage.v" \
	"/home/koyo/verilog/Forwarding_unit.v" \
	"/home/koyo/verilog/Hazard_unit.v" \
	"/home/koyo/verilog/id_ex.v" \
	"/home/koyo/verilog/idstage.v" \
	"/home/koyo/verilog/if_id.v" \
	"/home/koyo/verilog/ifstage.v" \
	"/home/koyo/verilog/jump_address.v" \
	"/home/koyo/verilog/mem_wb.v" \
	"/home/koyo/verilog/memstage.v" \
	"/home/koyo/verilog/pc.v" \
	"/home/koyo/verilog/rf32x32.v" \
	"/home/koyo/verilog/top.v" \
	"/home/koyo/verilog/top_test.v" \
	"/home/koyo/verilog/wbstage.v" \
	"/home/koyo/verilog/DW_ram_2r_w_s_dff.v" \
	"/home/koyo/verilog/exc.v" \
	"/home/koyo/verilog/sr.v" \
	"/home/koyo/verilog/iTunes.v" \
	&
OUT


