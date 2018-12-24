# Telosb嵌入式小车实验报告

## 功能和操作说明

### 小车舞蹈

小车会在启动后演示前进后退、转弯、各个舵机旋转和复位的功能。指示灯表示的3为二进制数代表了表演的阶段。自动表演结束后方可进行遥控操作。

### 遥控操作

- 用摇杆可以控制小车的前进、后退、左转和右转。
- 如果A和B键都不按下，那么控制舵机1；如果按住A键控制舵机2；如果按住B键控制舵机3
  - 此时按下C键降低对应舵机，按下E键升起对应舵机。
- 按F会依次复位所有舵机。
- 由于D键损坏，没有被使用。

### 指示灯

遥控器和小车都会用指示灯显示当前指令。指示灯0表示小车在前进或后退；指示灯1表示小车在左转或右转；指示灯2表示小车的某个舵机在运动。

### 光敏扩展功能

我们利用了小车的光敏功能，让小车会觉得“困”。如果光照降低，小车的移动速度会变慢。

## 技术实现细节

### 表演功能

我们用一个间隔较长的计时器，每次超时时发送不同的操作指令，执行不同的动作。

### 光敏功能

我们利用HamamatsuS1087ParC调用telosb节点上的光敏传感器，定时收集数据。

### 用PrintfC确定摇杆的数值

我们在调试时发现难以确定摇杆静止时X和Y的数值，这给我们编写发出控制指令的代码带来了困难。我们在代码中使用了printf和printfflush函数，用数据线连接到pc并启动java client查看输出，帮助我们确定摇杆和按键的数值。

## 遇到的困难和解决方案

### Button D不响应

D按钮在没有按下时仍然处于长时间的低电平。我们最初试图用手指短接遥控器背后的两个触点来“弹起”D按钮，但是最终因为太麻烦，修改了按钮的控制方案，不使用D按钮。

### 不能一次向STM32写入多个指令

在归位舵机时我们发现不能一次性向STM32写入多条指令来同时改变多个状态。我们利用定时器分别执行三个舵机的复位指令，并且在Car已经静止时不会多次写入Pause指令，解决了多条指令同时写入的冲突问题。

### 控制的方向问题

我们在实验中发现，摇杆X和Y的正方向，以及写入左转和右转指令的方向和我们预期的不同。我们通过printf和实际在小车上实验确定了摇杆在各个位置时X和Y的取值，找到了正确的控制方向。