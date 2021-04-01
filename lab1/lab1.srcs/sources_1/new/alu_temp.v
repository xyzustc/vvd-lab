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
    input [2:0] f,
    output reg [WIDTH-1:0] y_reg,
    output reg z_reg
);
//reg [WIDTH-1:0] y_reg;
//reg z_reg;

parameter f_plus = 3'b000;
parameter f_minus = 3'b001;
parameter f_and = 3'b010;
parameter f_or = 3'b011;
parameter f_xor = 3'b100;


always@(*) 
begin
    case(f)
        f_plus:     y_reg = a+b;
        f_minus:    y_reg = a-b;
        f_and:      y_reg = a&b;
        f_or:       y_reg = a|b;
        f_xor:      y_reg = a^b;
        default:    y_reg = 0;
    endcase
end


wire [WIDTH-1:0] y_wire;
assign y_wire = y_reg;
always@(*) 
begin
//    if(f<=3'b100)   z_reg = 0;
//    else            z_reg = 1;
//    case(y)
//        0:          z_reg = 0;
//        default:    z_reg = 1;
//    endcase
    if(y_wire==0)
        z_reg = 1;
    else
        z_reg = 0;
end

endmodule

