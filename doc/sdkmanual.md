# SDK使用方法

当前SDK是面向QML的方案，将底层的对象注册到QML层，用户只需要使用Javascript就可以进行地面站的开发。

## 源码目录结构

```
vkgc +
     |
```

## LICENSE机制

使用SDK需要从微克开发者网站上获取LICENSE，否则SDK无法正常使用。

获取LICENSE方法。。。

在项目根目录下的CMakeLists.txt中，找到下面的内容：

```
#######################################################
#                Custom Build Configuration
#######################################################

add_definitions(
    -DVK_USER_ID="xxxxxx"
    -DVK_SDK_LICENSE="xxxxxxx"
)

include(CustomOptions)
```

将从网站上获得的USERID和LINCENSE复制进去。

## 初始化SDK

在QGCApplication.cc中

```C++
void QGCApplication::init() {
    ...
    VkSdkInstance::initSdk(VK_USER_ID, VK_SDK_LICENSE);
    VkSdkInstance::registerQmlData();
    ...
}
```

`VkSdkInstance::initSdk(VK_USER_ID, VK_SDK_LICENSE);`

这个函数传入在CMakeLists.txt中预定义的USERID和LICENSE，初始化SDK。

`VkSdkInstance::registerQmlData();`

这个函数将SDK中相关的对象注册到QML中，用户可以在QML中直接使用。

## API

### 链接管理API

通过多种端口连接无人机（飞控）。

```JavaScript
// 打开一个连接
// 参数：schema用来表示连接的参数。支持"udp", "tcp", "serial".
// 示例:
//  "udp://127.0.0.1:14540"表示一个UDP连接,
//  "tcp://127.0.0.1:14540"表示一个TCP连接,
//  "serial://COM3:115200:8N1"表示一个串口连接.
VkSdkInstance.startLink(schema)

// 中断当前连接
VkSdkInstance.stopLink()

// 返回当前系统中所有的串口名
VkSdkInstance.availableSerialPorts()
```

## 属性/对象

### VehicleManager

```JavaScript
VkSdkInstance.vehicleManager
```

`vehicleManager`管理所有的无人机对象。它包含以下属性：

属性|说明
---|---
activeVehicle | 当前正在操作的无人机（Vehicle）对象
vehicles | 当前所有连接的无人机列表

### Vehicle

Vehicle对象是VKGCS中的核心对象，开发者基本所有操作都是在跟Vehicle对象打交道。

它包含以下属性（更多属性还在添加中）：

```JavaScript
VkSdkInstance.vehicleManager.activeVehicle.attitude
```

属性|说明
---|---
id | 当前无人机system id（1-254）
coordinate | 当前坐标（经纬度）
home | 当前HOME点坐标（经纬度）
sysStatus | 系统状态信息（包含系统组件状态、电池电量等）
GNSS1 | 主GNSS信息（经纬度，速度，方向等）
GNSS2 | 从GNSS信息
RtkMsg | RTK信息
attitude | 无人机姿态信息（欧拉角及角速度）
servoOutputRaw | 伺服电机输出信息
rcChannels | 遥控器通道输入信息
componentVersion | 无人机各组件信息
fmuStatus | 主控状态信息
insStatus | 惯导状态信息
parameters | 飞控参数表
mission | 航线信息

Vehicle也包含多个方法，用于给无人机（飞控）发送指令，控制无人机（更多方法还在添加中）：

方法|说明
---|---
takeOff | 起飞指令
land | 降落指令
setParam | 设置参数
uploadMission | 上传航线给飞控
downloadMission | 下载飞控内保存的航点


