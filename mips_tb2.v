`timescale 1ns/1ns
`include "dmem/dmem.v"
`include "imem/imem.v"
module mips_tb2;

	reg clock;
	reg reset;
	wire [31:0] pcout;
	wire [31:0] inst;
	wire [4:0] waddrout;
	wire [31:0] wdout;
	wire [31:0] rd1;
	wire [31:0] rd2;
	wire [31:0] aluop2out;
	wire [31:0] aluout;
	wire [31:0] dmemout;
	
	wire [2:0] ALUCtr;
	wire RegDst;
	wire Jump;
	wire Branch;
	wire MemRead;
	wire MemtoReg;
	wire [1:0] ALUOp;
	wire MemWrite;
	wire ALUSrc;
	wire RegWrite;
	
	mips 		mips(.clock(clock), .reset(reset), .pcout(pcout), .inst(inst), .waddrout(waddrout), .wdout(wdout), .rd1(rd1), .rd2(rd2), .aluop2out(aluop2out), 
				.aluout(aluout), .dmemout(dmemout), .ALUCtr(ALUCtr), .RegDst(RegDst), .Jump(Jump), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), 
				.ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));
	imem 		imem 	(.addr(pcout), .inst(inst));
	dmem		dmem	(.addr(aluout), .rddata(dmemout), .wrdata(rd2), .MemRead(MemRead), .MemWrite(MemWrite), .clock(clock));

	initial begin
	`define R_TYPE 6'b000000
	`define LW 6'b100011
	`define SW 6'b101011
	`define BEQ 6'b000100
	`define J 6'b000010
	`define ADD_FUNCT 6'b100000
	`define SUB_FUNCT 6'b100010
	`define AND_FUNCT 6'b100100
	`define OR_FUNCT 6'b100101
	`define SLT_FUNCT 6'b101010

	// instruction codes labels instructions 
	imem.mcell['h0] ={`LW, 5'd0, 5'd1, 16'h0000}; //lw $1, 'h0000($0) ;
	imem.mcell['h4] ={`LW, 5'd0, 5'd2, 16'h0004}; //lw $2, 'h0004($0) ;
	imem.mcell['h8] ={`LW, 5'd0, 5'd3, 16'h0008}; //lw $3, 'h0008($0) ;
	imem.mcell['hc] ={`BEQ, 5'd2, 5'd5, 16'd3}; //beq $2, $5, 16'd12; (if $2 == $5, go to 'h1c)	
	imem.mcell['h10] ={`R_TYPE, 5'd1, 5'd4, 5'd4, 5'd0, `ADD_FUNCT}; //add $4, $1, $4;	
	imem.mcell['h14] ={`R_TYPE, 5'd3, 5'd5, 5'd5, 5'd0, `ADD_FUNCT}; //add $5, $3, $5;		
	imem.mcell['h18]={`J, 26'd3}; //j, 26'd3; (jump to 'hc) 
	imem.mcell['h1c]={`SW, 5'd0, 5'd4, 16'h000c}; //sw $4, 'h0020($0) ; 

	dmem.mcell['h0000]='d56;
	dmem.mcell['h0004]='d10;
	dmem.mcell['h0008]='d1;
	dmem.mcell['h000c]='h0;
	dmem.mcell['h0010]='h0;
	dmem.mcell['h0014]='h0;
	dmem.mcell['h0018]='h0;
	dmem.mcell['h001c]='h0;
	
	dmem.mcell['h0020]='h0;
	dmem.mcell['h0024]='h0;
	dmem.mcell['h0028]='h0;
	dmem.mcell['h002c]='h0;
	dmem.mcell['h0030]='h0;

	clock = 1'b0;
	reset = 1'b0;
	
	#5
	reset = 1'b1;
	
	#5
	reset = 1'b0;
	
	#2000
	$display("RESULT:");
	$display("56 * 10: 560: %d",dmem.mcell['h000c]); //last three digits of your ID * 10
	$finish;
	
	end
	always #20 clock=~clock;

endmodule


