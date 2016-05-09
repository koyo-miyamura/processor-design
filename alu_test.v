module alu_test;
	reg signed [31:0]rs,rt;
	reg [4:0]alu_control,shamt;
	wire signed[31:0]alu_out; 

	alu unit1(alu_out,
	   rs,rt,alu_control,shamt);

	always #10 alu_control=alu_control+1;

	initial
	begin
		alu_control=5'b00000;
	  	rs=3;
		rt=-36;
		shamt=5'b00010;
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		#10
		$finish;
	end
	initial
	$monitor($stime,,"alu_control=%b, rs=%d %b rt=%d %b alu_out=%d  %b",alu_control,rs,rs,rt,rt,alu_out,alu_out);
endmodule
