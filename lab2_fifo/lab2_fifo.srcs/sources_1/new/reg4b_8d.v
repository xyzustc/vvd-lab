`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/13 10:59:51
// Design Name: 
// Module Name: reg4b_8d
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


module reg4b_8d#(parameter WIDTH=4)
    (
    input clk,
    input [2:0] ra0,
    output [WIDTH-1:0] rd0,
    input [2:0] ra1,
    output [WIDTH-1:0] rd1,
    input [2:0] wa,
    input we,
    input [WIDTH-1:0] wd
    );
    // 3 bits address, 8 regs 
reg [WIDTH-1:0] regfile[0:7];
assign rd0 = regfile[ra0];
assign rd1 = regfile[ra1];

always @(posedge clk)
begin
    if(we) regfile[wa] <= wd;
end
    
    
endmodule
