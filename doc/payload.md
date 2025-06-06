# 载荷（Payload）开发说明

## 载荷数据接收

在`VkSdkInstance`中有个信号（在`vkqtsdk.h`文件里）

```C++
    // 当收到载荷数据时，会触发这个信号
    void payloadDataReceived(int sysid, int addr, const QByteArray &payload);
```

当飞控收到载荷数据后，会将载荷数据通过这个信号发射出来，`sysid`代表载荷所在飞机的sysid，`addr`代表载荷在所在飞机上标记的地址（因为一个飞机可以挂载多个载荷，不同载荷用不同地址标识），`payload`是载荷数据。

用户收到载荷数据后可以自行依据载荷协议解析。

## 载荷数据发送

在`VkSdkInstance`中有个信号（在`vkqtsdk.h`文件里）

```C++
    // 这个信号用于发送载荷命令
    void payloadCommand(int sysid, int addr, const QByteArray &command);
```

当用户想向载荷发送数据时，通过发射这个信号就可以实现。`sysid`代表载荷所在飞机的sysid，`addr`代表载荷在所在飞机上标记的地址，`payload`是载荷数据。

**注意：发射信号后载荷数据会立刻发送，不会有命令返回是否发送成功。如果载荷本身有ACK机制，用户需要通过接收载荷数据来自行判断。**

## 载荷数据与QML整合

在`VkVehicle`中有个属性（在`vehicle.h`文件里）

```C++
    Q_PROPERTY(QQmlPropertyMap* payload READ getPayload CONSTANT)
```

这个属性用于将载荷数据加入QML中，以便在QML中使用。如下所示：

```C++
    auto inst = VkSdkInstance::instance();
    auto manager = inst->getManager();
    auto vehicle = manager->getVehicle(sysid);

    auto obj = new MyPayloadObj(sysid);
    connect(obj, &MyPayloadObj::dataSending, this, &MyPayload::sendPayload);
    auto payload = vehicle->getPayload();
    if (!payload->contains("myobj")) {
        payload->insert("myobj", QVariant::fromValue(obj));
    }
```

之后在QML中使用方式如下所示：

```QML
    VkSdkInstance.vehicleManager.activeVehicle.payload.myobj.myFunction()
```
