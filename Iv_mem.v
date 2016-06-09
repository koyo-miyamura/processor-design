`timescale              1 ns/1 ps
module Iv_mem(vector_mem,
	     data_address,vector_ex,size,s_u,memwrite,memread);

	input  [31:0]data_address;
	input  [4:0] vector_ex;
	input  [1:0] size;
	input        s_u,memwrite,memread;
	output [4:0] vector_mem;

	parameter data_missaline=5'b01011,data_memory=5'b01001;

	wire word_missaline,half_missaline;
	assign word_missaline=(size==2'b00)&&(memwrite||memread)&&(data_address[1:0]!=2'b00);
	assign half_missaline=(size==2'b01)&&(data_address[1:0]==2'b01);
	
	assign vector_mem=(vector_ex>data_missaline)?          vector_ex: 
	                  (word_missaline||half_missaline)?    data_missaline:
			  ((data_address<32'h000_10000)&&s_u&&(memwrite||memread))? data_memory:
			 		                       5'b00000;

endmodule
