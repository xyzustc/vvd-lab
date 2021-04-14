`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/12 13:07:14
// Design Name: 
// Module Name: LCU
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


module LCU(
    input clk,rst,
    input enq,
    input [3:0] in,
    input deq,
    output [3:0] out,
    output emp,
    output full,
    output [2:0] ra0,
    input [3:0] rd0,
    output [2:0] wa,
    output [3:0] wd,
    output we,
    output [7:0] valid
    );
    
assign wd = in;
reg enq_r1,enq_r2,deq_r1,deq_r2;
always@(posedge clk)
    begin enq_r1 <= enq; deq_r1 <= deq; end
always@(posedge clk)
    begin enq_r2 <= enq_r1; deq_r2 <= deq_r1; end
wire enq_wire,deq_wire;
assign enq_wire = enq_r1 & (~enq_r2);
assign deq_wire = deq_r1 & (~deq_r2);

reg [7:0] rstate;
//reg ri [0:7];
//wire r0,r1,r2,r3,r4,r5,r6,r7;
//wire [7:0] ri_wire;
//assign r0=ri[0];
//assign r1=ri[1];
//assign r2=ri[2];
//assign r3=ri[3];
//assign r4=ri[4];
//assign r5=ri[5];
//assign r6=ri[6];
//assign r7=ri[7];

reg [2:0] head;
reg [2:0] tail;

reg full_reg;
reg emp_reg;
always@(*)
begin
    case(rstate)
        8'b1111_1111: begin full_reg=1;emp_reg=0; end
        8'b0000_0000: begin full_reg=0;emp_reg=1; end
        default: begin full_reg=0;emp_reg=0; end
    endcase
end
assign full=full_reg; 
assign emp=emp_reg;

reg [7:0] tail_or; 
always@(*)
begin
    case(tail) 
        3'b000: tail_or = 8'b0000_0001;
        3'b001: tail_or = 8'b0000_0010; 
        3'b010: tail_or = 8'b0000_0100;
        3'b011: tail_or = 8'b0000_1000;
        3'b100: tail_or = 8'b0001_0000;
        3'b101: tail_or = 8'b0010_0000;
        3'b110: tail_or = 8'b0100_0000;
        3'b111: tail_or = 8'b1000_0000;
//        default: tail_or = 8'b0000_0000;
    endcase
end

reg [7:0] head_and; 
always@(*)
begin
    case(head) 
        3'b000: head_and = ~8'b0000_0000;
        3'b001: head_and = ~8'b0000_0010; 
        3'b010: head_and = ~8'b0000_0100;
        3'b011: head_and = ~8'b0000_1000;
        3'b100: head_and = ~8'b0001_0000;
        3'b101: head_and = ~8'b0010_0000;
        3'b110: head_and = ~8'b0100_0000;
        3'b111: head_and = ~8'b1000_0000;
//        default: head_and = ~8'b1111_1111;
    endcase
end

reg we_reg;

always@(posedge clk)
begin
    if(rst)
    begin
        rstate<=8'b0000_0000;
        head<=3'b000;
        tail<=3'b000;
        we_reg <= 0;
    end
    else if(enq_wire && ~deq && ~full_reg)
    begin
        rstate<=rstate|tail_or;
        tail <= tail+1;
        we_reg <= 1;
    end
    else if(deq_wire && ~enq && ~emp_reg)
    begin
        rstate<=rstate&head_and;
        head <= head+1;
        we_reg <= 0;
    end
    else
    begin
        we_reg <= 0;
    end
end

reg regfile_test;

assign we = enq_wire;
assign wa = tail;
assign ra0 = head;
assign out = rd0;
assign valid = rstate;

//always@(posedge clk)
//begin
//    if(enq)
//        regfile_test <= 1;
        
        
//    else
//        regfile_test <= 0;
//end



//parameter S_0 = 2'b00;
//parameter S_1 = 2'b01;
//parameter S_2 = 2'b10;

//reg [1:0] cur_state_reg;
//wire [1:0] cur_state;
//assign cur_state = cur_state_reg;

//reg [1:0] next_state_reg;
//always@(*)
//begin
//    if(rst)
//        next_state_reg = S_0;
//    else
//    begin
//        case(cur_state)
//            S_0: begin if(en_wire) next_state_reg=S_1; end
//            S_1: begin if(en_wire) next_state_reg=S_2; end
//            S_2: next_state_reg=S_2;
//            default: next_state_reg=S_0;
//        endcase
//    end
//end
//always@(posedge clk)
//begin
//    if(en_wire)
//        cur_state_reg <= next_state_reg;
//end



    
    
    
    
endmodule
