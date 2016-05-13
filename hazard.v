`timescale              1 ns/1 ps
module hazard(pc_write,if_id_write,control_dst,
	op,func,if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst, id_ex_memread, ex_mem_memread,id_ex_regwrite);

	input [5:0]op,func;
	input [4:0]if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst;
	input id_ex_memread, ex_mem_memread, id_ex_regwrite;
	output pc_write,if_id_write,control_dst;

	parameter beq_bne=5'b00010,beq_bne_blez_bgtz=4'b0001,bal=6'b000001,jr_jalr=9'b000000_001; 

	function [2:0] hazard;
		input [5:0]op,func;
		input [4:0]if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst;
		input id_ex_memread, ex_mem_memread, id_ex_regwrite;
/*
		integer lw_beq,lw_beq2,add_beq;

		lw_beq=((id_ex_memread)  && ( (id_ex_dst==if_id_rt) || (id_ex_dst==if_id_rs) ));
		lw_beq2=((ex_mem_memread)  && ( (ex_mem_dst==if_id_rt) || (ex_mem_dst==if_id_rs) ));
		add_beq= ((id_ex_regwrite==0)  && ( (id_ex_dst==if_id_rt) || (id_ex_dst==if_id_rs) ));
*/
		if(        (( (id_ex_memread)      && ( (id_ex_dst==if_id_rt)  || (id_ex_dst==if_id_rs)  ) ))
	        	|| (  (ex_mem_memread)     && (ex_mem_dst==if_id_rt)   && (op[5:1]==beq_bne) )
			|| (  (ex_mem_memread)     && (ex_mem_dst==if_id_rs)   && ( (op==bal)  ||  (op[5:2]==beq_bne_blez_bgtz)  ||  ({op,func[5:3]}==jr_jalr) ) )
			|| (  (id_ex_regwrite==0)  && (id_ex_dst==if_id_rt)    &&(id_ex_dst!=0)  && (op[5:1]==beq_bne) )
			|| (  (id_ex_regwrite==0)  && (id_ex_dst==if_id_rs)    &&(id_ex_dst!=0)   && ( (op==bal)  ||  (op[5:2]==beq_bne_blez_bgtz)  ||  ({op,func[5:3]}==jr_jalr) ) )
		) 	
		begin
			hazard=3'b000;
		end

		else
		begin
			hazard=3'b111;
		end
	endfunction

	assign {pc_write,if_id_write,control_dst}=hazard(op, func, if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst, id_ex_memread, ex_mem_memread, id_ex_regwrite);

endmodule
