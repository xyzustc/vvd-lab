`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/01 09:42:08
// Design Name: 
// Module Name: alu_6
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


module alu_6(
    input clk,
    input en,
//    input [7:0] sw,
    input [1:0] sel,
    input [5:0] x,
//    output reg [6:0] led
    output reg z,
    output reg [5:0] y
    );

reg ef,ea,eb;
always@(*)
begin
    if(en)
    begin
        case(sel)
            2'b00: begin ef = en;ea = 0;eb = 0; end
            2'b01: begin ef = 0;ea = en;eb = 0; end
            2'b10: begin ef = 0;ea = 0;eb = en; end
            default: begin ef = 0;ea = 0;eb = 0; end
        endcase
    end
    else begin ef = 0;ea = 0;eb = 0; end
end

//reg en_reg;
//reg [1:0] sel_reg;
//always@(*)
//begin
//    en_reg = en;
//    sel_reg = sel;
//end

reg [5:0] x_reg;
always@(*)
begin
    x_reg = x;
end
wire [5:0] f;
wire [5:0] a;
wire [5:0] b;
reg_inw_outw reg_F(
    .clk(clk),
    .en(ef),
    .x(x_reg),
    .x_out_reg(f)
    );
    
reg_inw_outw reg_A(
    .clk(clk),
    .en(ea),
    .x(x_reg),
    .x_out_reg(a)
    );
    
reg_inw_outw reg_B(
    .clk(clk),
    .en(eb),
    .x(x_reg),
    .x_out_reg(b)
    );

reg [2:0] f_reg;
reg [5:0] a_reg;
reg [5:0] b_reg;
always@(*)
begin
    f_reg = f[2:0];
    a_reg = a;
    b_reg = b;
end
wire [5:0] alu_y;
wire alu_z;
alu_temp #(6)alu_ins6(
    .a(a_reg),
    .b(b_reg),
    .f(f_reg),    
    .y_reg(alu_y),
    .z_reg(alu_z)
    );


wire cons_1;
assign cons_1 = 1;

reg alu_z_reg;
reg [5:0] alu_y_reg;
always@(*)
begin
    alu_z_reg = alu_z;
    alu_y_reg = alu_y;
end
wire z_wire;
wire [5:0] y_wire;
reg_inw_outw reg_Y(
    .clk(clk),
    .en(cons_1),
    .x(alu_y_reg),
    .x_out_reg(y_wire)
    );
    
reg_inw_outw #(1,1) reg_Z(
    .clk(clk),
    .en(cons_1),
    .x(alu_z_reg),
    .x_out_reg(z_wire)// map to led[7]
    );
    
always@(*)
begin
    y = y_wire;
    z = z_wire;
end
    
    
endmodule
