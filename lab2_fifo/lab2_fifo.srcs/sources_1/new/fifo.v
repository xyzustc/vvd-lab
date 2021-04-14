`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 13:06:57
// Design Name: 
// Module Name: fifo
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


module fifo(
    input clk,rst,
    input enq,
    input [3:0] in,
    input deq,
    output [3:0] out,
    output emp,
    output full,
    output [2:0] an,
    output [3:0] seg
    );
    
    
    wire [2:0] ra0;
//    wire [3:0] rd0_wire;
    wire [3:0] rd0;
    wire [2:0] wa;
    wire [3:0] wd;
    wire we;
    wire [7:0] valid;
    //LCU
    //
    LCU lcu_ins(
    clk,rst,
    enq,in,deq,out,
    emp,full,
    ra0,rd0,
    wa,wd,we,valid);
    
    
    wire [2:0] ra1;
//    wire ra1_wire;
//    assign ra1_wire=ra1;
    wire [3:0] rd1;
//    wire [2:0] wa_wire;
//    assign wa_wire=wa;
//    wire we_wire;
//    assign we_wire = we;
//    wire [3:0] wd_wire;
//    assign wd_wire=wd;
    //REG
    //
    reg4b_8d reg_ins(
    clk,ra0,rd0,ra1,rd1,wa,we,wd);
    
    
    wire [3:0] rd1_wire;
    assign rd1_wire=rd1;
    wire [7:0] valid_wire;
    assign valid_wire=valid;
    //SDU
    //
    SDU sdu_ins(
    clk,rst,rd1,valid,ra1,an,seg);
    
    
    
endmodule
