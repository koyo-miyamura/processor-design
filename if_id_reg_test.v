module if_id_reg_test;
	reg [31:0]pc_4_in,ins_in;
	reg if_flush,if_id_write,reset,clk;
	wire [31:0]ins_out,pc_4_out;	
	if_id_reg unit1(ins_out,pc_4_out,pc_4_in,ins_in,if_flush,if_id_write,reset,clk);
	initial
	begin
		ins_in=32'b0000_0000_0000_0000_0000_0000_0000_1111;
		pc_4_in=32'b0000_0000_0000_0000_0000_0000_1111_0000;
		reset=1'b1;
		if_flush=1'b0;
		if_id_write=1'b1;
		#5
		clk=1'b1;
		#5
		clk=1'b0;
		if_flush=1'b1;
		#5
		clk=1'b1;
		#5
		clk=1'b0;
		if_flush=1'b0;
		if_id_write=1'b0;
		#5
		clk=1'b1;
		#5
		clk=1'b0;
		if_id_write=1'b1;
		#5
		clk=1'b1;
		#5
		clk=1'b0;
		reset=1'b0;
		#5
		clk=1'b1;
		#5
		$finish;
	end
	initial
	$monitor($stime,,"clk=%b ins_out=%b pc_4_out=%b reset=%b if_flush=%b if_id_write=%b",clk,ins_out,pc_4_out,reset,if_flush,if_id_write);
endmodule
