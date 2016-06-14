`timescale              1 ns/1 ps

module top(DAD,MREQ,WRITE,SIZE,IAD,
	   DDT,ACKD_n,IDT,ACKI_n,rst,OINT_n,IACK_n,clk);
	
	input[31:0] IDT;
	input[2:0]  OINT_n;
	input ACKD_n,ACKI_n,rst,clk;

	output [31:0]DAD,IAD;
	output [1:0]SIZE;
	output MREQ,WRITE,IACK_n;

	inout[31:0] DDT;

	//if_stage
	wire [31:0] beq, jr, pc_4_out_if;
	wire [27:0] offset28;
	wire [4:0]  vector_if_out;
	wire [3:0]  pc_4_id;
	wire [1:0]  pc_src;
	wire pc_write;

	//if_id_reg
	wire [31:0] ins,pc_4_in_id;
	wire [4:0]  vector_id_in;
	wire if_flush,if_id_write;

	//id_stage
	wire [31:0]data1_out,data2_out,pc_4_out_id,offset_id,data_to_reg,ex_mem_data;
	wire [14:0]control_id;
	wire [4:0]rs_field_id,rt_field_id,rd_field_id,rd_add,vector_id_out;
	wire regwrite,forward_c,forward_d,control_sel;

	//id_ex_reg
	wire [31:0]pc_4_in_ex,data1_in,data2_in,offset_ex;
	wire [14:0]control_in_ex;
	wire [4:0]id_ex_rs,id_ex_rt,id_ex_rd,vector_ex_in;
	wire id_flush;

	//ex_stage
	wire [31:0]rt_out_ex,alu_data_ex,wb_data,pc_out_ex;
	wire [7:0]control_out_ex;
	wire [4:0]regdst_out_ex,vector_ex_out;
	wire [1:0]forward_a,forward_b;

	//ex_mem_reg
	wire [31:0]alu_in_mem,sw_in_mem,pc_in_mem;
	wire [7:0]control_in_mem;
	wire [4:0]regdst_in_mem,vector_mem_in;
	wire ex_flush;

	//mem_stage
	wire [31:0]data_write_out_mem,data_out_mem,load_data,store_data;
	wire [4:0]regdst_out_mem,vector_mem_out;
	wire [1:0]control_out_mem;
	wire mem_read,forward_e,rfe;

	//mem_wb_reg
	wire [31:0] data_in_wb,alu_in_wb;
	wire [4:0] regdst_in_wb;
	wire [1:0] control_in_wb;

	//IAR
	wire [31:0] IAR_pc;
	wire oint_ex;
	wire trap;

	//SR
	wire IE_c,s_u_c;

	//Exception
	wire [4:0]vector;
	wire exception;

	if_stage if_stage(.pc_4_out(pc_4_out_if), .pc_out(IAD), .vector_if(vector_if_out),
		.beq(beq), .jr(jr), .pc_4_id(pc_4_id), .offset28(offset28), .pc_write(pc_write), .pc_src(pc_src), .rfe(rfe), .exception(exception), .vector_no_3(vector), .IAR_pc(IAR_pc), .s_u(s_u_c),
		.clk(clk));

	assign pc_4_id=pc_4_in_id[31:28];
	assign if_flush=(exception||rfe);

	if_id_reg if_id_reg(.ins_out(ins), .pc_4_out(pc_4_in_id), .vector_if_out(vector_id_in),
		  .pc_4_in(pc_4_out_if), .ins_in(IDT), .if_flush(if_flush), .if_id_write(if_id_write), .vector_if_in(vector_if_out),
		  .reset(rst), .clk(clk));

	wire[5:0]op,func;   
	assign op=ins[31:26];
	assign func=ins[5:0];

	id_stage id_stage(.data1_out(data1_out), .data2_out(data2_out), .pc_4_out(pc_4_out_id), .control(control_id), .offset(offset_id), .rs_field(rs_field_id), .rt_field(rt_field_id), .rd_field(rd_field_id), .branch(beq), .rs(jr), .pc_src(pc_src), .offset28(offset28), .vector_id(vector_id_out),
		 .pc_4_in(pc_4_in_id), .ins(ins), .rd_add(rd_add), .data(data_to_reg), .reg_write(regwrite), .control_sel(control_sel), .forward_c(forward_c), .forward_d(forward_d), .ex_mem_data(ex_mem_data), .vector_if(vector_id_in), .s_u(s_u_c),
		 .reset(rst), .clk(clk));

	assign id_flush=(exception||rfe);

	id_ex_reg id_ex_reg(.control_out(control_in_ex), .pc_4_out(pc_4_in_ex), .rs_out(data1_in), .rt_out(data2_in), .offset_out(offset_ex), .id_ex_rs(id_ex_rs), .id_ex_rt(id_ex_rt), .id_ex_rd(id_ex_rd), .vector_id_out(vector_ex_in),
		 .control_in(control_id), .pc_4_in(pc_4_out_id), .rs_in(data1_out), .rt_in(data2_out), .offset_in(offset_id), .if_id_rs(rs_field_id), .if_id_rt(rt_field_id), .if_id_rd(rd_field_id), .vector_id_in(vector_id_out),
		.id_flush(id_flush), .reset(rst), .clk(clk));

	wire id_ex_memread,id_ex_regwrite;
	assign id_ex_memread=control_in_ex[3];
	assign id_ex_regwrite=control_in_ex[0];
	
	ex_stage ex_stage(.regdst_out(regdst_out_ex), .rt_out(rt_out_ex), .alu_data(alu_data_ex), .control_out(control_out_ex), .vector_ex(vector_ex_out), .pc_out(pc_out_ex),
		.control_in(control_in_ex), .pc_in(pc_4_in_ex), .data1(data1_in), .data2(data2_in), .offset(offset_ex), .rt_field(id_ex_rt), .rd_field(id_ex_rd), .wb_data(wb_data), .ex_mem_data(ex_mem_data), .forward_a(forward_a), .forward_b(forward_b), .vector_id(vector_ex_in));

	assign ex_flush=(exception||rfe);

	ex_mem_reg ex_mem_reg(.control_out(control_in_mem), .alu_out(alu_in_mem), .sw_out(sw_in_mem), .regdst_out(regdst_in_mem), .vector_ex_out(vector_mem_in), .pc_out(pc_in_mem),
		.control_in(control_out_ex), .alu_in(alu_data_ex), .sw_in(rt_out_ex), .regdst_in(regdst_out_ex), .vector_ex_in(vector_ex_out), .pc_in(pc_out_ex),
		.ex_flush(ex_flush), .reset(rst), .clk(clk));

	assign ex_mem_data=alu_in_mem;

	wire ex_mem_memread,ex_mem_regwrite;
	assign ex_mem_memread=control_in_mem[3];
	assign ex_mem_regwrite=control_in_mem[0];

	//for Interrupt load store test
	wire mem_write;

	mem_stage mem_stage(.address_out(DAD), .data_write_out(store_data), .data_out(data_out_mem), .size(SIZE), .mem_write(mem_write), .mem_read(mem_read), .control_out(control_out_mem), .regdst_out(regdst_out_mem), .rfe(rfe), .vector_mem(vector_mem_out),
		  .address_in(alu_in_mem), .data_write_in(sw_in_mem), .data_mem(load_data), .control_in(control_in_mem), .regdst_in(regdst_in_mem), .wb_data(wb_data), .forward_e(forward_e), .vector_ex(vector_mem_in), .s_u(s_u_c) );
	//for Interrupt load store test		
	assign WRITE=((vector==5'b01011)||(vector==5'b01001))? 0:mem_write;
	assign MREQ=((vector==5'b01011)||(vector==5'b01001))? 0:(WRITE|mem_read);


	assign load_data=DDT;
	assign DDT=(WRITE)? store_data:32'bz;

	mem_wb_reg mem_wb_reg(.control_out(control_in_wb), .data_out(data_in_wb), .alu_out(alu_in_wb), .regdst_out(regdst_in_wb),
		.control_in(control_out_mem), .data_in(data_out_mem), .alu_in(DAD), .regdst_in(regdst_out_mem),
		.mem_flush(exception), .reset(rst), .clk(clk));

	wb_stage wb_stage(.reg_write(regwrite), .data_to_reg(data_to_reg), .regdst_out(rd_add),
		.control_in(control_in_wb), .data_mem(data_in_wb), .data_alu(alu_in_wb), .regdst_in(regdst_in_wb));

	assign wb_data=data_to_reg;

	hazard hazard(.pc_write(pc_write), .if_id_write(if_id_write), .control_dst(control_sel),
	      .op(op), .func(func), .if_id_rs(rs_field_id), .if_id_rt(rt_field_id), .id_ex_dst(regdst_out_ex), .ex_mem_dst(regdst_out_mem), .id_ex_memread(id_ex_memread), .ex_mem_memread(ex_mem_memread), .id_ex_regwrite(id_ex_regwrite));

	forward forward(.a(forward_a), .b(forward_b), .c(forward_c), .d(forward_d), .e(forward_e),
	      .if_id_rs(rs_field_id), .if_id_rt(rt_field_id), .id_ex_rs(id_ex_rs), .id_ex_rt(id_ex_rt), .ex_mem_dst(regdst_in_mem), .mem_wb_dst(rd_add), .ex_mem_regwrite(ex_mem_regwrite), .mem_wb_regwrite(regwrite));

	wire overflow;
	assign overflow=(vector==5'b01100)? 1:0;

	IAR IAR(.pc_out(IAR_pc),
	        .memwrite(WRITE), .oint_ex(oint_ex), .exception(exception), .pc_8_in(pc_in_mem), .reset(rst), .trap(trap), .overflow(overflow), 
		.clk(clk));

	SR  SR(.IE_c(IE_c), .s_u_c(s_u_c),
	       .exception(exception), .rfe(rfe), .rst(rst), .clk(clk));

	assign oint_ex=~IACK_n;
	assign trap=((vector<=5'b10111)&&(vector>=5'b10000))? 1:0;

	Exception Exception(.exception(exception), .vector(vector), .IACK(IACK_n),
	                    .IE_c(IE_c), .vector_mem(vector_mem_out), .rst(rst), .OINT(OINT_n));

endmodule
