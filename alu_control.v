module alu_control(alu_control,
	      func,alu_op);
	input [5:0]func;
	input [3:0]alu_op;
	output [3:0]alu_control_out;

	//func
	parameter sll=6'b000000,srl=6'b000010,sra=6'b000011,sllv=6'b000100,srlv=6'b000110,srav=6'b000111,
		  jr=6'b001000,jalr=6'b001001,add=6'b100000,addu=6'b100001,sub=6'b100010,subu=6'b100011,And=6'b100100,Or=6'b100101,Xor=6'b100110,
		  Nor=6'b100111,slt=6'b101010,sltu=6'b101011;

	//alu_op
	parameter func_op=4'b0000,add_s=4'b0001,add_uns=4'b0010,slt_s=4'b0011,slt_uns=4'b0100,and_op=4'b0101,or_op=4'b0110,xor_op=4'b0111,lui_op=4'b1000;
	
	//alu_control_out
	parameter sll_alu=5'b00000,srl_alu=5'b00001,sra_alu=5'b00010,sllv_alu=5'b00011,srlv_alu=5'b00100,srav_alu=5'b00101,add_alu=5'b00110,addu_alu=5'b00111,
		  sub_alu=5'b01000,subu_alu=5'b01001,and_alu=5'b01010,or_alu=5'b01011,xor_alu=5'b01100,nor_alu=5'b01101,slt_alu=5'b01110,sltu_alu=5'b01111,
		  lui_alu=5'b10000,address=5'b10001;


	function [3:0] alu_control;
		input [5:0]func;
		input [3:0]alu_op;

		case(alu_op)
		
		func_op:begin
		     case(func)
		  	sll,srl,sra,sllv,srlv,srav,add,addu,sub,subu,And,Or,Xor,Nor,slt,sltu: control=14'b0000_0_01_00_0_0_10_0;
		  	jr:control=14'b0000_0_00_00_0_0_00_1;
		  	jalr:control=14'b0000_0_10_00_0_0_00_0;

		  	//the instruction isn't defined. maybe it is exception.
		     	default:control=14'b0000_0_00_00_0_0_00_0;
		     endcase
		     end

		bal:begin
		    case(rt_field)
		    	bgez,bltz:     control=14'b0001_0_00_00_0_0_00_1;
			bgezal,bltzal: control=14'b0001_0_10_00_0_0_00_0;

			//the instruction isn't defined. maybe it is exception.
		  	default:control=14'b0000_0_00_00_0_0_00_0;
		    endcase
		    end

		j,beq,bne,blez,bgtz: control=14'b0001_0_00_00_0_0_00_1;
		jal:   control=14'b0001_0_10_00_0_0_00_0;

		addi:  control=14'b0001_1_00_00_0_0_10_0;
		addiu: control=14'b0010_1_00_00_0_0_10_0;
		slti:  control=14'b0011_1_00_00_0_0_10_0;
		sltiu: control=14'b0100_1_00_00_0_0_10_0;
		andi:  control=14'b0101_1_00_00_0_0_10_0;
		ori:   control=14'b0110_1_00_00_0_0_10_0;
		xori:  control=14'b0111_1_00_00_0_0_10_0;
		lui:   control=14'b1000_1_00_00_0_0_10_0;

		lb,lbu:control=14'b0001_1_00_10_0_1_01_0;
		lh,lhu:control=14'b0001_1_00_01_0_1_01_0;
		lw:    control=14'b0001_1_00_00_0_1_01_0;

		sb:    control=14'b0001_1_00_10_1_0_00_1;
		sh:    control=14'b0001_1_00_01_1_0_00_1;
		sw:    control=14'b0001_1_00_00_1_0_00_1;

		//the instruction isn't defined. maybe it is exception.
		default:control=14'b0000_0_00_00_0_0_00_0;

		endcase
	endfunction

	assign control_out=control(op,func,rt_field);
endmodule
