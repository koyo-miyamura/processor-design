module hazard(pc_write,if_id_write,control_dst,
	if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst, id_ex_memread, ex_mem_memread,id_ex_regwrite);

	input [4:0]if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst;
	input id_ex_memread, ex_mem_memread, id_ex_regwrite;
	output pc_write,if_id_write,control_dst;

	function [2:0] hazard;
		input [4:0]if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst;
		input id_ex_memread, ex_mem_memread, id_ex_regwrite;
/*
		integer lw_beq,lw_beq2,add_beq;

		lw_beq=((id_ex_memread)  && ( (id_ex_dst==if_id_rt) || (id_ex_dst==if_id_rs) ));
		lw_beq2=((ex_mem_memread)  && ( (ex_mem_dst==if_id_rt) || (ex_mem_dst==if_id_rs) ));
		add_beq= ((id_ex_regwrite==0)  && ( (id_ex_dst==if_id_rt) || (id_ex_dst==if_id_rs) ));
*/
		if(        (( (id_ex_memread)      && ( (id_ex_dst==if_id_rt)  || (id_ex_dst==if_id_rs)  ) ))
	        	|| (( (ex_mem_memread)     && ( (ex_mem_dst==if_id_rt) || (ex_mem_dst==if_id_rs) ) )) 
			|| (( (id_ex_regwrite==0)  && ( (id_ex_dst==if_id_rt)  || (id_ex_dst==if_id_rs)  ) ))
		) 	
		begin
			hazard=3'b000;
		end

		else
		begin
			hazard=3'b111;
		end
	endfunction

	assign {pc_write,if_id_write,control_dst}=hazard(if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst, id_ex_memread, ex_mem_memread, id_ex_regwrite);

endmodule
