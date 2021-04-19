.data
num1:       .word       0x1
num2:       .word       0x00000002
delimiter:  .string      ", "

.text

    lw a1, num1 # 
    lw a2, num2 # 
    li s1, 5

    li a7, 1
    addi a0, a1, 0 # a0 = a1 + 0
    ecall

    li a7, 4
    la a0, delimiter
    ecall

    li a7, 1
    addi a0, a2, 0 # a0 = a1 + 0
    ecall

loop:
    jal next_num  # jump to next_num and save position to ra
    addi s1,s1,-1
    beq s1, x0, end_loop # if s1 == x0 then end_loop
    
    addi a1, a2, 0 # a1 = a2 + 0
    addi a2, a3, 0 # a2 = a3 + 0
    j loop  # jump to loop

end_loop:
    
    li a7, 10
    ecall

next_num:
    li a7, 4
    la a0, delimiter
    ecall

    add a3, a2, a1 # a3 = a2 + a1
    addi t1, a0, 0 # t1 = a0 + 0

    addi a0, a3, 0 # a0 = a3 + 0
    addi a7, x0, 1 # a7 = x0 + 1
    ecall

    addi a0, t1, 0 # a0 = t1 + 0
    jr ra   # jump to ra

