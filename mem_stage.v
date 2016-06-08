`timescale              1 ns/1 ps
module mem_stage(address_out,data_write_out,data_out,size,mem_write,mem_read,control_out,regdst_out,rfe,vector_mem,
		 address_in,data_write_in,data_mem,control_in,regdst_in,wb_data,forward_e,vector_ex,s_u);

	input [31:0]address_in,data_write_in,data_mem,wb_data;
	input [7:0]control_in;
	input [4:0]regdst_in,vector_ex;
	input forward_e,s_u;

	output [31:0]address_out,data_write_out,data_out;
	output [4:0]regdst_out,vector_mem;
	output [1:0]control_out;
	output [1:0]size;
	output mem_read,mem_write,rfe;

	wire lb_lh;

	assign regdst_out=regdst_in;
	
	assign rfe=control_in[7];
	assign size=control_in[6:5];
	assign mem_write=control_in[4];
	assign mem_read=control_in[3];
	assign lb_lh=control_in[2];
	assign control_out=control_in[1:0];

	assign address_out=address_in;
	assign data_write_out=(forward_e)? wb_data:data_write_in;

	//judge with size 
	assign data_out=(lb_lh==0)? data_mem:
	             (size==2'b01)? {{16{data_mem[15]}},data_mem[15:0]}:
		     (size==2'b10)? {{24{data_mem[7]}},data_mem[7:0]}:
		     data_mem;

	Iv_mem Iv_mem(.vector_mem(vector_mem),
	     .data_address(address_out), .vector_ex(vector_ex), .size(size), .s_u(s_u), .memwrite(mem_write), .memread(mem_read));


endmodule
