`timescale              1 ns/1 ps

module top(DAD,MREQ,WRITE,SIZE,IAD,IACK,
	   DDT,ACKD,IDT,ACKI,RESET,OINT,IACK,CLK1);
	
	input[31:0] DDT,IDT;
	input[2:0]  OINT;
	input ACKD,ACKI,RESET,IACK,CLK1;

	output [31:0]DAD,IAD;
	output [1:0]SIZE;
	output MREQ,WRITE,IACK;

	//if_stage
	wire [31:0] beq, jr, pc_4_out_if;
	wire [27:0] offset28;
	wire [3:0]  pc_4_id;
	wire [1:0]  pc_src;
	wire pc_write;

	//if_id_reg
	wire [31:0] ins,pc_4_in_id;
	wire if_flush,if_id_write;

	//id_stage
	wire [31:0]data1_out,data2_out,pc_4_out_id,offset_id,data_to_reg,ex_mem_data;
	wire [13:0]control_id;
	wire [4:0]rs_field_id,rt_field_id,rd_field_id,rd_add;
	wire [1:0]control_sel;
	wire reg_write,forward_c,forward_d;

	//id_ex_reg
	wire pc_4_in_ex,rs_field_ex,rt_field_ex,rd_field_ex,

	if_stage(.pc_4_out(pc_4_out_if), .pc_out(IAD),
		.beq(beq), .jr(jr), .pc_4_id(pc_4_id), .offset28(offset28), .pc_write(pc_write), .pc_src(pc_src), .reset(RESET), .clk(CLK1));

	if_id_reg(.ins_out(ins), .pc_4_out(pc_4_in_id),
		  .pc_4_in(pc_4_out_if), .ins_in(IDT), .if_flush(if_flush), .if_id_write(if_id_write),
		  .reset(RESET), .clk(CLK1));

	id_stage(.data1_out(data1_out), .data2_out(data2_out), .pc_4_out(pc_4_out_id), .control(control_id), .offset(offset_id), .rs_field(rs_field_id), .rt_field(rt_field_id), .rd_field(rd_field_id), .branch(branch), .pc_src(pc_src), .offset28(offset28),
		 .pc_4_in(pc_4_in_id), .ins(ins), .rd_add(rd_add), .data(data_to_reg), .reg_write(reg_write), .control_sel(control_sel), .forward_c(forward_c), .forward_d(forward_d), .ex_mem_data(ex_mem_data), .clk(CLK));

	id_ex_reg(control_out,pc_4_out,rs_out,rt_out,offset_out,id_ex_rs,id_ex_rt,id_ex_rd,
		control_in,pc_4_in,rs_in,rt_in,offset_in,if_id_rs,if_id_rt,if_id_rd,
		reset,clk);

	ex_stage(rs_field_out,rt_field_out,regdst_out,rt_out,alu_data,pc_out,control_out,
		control_in,pc_in,data1,data2,offset,rs_field,rt_field,rd_field,wb_data,mem_wb_data,forward_a,forward_b);

	ex_mem_reg(control_out,pc_4_out,alu_out,sw_out,regdst_out,
		control_in,pc_4_in,alu_in,sw_in,regdst_in,
		reset,clk);

	mem_stage(pc_out,address_out,data_write_out,data_out,size,mem_write,mem_read,control_out,regdst_out,
		 pc_in,address_in,data_write_in,data_mem,control_in,regdst_in,wb_data,forward_e);

	mem_wb_reg(control_out,pc_4_out,data_out,alu_out,regdst_out,
		control_in,pc_4_in,data_in,alu_in,regdst_in,
		reset,clk);

	wb_stage(.reg_write(reg_write), .data_to_reg(data_to_reg), .regdst_out(rd_add),
		control_in,pc_4,data_mem,data_alu,regdst_in);


	hazard(.pc_write(pc_write), .if_id_write(if_id_write), .control_dst(control_sel),
	      if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst, id_ex_memread, ex_mem_memread,id_ex_regwrite);

	forward(.a(forward_a), .b(forward_b), .c(forward_c), .d(forward_d), .e(forward_e),
	      if_id_rs, if_id_rt, id_ex_rs, id_ex_rt, ex_mem_dst, mem_wb_dst, ex_mem_regwrite, mem_wb_regwrite);

endmodule
