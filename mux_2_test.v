module mux_2_test;
	reg in1,in2,Sel;
	wire out;
	
	mux_2 m1(.a(in1),.b(in2),.sel(Sel),.out(out));
	 initial
	  begin
          in1 = 1'b0; in2 = 1'b0; Sel = 1'b0;
       #5 in1 = 1'b1;
       #5 in1 = 1'b0; in2 = 1'b1;
       #5 in1 = 1'b1;
       #5 in1 = 1'b0; in2 = 1'b0; Sel = 1'b1;
       #5 in1 = 1'b1;
       #5 in1 = 1'b0; in2 = 1'b1;
       #5 in1 = 1'b1;
       #5 $finish;
    end 
  initial
    $monitor($stime,,"in1=%b in2=%b Sel=%b out=%b", in1, in2, Sel, out);
endmodule 
