`timescale              1 ns/1 ps
module branch(pc_src,
	      op,rt_field,func,rs,rt);
	input [31:0]rs,rt;
	input [5:0]op,func;
	input [4:0]rt_field;
	output [1:0]pc_src;

	//op
	parameter R=6'b000000,bal=6'b000001,j=6'b000010,jal=6'b000011,beq=6'b000100,bne=6'b000101,blez=6'b000110,bgtz=6'b000111;
	//func
	parameter jr=6'b001000,jalr=6'b001001;
	//rt_field
	parameter bltz=5'b00000,bgez=5'b00001,bltzal=5'b10000,bgezal=5'b10001,dont_care=5'bzzzzz;

	//00=PC+4 01=j 10=branch 11=jr
	function [1:0] branch;
		input [31:0]rs,rt;
		input [5:0]op,func;
		input [4:0]rt_field;

		casez({op,rt_field})
		//op   000000=jr,jalr
		//func 001000=jr 001001=jalr
		{R,dont_care}: branch=( (func==jr)||(func==jalr) )? 2'b11:2'b00;

		//000001=bal
		//rt_field 00001=bgez 10001=bgezal
		{bal,bgez},{bal,bgezal}: branch=($signed(rs)>=0)? 2'b10:2'b00;

		//10000=bltzal 00000=bltz
		{bal,bltzal},{bal,bltz}: branch=($signed(rs)<0)? 2'b10:2'b00;

		//000010=j 000011=jal
		{j,dont_care},{jal,dont_care}: branch=2'b01;

		//000100=beq
		{beq,dont_care}: branch=(rs==rt)? 2'b10:2'b00;

		//000101=bne
		{bne,dont_care}: branch=(rs!=rt)? 2'b10:2'b00;

		//000110=blez
		{blez,dont_care}: branch=($signed(rs)<=0)? 2'b10:2'b00;

		//000111=bgtz
		{bgtz,dont_care}: branch=($signed(rs)>0)? 2'b10:2'b00;

		default:branch=2'b00;

		endcase
	endfunction

	assign  pc_src=branch(rs,rt,op,func,rt_field);
endmodule
