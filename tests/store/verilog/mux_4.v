`timescale              1 ns/1 ps
module mux_4(out,a,b,c,d,sel);
	input [31:0]a,b,c,d;
	input [1:0] sel;
	output [31:0]out;
	reg [31:0]out;
	always @ (a or b or c or d or sel)
	begin
		case(sel)
			2'b00: out<=a;
			2'b01: out<=b;
			2'b10: out<=c;
			2'b11: out<=d;
		endcase
	end
endmodule
