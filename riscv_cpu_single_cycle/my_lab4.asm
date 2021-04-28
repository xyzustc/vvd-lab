# 查看寄存器：x1，x2，x7. x1: 
# 查pc随时查
# 查mem,只有一个是有的,数据段0地址
# 断言: 按几下就完成几条指令的运行
.text
    lw      x9, 0(x0)       #get io base address
ready1:
# x3004
    lw      x6, 64(x9)      #read valid
# x3008
    beq     x6, x0, ready1  #if valid==1 then read data1
    lw      x1, 48(x9)      #read data_in
    # // 此时查x1,x3000+4*4=x3010
    sw      x1, 32(x9)       #display f1 
wating1:    
    lw      x6, 64(x9)      #read valid
    beq     x6, x0, ready2  #if valid==0 then data1 read done
    jal     x8, wating1
ready2: 
    lw      x6, 64(x9)      #read valid
    beq     x6, x0, ready2
    lw      x2, 48(x9)      #read data_in
    # // 查x2,x3000+4*11 = x302c
    sw      x2, 32(x9)       #display f2
wating2:    
    lw      x6, 64(x9)      #read valid
    beq     x6, x0, fib	    #if valid==0 then data1 read done
    jal     x8, wating2
fib:
    add     x7, x1,x2
    add     x1, x2,x0
    add     x2, x7,x0
ready3:
    lw      x6, 64(x9)      #read valid
    beq     x6, x0, ready3
    sw      x7, 32(x9)       #display fn
wating3:
    lw      x6, 64(x9)
    beq     x6, x0, fib
    jal     x8, wating3
.data
    0x400
