`timescale              1 ns/1 ps
module Iv_if(vector_if,
	     pc,s_u);

	input [31:0]pc;
	input s_u;
	output [4:0]vector_if;

	parameter Missline=5'b11110,memory=5'b11100;

	assign vector_if=(pc[1:0]!=2'b00)?        Missline:
			 ((pc<32'h000_10000)&&s_u)? memory:
			                          5'b00000;
endmodule
