module reg32a(in, clk, rst, out);
	input [31:0] in;
	input clk, rst;
	output reg [31:0] out;
	
	always @(posedge rst or posedge clk)
		begin
		
			out = (rst == 1)? 0 : out;
			
			if(clk==1) 
				if(rst == 0)
					out = in;
				
		end
		
endmodule
			
		