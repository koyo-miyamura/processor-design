module branch(pc_src,
	      op,rt_field,func,rs,rt);
	input [31:0]rs,rt;
	input [5:0]op,func;
	input [4:0]rt_field;
	output [1:0]pc_src;

	//00=PC+4 01=j 10=branch 11=jr
	function [1:0] branch;
		input [31:0]rs,rt;
		input [5:0]op,func;
		input [4:0]rt_field;

		casez({op,rt_field})
		//op   000000=jr,jalr
		//func 001000=jr 001001=jalr
		11'b000000_zzzzz: branch=( (func==6'b001000)||(func==6'b001001) )? 2'b11:2'b00;

		//000001=bal
		//rt_field 00001=bgez 10001=bgezal
		11'b000001_00001,11'b000001_10001: branch=(rs>=0)? 10:00;

		//10000=bltzal 00000=bltz
		11'b000001_10000,11'b000001_00000: branch=(rs<0)? 10:00;


		//000010=j 000011=jal
		11'b000010_zzzzz,11'b000011_zzzzz: branch=2'b01;

		//000100=beq
		11'b000100_zzzzz: branch=(rs==rt)? 2'b10:2'b00;

		//000101=bne
		11'b000101_zzzzz: branch=(rs!=rt)? 2'b10:2'b00;

		//000110=blez
		11'b000110_zzzzz: branch=(rs<=0)? 2'b10:2'b00;

		//000111=bgtz
		11'b000111_zzzzz: branch=(rs>0)? 2'b10:2'b00;

		default:branch=2'b00;

		endcase
	endfunction

	assign pc_src=branch(rs,rt,op,func,rt_field);
endmodule
