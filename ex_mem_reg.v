`timescale              1 ns/1 ps
module ex_mem_reg(control_out,alu_out,sw_out,regdst_out,vector_ex_out,pc_out,
		control_in,alu_in,sw_in,regdst_in,vector_ex_in,pc_in,
		ex_flush,reset,clk);
	input [31:0]alu_in,sw_in,pc_in;
	input [7:0]control_in;
	input [4:0]regdst_in,vector_ex_in;
	input ex_flush,reset,clk;
	
	output alu_out,sw_out,pc_out;
	output [7:0]control_out;
	output [4:0]regdst_out,vector_ex_out;

	reg [31:0]alu_out,sw_out,pc_out;
	reg [7:0]control_out;
	reg [4:0]regdst_out,vector_ex_out;

	always @ (posedge clk or negedge reset)
	begin
/*
		casez({reset,ex_flush}) //reset is active low
			//normal
			2'b10:
			begin
			alu_out<=alu_in;
			sw_out<=sw_in; 
			control_out<=control_in;
			regdst_out<=regdst_in;
			vector_ex_out<=vector_ex_in;
			pc_out<=pc_in;
			end
			
			//reset
			2'b0z,2'b11:
			begin
			alu_out<=0;
			sw_out<=0; 
			control_out<=1;
			regdst_out<=0; 
			vector_ex_out<=0;
			pc_out<=0;
			end
		endcase
*/
		if(reset==0)
			begin
			alu_out<=0;
			sw_out<=0; 
			control_out<=1;
			regdst_out<=0; 
			vector_ex_out<=0;
			pc_out<=0;
			end
		else if(ex_flush==1)
			begin
			alu_out<=0;
			sw_out<=0; 
			control_out<=1;
			regdst_out<=0; 
			vector_ex_out<=0;
			pc_out<=0;
			end
		else
			begin
			alu_out<=alu_in;
			sw_out<=sw_in; 
			control_out<=control_in;
			regdst_out<=regdst_in;
			vector_ex_out<=vector_ex_in;
			pc_out<=pc_in;
			end
	end
endmodule
