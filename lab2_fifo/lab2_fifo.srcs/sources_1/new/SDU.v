`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/13 11:02:13
// Design Name: 
// Module Name: SDU
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


module SDU(
    input clk,
    input rst,
    input [3:0] rd1,
    input [7:0] valid,
    output [2:0] ra1,
    output [2:0] an_sel,//select 
    output [3:0] seg_data
    );
    
    parameter WIDTH=7;
    parameter N=200;
    reg clk_out;
    reg [WIDTH:0]counter;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // reset
            counter <= 0;
        end
        else if (counter == N-1) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // reset
            clk_out <= 0;
        end
        else if (counter == N-1) begin
            clk_out <= !clk_out;
        end
    end
    
    
    reg [7:0] mask_reg;
    always@(posedge clk_out)
    begin
        case(mask_reg)
        8'b1000_0000: mask_reg<=8'b0000_0001;
        8'b0000_0001: mask_reg<=8'b0000_0010;
        8'b0000_0010: mask_reg<=8'b0000_0100;
        8'b0000_0100: mask_reg<=8'b0000_1000;
        8'b0000_1000: mask_reg<=8'b0001_0000;
        8'b0001_0000: mask_reg<=8'b0010_0000;
        8'b0010_0000: mask_reg<=8'b0100_0000;
        8'b0100_0000: mask_reg<=8'b1000_0000;
        default: mask_reg<=8'b0000_0001;
        endcase
    end
    reg [2:0] loop_a;
    always@(*)
    begin
        case(mask_reg)
        8'b0000_0001: loop_a=3'b000;
        8'b0000_0010: loop_a=3'b001;
        8'b0000_0100: loop_a=3'b010;
        8'b0000_1000: loop_a=3'b011;
        8'b0001_0000: loop_a=3'b100;
        8'b0010_0000: loop_a=3'b101;
        8'b0100_0000: loop_a=3'b110;
        8'b1000_0000: loop_a=3'b111;
        endcase
    end

    reg [2:0] an_sel_reg;
    always@(posedge clk)
    begin
        if(rst)
        an_sel_reg<=3'b000;
        else if(valid&mask_reg)
        an_sel_reg<=loop_a;
//        else//
//        an_sel_reg<=3'bxxx;//
    end
    assign an_sel = an_sel_reg;
    
    assign ra1 = an_sel_reg;
    assign seg_data = rd1;    

    
    
endmodule
