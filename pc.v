module pc(out,beq,jr,pc_4_if,pc_4_id,offset28,pc_write,pc_src,clk);
	input [31:0]beq,jr,pc_4_if;
	input [27:0]offset28;
	input [3:0]pc_4_id;
	input pc_write,clk;
	input [1:0]pc_src;
	output [31:0]out;
	
	reg [31:0]out;
	
	always @ (posedge clk)
	begin
		case({pc_write,pc_src})
			3'b100: out<=pc_4_if+3'b100;
			3'b101: out<={pc_4_id,offset28};
			3'b110: out<=beq;
			3'b111: out<=jr;
		endcase
	end
endmodule
