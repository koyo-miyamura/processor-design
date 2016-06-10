`timescale              1 ns/1 ps

module id_stage(data1_out,data2_out,pc_4_out,control,offset,rs_field,rt_field,rd_field,branch,rs,pc_src,offset28,vector_id,
		pc_4_in,ins,rd_add,data,reg_write,control_sel,forward_c,forward_d,ex_mem_data,vector_if,s_u,
		clk,reset);

	input [31:0]pc_4_in,ins,data,ex_mem_data;
	input [4:0]rd_add,vector_if;
	input reg_write,control_sel,forward_c,forward_d,clk,reset,s_u;

	output [31:0]data1_out,data2_out,pc_4_out,offset,branch,rs;
	output [27:0]offset28;
	output [14:0]control;
	output [4:0]rs_field,rt_field,rd_field,vector_id;
	output [1:0]pc_src;

	wire   [31:0]rt,data1_out_user,data2_out_user,data1_out_super,data2_out_super;
	wire   [15:0]offset_16;
	wire   [14:0]control_out;
	wire   [5:0]op,func;
	wire   [2:0]trap_vector;
	wire   trap_sign,no_define,rfe,reg_write_user,reg_write_super;

	parameter andi_op=6'b001100,ori_op=6'b001101,xori_op=6'b001110,trap_op=6'b010001;

	assign pc_4_out=pc_4_in+32'h0000_0004; //PC+8

	assign offset28={2'b00,ins[25:0]}<<2;

	assign rd_field=ins[15:11];
	assign rt_field=ins[20:16];
	assign rs_field=ins[25:21];

	assign offset_16=ins[15:0];
	assign op=ins[31:26];
	assign offset=( (op==andi_op)||(op==ori_op)||(op==xori_op) )? {16'b0,offset_16}:{{16{offset_16[15]}},offset_16};
	assign branch=(offset<<2)+pc_4_in;

	assign func=ins[5:0];

	//Register change
//	assign data1_out=(s_u)? data1_out_user:data1_out_super;
//	assign data2_out=(s_u)? data2_out_user:data2_out_super;

	//Register not change
	assign data1_out=data1_out_user;
	assign data2_out=data2_out_user;

	//regwrite is active low     Register change
//	assign reg_write_user=((s_u==1)&&(reg_write==0))? 0:1;
//	assign reg_write_super=((s_u==0)&&(reg_write==0))? 0:1;

	//Register not change
	assign reg_write_user=reg_write;


	assign rs=(forward_c)? ex_mem_data:data1_out;
	assign rt=(forward_d)? ex_mem_data:data2_out;

	assign control=(control_sel)? control_out:15'b0000_0000_0000_001;

	assign trap_sign=((op==trap_op)&&(control_sel))? 1:0;
	assign rfe=control[7];
	assign trap_vector=ins[2:0];

	rf32x32 rf32x32_user(.data1_out(data1_out_user), .data2_out(data2_out_user),
		     .clk(clk), .wr_n(reg_write_user), .rst_n(reset), .rd1_addr(rs_field), .rd2_addr(rt_field), .wr_addr(rd_add), .data_in(data));
	
	//superviser
//	rf32x32 rf32x32_super(.data1_out(data1_out_super), .data2_out(data2_out_super),
//		     .clk(clk), .wr_n(reg_write_super), .rst_n(reset), .rd1_addr(rs_field), .rd2_addr(rt_field), .wr_addr(rd_add), .data_in(data));

	branch  branch_unit(.pc_src(pc_src),
		     .op(op), .func(func), .rt_field(rt_field), .rs(rs), .rt(rt));
	
	control control_unit(.control_out(control_out), .no_define(no_define), 
		      .op(op), .func(func), .rt_field(rt_field));

	Iv_id Iv_id(.vector_id(vector_id),
	     .trap_sign(trap_sign), .no_define(no_define), .rfe(rfe), .vector_if(vector_if), .s_u(s_u), .trap_vector(trap_vector));

endmodule
