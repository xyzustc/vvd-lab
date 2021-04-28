`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 11:31:12
// Design Name: 
// Module Name: cpu
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

// 输入端口：从模块内部来讲，输入端口必须为线网数据类型，从模块外部来看，输入端口可以连接到线网或者reg数据类型的变量。
// https://blog.csdn.net/kebu12345678/article/details/85328445
// 输出端口：从模块内部来讲，输出端口可以是线网或者reg数据类型，从模块外部来看，输出必须连接到线网类型的变量，而不能连接到reg类型的变量。
//////////////////////////////////////////////////////////////////////////////////


module  cpu (
  input clk, 
  input rst,

  //IO_BUS
  output [7:0] io_addr,      //led和seg的地址 
  output [31:0] io_dout,     //输出led和seg的数据 
  output io_we,                 //输出led和seg数据时的使能信号 
  input [31:0] io_din,          //来自sw的输入数据 

  //Debug_BUS
  input [7:0] m_rf_addr,   //存储器(MEM)或寄存器堆(RF)的调试读口地址
  output [31:0] rf_data,    //从RF读取的数据
  output [31:0] m_data,    //从MEM读取的数据
  output [31:0] pc             //PC的内容
);

// TAG: var def 
//pc
reg [31:0] pc_r;
reg [31:0] pc_next_a;

//instruction memory 当前指令
wire [31:0] inst;
wire [7:0] addr_inst;

//register
wire [31:0] reg1data;
wire [31:0] reg2data;
reg [31:0] reg_pre_wdata_a;
reg [31:0] reg_wdata_a;

//control
reg Branch_r,MemRead_r,MemtoReg_r,MemWrite_r,ALUSrc_r,RegWrite_r,Jal_r;
reg [1:0] ALUOp_r;
wire Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jal; //
wire [1:0] ALUOp;
//MemRead 好像没人用,

//alu
wire [31:0] alu_result;
wire alu_zero;
reg [31:0] alu_in2_a;
//alu control
reg [2:0] alu_ctrl_a;
//combinaiton control
wire sel_pc; //

//Imm Gen
reg [31:0] Imm_out_a;

// data memory
wire [31:0] data;
wire [7:0] addr_data_or_io;
wire data_not_io;
reg [31:0] mix_data_a;


//TAG: assigns
assign pc = pc_r;
//(逻辑pc转换为instr mem真实地址, pc_r: 0x0000_3000 ~ 0x0000_33(0011)f(1111)c(1100) => addr_inst: pc_r[9:2]. 本cpu实现中用于存储指令的物理位置容量为256x32bit,全部映射到0x0000_3000 ~ 0x0000_33(0011)f(1111)c(1100)地址空间,
assign addr_inst = pc_r[9:2]; 
//)
//(逻辑地址空间为 {{20'h0000_0},{0},{0},(any_0_1_combination_8_bits),{x},{x}},与256x32bit的物理位置容量映射;
//但是外设的读写也是看作data mem 读写, 所以逻辑空间地址还要加上{{20'h0000_0},{0},{1},(any_0_1_combination_8_bits),{x},{x}},不过在这么多外设地址中,只有"五个地址"安装了外设,对其他的io地址空间访问在pdu实现中无定义,no sense.
assign addr_data_or_io =  alu_result[9:2];
assign data_not_io = alu_result[10];

//)
    //!!!------------------ ATTENTION ------------------!!!:
    //对此instruction mem和data mem的有物理映射的逻辑地址空间 之外的 访问是"不被允许"的(这需要写汇编的人或汇编器注意),因为没有为这些之外的逻辑地址空间设计物理存储.
    // 如果汇编程序员或汇编器操纵了这些"不被允许"的地址单元 :
        //pc引用: 相当于在引用{{20'h0000_3},{2{0}},(not_allow_addrs_32bits)[9:2],{2{0}}}
        //data mem addr引用: 相当于在引用{{20'h0000_0},{0},{(not_allow_addrs_32bits)[10]},(not_allow_addrs_32bits)[9:2],{2{0}}}
    //一些断言:
        //此实现下,数据不可能来自指令地址空间,指令不可能来自数据地址空间,事实上两者地址空间是独立的.
assign Branch = Branch_r;
assign MemRead = MemRead_r;
assign MemtoReg = MemtoReg_r;
assign ALUOp = ALUOp_r;
assign MemWrite = MemWrite_r;
assign ALUSrc = ALUSrc_r;
assign RegWrite = RegWrite_r;
assign Jal = Jal_r;
assign sel_pc = (Branch & alu_zero) | Jal;

//选择下一个pc
always @(*) begin
    case(sel_pc)
        1'b0: pc_next_a = pc_r + 4;
        1'b1: pc_next_a = pc_r + Imm_out_a;
    endcase
end


//初步选择则register file的输入数据来源reg_pre_wdata_a
always @(*) begin
    case (MemtoReg)
        1'b0: reg_pre_wdata_a = alu_result;
        1'b1: reg_pre_wdata_a = mix_data_a;
        default: ;
    endcase
end

//选择则register file的输入数据来源reg_wdata_a
always @(*) begin
    case (Jal)
        1'b0: reg_wdata_a = reg_pre_wdata_a;
        1'b1: reg_wdata_a = pc_r + 4;
        default: ;
    endcase
end
//选择alu的输入b来源
always @(*) begin
    case (ALUSrc)
        1'b0: alu_in2_a = reg2data;
        1'b1: alu_in2_a = Imm_out_a;
        default: ;
    endcase
end


//宏定义
parameter const_one_1bit = 1; //恒0和恒1
parameter const_zero_1bit = 0; 
parameter const_zero_32bit = 32'h0000_0000;

parameter alu_plus = 3'b000;
parameter alu_minus = 3'b001;
parameter alu_and = 3'b010;
parameter alu_or = 3'b011;
parameter alu_xor = 3'b100;


/*                                      */
// TAG: modules

//更新pc
always @(posedge clk, posedge rst) begin
    if(rst)
        pc_r <= 32'h0000_3000;
    else
        pc_r <= pc_next_a;
end


//生成立即数Imm Gen EXTEND: 拓展其他的话，case里面可能也要改，比如加 fun3,fun7的位
always @(*) begin
    case (inst[6:0])
        7'b1100011: Imm_out_a = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0}; //beq
        7'b1101111: Imm_out_a = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0}; //jal
        7'b0010011: Imm_out_a = {{20{inst[31]}},inst[31:20]}; //addi
        7'b0000011: Imm_out_a = {{20{inst[31]}},inst[31:20]}; //lw
        7'b0100011: Imm_out_a = {{20{inst[31]}},inst[31:25],inst[11:7]}; //sw
        default: Imm_out_a = const_zero_32bit;
    endcase
end

//生成alu_ctrl_a 
// always @(*) begin
// end
always @(*) begin
    case (ALUOp)
        2'b00: alu_ctrl_a = alu_plus; // lw,sw
        2'b01: alu_ctrl_a = alu_minus; // beq,jal
        2'b10: alu_ctrl_a = alu_plus; //add,addi 因为一共只需要支持这6条指令，所以这里就是粗暴处理了，如果要支持其他的则不能这么写。
        default: alu_ctrl_a = alu_plus;
    endcase
end


//instruction memory 
dist_mem_gen_0 InstrMem(
  .a(addr_inst),      // input wire [7 : 0] a
  .d(const_zero_32bit),      // input wire [31 : 0] d
  .clk(clk),  // input wire clk
  .we(const_zero_1bit),    // input wire we
  .spo(inst)  // output wire [31 : 0] spo
);


//redisters 
RegFile Regs(
    .clk(clk),
    .ra0(inst[19:15]), // input [4:0] ra0,
    .rd0(reg1data), // output [WIDTH-1:0] rd0,
    .ra1(inst[24:20]), // input [4:0] ra1,
    .rd1(reg2data), // output [WIDTH-1:0] rd1,
    .ra_debug(m_rf_addr[4:0]), // input [4:0] ra_debug,
    .rd_debug(rf_data), // output [WIDTH-1:0] rd_debug,
    .wa(inst[11:7]), // input [4:0] wa,
    .we(RegWrite), // input we, 
    .wd(reg_wdata_a)// input [WIDTH-1:0] wd
);

//alu 
alu_temp Alu(
    .a(reg1data),
    .b(alu_in2_a),// input [WIDTH-1:0] a,b,
    .op(alu_ctrl_a),// input [2:0] op,
    .out(alu_result), // output [WIDTH-1:0] out,
    .zero(alu_zero)// output zero
);

//data memory MAY_BUG: MemRead没用到？对于这个模块的性质存疑
dist_mem_gen_1 DataMem(
  .a(addr_data_or_io),        // input wire [7 : 0] a. 逻辑地址转换为data memory的真实地址
  .d(reg2data),        // input wire [31 : 0] d
  .dpra(m_rf_addr),  // input wire [7 : 0] dpra
  .clk(clk),    // input wire clk
  .we(MemWrite),      // input wire we
  .spo(data),    // output wire [31 : 0] spo
  .dpo(m_data)    // output wire [31 : 0] dpo
);
//io regarded as data mem
assign io_addr = addr_data_or_io;
assign io_dout = reg2data;
assign io_we = MemWrite;
// decide io or dataMem
always @(*) begin
    case (data_not_io)
        1'b0: mix_data_a = io_din;
        1'b1: mix_data_a = data; 
        default: ;
    endcase
end

//main control 
always @(*) begin
    case (inst[6:0])
        7'b1101111: begin
            //jal
            Branch_r = 1;
            MemRead_r = 0;
            MemtoReg_r = 0;//x,use jal control
            ALUOp_r = 2'b01;
            MemWrite_r = 0;
            ALUSrc_r = 0;//x
            RegWrite_r = 1;
            Jal_r = 1;
        end
        7'b1100011: begin
            //beq
            Branch_r = 1;
            MemRead_r = 0;
            MemtoReg_r = 0;//x
            ALUOp_r = 2'b01;
            MemWrite_r = 0;
            ALUSrc_r = 0;
            RegWrite_r = 0;
            Jal_r = 0;
        end
        7'b0110011: begin
            //add
            Branch_r = 0;
            MemRead_r = 0;
            MemtoReg_r = 0;
            ALUOp_r = 2'b10;
            MemWrite_r = 0;
            ALUSrc_r = 0;
            RegWrite_r = 1;
            Jal_r = 0;
        end
        7'b0010011: begin
            //addi
            Branch_r = 0;
            MemRead_r = 0;
            MemtoReg_r = 0;
            ALUOp_r = 2'b10;
            MemWrite_r = 0;
            ALUSrc_r = 1;
            RegWrite_r = 1;
            Jal_r = 0;
        end
        7'b0100011: begin
            //sw
            Branch_r = 0;
            MemRead_r = 0;
            MemtoReg_r = 0;//x
            ALUOp_r = 2'b00;
            MemWrite_r = 1;
            ALUSrc_r = 1;
            RegWrite_r = 0;
            Jal_r = 0;
        end
        7'b0000011: begin
            //lw
            Branch_r = 0;
            MemRead_r = 1;
            MemtoReg_r = 1;
            ALUOp_r = 2'b00;
            MemWrite_r = 0;
            ALUSrc_r = 1;
            RegWrite_r = 1;
            Jal_r = 0;
        end
        default: ; 
    endcase
end


endmodule

