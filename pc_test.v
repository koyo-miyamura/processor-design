module pc_test;
	reg [31:0]beq,jr,pc_4_if;
	reg [27:0]offset28;
	reg [3:0]pc_4_id;
	reg pc_write,clk;
	reg [1:0]pc_src;
	
	wire [31:0]out;
	
	pc unit1(.out(out),.beq(beq),.jr(jr),.pc_4_if(pc_4_if),.pc_4_id(pc_4_id),.offset28(offset28),.pc_write(pc_write),.pc_src(pc_src),.clk(clk));
	initial
	begin
		pc_write=1'b1; pc_src=2'b00;clk=1'b1;
		pc_4_if=32'b0000_0000_0000_0000_0000_0000_0000_1111;
		pc_4_id=4'b1111;
		offset28=28'b0000_0000_0000_0000_0000_0000_0001;
		beq=32'b0000_0000_0000_0000_0000_0000_1111_0000;
		jr=32'b0000_0000_0000_0000_0000_1111_0000_0000;
		#5
		clk=1'b0;
		#5
		clk=1'b1;pc_src=2'b01;
		#5
		clk=1'b0;
		#5
		clk=1'b1;pc_src=2'b10;
		#5
		clk=1'b0;
		#5
		clk=1'b1;pc_src=2'b11;
		#5
		clk=1'b0;
		#5
		clk=1'b1;jr=32'b0000_0000_0000_0000_0000_0000_0000_0000;
		pc_write=1'b0;
		#5
		clk=1'b0;
		#5
		clk=1'b1;pc_write=1'b1;
		#5	
		clk=1'b0;
		#5
		clk=1'b1;pc_write=1'b0;
		pc_src=2'b10;
		#5	
		clk=1'b0;pc_write=1'b1;
		pc_src=2'b10;
		#5
		$finish;
	end
	initial
	$monitor($stime,,"write=%b src=%b out=%b",pc_write,pc_src,out);
endmodule
