`timescale              1 ns/1 ps
module SR(IE_c,s_u_c,
	 exception,rfe,rst,clk);
	input exception,rfe,rst,clk;
	output IE_c,s_u_c;
	
	reg [31:0]sr_reg;
	
	always @ (posedge clk or negedge rst)
	begin
/*
		case({rst,exception,rfe}) //reset is active low
			//suspend
			3'b100:
			begin
			sr_reg<=sr_reg;
			end
			//rfe
			3'b101:
			begin
			sr_reg[30:28]<=3'b000;
			sr_reg[26:24]<=sr_reg[30:28];
			sr_reg[3:2]<=2'b00;
			sr_reg[1]<=sr_reg[3];
			sr_reg[0]<=sr_reg[2];
			end

			//exception
			3'b010,3'b011,3'b110,3'b111:
			begin	
			sr_reg[30:28]<=sr_reg[26:24];
			sr_reg[26:24]<=sr_reg[26:24];
			sr_reg[3]<=sr_reg[1];
			sr_reg[2]<=sr_reg[0];
			sr_reg[1:0]<=2'b00;
			end

			//reset
			3'b000,3'b001:
			begin
			sr_reg<=32'b0000_0000_0000_0000_0000_0000_0000_0011;   
			end

			default:
			begin
			sr_reg<=32'b0000_0000_0000_0000_0000_0000_0000_0011;   
			end
		endcase
*/
		if(rst==0)
			sr_reg<=32'b0000_0000_0000_0000_0000_0000_0000_1100; 
		else if(exception==1)
			begin	
			sr_reg[30:28]<=sr_reg[26:24];
			sr_reg[26:24]<=sr_reg[26:24];
			sr_reg[3]<=sr_reg[1];
			sr_reg[2]<=sr_reg[0];
			sr_reg[1:0]<=2'b00;
			end
		else if(rfe==1)
			begin
			sr_reg[30:28]<=3'b000;
			sr_reg[26:24]<=sr_reg[30:28];
			sr_reg[3:2]<=2'b00;
			sr_reg[1]<=sr_reg[3];
			sr_reg[0]<=sr_reg[2];
			end
		else 
		sr_reg<=sr_reg;
	end
	assign IE_c=(rst)? sr_reg[1]:1;
	assign s_u_c=sr_reg[0];
endmodule
