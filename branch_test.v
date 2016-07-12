`timescale              1 ns/1 ps
module branch_pre(predict,
	      Iadd,Badd);
	input [31:0]Iadd,Badd;
	output predict;

	parameter bal=6'b000001,bs=4'b0001;
	parameter WIDTH=2;
	parameter ENTRY=1024;
	parameter ADDRESS=10;

	reg  [WIDTH-1:0] ram [ENTRY-1:0];
	wire [ADDRESS-1:0]I_index=Iadd[ADDRESS-1:0];
	wire [ADDRESS-1:0]B_index=Badd[ADDRESS-1:0];
	
	always @(Iadd or Badd)
	begin

	end

endmodule
