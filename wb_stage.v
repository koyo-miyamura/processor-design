`timescale              1 ns/1 ps
module wb_stage(reg_write,data_to_reg,regdst_out,
		control_in,data_mem,data_alu,regdst_in);

	input [31:0]data_mem,data_alu;
	input [4:0]regdst_in;
	input [1:0]control_in;

	output [31:0]data_to_reg;
	output [4:0]regdst_out;
	output reg_write;

	wire mem_to_reg;

	assign regdst_out=regdst_in;
	
	assign mem_to_reg=control_in[1];
	assign reg_write=control_in[0];

	assign data_to_reg=(mem_to_reg)? data_mem:data_alu;

endmodule
