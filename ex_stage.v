module ex_stage(rs_field_out,regdst_out,rt,alu_data,pc_out,control_out,id_ex_memread,id_ex_regwrite,
		control_in,alu_src,pc_in,data1,data2,offset,rs_field,rt_field,rd_field,wb_data,mem_wb_data,forward_a,forward_b,regdst,alu_op);

	input [31:0]pc_in,data1,data2,offset,wb_data,mem_wb_data;
	input [13:0]control_in;
	input [4:0]rs_field,rt_field,rd_field;
	input [3:0]alu_op;
	input [1:0]regdst;
	input forward_a,forward_b;

	output [31:0]pc_out,alu_data,rt;
	output [6:0]control_out;
	output [4:0]rs_field_out,regdst_out;
	output id_ex_regwrite,id_ex_memread;

	wire  [5:0]func;
	wire  [4:0]shamt;
	wire  [3:0]alu_op;
	wire  [1:0]regdst;
	wire  alu_src;

	assign rs_field_out=rs_field;
	assign regdst_out=(regdst==2'b00)? rt_field:
			  (regdst==2'b01)? rd_field:
			  (regdst==2'b10)? 5'b11111:
			  5'bzzzzz;



	rf32x32 unit1(.data1_out(data1_out), .data2_out(data2_out),
		     .clk(clk), .wr_n(reg_write), .rd1_addr(rs_field), .rd2_addr(rt_field), .wr_addr(rd_add), .data_in(data));

	branch  unit2(.pc_src(pc_src),
		     .op(op), .func(func), .rt_field(rt_field), .rs(rs), .rt(rt));
	
	control unit3(.control_out(control_out),
		      .op(op), .func(func), .rt_field(rt_field));

	
endmodule
