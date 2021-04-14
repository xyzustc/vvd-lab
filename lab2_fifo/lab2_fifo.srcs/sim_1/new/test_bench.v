`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/13 08:19:25
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
    
    reg clk,rst;
    reg enq,deq;
    reg [3:0] in;
    wire [3:0] out;
    wire emp,full;
    wire [2:0] an;
    wire [3:0] seg;
    fifo fifo_ins(
    clk,rst,
    enq,in,deq,out,
    emp,full,
    an,seg);
    initial begin
        clk = 0;
        forever
        #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        #10
        rst = 0;
    end
    
    initial begin
        enq = 0;
        deq = 0;
        #4000;
        #250 enq = ~enq;
        #50 enq = ~enq;
        #200;#4000;#400000;
        #250 enq = ~enq;
        #50 enq = ~enq;
        #200;#4000;#400000;
        #250 enq = ~enq;
        #50 enq = ~enq;
        #200;#4000;#400000;
        #250 enq = ~enq;
        #50 enq = ~enq;
        #200;#4000;#400000;
        #250 enq = ~enq;
        #50 enq = ~enq;
        #200;#4000;#400000;
        #250 enq = ~enq;
        #50 enq = ~enq;
        #200;#4000;#400000;
        #250 enq = ~enq;
        #50 enq = ~enq;
        #200;#4000;#400000;
        #250 enq = ~enq;
        #50 enq = ~enq;
        #200;#4000;#400000;
        #250 enq = ~enq;
        #50 enq = ~enq;
        #200;#4000;#400000;       
        #250 deq = ~deq;
        #50 deq = ~deq;
        #200;#4000;#400000;
        #250 deq = ~deq;
        #50 deq = ~deq;
        #200;#4000;#400000;
        #250 deq = ~deq;
        #50 deq = ~deq;
        #200;#4000;#400000;
        #250 deq = ~deq;
        #50 deq = ~deq;
        #200;#4000;
    end
    
    initial begin
        in = 1;
        #500;
        in = 0;
        #500;
        in = 2;
    end
    
    
//    reg clk,rst;
//    reg enq,deq;
//    reg [3:0] in;
//    wire [3:0] out;
//    wire emp,full;
//    wire [2:0] ra0;
//    reg [3:0] rd0;
//    wire [2:0] wa;
//    wire [3:0] wd;
//    wire we;
//    wire [7:0] valid;
    
//    LCU lcu_ins(
//    clk,rst,
//    enq,
//    in,
//    deq,
//    out,
//    emp,
//    full,
//    ra0,
//    rd0,
//    wa,
//    wd,
//    we,
//    valid
//        );
        
//initial begin
//    clk = 0;
//    forever
//    #5 clk = ~clk;
//end

//initial begin
//    rst = 1;
//    #10
//    rst = 0;
//end

//initial begin
//    deq = 0;
//    in=4'b0001;
//    rd0=4'b1100;
//    #5;
//    enq = 0;
//    forever
//    #50 enq = ~enq;
//end
    
//----------------------
//reg clk;
//reg [3:0] rd1;
//reg [7:0] valid;
//wire [2:0] ra1;
//wire [2:0] an_sel;
//wire [3:0] seg_data;
//initial begin
//    clk = 0;
//    forever
//    #5 clk = ~clk;
//end
//initial begin
//    valid = 8'b0011_1000;
//end

//SDU sdu_ins(clk,rd1,valid,ra1,an_sel,seg_data);

    
endmodule
