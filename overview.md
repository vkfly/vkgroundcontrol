# VKSDK总体规划

## 代码存放位置

1. 私有库，放到私有代码库里（http://gitlab.jiagutech.com），包括SDK代码、不想开源的地面站代码和其他SDK的测试代码。
1. 开源代码，放到公共库里（https://github.com），包括SDK（dll、so）、开源的地面站代码、Wiki文档（中英文）、示例代码等。

## SDK代码构成

1. 协议封装
1. 与QML通信的封装
1. 载荷协议的封装
1. Android系统上对于各家遥控器的封装
1. 规划算法封装

## SDK整体实现方案

### SDK设计目标：

避免暴露具体的协议信息和交互逻辑

### 协议封装

在C++中构造一个SDK实例，并将这个实例注册到QML上下文中，作为一个全局对象使用
```CPP
// 生成SDK实例
VkSdkInstance *_instance = new VkSdkInstance();
// 将实例注册到QML上下文
engine.rootContext()->setContextProperty("sdkInstance", _instance);
```

SDK实例中提供多种signal用来emit数据，不同的信号对应不同的数据类型（这个数据可以不是mavlink数据，是SDK封装后的数据）
```CPP
class VkSdkInstance : public QObject {
    Q_OBJECT
    ....
signals:
    void position(const PositionData &pos);
    ....
};
```

在QML中连接这个signal
```QML
Connections {
    target: sdkInstance
    onPosition: {
        // process pos
    }
}
```

SDK实例中提供上层函数用于给飞控发指令
```CPP
class VkSdkInstance : public QObject {
    Q_OBJECT
    ....
public:
    Q_INVOKABLE void takeOff();
    Q_INVOKABLE void uploadWaypoints(Waypoint *wps, int count);
    ....
};
```

QML中可以直接调用这些函数
```QML
sdkInstance.takeOff()
```

相关的数据类型都需要在SDK中注册到QML环境中，所有的初始化工作可以在一个SdkInit函数中实现，该函数必须在最开始调用。

### 遥控器封装

遥控器功能的封装用Android的原生方式实现，使用ControllerFactory来自动识别和创建遥控器实例。

每个遥控器实例暴露一个与飞控的通信接口`IComm`
```JAVA
interface IComm {
    void send(byte[] data)
    int recv(byte[] data)
}
```

ControllerFactory开启一个UDP服务。地面站连接这个UDP服务之后，这个UDP服务把从遥控器数传接口读到的数据转发给地面站，把从地面站发下来的数据转发给遥控器数传接口。

如果地面站今后还要支持遥控器的相关操作，需要ControllerFactory开启另外一个UDP服务，用来封装遥控器相关的数据通信。