`timescale              1 ns/1 ps
module branch_pre(predict,
	      Iadd,Badd,Idata,Bdata,result,if_id_write,clk);
	input [31:0]Iadd,Badd,Idata,Bdata;
	input result,if_id_write,clk;
	output predict;

	parameter bal=6'b000001,bs=4'b0001;
	parameter WIDTH=2;
	parameter ENTRY=4096;
	parameter ADDRESS=12;
	parameter Initial=2'b01;

	reg  [WIDTH-1:0]  ram [ENTRY-1:0];
	reg  [31:0]       corect_counter;
	reg  [31:0]	  branch_counter;
	wire [ADDRESS-1:0]I_index=Iadd[ADDRESS+1:2];
	wire [ADDRESS-1:0]B_index=Badd[ADDRESS+1:2];
	
	wire I_branch_check=(Idata[31:26]==bal)||(Idata[31:28]==bs);
	wire B_branch_check=(Bdata[31:26]==bal)||(Bdata[31:28]==bs);


	//読み出し
	assign predict=(I_branch_check==0)?                           1'bz:
		       ( (ram[I_index]==2'b11)||(ram[I_index]==2'b10) )? 1:0;

        //更新
	always @(posedge clk)
	begin

		//counter
		//if((B_branch_check==0)||(Badd==32'h00010044))
		if((B_branch_check==0)||(if_id_write==0))
		begin
			corect_counter=corect_counter;
		end
		//else if(result==predict)
		else if( ( (result==1)&& ((ram[B_index]==2'b11)||(ram[B_index]==2'b10)) )||( (result==0)&& ((ram[B_index]==2'b01)||(ram[B_index]==2'b00)) ) )
		begin
			corect_counter=corect_counter+1;
		end
		else 
		begin
			corect_counter=corect_counter;
		end

		if((B_branch_check==0)||(if_id_write==0))
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

		if(I_branch_check==1)
		begin
			branch_counter=branch_counter+1;
		end
		else
		begin
			branch_counter=branch_counter;
		end
	end

	integer i;
        initial begin
	corect_counter=0;
	branch_counter=0;
        for(i=0;i<ENTRY;i=i+1)
            ram[i]=Initial;
	end
endmodule
