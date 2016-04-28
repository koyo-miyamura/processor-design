module if_stage(pc_4_out,pc_out,
		beq,jr,pc_4_id,offset28,pc_write,pc_src,reset,clk);
	input [31:0]beq,jr;
	input [27:0]offset28;
	input [3:0]pc_4_id;
	input pc_write,reset,clk;
	input [1:0]pc_src;
	output [31:0]pc_4_out,pc_out;
	
	wire [31:0]pc_4_out,pc_out,pc_in;

	
	//initial assign pc_in=32'b0000_0000_0000_0000_0000_0000_0001_0000;
	
	mux_4 mux4(.out(pc_in), .a(pc_4_out), .b({pc_4_id,offset28}), .c(beq), .d(jr), .sel(pc_src));

	assign pc_4_out=pc_out+3'b100; //PC+4

	pc unit1 (.out(pc_out), .in(pc_in), .pc_write(pc_write), .reset(reset), .clk(clk));

endmodule
