`timescale              1 ns/1 ps
module IAR(pc_out,
	   memwrite,oint_ex,exception,pc_8_in,s_u,reset,trap,clk);

	input [31:0]pc_8_in;
	input memwrite,oint_ex,exception,s_u,reset,trap,clk;
	output [31:0]pc_out;
	
	reg [31:0]pc_out;

	wire trap_store=((memwrite&&oint_ex)||(trap));
	
	always @ (posedge clk or negedge reset)
	begin
		casez({reset,s_u,exception,trap_store})
		        //user
			4'b11zz: pc_out<=pc_out;
			//exception
			4'b1011: pc_out<=pc_8_in-32'h0000_0004;
			4'b1010: pc_out<=pc_8_in-32'h0000_0008;

			//reset
			4'b0zzz: pc_out<=32'h000_10000;
			default pc_out<=pc_out;
		endcase
	end
endmodule
