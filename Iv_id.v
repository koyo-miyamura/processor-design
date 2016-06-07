`timescale              1 ns/1 ps
module Iv_id(vector_id,
	     control_sign,vector_if,s_u,trap_vector);

	input [4:0]vector_if;
	input [2:0]trap_vector;
	input [1:0]control_sign;
	input s_u;
	output [4:0]vector_id;

	parameter no_define=5'b11001,privilege=5'b11000;

	assign vector_id=(vector_if>no_define)?           vector_if:
			 (control_sign==2'b10)?           no_define:
			 ((control_sign==2'b01)&&s_u)?    privilege:
			 (control_sign==2'b00)? {2'b11,trap_vector}:
			 		                   5'b00000;
endmodule
