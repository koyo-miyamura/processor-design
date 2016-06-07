`timescale              1 ns/1 ps
module Exception(exception,vector,IACK,
	         IE_c,vector_mem,rst,OINT);

	input[4:0] vector_mem;
	input[2:0] OINT;
	input rst,IE_c;

	wire OINT_n=~OINT;

	output[4:0] vector;
	output exception,IACK; //IACK is active low

 	assign {vector,exception,IACK}=(IE_c==0)?             7'b00000_0_1:
				       (rst ==0)?             7'b11111_1_0:
				       (vector_mem>5'b00011)? {vector_mem,2'b11}:
				       (OINT_n!=3'b000)?      {2'b00,OINT_n,2'b10}:
				       			      {7'b00000_0_1};

endmodule
