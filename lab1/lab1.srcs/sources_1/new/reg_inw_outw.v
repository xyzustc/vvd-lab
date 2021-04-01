`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/01 09:59:51
// Design Name: 
// Module Name: reg_inw_outw
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


module reg_inw_outw#(
    parameter inw = 6,
    parameter outw = 6
)(
    input clk,
    input en,
    input [inw-1:0] x,
    output reg [outw-1:0] x_out_reg
    
    );


//assign x_out = x_out_reg;
    
always@(posedge clk)
begin
    if(en)
        x_out_reg <= x;
end

    
endmodule
