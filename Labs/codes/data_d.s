;-----------------------------------------------------------------
; 测试数据相关
; R3寄存器一直是B的地址
; R2从A开始每次 +0x4 
; Loop Ten Times
;-----------------------------------------------------------------
      LHI     R2, (A>>16) & 0xFFFF        ; R2 <- A
      ADDUI   R2, R2, A & 0xFFFF          ; 分别高位低位,发生数据相关
      LHI     R3, (B>>16)&0xFFFF          ; R3 <- B
      ADDUI   R3, R3, B&0xFFFF            ; 分别高位低位,发生数据相关
loop:  
      LW     R1, 0(R2)                    ; A[0] -> R1
      ADD    R1, R1, R3                   ; A[0] + B[0] -> R1  与上面数据相关                
      SW     0(R2), R1                    ; R1(A[0] + B[0]) -> A[0],发生数据相关
      LW     R5, 0(R1)                    ; A[0] + B[0] -> R5,发生数据相关
      ADDI   R5, R5, #10                  ; R5 = R5 + 0x10(16),发生数据相关
      ADDI   R2, R2, #4                   ; R2 = R2 + 0x4
      SUB    R4, R3, R2                   ; R4 = R3 - R2,发生数据相关
      BNEZ   R4, loop                     ; 结束条件:R2=R3=B,发生数据相关
      TRAP   #0                           ; Exit
A: .word 0, 4, 8, 12, 16, 20, 24, 28, 32, 36  
B: .word 9, 8, 7, 6, 5, 4, 3, 2, 1, 0  