//Moore
module state_machine(clk, rstn, x,push,state0,state1,state2,state3, z);
input clk, rstn,push;
input [13:0] x;
output [1:0]z;
output [41:0]state0;
output reg[41:0]state1,state2,state3;

	reg [1:0] ps, ns;
	parameter[1:0] s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
	
	assign state0 = 42'b111111111111111111111111111111111111111111;
	
	always@(push, ps)
		case(ps)
			s0: if(push)
					begin
					ns = s1;
					state1 <= {x[13:0],state0[27:0]};
					end
				 else  ns = s0;
			s1: if(push) 
					begin
					ns = s2;
					state2 <= {state1[41:28], x[13:0], state1[13:0]};
					end
				 else  ns = s0;
			s2: if(push) 
					begin
					ns = s3;
					state3 <= {state2[41:14],x[13:0]};
					end
				 else  ns = s0;
			s3: if(push) ns = s0;
				 else  ns = s0;
				 
				 default: ns = 2'bxx;
			endcase
			
		assign z = ps;
		
		always @(negedge rstn, posedge clk)
			if(rstn == 0)
				ps <= s0;
			else
				ps <= ns;
				
endmodule

//Moore state to seven segment
module mux4to1(z, display, s0,s1, s2, s3);
input [1:0] z;
input[41:0]s0,s1,s2,s3;
output [41:0]display;
reg [41:0]out;

	always@(z)
		case(z)
		
		2'b00: out = s0;
		2'b01: out = s1;
		2'b10: out = s2;
		2'b11: out = s3;
				 
		default: out = 42'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		endcase
		
	assign disp = 42'b111111011111101111110111111011111101111110;
	endmodule


//BCD to Seven Segment
module bcdto7(sw,push,seven);
input[7:0]sw;
input push;
output[13:0]seven;

reg[6:0]out0, out1;
wire[3:0]x0,x1;

	assign x0 = sw[3:0];
	assign x1 = sw[7:4];

always@(x0)
	case(x0)
	
	4'b0000: out0[6:0] = 0000001;
	4'b0001: out0[6:0] = 1001111;
	4'b0010: out0[6:0] = 0010010;
	4'b0011: out0[6:0] = 0000110;
	4'b0100: out0[6:0] = 1001100;
	4'b0101: out0[6:0] = 0100100;
	4'b0110: out0[6:0] = 0100000;
	4'b0111: out0[6:0] = 0001111;
	4'b1000: out0[6:0] = 0000000;
	4'b1001: out0[6:0] = 0001100;
	
	endcase
	
always@(x1)
	case(x1)
	
	4'b0000: out1[6:0] = 0000001;
	4'b0001: out1[6:0] = 1001111;
	4'b0010: out1[6:0] = 0010010;
	4'b0011: out1[6:0] = 0000110;
	4'b0100: out1[6:0] = 1001100;
	4'b0101: out1[6:0] = 0100100;
	4'b0110: out1[6:0] = 0100000;
	4'b0111: out1[6:0] = 0001111;
	4'b1000: out1[6:0] = 0000000;
	4'b1001: out1[6:0] = 0001100;
	
	endcase
	
assign seven = {out1[6:0],out0[6:0]};

endmodule

//Checks if the input password is correct
module lock(x,f);
input [41:0] x;
output [41:0]f;

reg [41:0]y;

always@(x)
	begin
	if(x == 42'b000111100000010001100000011000011000000110) y = 42'b100111110011111001111100111110011111001111;
	else y = 42'b111111011111101111110111111011111101111110;
	end

	assign f = y;
	
endmodule
