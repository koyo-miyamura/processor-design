`timescale              1 ns/1 ps
module ex_mem_reg(control_out,alu_out,sw_out,regdst_out,vector_ex_out,
		control_in,alu_in,sw_in,regdst_in,vector_ex_in,
		ex_flush,reset,clk);
	input [31:0]alu_in,sw_in;
	input [6:0]control_in;
	input [4:0]regdst_in,vector_ex_in;
	input ex_flush,reset,clk;
	
	output alu_out,sw_out;
	output [6:0]control_out;
	output [4:0]regdst_out,vector_ex_out;

	reg [31:0]alu_out,sw_out;
	reg [6:0]control_out;
	reg [4:0]regdst_out,vector_ex_out;

	always @ (posedge clk or negedge reset)
	begin
		case({reset,ex_flush}) //reset is active low
			//normal
			2'b10:
			begin
			alu_out<=alu_in;
			sw_out<=sw_in; 
			control_out<=control_in;
			regdst_out<=regdst_in;
			vector_ex_out<=vector_ex_in;
			end
			
			//reset
			2'b0z,2'b11:
			begin
			alu_out<=0;
			sw_out<=0; 
			control_out<=1;
			regdst_out<=0; 
			vector_ex_out<=0;
			end
		endcase
	end
endmodule
