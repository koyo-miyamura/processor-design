`timescale              1 ns/1 ps
module Iv_ex(vector_ex,
	     over_under_flow,vector_id);

	input  [4:0]vector_id;
	input over_under_flow;
	output [4:0]vector_ex;

	parameter arithmetic=5'b01100;

	assign vector_ex=(vector_id>arithmetic)? vector_id:
			 (over_under_flow)?     arithmetic:
			 		          5'b00000;
endmodule
