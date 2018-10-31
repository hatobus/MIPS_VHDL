module mux2_32(a, b, sel, out);
	input [31:0] a, b;
	input sel;
	output reg [31:0] out;
	
	always @(a or b or sel)
		out = (sel == 0) ? a : b;
		
endmodule