module if_stage_test;
	reg [31:0]beq,jr;
	reg [27:0]offset28;
	reg [3:0]pc_4_id;
	reg pc_write,reset,clk;
	reg [1:0]pc_src;
	wire [31:0]pc_4_out,pc_out;
	if_stage unit1(pc_4_out,pc_out,
		beq,jr,pc_4_id,offset28,pc_write,pc_src,reset,clk);
		always #5 clk=!clk;
	initial
	begin
		clk=0;
		reset=1;
		beq=32'b0000_0000_0000_0000_0000_0000_0000_1111;
		jr=32'b0000_0000_0000_0000_0000_0000_1111_0000;
		offset28=28'b1111_0000_0000_0000_0000_0000_0000;
		pc_4_id=4'b1010;
		pc_write=1'b1;
		pc_src=2'b00;
		#5
		reset=0;
		#5
		reset=1;
		#10
		#10
		#10
		#10
		$finish;
	end
	initial
	$monitor($stime,,"clk=%b reset=%b pc_out=%b pc_4_out=%b",clk,reset,pc_out,pc_4_out);
endmodule
