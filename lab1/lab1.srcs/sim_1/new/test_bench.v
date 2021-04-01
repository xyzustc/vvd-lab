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
reg [5:0] x;
wire [5:0] x_out;
integer i;


    
    
    
initial begin
    clk = 0;
    forever
    #5 clk = ~clk;
end

initial begin
    en = 1;
//    #100 en = 0;
end

initial begin
    #1;
    for(i=0;i<10000;i=i+1)
    begin
        x = i%64; #5;
    end
end


endmodule


