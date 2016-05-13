`timescale              1 ns/1 ps
module forward(a,b,c,d,e,
	if_id_rs, if_id_rt, id_ex_rs, id_ex_rt, ex_mem_dst, mem_wb_dst, ex_mem_regwrite, mem_wb_regwrite);

	input [4:0]if_id_rs, if_id_rt, id_ex_rs, id_ex_rt, ex_mem_dst, mem_wb_dst;
	input ex_mem_regwrite, mem_wb_regwrite;
	output [1:0]a,b;
	output c,d,e;

	function [1:0] forward_a;
		input [4:0]id_ex_rs, ex_mem_dst, mem_wb_dst;
		input ex_mem_regwrite, mem_wb_regwrite;

		if( (ex_mem_regwrite==0)&&(ex_mem_dst!=0)&&(ex_mem_dst==id_ex_rs) )
		begin
			forward_a=2'b10;
		end

		else if( (mem_wb_regwrite==0)&&(mem_wb_dst!=0)&&(mem_wb_dst==id_ex_rs) )
		begin
			forward_a=2'b01;
		end

		else
		begin
			forward_a=2'b00;
		end
	endfunction

	function [1:0] forward_b;
		input [4:0]id_ex_rt, ex_mem_dst, mem_wb_dst;
		input ex_mem_regwrite, mem_wb_regwrite;

		if( (ex_mem_regwrite==0)&&(ex_mem_dst!=0)&&(ex_mem_dst==id_ex_rt) )
		begin
			forward_b=2'b10;
		end

		else if( (mem_wb_regwrite==0)&&(mem_wb_dst!=0)&&(mem_wb_dst==id_ex_rt) )
		begin
			forward_b=2'b01;
		end

		else
		begin
			forward_b=2'b00;
		end
	endfunction

	function forward_c;
		input [4:0]if_id_rs,ex_mem_dst;
		input ex_mem_regwrite;

		if( (ex_mem_regwrite==0)&&(ex_mem_dst!=0)&&(ex_mem_dst==if_id_rs) )
		begin
			forward_c=1'b1;
		end

		else
		begin
			forward_c=1'b0;
		end
	endfunction

	function forward_d;
		input [4:0]if_id_rt,ex_mem_dst;
		input ex_mem_regwrite;

		if( (ex_mem_regwrite==0)&&(ex_mem_dst!=0)&&(ex_mem_dst==if_id_rt) )
		begin
			forward_d=1'b1;
		end

		else
		begin
			forward_d=1'b0;
		end
	endfunction

	function forward_e;
		input [4:0]ex_mem_dst,mem_wb_dst;
		input mem_wb_regwrite;

		if( (mem_wb_regwrite==0)&&(mem_wb_dst!=0)&&(mem_wb_dst==ex_mem_dst) )
		begin
			forward_e=1'b1;
		end

		else
		begin
			forward_e=1'b0;
		end
	endfunction

	assign a=forward_a(id_ex_rs, ex_mem_dst, mem_wb_dst, ex_mem_regwrite, mem_wb_regwrite);
	assign b=forward_b(id_ex_rt, ex_mem_dst, mem_wb_dst, ex_mem_regwrite, mem_wb_regwrite);
	assign c=forward_c(if_id_rs, ex_mem_dst, ex_mem_regwrite);
	assign d=forward_d(if_id_rt, ex_mem_dst, ex_mem_regwrite);
	assign e=forward_e(ex_mem_dst, mem_wb_dst, mem_wb_regwrite);
endmodule
