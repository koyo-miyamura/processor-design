module branch_test;
	reg signed [31:0]rs,rt;
	reg [5:0]op,func;
	reg [4:0]rt_field;
	wire [1:0]pc_src;

	branch unit1(pc_src,
	      	     op,rt_field,func,rs,rt);
	always #10 op=op+1;
	initial
	begin
		op=6'b000000;
		func=6'b001001;
		rt_field=5'b00001;
		rs=-4;
		rt=12;
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
	$monitor($stime,,"rs=%d,rt=%d,pc_src=%b",rs,rt,pc_src);
endmodule
