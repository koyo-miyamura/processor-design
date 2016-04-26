module ex_mem_reg(control_out,pc_4_out,alu_out,sw_out,regdst_out,
		control_in,pc_4_in,alu_in,sw_in,regdst_in,
		reset,clk);
	input [31:0]pc_4_in,alu_in,sw_in;
	input [6:0]control_in;
	input [4:0]regdst_in;
	input reset,clk;
	
	output [31:0]pc_4_out,alu_out,sw_out;
	output [6:0]control_out;
	output [4:0]regdst_out;

	reg [31:0]pc_4_out,alu_out,sw_out;
	reg [6:0]control_out;
	reg [4:0]regdst_out;

	always @ (posedge clk or negedge reset)
	begin
		case(reset) //reset is active low
			//normal
			1'b1:
			begin
			pc_4_out<=pc_4_in;
			alu_out<=alu_in;
			sw_out<=sw_in; 
			control_out<=control_in;
			regdst_out<=regdst_in;
			end
			
			//reset
			1'b0:
			begin
			pc_4_out<=0;
			alu_out<=0;
			sw_out<=0; 
			control_out<=1;
			regdst_out<=0; 
			end
		endcase
	end
endmodule
