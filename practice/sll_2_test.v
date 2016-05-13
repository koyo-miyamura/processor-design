module sll_2_test;
	reg [31:0] in;
	wire[31:0] out;
	sll_2 unit1(.out(out), .in(in));

	initial
	begin
		in <= 32'b0000_0000_0000_0000_0000_0000_0000_0101;
	end
	
	initial
	$monitor("in_d=%d out_d=%d in_b=%b out_b=%b",in,out,in,out);

endmodule
