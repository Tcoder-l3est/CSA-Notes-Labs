# CH1 Fundamental Concepts

> 基本概念

## 六个层级

![image-20220504141727462](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220504141727462.png)

## 翻译和解释

翻译：先把N+1级的程序全部转化为N级程序之后，再去执行新产生的N级程序，在执行过程中N+1级程序不再被访问(N+1->N)

解释：每当一条N+1级指令被译码后，就直接去执行一串等效的N级指令，然后再去取下一条N+1级指令，重复进行。

解释比编译后执行花的时间多，但是所需的存储空间少。

L0—L2用解释的方法，L3—L5用翻译的方法。

## 定义

程序设计者所看到的计算机系统的属性, 即概念性结构和功能特性

计算机系统结构研究的是软、硬件之间的功能分配以及对传统机器级界面的确定，为机器语言、汇编语言程序设计者或编译程序生成系统提供使其设计或生成的程序能在机器上正确运行而应看到和遵循的计算机属性.

**[问题1] 以乘法运算为例，试说明计算机系统结构、计算机组成、计算机实现各考虑什么？**

**[回答] 计算机系统结构：要放入指令集吗？ 计算机组成：控制流程 计算机实现：乘法器怎么设计**

## 分类

**性能**

巨型、大型、中型、小型、微型

**Flynn分类法**：单指令流单数据流、单指令流多数据流、多指令流单数据流、多指令流多数据流 

**库克分类法：**看指令流和执行流

**冯泽云分类法**：最大并行度

## ==计算机系统的设计技术==

### 定量原理

==Huffman压缩原理==

加速处理高概率事件

==Amdahl定律==

可改进部分的比例 Fe = 可改进部分执行时间 / 改进前整个任务的执行时间

改进部分的加速比 Se = 改进前改进部分的执行时间 / 改进后改进部分的执行时间

假设T0 为改进前全部时间，则改进后全部时间Tn = T0 * (1 - Fe + Fe/Se) 

改进后整个系统的加速比Sn = T0 / Tn = 1 / (1-Fe+Fe/Se)

==CPU性能公式==

程序执行的总指令条数IC：取决于指令集结构以及编译技术

平均每条指令的时钟周期数CPI

时钟主频$f_c$ 

CPU程序执行时间$T_{CPU} = IC*CPI*\frac{1}{f_c}$ 

![image-20220504144402617](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220504144402617.png)

## 计算机系统的评价标准

### MIPS 每秒多少百万条指令

MIPS = 指令条数 / (执行时间\*10^6) = Fz / CPI = IPC \* Fz

fz / cpi 每秒多少时钟周期 / 每条指令所需周期

IPC 是每个时钟周期平均执行的指令条数

主要优点：直观、方便。目前还经常使用
主要缺点:

1) MIPS依赖于指令集，用MIPS来比较指令集不同的机器的性能好
坏是很不准确的
2) 在同一台机器上，由于指令使用频度差别很大，MIPS会因程序
不同而变化
3) MIPS可能与性能相反
例如，具有可选硬件浮点运算部件的机器，具有优化功能的编
译器

### MFLOPS 每秒多少百万条浮点指令

MFLOPS = 程序中的浮点操作次数 / 执行时间*10^6

一般认为1 MFLOPS ≈ 13MIPS

### 基准测试程序



### 性能的比较

峰值性能和持续性能

算数性能平均值 Am = mean(n道程序运算速度或者运算时间)

加权算术平均、**几何平均与所参考的机器无关**



## 计算机系统的发展

冯诺依曼结构：存储程序原理的基本点：指令驱动

关于并行性

提高并行性的技术途径：

时间重叠: 引入时间因素，让多个处理过程在时间上相互错开，轮
流重叠地使用同一套硬件设备的各个部分，以加快硬件周转而赢得
速度
资源重复: 引入空间因素，以数量取胜。通过重复设置硬件资源，
大幅度地提高计算机系统的性能
资源共享：这是一种软件方法，它使多个任务按一定时间顺序轮流
使用同一套硬件设备。

在单处理机中，资源重复原理的运用也已经十分普遍。
多体存储器
多操作部件
阵列处理机（并行处理机）
在单处理机中，资源共享的概念实质上是用单处理机模拟多处理机
的功能，形成所谓虚拟机的概念。

多机系统遵循时间重叠、资源重复、资源共享原理，发展为为3种不同的
多处理机：**异构型多处理机、同构型多处理机、分布式系统**

### 冯·诺依曼结构

1. 存储程序原理的基本点：指令驱动。程序预先存放在计算机存储器中，计算机一旦启动，就能按照程序指定的
   逻辑顺序执行这些程序，自动完成由程序所描述的处理工作

   ![image-20220524151816601](https://vvtorres.oss-cn-beijing.aliyuncs.com/image-20220524151816601.png)

2. 以运算器为中心,集中控制。

3. 在存储器中，指令和数据同等对待。指令和数据一样可以进行运算，即由指令
   组成的程序是可以修改的。

4. 存储器是按地址访问、按顺序线性编址的一维结构，每个单元的位数是固定的。

5. 指令的执行是顺序的。

   - 一般是按照指令在存储器中存放的顺序执行。
   - 程序的分支由转移指令实现。
   -  由指令计数器PC指明当前正在执行的指令在存储器中的地址。

6. 指令由操作码和地址码组成。

7. 指令和数据均以二进制编码表示，采用二进制运算。

### 对系统结构进行改进

1. 输入输出方式改进：
   1. 程序控制：程序等待、程序中断
   2. DMA 成组传递、周期挪用
   3. I/O处理机：通道、外围处理机
2. 采用并行处理技术
   1. 在不同的级别采用并行技术
   2. 例如：微操作级、指令级、线程级、进程级、任务级
3. 存储器组织结构发展
   1. 相联存储器和相联处理及
   2. 通用寄存器组
   3. 高速缓冲存储器cache
4. 指令集发展
   1. CISC
   2. RISC

### 软件对系统结构的影响

模拟和仿真

从指令系统来看，是指要在一种机器的系统结构上实现另一种机器的指令系统
模拟（Simulation）：用**机器语言程序**解释实现**软件移植**的方法
仿真（Emulation）：用**微程序直接解释**另一种**机器指令**的方法。

#### 模拟

用机器语言程序解释实现软件移植的方法。
• 进行模拟工作的A机称为宿主机（Host Machine）
• 被模拟的B机称为虚拟机（Virtual Machine）
• 所有为各种模拟所编制的解释程序通称为模拟程序，编制非常复
杂和费时
• 只适合于移植运行时间短，使用次数少，而且在时间关系上没有
约束和限制的软件；

#### 仿真

用微程序直接解释另一种机器指令的方法。
• 进行仿真工作的A机称为宿主机
• 被仿真的B机称为目标机（Target Machine）
• 所有为仿真所编制的解释微程序通称为仿真微程序；

#### 两者区别

解释用的语言不同
• 解释程序所存的位置不同：仿真存在控制寄存器，模拟存在主存中
• 说明：
• 模拟适用于运行时间不长、使用次数不多的程序
• 仿真提高速度，但难以仿真存储系统、I/O系统，只能适用于系
统结构差异不大的机器间；
• 在开发系统中，两种方法共用

