`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 11:10:14
// Design Name: 
// Module Name: RegFile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegFile#(parameter WIDTH=32)
    (
    input clk,
    input [4:0] ra0,
    output [WIDTH-1:0] rd0,
    input [4:0] ra1,
    output [WIDTH-1:0] rd1,
    input [4:0] ra_debug,
    output [WIDTH-1:0] rd_debug,
    input [4:0] wa,
    input we,
    input [WIDTH-1:0] wd
    );
    // 5 bits address, 32 regs 
reg [WIDTH-1:0] regfile[0:31];

integer i;
initial begin
		for(i=0; i <32; i = i+1) begin
			regfile[i] = {WIDTH{0}};
		end
end

reg [WIDTH-1:0]rd0_r,rd1_r;
always @(*) begin
    if(ra0==5'b00000)
        rd0_r = {WIDTH{0}};
    else if(ra0==wa)
        rd0_r = wd;
    else
        rd0_r = regfile[ra0];
end
always @(*) begin
    if(ra1==5'b00000)
        rd1_r = {WIDTH{0}};
    else if(ra1==wa)
        rd1_r = wd;
    else
        rd1_r = regfile[ra1];
end
assign rd0      = rd0_r;
assign rd1      = rd1_r;

assign rd_debug = regfile[ra_debug];
reg zero_addres;

always @(*) begin
    if(wa==5'b00000)
        zero_addres = 1;
    else
        zero_addres = 0;
end

always @(posedge clk)
begin
    if(we&~zero_addres) regfile[wa] <= wd;
    else if(we&zero_addres) regfile[wa] <= {WIDTH{0}};
end
    
    
endmodule
