# 实验二 用WinDLX模拟器执行程序求最大公约数

> 实验信息
>
> 姓名： 				班级： 
>
> 学号：	时间：
>

## 实验目的

通过本实验，熟练掌握 WinDLX 模拟器的操作和使用，清楚 WinDLX 五段 流水线在执行具体程序时的流水情况，熟悉 DLX 指令集结构及其特点。

## 实验环境

操作系统：Windows XP

软件环境：WinDLX



## 实验内容

- 用 WinDLX 模拟器执行程序 gcm.s 。

  该程序从标准输入读入两个整数，求他们的 $greatest\quad common\quad measure$， 然后将结果写到标准输出。 该程序中调用了 input.s 中的输入子程序。 

- 给出两组数 6、3 和 6、1，分别在 main+0x8(add r2,r1,r0)、gcm.loop(seg r3,r1,r2)和 result+0xc(trap 0x0)设断点，采用单步和连续混合执行的方法完成程序，注意中间过程和寄存器的 43 变化情况，然后单击主菜单 execute/display dlx-i/0,观察结果。 


## 实验步骤

### 设置断点

![image-20220426200451808](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426200451808.png)

### 运行

单次运行，输入第一个数字$6$，之后继续F5运行，到达断点#1 $\quad main+0x8(add\quad r2,r1,r0)$ 

![image-20220426200846301](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426200846301.png)

可以看到因为$J \quad input.Loop$ 导致的气泡

查看寄存器发现：输入6之后，首先保存在A寄存器中，然后到ALU中。

![image-20220426201226213](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426201226213.png)

继续执行输入第二个数3，然后运行到断点#2 gcm.loop(seg r3,r1,r2)处，也就是对应汇编代码gcm.s 里面的Loop

![image-20220426201642885](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426201642885.png)

首先可以发现通过 jr r31 跳转至此，而r31的值为 0x0000 0114即gcm Loop入口地址

![image-20220426201901715](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426201901715.png)

可以发现 bnez指令需要r3结果，所以存在写读冲突，需要R-Stall，然后当执行计算出r3 之后，通过$Forwarding$ 减少R-Stall 阶段。

当然此时

![image-20220426202235697](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426202235697.png)R1寄存器为3，R2为6

所以会执行R2Greater，指令体现在判断不是r1Greater之后继续顺序执行，然后自然执行了R2Greater对应的sub指令，最后再跳转回gcm.Loop

![image-20220426202501005](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426202501005.png)

F5 继续运行 最后直到R1 == R2

![image-20220426202814963](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426202814963.png)

跳转到Finish 模块，trap 0x5 打印输出，trap 0x0 结束

![image-20220426202857963](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426202857963.png)

### 分析

查看Statistics，总共121 Cycles (input 6 and 3)

![image-20220426203110816](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426203110816.png)

如果取消Forwarding，花费136 Cycles

![image-20220426203258283](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426203258283.png)

---

如果Input: 6 & 1

则分别花费157 和 180 Cycles

---

查看DLX-Standard-I/O可以得到结果

![image-20220426204312282](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426204312282.png)



## 源码阅读

gcm.s 代码以及注释如下：

```assembly
;------------------------------------------------------------------------
; 程序在main 开始
; 需要INPUT 模块
; 从标准输入读入两个正整数，计算最大公约数
; 并且把他们写到标准输出中
;------------------------------------------------------------------------
		
		;*** 数据区
		.data		

		;*** Prompts for input
Prompt1:	.asciiz 	"First Number:"
Prompt2:	.asciiz 	"Second Number: "

		;*** Data for printf-Trap
PrintfFormat:	.asciiz 	"gcM=%d\n\n"
		.align		2
PrintfPar:      .word		PrintfFormat
PrintfValue:	.space		4


		.text
		.global	main
main:
		;*** 将两个正整数分别读入R1 和 R2 寄存器
		;*** 主要用了更相减损法
		addi	r1,r0,Prompt1
		jal     InputUnsigned	; 读入一个正整数到R1
		add     r2,r1,r0        ; R2 <- R1
		addi	r1,r0,Prompt2
		jal     InputUnsigned	; 读入另外一个正整数到R1

Loop:                           ; *** 比较R1 和 R2寄存器数据的大小
		seq     r3,r1,r2        ; R1 == R2 ?
		bnez	r3,Result		; 跳转到Result
		sgt     r3,r1,r2        ; R1 > R2 ?
		bnez	r3,r1Greater	; 跳转到r1Greater
		
r2Greater:	;*** r2 <-- r2 - r1 
		sub		r2,r2,r1
		j		Loop			; 跳转回Loop

r1Greater:	;*** r1 <-- r1 - r2
		sub		r1,r1,r2
		j		Loop			; 跳转回Loop

Result: 	;*** 从R1 寄存器中打印输出
		sw		PrintfValue,r1
		addi	r14,r0,PrintfPar
		trap	5

		;*** end
		trap	0
```



## 涉及指令

gcm 所使用的部分DLX指令如下

| 指令           | 含义                                                |
| -------------- | --------------------------------------------------- |
| seq r3,r1,r2   | 如果r1 = r2，r3为1，否则为0                         |
| bnez r3,Result | 如果r3 不为0，则跳转到Result 反之顺序执行           |
| sgt r3,r1,r2   | 如果r1 > r2，r3为1，否则为0                         |
| j & jal        | j 是跳转，jal是跳转并链接，结束后继续执行原来的指令 |

## 实验心得

1. 在input 6 and 3时，Forwarding 技术导致的加速比= $\frac{136}{121} = 1.124$ 快大约12.4%

2. 在input 6 and 1时，Forwarding 技术导致的加速比= $\frac{180}{157} = 1.146$ 快大约14.6%

3. 明白了gcm的设计思想，这里主要用了更相减损法，还有辗转相除法以及Stein算法等。

4. 针对流水线而言，本次实验中主要存在数据相关，具体是RAW(Read and Write) 读写/写读相关，没有WAW，而stalls 除了RAW 还有因为Control 以及 Trap Stalls

   ![image-20220426204810740](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220426204810740.png)

5. Control 控制相关指的是：当流水线遇到分支指令和其它能够改变 PC 值的指令时，就会发生控制相关。(例如跳转指令等)

6. 本实验主要通过定向技术减少数据相关带来的暂停，将一个结果直接传送到所有需要它的功能单元。

7. 通过调试汇编代码，查看流水线结构以及寄存器，进一步体会了流水线执行过程以及流水线中存在的优化机制。
