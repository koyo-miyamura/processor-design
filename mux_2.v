module mux_2(out,a,b,sel);
	output out;
	input a,b,sel;
	wire out,a,b,sel;
	assign out=sel?b:a;
endmodule

