`timescale              1 ns/1 ps
module alu(alu_out,
	   rs,rt,alu_control,shamt);
	input [31:0]rs,rt;
	input [4:0]alu_control,shamt;
	output[31:0]alu_out; 
	
	//alu_control
	parameter sll_alu=5'b00000,srl_alu=5'b00001,sra_alu=5'b00010,sllv_alu=5'b00011,srlv_alu=5'b00100,srav_alu=5'b00101,add_alu=5'b00110,addu_alu=5'b00111,
		  sub_alu=5'b01000,subu_alu=5'b01001,and_alu=5'b01010,or_alu=5'b01011,xor_alu=5'b01100,nor_alu=5'b01101,slt_alu=5'b01110,sltu_alu=5'b01111,
		  lui_alu=5'b10000;


	function [31:0] alu_exe;
		input [31:0]rs,rt;
		input [4:0]alu_control,shamt;

		case(alu_control)
		sll_alu:  alu_exe=rt<<shamt;

		srl_alu:  alu_exe=rt>>shamt;

		sra_alu:  alu_exe=($signed(rt))>>>shamt;

		sllv_alu: alu_exe=rt<<rs;

		srlv_alu: alu_exe=rt>>rs;

		srav_alu: alu_exe=($signed(rt))>>>rs;
		
		//overflow is to be supported
		add_alu:  alu_exe=rs+rt;

		addu_alu: alu_exe=rs+rt;

		//underflow is to be supported
		sub_alu:  alu_exe=rs-rt;

		subu_alu: alu_exe=rs-rt;

		and_alu:  alu_exe=rs&rt;

		or_alu:   alu_exe=rs|rt;

		xor_alu:  alu_exe=rs^rt;

		nor_alu:  alu_exe=~(rs|rt);

		slt_alu:  alu_exe=(($signed(rs))<($signed(rt)));

		sltu_alu: alu_exe=(rs<rt);

		lui_alu:  alu_exe={rt[15:0],16'h0000};

		//the instruction isn't defined. maybe it is exception.
		default:  alu_exe=0;

		endcase
	endfunction

	assign alu_out=alu_exe(rs,rt,alu_control,shamt);
endmodule
