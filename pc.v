`timescale              1 ns/1 ps
module pc(out,
	in,pc_write,reset,clk);

	input [31:0]in;
	input pc_write,reset,clk;
	output [31:0]out;
	
	reg [31:0]out;
	
	always @ (posedge clk or negedge reset)
	begin
		case({reset,pc_write})
			2'b11: out<=in;
			2'b10: out<=out;
			default out<=32'h0001_0000;
		endcase
	end
endmodule
