module if_stage(pc_4_out,pc_out,
		beq,jr,pc_4_id,offset28,pc_write,pc_src,clk);
	input [31:0]beq,jr;
	input [27:0]offset28;
	input [3:0]pc_4_id;
	input pc_write,clk;
	input [1:0]pc_src;
	output [31:0]pc_4_out,pc_out;
	
	wire [31:0]pc_4_out,pc_out;
	
	assign pc_4_out=pc_out+3'b100; //PC+4

	pc unit1 (.out(pc_out),.beq(beq),.jr(jr),.pc_4_if(pc_4_out),.pc_4_id(pc_4_id),.offset28(offset28),.pc_write(pc_write),.pc_src(pc_src),.clk(clk));

endmodule
