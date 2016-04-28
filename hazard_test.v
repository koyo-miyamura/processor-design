module hazard_test;
	reg [4:0]if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst;
	reg id_ex_memread, ex_mem_memread, id_ex_regwrite;
	wire pc_write,if_id_write,control_dst;

	hazard unit1(pc_write,if_id_write,control_dst,
	if_id_rs, if_id_rt, id_ex_dst, ex_mem_dst, id_ex_memread, ex_mem_memread,id_ex_regwrite);


	initial
	begin
		id_ex_memread=1;
		id_ex_dst=12;
		if_id_rt=12;
		#10
		id_ex_memread=0;
		#10
		#10
		#10
		$finish;
	end
	initial
	$monitor($stime,,"pc_write=%b if_id_write=%b control_dst=%b",pc_write,if_id_write,control_dst);
endmodule
