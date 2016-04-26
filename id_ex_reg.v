module id_ex_reg(control_out,pc_4_out,rs_out,rt_out,offset_out,id_ex_rs,id_ex_rt,id_ex_rd,
		control_in,pc_4_in,rs_in,rt_in,offset_in,if_id_rs,if_id_rt,if_id_rd,
		reset,clk);
	input [31:0]pc_4_in,rs_in,rt_in,offset_in;
	input [12:0]control_in;
	input [4:0]if_id_rs,if_id_rt,if_id_rd;
	input reset,clk;
	
	output [31:0]pc_4_out,rs_out,rt_out,offset_out;
	output [12:0]control_out;
	output [4:0]id_ex_rs,id_ex_rt,id_ex_rd;

	reg [31:0]pc_4_out,rs_out,rt_out,offset_out;
	reg [12:0]control_out;
	reg [4:0]id_ex_rs,id_ex_rt,id_ex_rd;

	always @ (posedge clk or negedge reset)
	begin
		case(reset) //reset is active low
			//normal
			1'b1:
			begin
			pc_4_out<=pc_4_in;
			rs_out<=rs_in;
			rt_out<=rt_in; 
			offset_out<=offset_in;
			control_out<=control_in;
			id_ex_rs<=if_id_rs;
			id_ex_rt<=if_id_rt; 
			id_ex_rd<=if_id_rd;
			end
			
			//reset
			1'b0:
			begin
			pc_4_out<=0;
			rs_out<=0;
			rt_out<=0; 
			offset_out<=0;
			control_out<=1;
			id_ex_rs<=0;
			id_ex_rt<=0; 
			id_ex_rd<=0;  
			end
		endcase
	end
endmodule
