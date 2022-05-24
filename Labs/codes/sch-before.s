;-------------------------------------------------------------------
; 模拟指令调度的示例，调度前的指令
; 
;-------------------------------------------------------------------
		.data					; data
		.global		ONE			; 
ONE:	.word		1			;
		.text					;
		.global	main			;
main:
		lf          f1,ONE		; 载入单精度浮点数 one -> f1
		cvti2f		f7,f1		; int 转 float
		nop                     ; 
		divf		f1,f8,f7	; f8 / f7 -> f1
		divf		f2,f9,f7	; f9 / f7 -> f2
		addf		f3,f1,f2	; f1+f2->f3
		divf		f10,f3,f7	; f3 / f7 -> f10
		divf		f4,f11,f7	; f11 / f4 -> f4
		divf		f5,f12,f7	; f12 / f7 -> f5
		multf		f6,f4,f5	; f4 * f5 -> f6
		divf		f13,f6,f7	; f6 / f7 -> f13
Finish: 	
		trap		0
