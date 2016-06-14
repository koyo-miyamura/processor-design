`timescale              1 ns/1 ps
module if_stage(pc_4_out,pc_out,vector_if,
		beq,jr,pc_4_id,offset28,pc_write,pc_src,rfe,exception,vector_no_3,IAR_pc,s_u,
		clk);
	input [31:0]beq,jr,IAR_pc;
	input [27:0]offset28;
	input [4:0]vector_no_3;
	input [3:0]pc_4_id;
	input [1:0]pc_src;
	input pc_write,clk,rfe,exception,s_u;

	output [31:0]pc_4_out,pc_out;
	output [4:0]vector_if;
	
	wire [31:0]pc_4_out,pc_out,pc_in,vector_3,pc_mux4,pc_rfe;
	
	//initial assign pc_in=32'b0000_0000_0000_0000_0000_0000_0001_0000;
	
	mux_4 mux4(.out(pc_mux4), .a(pc_4_out), .b({pc_4_id,offset28}), .c(beq), .d(jr), .sel(pc_src));

	assign pc_rfe=(rfe)? IAR_pc:pc_mux4;

	assign vector_3={27'b0,vector_no_3}<<3;
	assign pc_in= (exception)? vector_3:pc_rfe;

	pc pc(.out(pc_out), .in(pc_in), .pc_write(pc_write), .clk(clk));

	Iv_if Iv_if(.vector_if(vector_if), .pc(pc_out), .s_u(s_u));

	assign pc_4_out=pc_out+3'b100; //PC+4
endmodule
