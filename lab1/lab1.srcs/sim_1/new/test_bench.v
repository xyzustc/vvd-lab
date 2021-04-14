`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/01 10:40:08
// Design Name: 
// Module Name: test_bench
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


module test_bench(

    );
reg clk;
reg en;
reg [1:0] sel;
reg [5:0] x;
wire z;
wire [5:0] y;
integer i;

alu_6 alu_ins
(   
    clk,en,
    sel,x,z,y
);
    
    
    
initial begin
    clk = 0;
    forever
    #5 clk = ~clk;
end

initial begin
    x = 6'b000000;
    sel = 2'b00;
    #20;
    en = 1;
    #100;
    en = 0;
    x = 6'b000010;
    sel = 2'b01;
    #20;
    en = 1;
    #100;
    en = 0;
    x = 6'b000001;
    sel = 2'b10;
    #20;
    en = 1;
    #100;
    en = 0;
end


endmodule


