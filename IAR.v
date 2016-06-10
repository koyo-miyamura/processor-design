`timescale              1 ns/1 ps
module IAR(pc_out,
	   memwrite,oint_ex,exception,pc_8_in,reset,trap,overflow,
	   clk);

	input [31:0]pc_8_in;
	input memwrite,oint_ex,exception,reset,trap,clk,overflow;
	output [31:0]pc_out;
	
	reg [31:0]pc_out;

	//PC+4 back at overflow
	//wire trap_store=((memwrite&&oint_ex)||(trap))||(overflow);	
	
	//PC back to at overflow
	wire trap_store=((memwrite&&oint_ex)||(trap));
	wire valid=(pc_8_in<=32'h00010008);

	always @ (posedge clk or negedge reset)
	begin
		casez({reset,valid,exception,trap_store})
			//exception
			4'b1011: pc_out<=pc_8_in-32'h0000_0004;
			4'b1010: pc_out<=pc_8_in-32'h0000_0008;

			//reset
			4'b0zzz: pc_out<=32'h000_10000;
			default pc_out<=pc_out;
		endcase
	end
endmodule
