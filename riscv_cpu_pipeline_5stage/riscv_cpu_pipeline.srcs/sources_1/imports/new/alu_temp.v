`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/01 07:18:46
// Design Name: 
// Module Name: alu
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


module alu_temp#(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] a,b,
    input [2:0] op,
    output [WIDTH-1:0] out,
    output zero
);

parameter f_plus = 3'b000;
parameter f_minus = 3'b001;
parameter f_and = 3'b010;
parameter f_or = 3'b011;
parameter f_xor = 3'b100;

reg [WIDTH-1:0] out_a;
reg zero_a;

assign zero=zero_a;
assign out = out_a;

always@(*) 
begin
    case(op)
        f_plus:     out_a = a+b;
        f_minus:    out_a = a-b;
        f_and:      out_a = a&b;
        f_or:       out_a = a|b;
        f_xor:      out_a = a^b;
        default:    out_a = 0;
    endcase
end

always@(*) 
begin
    if(out_a==0)
        zero_a = 1;
    else
        zero_a = 0;
end

endmodule

