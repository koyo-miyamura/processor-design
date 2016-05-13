`timescale              1 ns/1 ps

module top(DAD,MREQ,WRITE,SIZE,IAD,
	   DDT,ACKD_n,IDT,ACKI_n,rst,OINT_n,IACK_n,clk);
	
	input[31:0] IDT;
	input[2:0]  OINT_n;
	input ACKD_n,ACKI_n,rst,clk;

	output [31:0]DAD,IAD;
	output [1:0]SIZE;
	output MREQ,WRITE,IACK_n;

	inout[31:0] DDT;

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
	wire regwrite,forward_c,forward_d,control_sel;

	//id_ex_reg
	wire [31:0]pc_4_in_ex,data1_in,data2_in,offset_ex;
	wire [13:0]control_in_ex;
	wire [4:0]id_ex_rs,id_ex_rt,id_ex_rd;

	//ex_stage
	wire [31:0]pc_4_out_ex,rt_out_ex,alu_data_ex,wb_data;
	wire [7:0]control_out_ex;
	wire [4:0]regdst_out_ex;
	wire [1:0]forward_a,forward_b;

	//ex_mem_reg
	wire [31:0]pc_4_in_mem,alu_in_mem,sw_in_mem;
	wire [7:0]control_in_mem;
	wire [4:0]regdst_in_mem;

	//mem_stage
	wire [31:0]pc_4_out_mem,data_write_out_mem,data_out_mem,load_data,store_data;
	wire [4:0]regdst_out_mem;
	wire [2:0]control_out_mem;
	wire mem_read,forward_e;

	//mem_wb_reg
	wire [31:0] pc_4_in_wb,data_in_wb,alu_in_wb;
	wire [4:0] regdst_in_wb;
	wire [2:0] control_in_wb;

//	assign {pc_write,if_id_write,control_sel}=3'b111;

	if_stage if_stage(.pc_4_out(pc_4_out_if), .pc_out(IAD),
		.beq(beq), .jr(jr), .pc_4_id(pc_4_id), .offset28(offset28), .pc_write(pc_write), .pc_src(pc_src), .reset(rst), .clk(clk));

	assign pc_4_id=pc_4_in_id[31:28];

	if_id_reg if_id_reg(.ins_out(ins), .pc_4_out(pc_4_in_id),
		  .pc_4_in(pc_4_out_if), .ins_in(IDT), .if_flush(if_flush), .if_id_write(if_id_write),
		  .reset(rst), .clk(clk));

	wire[5:0]op,func;   
	assign op=ins[31:26];
	assign func=ins[5:0];

	id_stage id_stage(.data1_out(data1_out), .data2_out(data2_out), .pc_4_out(pc_4_out_id), .control(control_id), .offset(offset_id), .if_flush(if_flush), .rs_field(rs_field_id), .rt_field(rt_field_id), .rd_field(rd_field_id), .branch(beq), .rs(jr), .pc_src(pc_src), .offset28(offset28),
		 .pc_4_in(pc_4_in_id), .ins(ins), .rd_add(rd_add), .data(data_to_reg), .reg_write(regwrite), .control_sel(control_sel), .forward_c(forward_c), .forward_d(forward_d), .ex_mem_data(ex_mem_data), .reset(rst), .clk(clk));

	id_ex_reg id_ex_reg(.control_out(control_in_ex), .pc_4_out(pc_4_in_ex), .rs_out(data1_in), .rt_out(data2_in), .offset_out(offset_ex), .id_ex_rs(id_ex_rs), .id_ex_rt(id_ex_rt), .id_ex_rd(id_ex_rd),
		 .control_in(control_id), .pc_4_in(pc_4_out_id), .rs_in(data1_out), .rt_in(data2_out), .offset_in(offset_id), .if_id_rs(rs_field_id), .if_id_rt(rt_field_id), .if_id_rd(rt_field_id),
		.reset(rst), .clk(clk));

	wire id_ex_memread,id_ex_regwrite;
	assign id_ex_memread=control_in_ex[3];
	assign id_ex_regwrite=control_in_ex[0];
	
	ex_stage ex_stage(.regdst_out(regdst_out_ex), .rt_out(rt_out_ex), .alu_data(alu_data_ex), .pc_out(pc_4_out_ex), .control_out(control_out_ex),
		.control_in(control_in_ex), .pc_in(pc_4_in_ex), .data1(data1_in), .data2(data2_in), .offset(offset_ex), .rt_field(id_ex_rt), .rd_field(id_ex_rd), .wb_data(wb_data), .ex_mem_data(ex_mem_data), .forward_a(forward_a), .forward_b(forward_b));

	ex_mem_reg ex_mem_reg(.control_out(control_in_mem), .pc_4_out(pc_4_in_mem), .alu_out(alu_in_mem), .sw_out(sw_in_mem), .regdst_out(regdst_in_mem),
		.control_in(control_out_ex), .pc_4_in(pc_4_out_ex), .alu_in(alu_data_ex), .sw_in(sw_in_mem), .regdst_in(regdst_out_ex),
		.reset(rst), .clk(clk));

	assign ex_mem_data=alu_in_mem;

	wire ex_mem_memread,ex_mem_regwrite;
	assign ex_mem_memread=control_in_mem[3];
	assign ex_mem_regwrite=control_in_mem[0];

	mem_stage mem_stage(.pc_out(pc_4_out_mem), .address_out(DAD), .data_write_out(store_data), .data_out(data_out_mem), .size(SIZE), .mem_write(WRITE), .mem_read(mem_read), .control_out(control_out_mem), .regdst_out(regdst_out_mem),
		 .pc_in(pc_4_in_mem), .address_in(alu_in_mem), .data_write_in(sw_in_mem), .data_mem(load_data), .control_in(control_in_mem), .regdst_in(regdst_in_mem), .wb_data(wb_data), .forward_e(forward_e));

	assign MREQ=(WRITE|mem_read);
	assign load_data=DDT;
	assign DDT=(WRITE)? store_data:32'bz;


	mem_wb_reg mem_wb_reg(.control_out(control_in_wb), .pc_4_out(pc_4_in_wb), .data_out(data_in_wb), .alu_out(alu_in_wb), .regdst_out(regdst_in_wb),
		.control_in(control_out_mem), .pc_4_in(pc_4_out_mem), .data_in(data_out_mem), .alu_in(DAD), .regdst_in(regdst_out_mem),
		.reset(rst), .clk(clk));

	wb_stage wb_stage(.reg_write(regwrite), .data_to_reg(data_to_reg), .regdst_out(rd_add),
		.control_in(control_in_wb), .pc_4(pc_4_in_wb), .data_mem(data_in_wb), .data_alu(alu_in_wb), .regdst_in(regdst_in_wb));

	assign wb_data=data_to_reg;

	hazard hazard(.pc_write(pc_write), .if_id_write(if_id_write), .control_dst(control_sel),
	      .op(op), .func(func), .if_id_rs(rs_field_id), .if_id_rt(rt_field_id), .id_ex_dst(regdst_out_ex), .ex_mem_dst(regdst_out_mem), .id_ex_memread(id_ex_memread), .ex_mem_memread(ex_mem_memread), .id_ex_regwrite(id_ex_regwrite));

	forward forward(.a(forward_a), .b(forward_b), .c(forward_c), .d(forward_d), .e(forward_e),
	      .if_id_rs(rs_field_id), .if_id_rt(rt_field_id), .id_ex_rs(id_ex_rs), .id_ex_rt(id_ex_rt), .ex_mem_dst(regdst_out_mem), .mem_wb_dst(rd_add), .ex_mem_regwrite(ex_mem_regwrite), .mem_wb_regwrite(regwrite));

endmodule
