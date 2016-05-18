`timescale              1 ns/1 ps
module mem_wb_reg(control_out,data_out,alu_out,regdst_out,
		control_in,data_in,alu_in,regdst_in,
		reset,clk);
	input [31:0]data_in,alu_in;
	input [1:0]control_in;
	input [4:0]regdst_in;
	input reset,clk;
	
	output [31:0]data_out,alu_out;
	output [1:0]control_out;
	output [4:0]regdst_out;

	reg [31:0]data_out,alu_out;
	reg [1:0]control_out;
	reg [4:0]regdst_out;

	always @ (posedge clk or negedge reset)
	begin
		case(reset) //reset is active low
			//normal
			1'b1:
			begin
			data_out<=data_in;
			alu_out<=alu_in;
			control_out<=control_in;
			regdst_out<=regdst_in;
			end
			
			//reset
			1'b0:
			begin
			data_out<=0;
			alu_out<=0;
			control_out<=1;
			regdst_out<=0; 
			end
		endcase
	end
endmodule
