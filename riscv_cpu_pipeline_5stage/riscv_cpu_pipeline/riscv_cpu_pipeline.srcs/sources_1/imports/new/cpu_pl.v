`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 07:50:30
// Design Name: 
// Module Name: cpu_pl
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


module cpu_pl(
  input clk, 
  input rst,

  // IO_BUS
  output [7:0] io_addr,      //led和seg的地址
  output [31:0] io_dout,     //输出led和seg的数据
  output io_we,                 //输出led和seg数据时的使能信号
  input [31:0] io_din,        //来自sw的输入数据

  // Debug_BUS
  input [7:0] m_rf_addr,   //存储器(MEM)或寄存器堆(RF)的调试读口地址
  output [31:0] rf_data,    //从RF读取的数据
  output [31:0] m_data,    //从MEM读取的数据

  // PC/IF/ID 流水段寄存器
  output [31:0] pc,
  output [31:0] pcd,
  output [31:0] ir,
  output [31:0] pcin,

  // ID/EX 流水段寄存器
  output [31:0] pce,
  output [31:0] a,
  output [31:0] b,
  output [31:0] imm,
  output [4:0] rd,
  output [31:0] ctrl,

  // EX/MEM 流水段寄存器
  output [31:0] y,
  output [31:0] bm,
  output [4:0] rdm,
  output [31:0] ctrlm,

  // MEM/WB 流水段寄存器
  output [31:0] yw,
  output [31:0] mdr,
  output [4:0] rdw,
  output [31:0] ctrlw
);

//宏定义
parameter const_one_1bit = 1; //恒0和恒1
parameter const_zero_1bit = 0; 
parameter const_zero_32bit = 32'h0000_0000;
parameter nop_inst = 32'h0000_0033;

parameter alu_plus = 3'b000;
parameter alu_minus = 3'b001;
parameter alu_and = 3'b010;
parameter alu_or = 3'b011;
parameter alu_xor = 3'b100;
// 命名规则：
//      图中有名有姓的寄存器加_r后缀；
//      为了使用ifelse得到的后面的输入加_a后缀；
//      其他的应该都是wire型变量了。有的wire型变量需要assign自对应的_r变量。

//
reg [31:0] pc_r,pc_next_a;
reg [31:0] pc4_IF_ID_r, pc_IF_ID_r, ir_IF_ID_r;
wire [7:0] addr_inst;
wire [31:0] inst;
assign addr_inst = pc_r[9:2]; 
wire pc_stall;
wire flush_IF_ID, stall_IF_ID;
// reg pc_stall_a,stall_IF_ID_a;

//
wire [31:0] reg1data, reg2data;
reg [31:0] imm_out_a;
wire [31:0] ctrl_a;
reg Branch_a, MemRead_a, MemtoReg_a, MemWrite_a, ALUSrc_a, RegWrite_a, Jal_a;
reg [1:0] ALUOp_a;
reg [31:0] ctrl_ID_EX_r, pc4_ID_EX_r, pc_ID_EX_r, A_ID_EX_r, B_ID_EX_r, ir_ID_EX_r, imm_ID_EX_r;
reg [31:0] reg_wdata_a;
wire flush_ID_EX, stall_ID_EX;

wire [31:0] ctrl_debug_ID_EX;//for display
// reg stall_ID_EX_a;

//
wire pc_jump, alu_zero;
wire [31:0] alu_result;
reg [2:0] alu_ctrl_a;
reg [31:0] ctrl_EX_MEM_r,pc4_EX_MEM_r,ALUans_EX_MEM_r,rs2_EX_MEM_r,ir_EX_MEM_r;
reg [31:0] alu_A_in_a, alu_B_in_a, alu_B_in_pre_a;
wire flush_EX_MEM;

wire [31:0] ctrl_debug_EX_MEM;
// reg flush_EX_MEM_a;

//
wire data_not_io;
wire [7:0] addr_data_or_io;
wire [31:0] data;
reg [31:0] mix_data_a;
reg [31:0] ctrl_WB_r, pc4_WB_r, MemData_WB_r, ALUans_WB_r, ir_WB_r;

wire [31:0] ctrl_debug_WB;

//
reg [31:0] reg_wdata_pre_a;

//
reg A_loaduse_a,B_loaduse_a;
reg [31:0] A_in_forward,B_in_forward;
reg forward_A,forward_B;

//segment reg debug
assign pc = pc_r;
assign pcd = pc_IF_ID_r;
assign ir = ir_IF_ID_r;
assign pcin = pc_next_a;

assign pce = pc_ID_EX_r;
assign a = A_ID_EX_r;
assign b = B_ID_EX_r;
assign imm = imm_ID_EX_r;
assign rd = ir_ID_EX_r[11:7];
assign ctrl = ctrl_ID_EX_r;

assign y = ALUans_EX_MEM_r;
assign bm = rs2_EX_MEM_r;
assign rdm = ir_EX_MEM_r[11:7];
assign ctrlm = ctrl_EX_MEM_r;

assign yw = ALUans_WB_r;
assign mdr = MemData_WB_r;
assign rdw = ir_WB_r[11:7];
assign ctrlw = ctrl_WB_r;


// IF
always @(posedge clk, posedge rst) begin //, posedge stall ?应该不需要
    if(rst)
        pc_r <= 32'h0000_3000;
    else if(pc_stall)
        pc_r <= pc_r;
    else
        pc_r <= pc_next_a;//
end

always @(*) begin
    if(pc_jump)
        pc_next_a = pc_ID_EX_r + imm_ID_EX_r;
    else
        pc_next_a = pc_r + 4;
end

dist_mem_gen_0 InstrMem(
  .a(addr_inst),      // input wire [7 : 0] a
  .d(const_zero_32bit),      // input wire [31 : 0] d
  .clk(clk),  // input wire clk
  .we(const_zero_1bit),    // input wire we
  .spo(inst)  // output wire [31 : 0] spo
);


// IF/ID
always @(posedge clk, posedge rst) begin
    if(rst)begin
        pc4_IF_ID_r <= 32'h0000_0000;
        pc_IF_ID_r <= 32'h0000_0000;
        ir_IF_ID_r <= 32'h0000_0000;
    end
    else if(stall_IF_ID) begin
        pc4_IF_ID_r <= pc4_IF_ID_r;
        pc_IF_ID_r <= pc_IF_ID_r;
        ir_IF_ID_r <= ir_IF_ID_r;
    end
    else if(flush_IF_ID) begin
        pc4_IF_ID_r <= 32'h0000_0001;//1 just for debug, more easily locate the bug line.
        pc_IF_ID_r <= 32'h0000_0001;
        ir_IF_ID_r <= nop_inst;
    end
    else begin
        pc4_IF_ID_r <= pc_r + 4;
        pc_IF_ID_r <= pc_r;
        ir_IF_ID_r <= inst;
    end
end

//ID
RegFile Regs(
    .clk(clk),
    .ra0(ir_IF_ID_r[19:15]), // input [4:0] ra0,
    .rd0(reg1data), // output [WIDTH-1:0] rd0,
    .ra1(ir_IF_ID_r[24:20]), // input [4:0] ra1,
    .rd1(reg2data), // output [WIDTH-1:0] rd1,
    .ra_debug(m_rf_addr[4:0]), // input [4:0] ra_debug,
    .rd_debug(rf_data), // output [WIDTH-1:0] rd_debug,
    .wa(ir_WB_r[11:7]), // input [4:0] wa,
    .we(ctrl_WB_r[18]), // input we, 
    .wd(reg_wdata_a)// input [WIDTH-1:0] wd
);

always @(*) begin
    case (ir_IF_ID_r[6:0])
        7'b1100011: imm_out_a = {{20{ir_IF_ID_r[31]}},ir_IF_ID_r[7],ir_IF_ID_r[30:25],ir_IF_ID_r[11:8],1'b0}; //beq
        7'b1101111: imm_out_a = {{12{ir_IF_ID_r[31]}},ir_IF_ID_r[19:12],ir_IF_ID_r[20],ir_IF_ID_r[30:21],1'b0}; //jal
        7'b0010011: imm_out_a = {{20{ir_IF_ID_r[31]}},ir_IF_ID_r[31:20]}; //addi
        7'b0000011: imm_out_a = {{20{ir_IF_ID_r[31]}},ir_IF_ID_r[31:20]}; //lw
        7'b0100011: imm_out_a = {{20{ir_IF_ID_r[31]}},ir_IF_ID_r[31:25],ir_IF_ID_r[11:7]}; //sw
        default: imm_out_a = const_zero_32bit;
    endcase
end

always @(*) begin
    case (ir_IF_ID_r[6:0])
        7'b1101111: begin
            // ctrl_a = {12'h000,1'b0,{1'rf_wr},{2'wb_sel},2'b00,{1b'm_rd},{1'm_wr},2'b00,{1'jal},{1'br},4'h0,{4'alu_op}};
            //jal
            Branch_a = 1;                       //8
            MemRead_a = 0;                      //13
            MemtoReg_a = 0;//x,use jal control  //
            ALUOp_a = 2'b01;                    //0extend 3-0
            MemWrite_a = 0;                     //12
            ALUSrc_a = 0;//x                    //
            RegWrite_a = 1;                     //18
            Jal_a = 1;                          //9
        end
        7'b1100011: begin
            //beq
            Branch_a = 1;
            MemRead_a = 0;
            MemtoReg_a = 0;//x
            ALUOp_a = 2'b01;
            MemWrite_a = 0;
            ALUSrc_a = 0;
            RegWrite_a = 0;
            Jal_a = 0;
        end
        7'b0110011: begin
            //add
            Branch_a = 0;
            MemRead_a = 0;
            MemtoReg_a = 0;
            ALUOp_a = 2'b10;
            MemWrite_a = 0;
            ALUSrc_a = 0;
            RegWrite_a = 1;
            Jal_a = 0;
        end
        7'b0010011: begin
            //addi
            Branch_a = 0;
            MemRead_a = 0;
            MemtoReg_a = 0;
            ALUOp_a = 2'b10;
            MemWrite_a = 0;
            ALUSrc_a = 1;
            RegWrite_a = 1;
            Jal_a = 0;
        end
        7'b0100011: begin
            //sw
            Branch_a = 0;
            MemRead_a = 0;
            MemtoReg_a = 0;//x
            ALUOp_a = 2'b00;
            MemWrite_a = 1;
            ALUSrc_a = 1;
            RegWrite_a = 0;
            Jal_a = 0;
        end
        7'b0000011: begin
            //lw
            Branch_a = 0;
            MemRead_a = 1;
            MemtoReg_a = 1;
            ALUOp_a = 2'b00;
            MemWrite_a = 0;
            ALUSrc_a = 1;
            RegWrite_a = 1;
            Jal_a = 0;
        end
        default: begin
            Branch_a = 0;
            MemRead_a = 0;
            MemtoReg_a = 0;
            ALUOp_a = 2'b00;
            MemWrite_a = 0;
            ALUSrc_a = 0;
            RegWrite_a = 0;
            Jal_a = 0;
        end
    endcase
end

assign ctrl_a = {12'h000,1'b0,{RegWrite_a},1'b0,{MemtoReg_a},2'b00,{MemRead_a},{MemWrite_a},2'b00,{Jal_a},{Branch_a},3'b000,{ALUSrc_a},2'b00,{ALUOp_a}};

// ID/EX
always @(posedge clk, posedge rst) begin
    if(rst)begin
        ctrl_ID_EX_r <= 32'h0000_0000;
        pc4_ID_EX_r <= 32'h0000_0000;
        pc_ID_EX_r <= 32'h0000_0000;
        A_ID_EX_r <= 32'h0000_0000;
        B_ID_EX_r <= 32'h0000_0000;
        ir_ID_EX_r <= 32'h0000_0000;
        imm_ID_EX_r <= 32'h0000_0000;
    end
    else if(stall_ID_EX) begin
        ctrl_ID_EX_r <= ctrl_ID_EX_r;
        pc4_ID_EX_r <= pc4_ID_EX_r;
        pc_ID_EX_r <= pc_ID_EX_r;
        A_ID_EX_r <= A_ID_EX_r;
        B_ID_EX_r <= B_ID_EX_r;
        ir_ID_EX_r <= ir_ID_EX_r;
        imm_ID_EX_r <= imm_ID_EX_r;
    end
    else if(flush_ID_EX) begin
        ctrl_ID_EX_r <= 32'h0000_0000;
        pc4_ID_EX_r <= 32'h0000_0001;
        pc_ID_EX_r <= 32'h0000_0001;
        A_ID_EX_r <= 32'h0000_0000;
        B_ID_EX_r <= 32'h0000_0000;
        ir_ID_EX_r <= nop_inst;
        imm_ID_EX_r <= 32'h0000_0000;
    end
    else begin
        ctrl_ID_EX_r <= ctrl_a;
        pc4_ID_EX_r <= pc4_IF_ID_r;
        pc_ID_EX_r <= pc_IF_ID_r;
        A_ID_EX_r <= reg1data;
        B_ID_EX_r <= reg2data;
        ir_ID_EX_r <= ir_IF_ID_r;
        imm_ID_EX_r <= imm_out_a;
    end
end

//EX
always @(*) begin
    case (ctrl_ID_EX_r[1:0])//ALUOp
        2'b00: alu_ctrl_a = alu_plus; // lw,sw
        2'b01: alu_ctrl_a = alu_minus; // beq,jal
        2'b10: alu_ctrl_a = alu_plus; //add,addi 因为一共只需要支持这6条指令，所以这里就是粗暴处理了，如果要支持其他的则不能这么写。
        default: alu_ctrl_a = alu_plus;
    endcase
end

always @(*) begin
    if(forward_A)
        alu_A_in_a = A_in_forward;
    else
        alu_A_in_a = A_ID_EX_r;
end

always @(*) begin
    if(forward_B)
        alu_B_in_pre_a = B_in_forward;
    else
        alu_B_in_pre_a = B_ID_EX_r;
end

always @(*) begin
    if(ctrl_ID_EX_r[4])
        alu_B_in_a = imm_ID_EX_r;
    else
        alu_B_in_a = alu_B_in_pre_a;
end
alu_temp Alu(
    .a(alu_A_in_a),
    .b(alu_B_in_a),// input [WIDTH-1:0] a,b,
    .op(alu_ctrl_a),// input [2:0] op,
    .out(alu_result), // output [WIDTH-1:0] out,
    .zero(alu_zero)// output zero
);

assign pc_jump = (alu_zero && ctrl_ID_EX_r[8])||ctrl_ID_EX_r[9];


//EX/MEM
always @(posedge clk, posedge rst) begin
    if(rst) begin
        ctrl_EX_MEM_r <= 32'h0000_0000;
        pc4_EX_MEM_r <= 32'h0000_0000;
        ALUans_EX_MEM_r <= 32'h0000_0000;
        rs2_EX_MEM_r <= 32'h0000_0000;
        ir_EX_MEM_r <= 32'h0000_0000;
    end
    else if(flush_EX_MEM) begin
        ctrl_EX_MEM_r <= 32'h0000_0000;
        pc4_EX_MEM_r <= 32'h0000_0001;
        ALUans_EX_MEM_r <= 32'h0000_0000;
        rs2_EX_MEM_r <= 32'h0000_0000;
        ir_EX_MEM_r <= nop_inst;
    end
    else begin
        ctrl_EX_MEM_r <= ctrl_ID_EX_r;
        pc4_EX_MEM_r <= pc4_ID_EX_r;
        ALUans_EX_MEM_r <= alu_result;
        rs2_EX_MEM_r <= alu_B_in_pre_a;//
        ir_EX_MEM_r <= ir_ID_EX_r;
    end
end


//MEM
assign addr_data_or_io =  ALUans_EX_MEM_r[9:2];
assign data_not_io = ~ALUans_EX_MEM_r[10];
dist_mem_gen_1 DataMem(
  .a(addr_data_or_io),        // input wire [7 : 0] a. 逻辑地址转换为data memory的真实地址
  .d(rs2_EX_MEM_r),        // input wire [31 : 0] d
  .dpra(m_rf_addr),  // input wire [7 : 0] dpra
  .clk(clk),    // input wire clk
  .we(ctrl_EX_MEM_r[12] && data_not_io),      // input wire we
  .spo(data),    // output wire [31 : 0] spo
  .dpo(m_data)    // output wire [31 : 0] dpo
);
//io regarded as data mem
assign io_addr = addr_data_or_io;
assign io_dout = rs2_EX_MEM_r;
assign io_we = ctrl_EX_MEM_r[12] && ~data_not_io;
// decide io or dataMem
always @(*) begin
    case (data_not_io)
        1'b0: mix_data_a = io_din;
        1'b1: mix_data_a = data; 
        default: ;
    endcase
end

//MEM/WB
always @(posedge clk, posedge rst) begin
    if(rst) begin
        ctrl_WB_r <= 32'h0000_0000;
        pc4_WB_r <= 32'h0000_0000;
        MemData_WB_r <= 32'h0000_0000;
        ALUans_WB_r <= 32'h0000_0000;
        ir_WB_r <= 32'h0000_0000;
    end
    else begin
        ctrl_WB_r <= ctrl_EX_MEM_r;
        pc4_WB_r <= pc4_EX_MEM_r;
        MemData_WB_r <= mix_data_a;
        ALUans_WB_r <= ALUans_EX_MEM_r;
        ir_WB_r <= ir_EX_MEM_r;
    end
end

//WB
always @(*) begin
    if(ctrl_WB_r[16])
        reg_wdata_pre_a = MemData_WB_r;
    else
        reg_wdata_pre_a = ALUans_WB_r;
end
always @(*) begin
    if(ctrl_WB_r[9])
        reg_wdata_a = pc4_WB_r;
    else
        reg_wdata_a = reg_wdata_pre_a;
end


//BranchHazard
assign flush_IF_ID = pc_jump;
assign flush_ID_EX = pc_jump;

//DataHazrd
assign pc_stall = A_loaduse_a||B_loaduse_a;
assign stall_IF_ID = A_loaduse_a||B_loaduse_a;
assign stall_ID_EX = A_loaduse_a||B_loaduse_a;
assign flush_EX_MEM = A_loaduse_a||B_loaduse_a;

reg [31:0] wdata_EX_MEM;
wire [31:0] wdata_WB;
assign wdata_WB = reg_wdata_a;
always @(*) begin
    if(ctrl_EX_MEM_r[9])
        wdata_EX_MEM = pc4_EX_MEM_r;
    else
        wdata_EX_MEM = ALUans_EX_MEM_r;
end


always @(*) begin
    if(ir_ID_EX_r[19:15]==5'b00000) begin
        A_in_forward = 32'h0000_0000;
        forward_A = 1'b0;
        A_loaduse_a = 1'b0;
    end
    else if(ctrl_EX_MEM_r[18]&&ir_ID_EX_r[19:15]==ir_EX_MEM_r[11:7]) begin
        if(ir_EX_MEM_r[6:0]==7'b0000011 && ~ctrl_ID_EX_r[9]) begin//~ctrl_ID_EX_r[9] 是为了 && USE 
            A_in_forward = 32'h0000_0000;
            forward_A = 1'b0;
            A_loaduse_a = 1'b1;
        end
        else begin
            A_in_forward = wdata_EX_MEM;
            forward_A = 1'b1;
            A_loaduse_a = 1'b0;
        end
    end
    else if(ctrl_WB_r[18]&&ir_ID_EX_r[19:15]==ir_WB_r[11:7]) begin
        A_in_forward = wdata_WB;
        forward_A = 1'b1;
        A_loaduse_a = 1'b0;
    end
    else begin
        A_in_forward = 32'h0000_0000;
        forward_A = 1'b0;
        A_loaduse_a = 1'b0;
    end
end

always @(*) begin
    if(ir_ID_EX_r[24:20]==5'b00000) begin
        B_in_forward = 32'h0000_0000;
        forward_B = 1'b0;
        B_loaduse_a = 1'b0;
    end
    else if(ctrl_EX_MEM_r[18]&&ir_ID_EX_r[24:20]==ir_EX_MEM_r[11:7]) begin
        if(ir_EX_MEM_r[6:0]==7'b0000011 && ~ctrl_ID_EX_r[9] && ir_ID_EX_r[5]) begin//~ctrl_ID_EX_r[9] 是为了 && USE; sw,add,beq
            B_in_forward = 32'h0000_0000;
            forward_B = 1'b0;
            B_loaduse_a = 1'b1;
        end
        else begin
            B_in_forward = wdata_EX_MEM;
            forward_B = 1'b1;
            B_loaduse_a = 1'b0;
        end
    end
    else if(ctrl_WB_r[18]&&ir_ID_EX_r[24:20]==ir_WB_r[11:7]) begin
        B_in_forward = wdata_WB;
        forward_B = 1'b1;
        B_loaduse_a = 1'b0;
    end
    else begin
        B_in_forward = 32'h0000_0000;
        forward_B = 1'b0;
        B_loaduse_a = 1'b0;
    end
end




endmodule
