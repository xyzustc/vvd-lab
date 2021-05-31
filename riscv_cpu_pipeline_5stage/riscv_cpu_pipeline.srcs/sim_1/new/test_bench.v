// `timescale 1ns / 1ps
// //////////////////////////////////////////////////////////////////////////////////
// // Company: 
// // Engineer: 
// // 
// // Create Date: 2021/05/13 10:36:20
// // Design Name: 
// // Module Name: test_bench
// // Project Name: 
// // Target Devices: 
// // Tool Versions: 
// // Description: 
// // 
// // Dependencies: 
// // 
// // Revision:
// // Revision 0.01 - File Created
// // Additional Comments:
// // 
// //////////////////////////////////////////////////////////////////////////////////
// // module cpu_proj(
// //     input clk,
// //     input rst,

// //     input run,
// //     input step,
    
// //     input valid,
// //     input [4:0] in,

// //     output [1:0] check,
// //     output [4:0] out0,
// //     output [2:0] an,
// //     output [3:0] seg,
// //     output ready
    
// // );

// module test_bench(  );
//     reg clk;
//     reg step;   
//     reg rst,run,valid; 
//     reg [4:0] sw;

//     wire [1:0] check;
//     wire [4:0] out0;
//     wire [2:0] an;
//     wire [3:0] seg;
//     wire ready;

//     cpu_proj test(.clk(clk),.rst(rst),.run(run),.step(step),.valid(valid),.in(sw[4:0]),.check(check),.out0(out0),.an(an),.seg(seg));
//     initial begin
//     clk = 0;
//     forever #5 clk = ~clk;
//     end
//     initial begin
//     step = 0; rst = 0; run = 0; valid = 0; sw = 5'b0_0000;
//     #1000;
//     rst = 1;
//     #1000;
//     rst = 0;
//     #1000;
//     run = 1;
//     #2000;
//     // sw = 5'b0_0001;
//     // #2000;
//     // valid = 1;
//     // #2000;
//     // valid =0;
//     // #2000;
//     // sw = 5'b0_0010;
//     // #2000;
//     // valid = 1;
//     // #2000;
//     // valid = 0;
//     // #2000;
//     // sw = 5'b0_0000;

//     // #2000;    valid = 1;    #2000;    valid = 0;
//     // #2000;    valid = 1;    #2000;    valid = 0;
//     // #2000;    valid = 1;    #2000;    valid = 0;
//     // #2000;    valid = 1;    #2000;    valid = 0;
//     // #2000;    valid = 1;    #2000;    valid = 0;
//     // #2000;    valid = 1;    #2000;    valid = 0;

//     // $finish;
//     end
   
// endmodule


//TODO:
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/13 10:36:20
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
// module cpu_proj(
//     input clk,
//     input rst,

//     input run,
//     input step,
    
//     input valid,
//     input [4:0] in,

//     output [1:0] check,
//     output [4:0] out0,
//     output [2:0] an,
//     output [3:0] seg,
//     output ready
    
// );

module test_bench(  );
    reg clk;
    reg step;   
    reg rst,run,valid; 
    reg [4:0] sw;

    wire [1:0] check;
    wire [4:0] out0;
    wire [2:0] an;
    wire [3:0] seg;
    wire ready;

    cpu_proj test(.clk(clk),.rst(rst),.run(run),.step(step),.valid(valid),.in(sw[4:0]),.check(check),.out0(out0),.an(an),.seg(seg));
    initial begin
    clk = 0;
    forever #5 clk = ~clk;
    end
    initial begin
    step = 0; rst = 0; run = 0; valid = 0; sw = 5'b0_0000;
    #1000;
    rst = 1;
    #1000;
    rst = 0;
    #1000;
    run = 1;
    #2000;
    sw = 5'b0_0001;
    #2000;
    valid = 1;
    #2000;
    valid =0;
    #2000;
    sw = 5'b0_0010;
    #2000;
    valid = 1;
    #2000;
    valid = 0;
    #2000;
    sw = 5'b0_0000;

    #2000;    valid = 1;    #2000;    valid = 0;
    #2000;    valid = 1;    #2000;    valid = 0;
    #2000;    valid = 1;    #2000;    valid = 0;
    #2000;    valid = 1;    #2000;    valid = 0;
    #2000;    valid = 1;    #2000;    valid = 0;
    #2000;    valid = 1;    #2000;    valid = 0;

    $finish;
    end
   
endmodule
