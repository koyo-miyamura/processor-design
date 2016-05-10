`timescale              1 ns/1 ps

module id_stage(data1_out,data2_out,pc_4_out,control,offset,rs_field,rt_field,rd_field,branch,pc_src,offset28,
		pc_4_in,ins,rd_add,data,reg_write,control_sel,forward_c,forward_d,ex_mem_data,clk,reset);

	input [31:0]pc_4_in,ins,data,ex_mem_data;
	input [4:0]rd_add;
	input reg_write,control_sel,forward_c,forward_d,clk,reset;

	output [31:0]data1_out,data2_out,pc_4_out,offset,branch;
	output [27:0]offset28;
	output [13:0]control;
	output [4:0]rs_field,rt_field,rd_field;
	output [1:0]pc_src;

	wire   [31:0]rs,rt;
	wire   [15:0]offset_16;
	wire   [13:0]control_out;
	wire   [4:0]rs_in,rt_in;
	wire   [5:0]op,func;

	assign pc_4_out=pc_4_in;

	assign offset28={2'b00,ins[25:0]}<<2;

	assign rd_field=ins[15:11];
	assign rt_field=ins[20:16];
	assign rs_field=ins[25:21];

	assign offset_16=ins[15:0];
	assign offset={{16{offset_16[15]}},offset_16};
	assign branch=(offset<<2)+pc_4_in;

	assign op=ins[31:26];
	assign func=ins[5:0];

	assign rs=(forward_c)? ex_mem_data:data1_out;
	assign rt=(forward_d)? ex_mem_data:data2_out;

	assign control=(control_sel)? control_out:13'b0000_0000_0000_0;

	rf32x32 unit1(.data1_out(data1_out), .data2_out(data2_out),
		     .clk(clk), .wr_n(reg_write), .rst_n(reset), .rd1_addr(rs_field), .rd2_addr(rt_field), .wr_addr(rd_add), .data_in(data));

	branch  unit2(.pc_src(pc_src),
		     .op(op), .func(func), .rt_field(rt_field), .rs(rs), .rt(rt));
	
	control unit3(.control_out(control_out),
		      .op(op), .func(func), .rt_field(rt_field));

	
endmodule
