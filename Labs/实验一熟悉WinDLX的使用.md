# 实验一 熟悉WinDLX的使用

> 实验信息
>
> 姓名：
>
> 班级： 
>
> 学号：
>
> 时间：2022.4.25

## 实验目的

通过本实验，熟悉 WinDLX 模拟器的操作和使用，了解 DLX 指令集结构 及其特点。

## 实验环境

操作系统：Windows XP

软件环境：WinDLX



## 实验内容

- 用 WinDLX 模拟器执行求阶乘程序 fact.s 。执行步骤详见“WinDLX 教程”。 这个程序说明浮点指令的使用。该程序从标准输入读入一个整数，求其阶乘， 然后将结果输出。该程序中调用了 input.s 中的输入子程序，这个子程序用于读入正整数。 

- 输入数据“3”采用单步执行方法，完成程序并通过上述使用 WinDLX，总结 WinDLX 的特点。 
- 注意观察变量说明语句所建立的数据区，理解 WinDLX 指令系统。



## 实验步骤

### 安装

1. 为 WinDLX 创建目录，例如 D:\WINDLX 
2. 解压 WinDLX 软件包或拷贝所有的 WinDLX 文件(至少包含 windlx.exe, windlx.hlp, fact.s  和 input.s)到这个 WinDLX 目录。

### 执行fact.s

#### 开始和配置WinDLX

![image-20220425192930299](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425192930299.png)

初始化模拟器，点击 **Reset all ** 

然后点击 **Configuration / Floating Point Stages** 选择如下配置

![image-20220425193124389](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425193124389.png)

设置MemorySize = 0x8000

#### 装载测试程序

**File / Load Code or Data**

- 点击fact.s
- 点击select 
- 点击 input.s
- 点击select
- 点击load

#### 模拟

##### Pipeline 窗口

双击图标 Pipeline，出现一个子窗口，窗 口中用图表形示显示了 DLX 的五段流水线。

![image-20220425193431642](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425193431642.png)

可以看到显示了DLX处理器的五个流水段以及浮点操作的单元



##### Code窗口

![image-20220425193659602](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425193659602.png)

代表存储器内容的三栏信息，从左到右依次为：地址、指令的16进制机器代码、汇编命令

---

点击Execution开始模拟，选择Single Cycle 或者 F7键

![image-20220425194711338](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425194711338.png)

![image-20220425194822246](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425194822246.png)

​	第一行为橘黄色，下一行为黄色。 对应于PipeLine里面ID 和 IF阶段的两条指令

| 阶段 | 说明     |
| ---- | -------- |
| IF   | 取指令   |
| ID   | 指令译码 |
| EX   | 执行     |
| MEM  | 读数     |
| WB   | 写回     |

点击几次执行后

![image-20220425195611585](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425195611585.png)



在代码窗口中，黄色出现在更下面的位置，并且可能是唯一彩色行。查 看一下 Pipeline 窗口，你会发现 IF，intEX 和 MEM 段正在使用而 ID 段没有。**为什么？**

**回答：** 

首先查看Clock Cycle Diagram

![image-20220425200425092](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425200425092.png)

第一条命令是add，此时正处于Mem阶段，第二条jal 再intEX阶段，第四条命令sw在IF阶段。而第三条movi指令则说明为aborted。

因为：第二条命令jal 是无条件分支指令，只有在第三个时钟周期，jal被译码之后才知道，而此时movi已经被取出，需要跳转，所以movi指令作废，在流水线中产生气泡。

而ID段 正是对应着此时movi所处的阶段，所以没有。

---

##### Clock Cycle Diagram 窗口

![image-20220425200425092](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425200425092.png)

jal 的分支地址命名为“InputUnsigned”。

为找到此符号地址的实际值，点击主窗口中的 Memory 和 Symbols，出现的子窗口中显示相应的符号和对应的实际值。

