`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 11:25:16
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
// put 4'b0101 at 4'x2222
// put 4'b1010 at 4'x3333
// put 4'b1111 at 4'xffff
//read 4'x2222, read 4'x3333, read 4'xffff

module test_bench(

    );
    
parameter w=4;

reg clk;
reg [w-1:0] in_data;
wire [w-1:0] rd0,rd1;
reg [4:0] ra0,ra1,wa;
reg we;

RegFile#(4) rf_ins(clk,ra0,rd0,ra1,rd1,wa,we,in_data); 


initial begin
    clk = 0;
    forever
    #5 clk = ~clk;
end

initial begin
    forever begin
        in_data = 4'b0101;
        #3;
        wa = 16'h2222;
        #3;
        we = 1;
        #22;
        we = 0;
        #52;
        in_data = 16'b1010;
        #3;
        wa = 16'h3333;
        #3;
        we = 1;
        #22;
        we = 0;
        #52;
        in_data = 4'b1111;
        #3;
        wa = 16'hffff;
        #3;
        we = 1;
        #22;
        we = 0;
        #52;
    end
end


initial begin

forever begin
    #3;
    ra0 = 16'heffe;
    #6;
    ra1 = 16'hffff;
    
    #12;

    ra0 = 16'h2222;
    #6;
    ra0 = 16'heffe;

    #8;
    
    ra1 = 16'h2222;
    #6
    ra0 = 16'h3333;
    
    #7;
    
    ra1 = 16'h3333;
    #2;
    ra0 = 16'hffff;
    #6;
    
end
end

    
endmodule



