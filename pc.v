`timescale              1 ns/1 ps
module pc(out,
	in,pc_write,clk);

	input [31:0]in;
	input pc_write,clk;
	output [31:0]out;
	
	reg [31:0]out;
	
	always @ (posedge clk)
	begin
//		case({reset,pc_write})
//			2'b11: out<=in;
//			2'b10: out<=out;
//			default out<=in;
//		endcase
		if(pc_write==0)
			out<=out;
		else
			out<=in;
	end

endmodule
