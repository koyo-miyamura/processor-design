`timescale              1 ns/1 ps
module alu_control(alu_control_out,shamt_out,
	      func,shamt_in,alu_op);
	input [5:0]func;
	input [4:0]shamt_in;
	input [3:0]alu_op;
	output[4:0]alu_control_out,shamt_out;

	//func
	parameter sll=6'b000000,srl=6'b000010,sra=6'b000011,sllv=6'b000100,srlv=6'b000110,srav=6'b000111,
		  jr=6'b001000,jalr=6'b001001,add=6'b100000,addu=6'b100001,sub=6'b100010,subu=6'b100011,And=6'b100100,Or=6'b100101,Xor=6'b100110,
		  Nor=6'b100111,slt=6'b101010,sltu=6'b101011;

	//alu_op
	parameter func_op=4'b0000,add_s=4'b0001,add_uns=4'b0010,slt_s=4'b0011,slt_uns=4'b0100,and_op=4'b0101,or_op=4'b0110,xor_op=4'b0111,lui_op=4'b1000;
	
	//alu_control_out
	parameter sll_alu=5'b00000,srl_alu=5'b00001,sra_alu=5'b00010,sllv_alu=5'b00011,srlv_alu=5'b00100,srav_alu=5'b00101,add_alu=5'b00110,addu_alu=5'b00111,
		  sub_alu=5'b01000,subu_alu=5'b01001,and_alu=5'b01010,or_alu=5'b01011,xor_alu=5'b01100,nor_alu=5'b01101,slt_alu=5'b01110,sltu_alu=5'b01111,
		  lui_alu=5'b10000;

	//shamt
	parameter zero=5'b00000;


	function [9:0] alu_control;
		input [5:0]func;
		input [4:0]shamt_in;
		input [3:0]alu_op;

		case(alu_op)
		func_op:begin
			case(func)
			   sll:alu_control={sll_alu,shamt_in};
			   srl:alu_control={srl_alu,shamt_in};
		           sra:alu_control={sra_alu,shamt_in};	  
			   sllv:alu_control={sllv_alu,zero};			
			   srlv:alu_control={srlv_alu,zero};
			   srav:alu_control={srav_alu,zero};
			   //alu is not work
			   jr,jalr:alu_control={5'b00000,zero};
			   add:alu_control={add_alu,zero};
		           addu:alu_control={addu_alu,zero};	  
			   sub:alu_control={sub_alu,zero};			
			   subu:alu_control={subu_alu,zero};
		           And:alu_control={and_alu,zero};	  
			   Or:alu_control={or_alu,zero};			
			   Xor:alu_control={xor_alu,zero};
		           Nor:alu_control={nor_alu,zero};	  
			   slt:alu_control={slt_alu,zero};
			   sltu:alu_control={sltu_alu,zero};

			   //the instruction isn't defined. maybe it is exception.
			   default:alu_control=10'b00000_00000;
			endcase
			end

		add_s:   alu_control={add_alu,zero};
		add_uns: alu_control={addu_alu,zero};
		slt_s:   alu_control={slt_alu,zero};
		slt_uns: alu_control={sltu_alu,zero};
		and_op:  alu_control={and_alu,zero};
		or_op:   alu_control={or_alu,zero};
		xor_op:  alu_control={xor_alu,zero};
		lui_op:  alu_control={lui_alu,zero};

		//the instruction isn't defined. maybe it is exception.
		default:alu_control=10'b00000_00000;

		endcase
	endfunction

	assign {alu_control_out,shamt_out}=alu_control(func,shamt_in,alu_op);
endmodule
