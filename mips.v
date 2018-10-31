module mips(clock, reset, pcout, inst, waddrout, wdout, rd1, rd2, aluop2out, aluout, dmemout, ALUCtr, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
	input [31:0] inst, dmemout;
	output [31:0] wdout, pcout, rd2, rd1, aluop2out, aluout;
	output [4:0] waddrout;
	output RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	output [2:0] ALUCtr;
	input clock, reset;
	output [1:0] ALUOp;
	wire aluzero, brandzero;
	wire [2:0] out2ALUfunc;
	wire [31:0] out2PC, out2mux, out1mux, plus4out, jaddr, mxout, sg1632out, out2ALUb, slout;
	wire [27:0] left2_28out;

mux2_32 mx32(.a(out1mux),
				 .b(jaddr),
				 .sel(Jump),
				 .out(mxout)
				 );
				 
reg32a PC(.in(mxout),
			 .clk(clock),
			 .rst(reset),
			 .out(pcout)
			 );
			
mux2_5 mx25(.a(inst[20:16]),
				.b(inst[15:11]),
				.sel(RegDst),
				.out(waddrout)
				);
				
ctr ctrop(.Op(inst[31:26]),
			 .RegDst(RegDst),
			 .Jump(Jump),
			 .Branch(Branch),
			 .MemRead(MemRead),
			 .MemtoReg(MemtoReg),
			 .ALUOp(ALUOp),
			 .MemWrite(MemWrite),
			 .ALUSrc(ALUSrc),
			 .RegWrite(RegWrite)
			 );
	
add32 plus4(.a(pcout),
			   .b(4),
			   .out(plus4out)
			   );
			   
left2_28 lf228(.in(inst[25:0]),
					.out(left2_28out)
					);
					
sign16_32 sgn1632(.in(inst[15:0]),
						.out(sg1632out)
						);
						
regfile32_32 Registers(.rdaddr1(inst[25:21]),
							  .rdaddr2(inst[20:16]),
							  .wraddr(waddrout),
							  .wrdata(wdout),
							  .clock(clock),
							  .reset(reset),
							  .RegWrite(RegWrite),
							  .rddata1(rd1),
							  .rddata2(rd2)
							  );
							  
mux2_32 mux232(.a(rd2),
					.b(sg1632out),
					.sel(ALUSrc),
					.out(aluop2out)
					);
					
aluctr ALUcountrol(.ALUOp(ALUOp),
						 .func(inst[5:0]),
						 .ALUctr(out2ALUfunc)
						 );
				  
alu ALU(.a(rd1),
		  .b(aluop2out),
		  .ALUctr(out2ALUfunc),
		  .out(aluout),
		  .zero(aluzero)
		  );
		  
mux2_32 muxdmem(.a(aluout),
					 .b(dmemout),
					 .sel(MemtoReg),
					 .out(wdout)
					 );
					 
left2_32 sl2(.in(sg1632out),
				 .out(slout)
				 );
				 
add32 add322mux(.a(plus4out),
					 .b(slout),
					 .out(out2mux)
					 );
					 
mux2_32 muxfromalu(.a(plus4out),
						 .b(out2mux),
						 .sel(brandzero),
						 .out(out1mux)
						 );
						 

assign jaddr = {plus4out[31:28], left2_28out};
assign brandzero = Branch & aluzero;

endmodule