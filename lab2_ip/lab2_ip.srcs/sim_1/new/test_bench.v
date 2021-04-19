`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 13:02:33
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


reg clka;
reg ena;
reg wea;
reg [3:0] addra;
reg [7:0] dina;
wire [7:0] douta;

blk_mem_gen_0 blk_ins(
  .clka(clka),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [3 : 0] addra
  .dina(dina),    // input wire [7 : 0] dina
  .douta(douta)  // output wire [7 : 0] douta
);

initial begin
    clka = 0;
    forever begin
         #5;
        clka = ~clka;
    end
end

initial begin
    wea = 1;ena = 1;
    dina = 8'h00;addra=4'h0;
    // #4;
    // #5;
    #6;
    dina = 8'h11;addra=4'h1;#10;
    dina = 8'h22;addra=4'h2;#10;
    dina = 8'h33;addra=4'h3;#10;

    wea = 0;ena = 1;
    dina = 8'h44;addra=4'h1;#10;
    dina = 8'h55;addra=4'h2;#10;
    dina = 8'h66;addra=4'h3;#10;

    wea = 1;ena = 0;
    dina = 8'h77;addra=4'h1;#10;
    dina = 8'h88;addra=4'h2;#10;
    dina = 8'h99;addra=4'h3;#10;

    wea = 0;ena = 1;
    dina = 8'haa;addra=4'h1;#10;
    dina = 8'hbb;addra=4'h2;#10;
    dina = 8'hcc;addra=4'h3;#10;
end

// initial begin
//     #2;
    
// end


reg [3:0] a;
reg [7:0] d;
reg clk;
reg we;
wire [7:0] spo;

dist_mem_gen_0 dist_ins(
  .a(a),      // input wire [3 : 0] a
  .d(d),      // input wire [7 : 0] d
  .clk(clk),  // input wire clk
  .we(we),    // input wire we
  .spo(spo)  // output wire [7 : 0] spo
);

initial begin
    clk = 0;
    forever begin
        #5;
        clk = ~clk;
    end
end

initial begin
    we = 1;
    a = 8'h00;d=4'h0;
    #4;
    a = 8'h11;d=4'h1;#10;
    a = 8'h22;d=4'h2;#10;
    a = 8'h33;d=4'h3;#10;

    we = 0;
    a = 8'h44;d=4'h1;#10;
    a = 8'h55;d=4'h2;#10;
    a = 8'h66;d=4'h3;#10;

    we = 1;
    a = 8'h77;d=4'h1;#10;
    a = 8'h88;d=4'h2;#10;
    a = 8'h99;d=4'h3;#10;

    we = 0;
    a = 8'haa;d=4'h1;#10;
    a = 8'hbb;d=4'h2;#10;
    a = 8'hcc;d=4'h3;#10;
end

endmodule
