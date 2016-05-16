`timescale              1 ns/1 ps
module branch(pc_src,if_flush,
	      op,rt_field,func,rs,rt);
	input [31:0]rs,rt;
	input [5:0]op,func;
	input [4:0]rt_field;
	output [1:0]pc_src;
	output if_flush;

	//00=PC+4 01=j 10=branch 11=jr
	function [2:0] branch;
		input [31:0]rs,rt;
		input [5:0]op,func;
		input [4:0]rt_field;

		casez({op,rt_field})
		//op   000000=jr,jalr
		//func 001000=jr 001001=jalr
		11'b000000_zzzzz: branch=( (func==6'b001000)||(func==6'b001001) )? 3'b111:3'b000;

		//000001=bal
		//rt_field 00001=bgez 10001=bgezal
		11'b000001_00001,11'b000001_10001: branch=(rs>=0)? 3'b101:3'b000;

		//10000=bltzal 00000=bltz
		11'b000001_10000,11'b000001_00000: branch=(rs<0)? 3'b101:3'b000;


		//000010=j 000011=jal
		11'b000010_zzzzz,11'b000011_zzzzz: branch=3'b011;

		//000100=beq
		11'b000100_zzzzz: branch=(rs==rt)? 3'b101:3'b000;

		//000101=bne
		11'b000101_zzzzz: branch=(rs!=rt)? 3'b101:3'b000;

		//000110=blez
		11'b000110_zzzzz: branch=(rs<=0)? 3'b101:3'b000;

		//000111=bgtz
		11'b000111_zzzzz: branch=(rs>0)? 3'b101:3'b000;

		default:branch=3'b000;

		endcase
	endfunction

	assign {pc_src,if_flush}=branch(rs,rt,op,func,rt_field);
endmodule
