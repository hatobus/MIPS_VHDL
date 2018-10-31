module mux2_5(a, b, sel, out);
	input [4:0] a, b;
	input sel;
	output reg [4:0] out;
	
	always @(a or b or sel)
		out = (sel == 0) ? a : b;
endmodule