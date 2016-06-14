`timescale              1 ns/1 ps
module if_id_reg(ins_out,pc_4_out,vector_if_out,
		 pc_4_in,ins_in,if_flush,if_id_write,vector_if_in,
		 reset,clk);
	input [31:0]pc_4_in,ins_in;
	input [4:0] vector_if_in;
	input if_flush,if_id_write,reset,clk;

	output [31:0]ins_out,pc_4_out;
	output [4:0] vector_if_out;
	
	reg [31:0]ins_out,pc_4_out;
	reg [4:0] vector_if_out;
	
	always @ (posedge clk or negedge reset)
	begin
/*
		casez({reset,if_flush,if_id_write}) //reset is active low
			//not write
			3'b100:
			begin
			ins_out<=ins_out; pc_4_out<=pc_4_out; vector_if_out<=vector_if_out;
			end
			//normal
			3'b101:
			begin
			ins_out<=ins_in;  pc_4_out<=pc_4_in; vector_if_out<=vector_if_in;
			end
			//flush
			3'b11z:
			begin
			ins_out<=32'b0;   pc_4_out<=0; vector_if_out<=0;
			end
			//reset
			3'b0zz:
			begin
			ins_out<=32'b0;   pc_4_out<=0; vector_if_out<=0;
			end
		endcase
*/
		if(reset==0)
		begin
			ins_out<=32'b0;   
			pc_4_out<=0; 
			vector_if_out<=0;
		end
		else if(if_flush==1)
		begin
			ins_out<=32'b0;   
			pc_4_out<=0; 
			vector_if_out<=0;
		end
		else if(if_id_write==0)
		begin
			ins_out<=ins_out; 
			pc_4_out<=pc_4_out; 
			vector_if_out<=vector_if_out;
		end
		else
		begin
			ins_out<=ins_in;  
			pc_4_out<=pc_4_in; 
			vector_if_out<=vector_if_in;
		end
	end
endmodule
