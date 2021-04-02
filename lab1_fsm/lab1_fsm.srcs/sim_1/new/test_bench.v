`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/02 11:51:54
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
reg rst;
wire [1:0] out;
wire en_wire;
integer i;
    
    
initial begin
    clk = 0;
    forever
    #5 clk = ~clk;
end

fsm test(clk,en,rst,out,en_wire);

initial begin
    #102
    en = 0;
    forever
    #100 en = ~en;
end

initial begin
    rst = 0;
    forever
    begin
    #500 rst = ~rst;
//    #100 rst = ~rst;
//    #100 rst = ~rst;
//    #100 rst = ~rst;
    end
end

//initial begin
//    #1;
//    for(i=20;i<50;i=i+1)
//    begin
//        en = 1; #i;
//        en = 0; #i;
//    end
//end



endmodule
