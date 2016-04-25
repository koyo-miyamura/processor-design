module sll_2(out,in);
	input [31:0]in;
	output [31:0]out;
	wire [31:0]in,out;
	assign out=in<<2'b10;
	//assign out={in[29:0],2'b00};
endmodule
