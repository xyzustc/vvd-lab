module cpu_proj(
    input clk,
    input rst,

    input run,
    input step,
    
    input valid,
    input [4:0] in,

    output [1:0] check,
    output [4:0] out0,
    output [2:0] an,
    output [3:0] seg,
    output ready
    
);

wire clk_cpu;
wire [7:0] io_addr;
wire [31:0] io_dout;
wire io_we;
wire [31:0] io_din;

wire [7:0] m_rf_addr;
wire [31:0] rf_data;
wire [31:0] m_data;
wire [31:0] pc;

cpu cpu_inst (
    .clk(clk_cpu),//   input clk,
    .rst(rst),//   input rst,

    //   //IO_BUS
    .io_addr(io_addr),//   output [7:0] io_addr,      //led和seg的地址
    .io_dout(io_dout),//   output [31:0] io_dout,     //输出led和seg的数据
    .io_we(io_we),//   output io_we,                 //输出led和seg数据时的使能信号
    .io_din(io_din),//   input [31:0] io_din,          //来自sw的输入数据

    //   //Debug_BUS
    .m_rf_addr(m_rf_addr),//   input [7:0] m_rf_addr,   //存储器(MEM)或寄存器堆(RF)的调试读口地址
    .rf_data(rf_data),//   output [31:0] rf_data,    //从RF读取的数据
    .m_data(m_data),//   output [31:0] m_data,    //从MEM读取的数据
    .pc(pc)//   output [31:0] pc             //PC的内容
);



pdu_1cycle pdu_inst(
    .clk(clk),//   input clk,
    .rst(rst),//   input rst,

    //   //选择CPU工作方式;
    .run(run),//   input run, 
    .step(step),//   input step,
    .clk_cpu(clk_cpu),//   output clk_cpu,

    //   //输入switch的端口
    .valid(valid),//   input valid,
    .in(in),//   input [4:0] in,

    //   //输出led和seg的端口 
    .check(check),//   output [1:0] check,  //led6-5:查看类型
    .out0(out0),//   output [4:0] out0,    //led4-0
    .an(an),//   output [2:0] an,     //8个数码管
    .seg(seg),//   output [3:0] seg,
    .ready(ready),//   output ready,          //led7

    //   //IO_BUS
    .io_addr(io_addr),//   input [7:0] io_addr,//读写外设的共用数据线.此模块中外设只有几个,且几个是只读的,另几个是只写的.
    .io_dout(io_dout),//   input [31:0] io_dout,//向外设写数据的中间工具人复用数据线,根据地址不同分别写到 out0: io_dout[4:0],ready: io_dout[0],out :io_dout[31:0] displayed as 8 leds.
    .io_we(io_we), //   input io_we,//向外设写数据的使能信号
    .io_din(io_din),//   output [31:0] io_din,//从外设读数据的数据线,只要地址对就可以读

    //   //Debug_BUS
    .m_rf_addr(m_rf_addr),//   output [7:0] m_rf_addr,//输出到led显示数据,从下面三个来自cpu的数据里面选.
    .rf_data(rf_data), //   input [31:0] rf_data,
    .m_data(m_data), //   input [31:0] m_data,
    .pc(pc)//   input [31:0] pc
);

endmodule
