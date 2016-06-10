`timescale              1 ns/1 ps
module Iv_id(vector_id,
	     trap_sign,no_define,rfe,vector_if,s_u,trap_vector);

	input [4:0]vector_if;
	input [2:0]trap_vector;
	input s_u,no_define,rfe,trap_sign;
	output [4:0]vector_id;

	parameter nodef=5'b11001,privilege=5'b11000;

	assign vector_id=(vector_if>nodef)?     vector_if:
			 (no_define)?               nodef:
			 ((rfe)&&s_u)?          privilege:
			 (trap_sign)? {2'b10,trap_vector}:
			                         5'b00000;
endmodule
