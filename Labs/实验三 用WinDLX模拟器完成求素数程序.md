# 实验三 用WinDLX模拟器完成求素数程序

> 实验信息
>
> 姓名： 	张朝阳			班级： 19.1
>
> 学号：	201900180091      时间：2022.5.3
>

## 实验目的

通过实验，熟练掌握 WINDLX 的操作方法，特别注意在单步执行 WinDLX 程序中，流水线中指令的节拍数

## 实验环境

操作系统：Windows XP

软件环境：WinDLX

## 实验内容

- 用 WinDLX 模拟器执行求素数程序 prim.s。这个程序计算若干个整数的素数。

- 单步执行两轮程序，求出素数 2 和 3。
- 在执行程序过程中，注意体验单步执行除法和乘法指令的节拍数，并和主菜单 configuration/floating point slages 中的各指令执行拍数进行比较。

## 实验步骤

### 整体流程

![image-20220510084809516](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220510084809516.png)

### 单步执行

load prim.s然后F7 单步执行，查看效果

可以看出乘法指令执行了>=22个cycles，具体到fmulEX阶段，是用了5个节拍。

![image-20220510084705770](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220510084705770.png)

可以看出除法指令执行了>=23个cycles，具体到fmulEX阶段，是用了19个节拍。

![image-20220510084619052](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220510084619052.png)

可以看出主菜单configuration/floating point slages中的各指令执行拍数：乘法为5；除法为19。正好与上述的执行过程一致。

![image-20220510085216036](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220510085216036.png)

通过查看内存，查看Table的值

![image-20220510085721092](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220510085721092.png)

跟踪寄存器

1. 获取素数2，由于R1=R3=0，所以R2=2为素数，将2送入Table（0）中。

![image-20220510090217509](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220510090217509.png)



2. 获取素数3。执行步骤以及对应的寄存器的变化情况：

   - R2=2 is PRim,R4=1;
- R1+4->R1;
   - 10->R9,R1/4->R10,R2+1->R2;

   - R1!=R3,R4=0;

   ![image-20220510090416898](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220510090416898.png)

   - Table(R3)->R5;
- R2/R5->R6;
   - R6*R5->R7;
- R2-R7->R8;
   
![image-20220510090458536](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220510090458536.png)



### 分析

**数据相关和结构相关**

数据相关：

Addi r1,r0,0x0

Addi r2,r0,0x2

Addi r3,r0,0x0

Seq r4,r1,r3

Bnez r4,lsprim

Lw r5,table(r3)

Divu r6,r2,r5

Multu r7,r6,r5

Subu r8,r2,r7

Beqz r8,lsnoprim

Addi r3,r3,0x4

J loop

Sw table(r1),r2

Addi r1,r1,0x4

Lw r9,$data(r0)

Srli r10,r1,2

Sge r11,r10,r9

Bnez r11,finish

Addi r2,r2,0x1

J nextvalue

Trap0x0

nop

---

结构相关

Instructions/cycles

Sw table(r1),r2

Addi r1,r1,0x4

Lw r9,$data(r0)

Srli r10,r1,2

Sge r11,r10,r9

Bnez r11,finish

Addi r2,r2,0x1

Trap0x0

nop

## 源码阅读

prim.s 代码以及注释如下：

```assembly

;------------------------------------------------ ------------------
; 程序从符号 main 开始
; 生成一个表,其中包含素数
; r1 是标志table下一个要写入的素数的位置索引
; r2 是用来遍历2---INF的
; r3 是用来遍历table 0---r1 从而判断r2 是不是素数 
; 一个数字r2
;	如果遍历完所有的table元素仍不能被整除
; 		则认为是一个素数，并写入到table[r1] 里面
;	如果发现能被整除,则一定不是素数
;		则r2++ 遍历判断下一个自然数
;------------------------------------------------ ------------------
		.data

		;*** table的size = count = 10
		;*** table 大小为 10 * 4 = 40
		.global		Count
Count:		.word		10
		.global		Table
Table:		.space		Count*4


		.text
		.global	main
main:
		;*** 初始化
		addi		r1,r0,0		; r1记录数组已经写入数的索引 初始 r1 = 0 
		addi		r2,r0,2 	; r2是当前判断是否是素数的数 初始 r2 = 2

		;*** 判断R2能够被Table中的数值整除
NextValue:	addi	r3,r0,0 	; 辅助索引 r3=0,用于遍历Table
Loop:		seq		r4,r1,r3	; 判断是否遍历完Table 即判断r1 == r3?
		bnez		r4,IsPrim	; 如果遍历完,说明R2是素数,反之不是
		lw          r5,Table(R3); 取出Table[R3] -> r5
		divu		r6,r2,r5	; r2 / r5 -> r6 
		multu		r7,r6,r5	; r6 * r5 -> r7	
		subu		r8,r2,r7	; r2 - r7 -> r8	 r8为r5/r2的余数
		beqz		r8,IsNoPrim	; 判断r8,0说明R5整除R2,确定r2不为素数
		addi		r3,r3,4		; r3 += 4 goto next table entry
		j           Loop		; goto Loop

IsPrim: 	;*** 找到素数,将其写入table,更新索引
		sw          Table(r1),r2; 将素数R2写入table[r1]
		addi		r1,r1,4		; r1++ 下一个索引位置

		;*** 'Count' reached?
		lw		r9,Count		; 10(count) -> r9
		srli	r10,r1,2		; r1 逻辑右移2位 -> r10 (除4)
		sge		r11,r10,r9		; 判断 r10 > r9
		bnez	r11,Finish		; r11 = 1 说明table已经写满  需要结束

IsNoPrim:	;*** Check next value
		addi	r2,r2,1 		; r2++
		j		NextValue		; jump to NextValue
		
Finish: 	;*** end
		trap	0
```



## 涉及指令

prim所使用的部分DLX指令如下

|       指令        |                        含义                         |
| :---------------: | :-------------------------------------------------: |
|   seq  r4,r1,r2   |             如果r1 = r2，r4为1，否则为0             |
|  bnez r4,IsPrim   |      如果r4不为0，则跳转到IsPrim,反之顺序执行       |
|   sgt  r3,r1,r2   |             如果r1 > r2，r3为1，否则为0             |
|      j & jal      | j 是跳转，jal是跳转并链接，结束后继续执行原来的指令 |
|  divu  r6,r2,r5   |                  无符号数r2/r5->r6                  |
|  multu r7,r6,r5   |                      无符号乘                       |
|  subu  r8,r2,r7   |                      无符号减                       |
| beqz  r8,IsNoPrim |           等于0分支，如果R4=0，则name->PC           |
| srli	r10,r1,2  |                      逻辑右移                       |

## 实验心得

1. 通过本次实验的学习，我充分理解了寄存器的变化情况一步一步反映着程序的进行情况。我基本熟练掌握windlx的操作和使用，对程序在流水线中的执行情况基本了解，观察到了cpu中寄存器和存储器的内容变化，清晰掌握数据相关和结构相关的意义。
1. 同时执行过程中的乘除法节拍也是通过Configuration，我们自己进行设定的。通过这些数据，我们可以看到数据相关以及结构相关的一些情况。本次实验使我对程序执行过程中，各个硬件的工作状态有了更加深刻的了解和认识。
