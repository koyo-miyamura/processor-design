module mux_4_test;
	reg [31:0]in1,in2,in3,in4;
	reg [1:0] sel;
	wire [31:0]out;
	mux_4 unit1(.out(out),.a(in1),.b(in2),.c(in3),.d(in4),.sel(sel));

	initial
	begin
		in1=32'b0; 
		in2=32'b0; 
		in3=32'b0; 
		in4=32'b0; 
		sel=2'b0; 
		#5
		in1=32'b1;
		#5
		sel=2'b01; 
		#5
		in2=32'b1;
		#5
		sel=2'b10;
		#5
		in3=32'b1;
		#5
		sel=2'b11;
		#5
		in4=32'b1;
		#5
		$finish;
	end
	initial
	$monitor($stime,,"in1=%d in2=%d in3=%d in4=%d Sel=%d out=%d", in1, in2, in3, in4, sel, out);
endmodule
