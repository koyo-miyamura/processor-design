`timescale              1 ns/1 ps
module branch_pre(predict,
	      Iadd,Badd,Idata,Bdata,result);
	input [31:0]Iadd,Badd,Idata,Bdata;
	input result;
	output predict;

	parameter bal=6'b000001,bs=4'b0001;
	parameter WIDTH=2;
	parameter ENTRY=1024;
	parameter ADDRESS=10;
	parameter Initial=2'b01;

	reg  [WIDTH-1:0]  ram [ENTRY-1:0];
	reg  [31:0]       corect_counter;
	wire [ADDRESS-1:0]I_index=Iadd[ADDRESS+1:2];
	wire [ADDRESS-1:0]B_index=Badd[ADDRESS+1:2];
	
	wire I_branch_check=(Idata[31:26]==bal)||(Idata[31:28]==bs);
	wire B_branch_check=(Bdata[31:26]==bal)||(Bdata[31:28]==bs);


	//読み出し
	assign predict=(I_branch_check==0)?                           1'bz:
		       ( (ram[I_index]==2'b11)||(ram[I_index]==2'b10) )? 1:0;

        //更新
	always @(result)
	begin
		if(B_branch_check==0)
		begin
			ram[B_index]<=ram[B_index];
		end
		else if( ((result==1)&&(ram[B_index]==2'b11)) || ((result==0)&&(ram[B_index]==2'b00)))
		begin
			ram[B_index]<=ram[B_index];
		end
		else if(result==1)
		begin
			ram[B_index]<=ram[B_index]+1;
		end
		else
		begin
			ram[B_index]<=ram[B_index]-1;
		end

		//counter
		//if((B_branch_check==0)||(Badd==32'h00010044))
		if(B_branch_check==0)
		begin
			corect_counter=corect_counter;
		end
		else if( ( (result==1)&& ((ram[B_index]==2'b11)||(ram[B_index]==2'b10)) )||( (result==0)&& ((ram[B_index]==2'b01)||(ram[B_index]==2'b00)) ) )
		begin
			corect_counter=corect_counter+1;
		end
		else 
		begin
			corect_counter=corect_counter;
		end
	end

	integer i;
        initial begin
	corect_counter=0;
        for(i=0;i<ENTRY;i=i+1)
            ram[i]=Initial;
	end
endmodule
