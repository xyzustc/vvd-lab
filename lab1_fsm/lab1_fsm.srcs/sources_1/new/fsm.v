`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/02 11:32:06
// Design Name: 
// Module Name: fsm
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


module fsm(
    input clk,
    input en,
    input [6:0] d,
    input rst,
    output reg [6:0] f

//    input clk,
//    input en,
//    output [1:0] out
//    output en_wire
    );

//reg [6:0] f;
//assign f_wire=f;
reg button_r1,button_r2;
always@(posedge clk)
    button_r1 <= en;
always@(posedge clk)
    button_r2 <= button_r1;
    
wire en_wire;
assign en_wire = button_r1 & (~button_r2);


parameter S_0 = 2'b00;
parameter S_1 = 2'b01;
parameter S_2 = 2'b10;

reg [1:0] cur_state_reg;
wire [1:0] cur_state;
assign cur_state = cur_state_reg;

reg [1:0] next_state_reg;
always@(*)
begin
//    if(rst)
//        next_state_reg = S_0;
//    else
    begin
        case(cur_state)
            S_0: begin if(en_wire) next_state_reg=S_1; end
            S_1: begin if(en_wire) next_state_reg=S_2; end
            S_2: next_state_reg=S_2;
            default: next_state_reg=S_0;
        endcase
    end
end
always@(posedge clk)
begin
    if(rst)
        cur_state_reg <= S_0;
    else if(en_wire)
        cur_state_reg <= next_state_reg;
end


reg sel1,sel2;
always@(*)
begin
    case(cur_state)
        S_0: sel1=0;
        S_2: sel1=1;
        default: sel1=0;
    endcase
end
always@(*)
begin
    case(cur_state)
        S_1: sel2=0;
        S_2: sel2=1;
        default: sel2=0;
    endcase
end

reg en1,en2;
//wire en_sum;
always@(*)
begin
    if(en_wire)
        case(cur_state)
            S_0: en1=1;
            S_2: en1=1;
            default: en1=0;
        endcase
    else
        en1=0;
end
always@(*)
begin
    if(en_wire)
        case(cur_state)
            S_1: en2=1;
            S_2: en2=1;
            default: en2=0;
        endcase
    else
        en2=0;
end
//assign en_sum = en_wire;

reg [6:0] d1_reg;
//+wire ?
reg [6:0] d2_reg;
//+wire ?
wire [6:0] sum;
always@(posedge clk)
begin
    if(en1)
    begin
        if(sel1) begin d1_reg<=d2_reg; end
        else begin d1_reg<=d; end
    end
end
always@(posedge clk)
begin
    if(en2)
    begin
        if(sel2) begin d2_reg<=sum; end
        else begin d2_reg<=d; end
    end
end


always@(*)
begin
    case(cur_state)
        S_0: f=7'h0000000;
        S_1: f=d1_reg;
        S_2: f=d2_reg;
        default: f=7'h0000000;
    endcase
end

wire [2:0] alu_opcode;
assign alu_opcode=3'b000;
alu_temp#(7) alu_ins(
    .a(d1_reg),
    .b(d2_reg),
    .y_reg(sum),
    .f(alu_opcode),
    .z_reg()
    );
//assign sum=sum_reg;



//assign out=cur_state;




endmodule
