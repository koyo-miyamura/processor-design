module ex_stage(rs_field_out,rt_field_out,regdst_out,rt_out,alu_data,pc_out,control_out,
		control_in,pc_in,data1,data2,offset,rs_field,rt_field,rd_field,wb_data,mem_wb_data,forward_a,forward_b);

	input [31:0]pc_in,data1,data2,offset,wb_data,mem_wb_data;
	input [13:0]control_in;
	input [4:0]rs_field,rt_field,rd_field;
	input forward_a,forward_b;

	output [31:0]pc_out,alu_data,rt_out;
	output [7:0]control_out;
	output [4:0]rs_field_out,rt_field_out,regdst_out;

	wire  [31:0]data1_in,data2_in;
	wire  [5:0]func;
	wire  [4:0]shamt_in,shamt_out,alu_control_out;
	wire  [3:0]alu_op;
	wire  [1:0]regdst;
	wire  alu_src,lb_lh;

	assign pc_out=pc_in;
	assign regdst=control_in[8:7];
	assign alu_src=control_in[9];
	assign alu_op=control_in[13:10];
	assign lb_lh=(alu_op==4'b1001)? 1'b1:1'b0;
	assign control_out={lb_lh,control_in[6:0]};

	assign rs_field_out=rs_field;
	assign rt_field_out=rt_field;

	assign regdst_out=(regdst==2'b00)? rt_field:
			  (regdst==2'b01)? rd_field:
			  (regdst==2'b10)? 5'b11111:
			  5'bzzzzz;

	assign shamt_in=offset[10:6];
	assign func= offset[5:0];

	assign rt_out=(forward_b==2'b00)? data2:
		      (forward_b==2'b01)? wb_data:
		      (forward_b==2'b10)? mem_wb_data:
		      5'bzzzzz;

	assign data2_in=(alu_src==1'b1)? rt_out:offset;

	assign data1_in=(forward_a==2'b00)? data1:
		        (forward_b==2'b01)? wb_data:
		        (forward_b==2'b10)? mem_wb_data:
		        5'bzzzzz;



	alu_control unit1(.alu_control_out(alu_control_out), .shamt_out(shamt_out),
 			  .func(func), .shamt_in(shamt_in), .alu_op(alu_op));

	alu unit2(.alu_out(alu_data),
	         .rs(data1_in), .rt(data2_in), .alu_control(alu_control_out), .shamt(shamt_out));

	
endmodule