![image-20220425211346312](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425211346312.png)

再一次点击 F7 ，第一条命令（addi）到达流水线的最后一段。如果想了解某条命令执行后 处理器内部会发生什么？你只要对准 Clock cycle diagram 窗口中相应命令所在行，然后双击它， 弹出一个新窗口。窗口中会详细显示每一个流水段处理器内部的执行动作。

![image-20220425211454223](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425211454223.png)

双击第三行（movi2fp）， 你会看到它只执行了第一段（IF）， 这是因为出现跳转而被取消。

![image-20220425211532229](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425211532229.png)



##### Breakpoint 窗口

现在，请指向 Code 窗口中包含命令 trap 0x5 的 0x0000015c 行，此命令是写屏幕的系统调用。

添加断点

![image-20220425211828086](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425211828086.png)

点击 Execution / Run 或者F5，模拟继续运行，并且提示到达断点1

![image-20220425212301680](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425212301680.png)

然后点击Clock 里面的trap 0x5行

![image-20220425212510932](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425212510932.png)

无论何时遇到一条 trap 指令时，DLX 处理器中的流水线将被清空。在 Information 窗 口（双击 trap 行弹出）中，在 IF 段显示消息“3 stall(s) because of Trap-Pipeline-Clearing!”。



##### Register窗口

在地址为0x0000 0194那一行（指令是 lw r2, SaveR2(r0))，设置断点。

采用同样的方法，在地址 0x000001a4（指令 jar r31）处设置断点。

输入 **20**

![image-20220425223554583](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425223554583.png)

继续运行到断点 #2 处

![image-20220425222208806](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425222208806.png)



在指令之间出现了红和绿的箭头。**红色箭头表示需要一个暂停**，箭头指向处显示了暂停的原因。R-Stall（R-暂停）表示引起暂停的原因是 RAW。绿色箭头 **表示定向技术的使用**。

双击主窗口中的 Register 图标。Register 窗口会 显示各个寄存器中的内容。看一下 R1 到 R5 的值。按 F5 使模拟继续运行到下一个断点处，有些 值将发生改变，指令 lw 从主存中取数到寄存器中。

![image-20220425222955324](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425222955324.png)



##### Statistics 窗口

按 F5 使程序完成执行，出现消息“Trap #0 occurred”表明最后一条指令 trap 0 已经执行， Trap 指令中编号“0”没有定义，只是用来终止程序。

![image-20220425223612068](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425223612068.png)



双击图标 Statistics。Statistics 窗口提供各 个方面的信息：模拟中硬件配置情况、暂停及原因、条件分支、Load/Store 指令、浮点指令和 traps。 窗口中给出事件发生的次数和百分比，如 RAW stalls：17(7.91 % of all Cycles)。

![image-20220425223745456](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425223745456.png)



点击 Configuration 中的 Enable Forwarding 使定向无效（去掉小钩），再去运行。

![image-20220425224127959](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220425224127959.png)

RAW 暂停从 17 变成了 53，总的模拟周期数增加到 236。利用 这些值，你能够计算定向技术带来的加速比

236 / 215 = 1.098

快9.8%



## 实验心得

1. 流水线相关

   流水线中的相关是指相邻或相近的指令因存在某种关联，后面的指令不能 31 在原指定的时钟周期开始执行。 一般来说，流水线中的相关主要分为如下三种类型： (1) 结构相关：当硬件资源满足不了指令重叠执行的要求，而发生资源冲突时，就发生了结 构相关。 

   (2) 数据相关：当一条指令需要用到前面指令的执行结果，而这些指令均在流水线中重叠执 行时，就可能引起数据相关。

   (3) 控制相关：当流水线遇到分支指令和其它能够改变 PC 值的指令时，就会发生控制相关。

2. 熟悉了WinDLX，可以看出对于计算机体系结构特别是指令执行过程的模拟仿真非常真实，后续还要继续深入研究。