module sll_2_test;
	wire[31:0]in,out;
	sll_2 unit1(in(in),out(out));

	initial
	begin
		in=32'b0000_0000_0000_0000_0000_0000_0000_0101;
	end
	
	initial
	$monitor("in_d=%d out_d=%d in_b=%b out_b=%b",in,out,in,out);

endmodule
