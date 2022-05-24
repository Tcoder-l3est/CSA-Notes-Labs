;-------------------------------------------------------------------
; 模拟指令调度的示例，重新排序的指令
; sch-afer.s
;-------------------------------------------------------------------
		.data
		.global		ONE
ONE:	.word		1
		.text
		.global	main
main:
		lf          f1,ONE		; 通过以浮点格式存储在f7 1中将 divf 变为 move
		cvti2f		f7,f1		; 
		nop                     ; 
		divf		f1,f8,f7	;
		divf		f2,f9,f7	;
		divf		f4,f11,f7	; 相比之前，提前该指令，避免了f2寄存器数据相关
		divf		f5,f12,f7	
		addf		f3,f1,f2	
		multf		f6,f4,f5
		divf		f10,f3,f7	; 相比之前，后置该指令，避免了f3寄存器数据相关
		divf		f13,f6,f7	; 相比之前，后置该指令，避免了f6寄存器数据相关
Finish: 	
		trap		0
