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
reg [6:0] d;
reg rst;
wire [6:0] f;
    
    
initial begin
    clk = 0;
    forever
    #5 clk = ~clk;
end

initial begin
    rst = 1;
    #10;
    rst = 0;
end

fsm fsm_ins(clk,en,d,rst,f);

initial begin
    en=0;
    d = 6'b0000001;
    #200;
    en = 1;
    #200;
    en = 0;
    #100;
    d = 6'b0000010;
    #200;
    en = 1;
    #200;
    en = ~en;
    #200;
    en = ~en;
    #200;
    en = ~en;
    #200;
    en = ~en;
    #200;
    en = ~en;
    #200;
    en = ~en;
    #200;
    en = ~en;
    #200;
    en = ~en;
    #200;
    en = ~en;
    #200;
    en = ~en;
    #200;
    en = ~en;
end


endmodule
