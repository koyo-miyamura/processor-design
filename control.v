`timescale              1 ns/1 ps
module control(control_out,no_define,
	      op,func,rt_field);
	input [5:0]op,func;
	input [4:0]rt_field;
	output [14:0]control_out;
	output no_define;

	//op_field
	parameter R=6'b000000,bal=6'b000001,j=6'b000010,jal=6'b000011,beq=6'b000100,bne=6'b000101,blez=6'b000110,bgtz=6'b000111,
		  addi=6'b001000,addiu=6'b001001,slti=6'b001010,sltiu=6'b001011,andi=6'b001100,ori=6'b001101,xori=6'b001110,lui=6'b001111,
		  rfe=6'b010000,trap=6'b010001,lb=6'b100000,lh=6'b100001,lw=6'b100011,lbu=6'b100100,lhu=6'b100101,sb=6'b101000,
		  sh=6'b101001,sw=6'b101011;
	//func
	parameter sll=6'b000000,srl=6'b000010,sra=6'b000011,sllv=6'b000100,srlv=6'b000110,srav=6'b000111,
		  jr=6'b001000,jalr=6'b001001,add=6'b100000,addu=6'b100001,sub=6'b100010,subu=6'b100011,And=6'b100100,Or=6'b100101,Xor=6'b100110,
		  Nor=6'b100111,slt=6'b101010,sltu=6'b101011;
	//rt_field
	parameter bgez=5'b00001,bgezal=5'b10001,bltzal=5'b10000,bltz=5'b00000;

	//[14bit]control=[4bit]ALUOP,[1bit]ALUSrc,[2bit]RegDst,[2bit]Size,[1bit]MemWrite,[1bit]MemRead,[1bit]lb_lh,[1bit]MemtoReg,[1bit]RegWrite 
	function [14:0] control;
		input [5:0]op,func;
		input [4:0]rt_field;

		case(op)
		
		R:begin
		  case(func)
		  	sll,srl,sra,sllv,srlv,srav,add,addu,sub,subu,And,Or,Xor,Nor,slt,sltu: control=15'b0000_0_01_0_00_0_0_0_0_0;
		  	jr:control=  15'b0000_0_00_0_00_0_0_0_0_1;
		  	jalr:control=15'b0000_0_10_0_00_0_0_0_0_0;

		  	//the instruction isn't defined. maybe it is exception.
		  	default:control=15'b0000_0_00_0_00_0_0_0_0_0;
		  endcase
		  end

		bal:begin
		    case(rt_field)
		    	bgez,bltz:     control=15'b0001_0_00_0_00_0_0_0_0_1;
			bgezal,bltzal: control=15'b0001_0_10_0_00_0_0_0_0_0;

			//the instruction isn't defined. maybe it is exception.
		  	default:control=15'b0000_0_00_0_00_0_0_0_0_0;
		    endcase
		    end

		j,beq,bne,blez,bgtz: control=15'b0001_0_00_0_00_0_0_0_0_1;
		jal:   control=15'b0001_0_10_0_00_0_0_0_0_0;

		addi:  control=15'b0001_1_00_0_00_0_0_0_0_0;
		addiu: control=15'b0010_1_00_0_00_0_0_0_0_0;
		slti:  control=15'b0011_1_00_0_00_0_0_0_0_0;
		sltiu: control=15'b0100_1_00_0_00_0_0_0_0_0;
		andi:  control=15'b0101_1_00_0_00_0_0_0_0_0;
		ori:   control=15'b0110_1_00_0_00_0_0_0_0_0;
		xori:  control=15'b0111_1_00_0_00_0_0_0_0_0;
		lui:   control=15'b1000_1_00_0_00_0_0_0_0_0;

		rfe:   control=15'b0001_0_00_1_00_0_0_0_0_0;
		trap:  control=15'b0001_0_00_0_00_0_0_0_0_0;

		lb:    control=15'b0001_1_00_0_10_0_1_1_1_0;
		lbu:   control=15'b0001_1_00_0_10_0_1_0_1_0;

		lh:    control=15'b0001_1_00_0_01_0_1_1_1_0;
		lhu:   control=15'b0001_1_00_0_01_0_1_0_1_0;

		lw:    control=15'b0001_1_00_0_00_0_1_0_1_0;

		sb:    control=15'b0001_1_00_0_10_1_0_0_0_1;
		sh:    control=15'b0001_1_00_0_01_1_0_0_0_1;
		sw:    control=15'b0001_1_00_0_00_1_0_0_0_1;

		//the instruction isn't defined. maybe it is exception.
	        default:control=15'b0000_0_00_0_00_0_0_0_0_0;

		endcase
	endfunction

	assign control_out=control(op,func,rt_field);

	assign no_define=(control_out==0)? 1:0;
endmodule
