module if_id_reg(ins_out,pc_4_out,pc_4_in,ins_in,if_flush,if_id_write,reset,clk);
	input [31:0]pc_4_in,ins_in;
	input if_flush,if_id_write,reset,clk;
	output [31:0]ins_out,pc_4_out;
	
	reg [31:0]ins_out,pc_4_out;
	
	always @ (posedge clk or negedge reset)
	begin
		casez({reset,if_flush,if_id_write}) //reset is active low
			//not write
			3'b100:
			begin
			ins_out<=ins_out; pc_4_out<=pc_4_out;
			end
			//normal
			3'b101:
			begin
			ins_out<=ins_in;  pc_4_out<=pc_4_in;
			end
			//flush
			3'b11z:
			begin
			ins_out<=32'b0;   pc_4_out<=pc_4_in;
			end
			//reset
			3'b0zz:
			begin
			ins_out<=32'b0;   pc_4_out<=pc_4_in;   
			end
		endcase
	end
endmodule
