module add32(a, b, out);
	input [31:0] a, b;
	output reg [31:0] out;
	
	always @(a or b)
	begin
		out <= a + b;
	end
	
endmodule