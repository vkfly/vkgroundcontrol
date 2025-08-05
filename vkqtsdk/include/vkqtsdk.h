/*
 * VKSDK implemented with Qt
 */

#pragma once

#include <QList>
#include <QObject>
#include <QString>

class VkObjManager;
class Vk_RcInfo;
class VkServerController;

Q_MOC_INCLUDE("objmanager.h")
Q_MOC_INCLUDE("vkservercontroller.h")

/**
 * @class VkSdkInstance
 * @brief VK SDK实例类
 *
 * 该类是VK SDK的主要接口类，提供与无人机设备的连接管理、
 * 数据通信和控制功能。支持多种通信协议包括UDP、TCP、串口和4G连接。
 *
 * 主要功能：
 * - 设备连接管理：建立和断开与无人机的通信链路
 * - 遥控器连接：管理遥控器设备的连接
 * - 串口枚举：获取系统可用的串口列表
 * - 配置管理：保存和加载连接配置
 * - 载荷通信：处理载荷设备的数据收发
 * - 命令确认：处理设备命令执行结果
 */
class VkSdkInstance : public QObject {
    Q_OBJECT

    /**
     * @property vehicleManager
     * @brief 设备管理器
     * 用于管理所有连接的无人机设备，提供设备列表和设备操作接口
     */
    Q_PROPERTY(VkObjManager *vehicleManager READ getManager CONSTANT)

    /**
     * @property rcInfo
     * @brief 遥控器信息
     * 包含遥控器的连接状态、信号强度和通道数据等信息
     */
    Q_PROPERTY(Vk_RcInfo *rcInfo READ getRcInfo CONSTANT)

    Q_PROPERTY(VkServerController *vkServerController READ getVkServerController CONSTANT)

public:
    /**
     * @brief Starts the link with a given schema.
     * @param schema The schema to use for the link. The supported schemas are "udp", "tcp", "serial".
     *      Example: "udp://127.0.0.1:14540" for UDP connection,
     *               "tcp://127.0.0.1:14540" for TCP connection,
     *               "serial:///dev/ttyUSB0:115200:8N1" for serial port connection.
     *               "4g://127.0.0.1:7001?xxxxxxxxxxxxxxxxx" for 4G connection (for VK4G only)
     */
    Q_INVOKABLE virtual void startLink(QString schema) = 0;

    /**
     * @brief 启动遥控器连接
     * @param schema 遥控器连接协议字符串，支持的协议包括"udp"、"tcp"、"serial"
     *      示例："udp://127.0.0.1:14540" UDP连接
     *            "tcp://127.0.0.1:14540" TCP连接
     *            "serial:///dev/ttyUSB0:115200:8N1" 串口连接
     */
    Q_INVOKABLE virtual void startRcLink(QString schema) = 0;

    /**
     * @brief Stops the link with the vehicle.
     */
    Q_INVOKABLE virtual void stopLink() = 0;

    /**
     * @brief enumerate available serial ports
     */
    Q_INVOKABLE virtual QList<QString> availableSerialPorts() = 0;

    /**
     * @brief 保存连接配置
     * @param config 连接配置参数列表，包含协议、地址、端口等信息
     */
    Q_INVOKABLE virtual void saveLinkConfig(const QStringList &config) = 0;

    /**
     * @brief 加载连接配置
     * @return 返回已保存的连接配置参数列表
     */
    Q_INVOKABLE virtual QStringList loadLinkConfig() = 0;

signals:
    /**
     * @brief 命令确认信号
     * @param sysid 系统ID
     * @param cmdid 命令ID
     * @param errcode 错误码，0表示成功，非0表示失败
     * 当设备执行命令后发出确认信号
     */
    void commandAck(int sysid, int cmdid, int errcode);

    /**
     * @brief 载荷数据接收信号
     * @param sysid 系统ID
     * @param addr 载荷设备地址
     * @param payload 载荷数据内容
     * 当收到载荷设备发送的数据时触发此信号
     */
    void payloadDataReceived(int sysid, int addr, const QByteArray &payload);

    /**
     * @brief 载荷命令发送信号
     * @param sysid 系统ID
     * @param addr 载荷设备地址
     * @param command 要发送的命令数据
     * 用于向载荷设备发送控制命令
     */
    void payloadCommand(int sysid, int addr, const QByteArray &command);

public:
    /**
     * @brief 获取设备管理器
     * @return 返回设备管理器指针，用于管理所有连接的无人机设备
     */
    virtual VkObjManager *getManager() = 0;

protected:
    /**
     * @brief 获取遥控器信息
     * @return 返回遥控器信息指针，包含遥控器状态和数据
     */
    virtual Vk_RcInfo *getRcInfo() = 0;

    explicit VkSdkInstance(QObject *parent = nullptr) : QObject(parent) {}

    ~VkSdkInstance() {}

    virtual VkServerController *getVkServerController() = 0;
public:
    /**
     * @brief 初始化SDK
     * @param userid 用户ID
     * @param signature 用户签名
     */
    static void initSdk(const QString &userid, const QString &signature);

    /**
     * @brief 注册QML数据类型
     * 将SDK相关的数据类型注册到QML系统中，使其可在QML中使用
     */
    static void registerQmlData();

    /**
     * @brief 获取SDK实例
     * @return 返回SDK单例实例指针
     */
    static VkSdkInstance *instance();
};

/**
 * @class VkSdk
 * @brief VK SDK数据类型定义类
 *
 * 该类定义了VK SDK中使用的各种枚举类型和常量，包括：
 * - 无人机机型类型：定义支持的各种无人机构型
 * - 组件ID：定义系统中各个组件的标识符
 * - 解锁拒绝原因：定义无人机无法解锁的各种原因
 * - 失效保护动作：定义系统异常时的应对措施
 * - 传感器扩展状态：定义扩展传感器的状态标识
 * - 自定义飞行模式：定义各种飞行模式的标识
 */
class VkSdk : public QObject {
    Q_OBJECT

public:
    /**
     * @enum VKFLY_AP_TYPE
     * @brief 无人机机型类型枚举
     * 定义了支持的各种无人机构型，包括多旋翼、固定翼等不同配置
     */
    enum VKFLY_AP_TYPE {
        VKFLY_AP_TYPE_I4 = 41,        /* I4 | */
        VKFLY_AP_TYPE_X4 = 42,        /* X4 | */
        VKFLY_AP_TYPE_I6 = 61,        /* I6 | */
        VKFLY_AP_TYPE_X6 = 62,        /* X6 | */
        VKFLY_AP_TYPE_YI6D = 63,      /* YI6D | */
        VKFLY_AP_TYPE_Y6D = 64,       /*  Y6D | */
        VKFLY_AP_TYPE_H6 = 65,        /* H6 | */
        VKFLY_AP_TYPE_I8 = 81,        /* I8 | */
        VKFLY_AP_TYPE_X8 = 82,        /*  X8 | */
        VKFLY_AP_TYPE_4X8M = 83,      /* 4轴8桨 | */
        VKFLY_AP_TYPE_4X8D = 84,      /* 4轴8桨 */
        VKFLY_AP_TYPE_4X8MR = 85,     /* 4轴8桨  */
        VKFLY_AP_TYPE_4X8DR = 86,     /* 4轴8桨*/
        VKFLY_AP_TYPE_6I12 = 121,     /* 6轴12桨, 十字布局 */
        VKFLY_AP_TYPE_6X12 = 122,     /* 6轴12桨, X字布局 */
        VKFLY_AP_TYPE_6H12 = 123,     /* 6轴12桨, H字布局 */
        VKFLY_AP_TYPE_8I16 = 161,     /* 8轴16桨, 十字布局 */
        VKFLY_AP_TYPE_8X16 = 162,     /* 8轴16桨, X字布局 */
        VKFLY_AP_TYPE_ENUM_END = 163, /*  | */
    };
    Q_ENUM(VKFLY_AP_TYPE)

    /**
     * @enum VKFLY_USER_COMP_ID
     * @brief 用户组件ID枚举
     * 定义了系统中各个组件的唯一标识符，包括GPS、雷达、电池、ECU等设备
     */
    enum VKFLY_USER_COMP_ID {
        VKFLY_COMP_ID_VKGPSA = 3,         /* 普通 GPSA | */
        VKFLY_COMP_ID_VKGPSB = 4,         /* 普通 GPSB | */
        VKFLY_COMP_ID_RFD_F = 5,          /* 前雷达 | */
        VKFLY_COMP_ID_RFD_R = 6,          /* 后雷达 | */
        VKFLY_COMP_ID_RFD_D = 7,          /* 下雷达 | */
        VKFLY_COMP_ID_RFD_360 = 8,        /* 360雷达 | */
        VKFLY_COMP_ID_BAT0 = 10,          /* 电池0 | */
        VKFLY_COMP_ID_BAT1 = 11,          /* 电池1 | */
        VKFLY_COMP_ID_BAT2 = 12,          /* 电池2 | */
        VKFLY_COMP_ID_BAT3 = 13,          /* 电池3 | */
        VKFLY_COMP_ID_BAT4 = 14,          /* 电池4 | */
        VKFLY_COMP_ID_BAT5 = 15,          /* 电池5 | */
        VKFLY_COMP_ID_ECU0 = 16,          /* 发动机 ECU0 | */
        VKFLY_COMP_ID_ECU1 = 17,          /* 发动机 ECU1 | */
        VKFLY_COMP_ID_ECU2 = 18,          /* 发动机 ECU2 | */
        VKFLY_COMP_ID_ECU3 = 19,          /* 发动机 ECU3 | */
        VKFLY_COMP_ID_WEIGHER = 20,       /* 称重器  | */
        VKFLY_USER_COMP_ID_ENUM_END = 21, /*  | */
    };
    Q_ENUM(VKFLY_USER_COMP_ID)

    /**
     * @enum VKFLY_ARM_DENIED_REASON
     * @brief 解锁拒绝原因枚举
     * 定义了无人机无法解锁的各种原因，用于安全检查和故障诊断
     */
    enum VKFLY_ARM_DENIED_REASON {
        VKFLY_ARM_DENIED_REASON_NONE = 0,          /*  | */
        VKFLY_ARM_DENIED_NO_INS = 1,               /* 航姿数据异常 | */
        VKFLY_ARM_DENIED_SPD_OVER_LIM = 2,         /* 速度过大 | */
        VKFLY_ARM_DENIED_ACC_OVER_LIM = 3,         /* 加速度过大 | */
        VKFLY_ARM_DENIED_GYR_OVER_LIM = 4,         /* 角速度过大 | */
        VKFLY_ARM_DENIED_GPS_ERR = 5,              /* GPS 异常 | */
        VKFLY_ARM_DENIED_IMU_ERR = 6,              /* IMU 异常 | */
        VKFLY_ARM_DENIED_POS_NOT_FIXED = 7,        /* 未定位 | */
        VKFLY_ARM_DENIED_RTK_NOT_FIXED = 8,        /* RTK未锁定 | */
        VKFLY_ARM_DENIED_MAG_ERR = 9,              /* 磁异常 | */
        VKFLY_ARM_DENIED_RESERVE = 10,             /* 预留 | */
        VKFLY_ARM_DENIED_TEMP_OVER_LIM = 11,       /* 温度过热 | */
        VKFLY_ARM_DENIED_OUT_FENCE = 13,           /* 超出电子围栏范围 | */
        VKFLY_ARM_DENIED_LOW_BAT_VOLT = 14,        /* 电池电压低 | */
        VKFLY_ARM_DENIED_LOW_BAT_CAP = 15,         /* 电池电量低 | */
        VKFLY_ARM_DENIED_BAT_BMS_FAULT = 16,       /* 电池BMS故障 | */
        VKFLY_ARM_DENIED_SERVO_FAULT = 17,         /* 动力故障 | */
        VKFLY_ARM_DENIED_LEAN_ANG = 18,            /* 倾斜角过大 | */
        VKFLY_ARM_DENIED_IN_CALIBRATION = 19,      /* 正在校准中 | */
        VKFLY_ARM_DENIED_HYDRO_BMS_CHECK_ERR = 20, /* 氢电池自检故障 | */
        VKFLY_ARM_DENIED_FUEL_LOW = 21,            /* 发动机油量低 | */
        VKFLY_ARM_DENIED_H2P_LOW = 22,             /* 氢能气压低 | */
        VKFLY_ARM_DENIED_REASON_ENUM_END = 23,     /*  | */
    };
    Q_ENUM(VKFLY_ARM_DENIED_REASON)

    /**
     * @enum VKFLY_FS_ACTION
     * @brief 失效保护动作枚举
     * 定义了系统异常或失效时可执行的各种应对措施
     */
    enum VKFLY_FS_ACTION {
        FAIL_SAFE_ACT_NONE = 0,       /* 无动作 | */
        FAIL_SAFE_ACT_LOITER = 1,     /* 悬停 | */
        FAIL_SAFE_ACT_RTL = 2,        /* 返航(回起飞点) | */
        FAIL_SAFE_ACT_RTR = 3,        /* 去往备降点(最近的 rally 点) | */
        FAIL_SAFE_ACT_LAND = 4,       /* 原地降落 | */
        FAIL_SAFE_ACT_LOCK = 5,       /* 停桨上锁 | */
        VKFLY_FS_ACTION_ENUM_END = 6, /*  | */
    };
    Q_ENUM(VKFLY_FS_ACTION)

    /**
     * @enum VKFLY_SYS_STATUS_SENSOR_EXTEND
     * @brief 系统状态传感器扩展枚举
     * 定义了扩展传感器和设备的状态标识位
     */
    enum VKFLY_SYS_STATUS_SENSOR_EXTEND {
        VKFLY_SYS_STATUS_SENSOR_GPS2 = 4,             /* GPS2 | */
        VKFLY_SYS_STATUS_SENSOR_RTK_GPS = 8,          /* RTK GPS | */
        VKFLY_SYS_STATUS_SDCARD = 16,                 /* Onboard SD card | */
        VKFLY_SYS_STATUS_SENSOR_EXTEND_ENUM_END = 17, /*  | */
    };
    Q_ENUM(VKFLY_SYS_STATUS_SENSOR_EXTEND)

    /**
     * @enum VKFLY_CUSTOM_MODE
     * @brief 自定义飞行模式枚举
     * 定义了无人机支持的各种飞行模式，包括手动模式、自动模式等
     */
    enum VKFLY_CUSTOM_MODE {
        VKFLY_CUSTOM_MODE_STANDBY = 1,      /* Standby mode | 待命模式 */
        VKFLY_CUSTOM_MODE_ATTITUDE = 3,     /* Attitude mode 姿态模式 | */
        VKFLY_CUSTOM_MODE_POSHOLD = 4,      /* Poshold mode 定点模式| */
        VKFLY_CUSTOM_MODE_TAKEOFF = 10,     /* Auto takeoff. 自动起飞| */
        VKFLY_CUSTOM_MODE_LOITER = 11,      /* Auto loiter. 自动悬停| */
        VKFLY_CUSTOM_MODE_RTL = 12,         /* Auto return. 自动返航| */
        VKFLY_CUSTOM_MODE_CRUISE = 15,      /* Auto cruise. 自动巡航| */
        VKFLY_CUSTOM_MODE_GUIDE = 18,       /* Guide to point. 指点飞行| */
        VKFLY_CUSTOM_MODE_LAND = 19,        /* Land. 降落| */
        VKFLY_CUSTOM_MODE_FSLAND = 20,      /* Force land. 迫降| */
        VKFLY_CUSTOM_MODE_FOLLOW = 21,      /* Follow. 跟随| */
        VKFLY_CUSTOM_MODE_WP_ORBIT = 23,    /* WP_Orbit 航点环绕| */
        VKFLY_CUSTOM_MODE_DYN_TAKEOFF = 24, /* Dyn_Takeoff  动平台起飞| */
        VKFLY_CUSTOM_MODE_DYN_LAND = 25,    /* Dyn_Land 动平台降落| */
        VKFLY_CUSTOM_MODE_OBAVOID = 26,     /* Obavoid  自主避障| */
        VKFLY_CUSTOM_MODE_OFFBOARD = 27,    /* Offboard command control. OFFBORAD 控制| */
        VKFLY_CUSTOM_MODE_FORMATION = 28,   /* Formation 队形编队 */
        VKFLY_CUSTOM_MODE_FW_MANUL = 51,    /* Fixedwing Manul 固定翼手动 | */
        VKFLY_CUSTOM_MODE_FW_ATTITUDE = 52, /* Fixedwing Attitude 固定翼增稳定 | */
        VKFLY_CUSTOM_MODE_FW_CRUISE = 53,   /* Fixedwing Cruise 固定翼巡航 | */
        VKFLY_CUSTOM_MODE_FW_CIRCLE = 54,   /* Fixedwing Circle 固定翼盘旋 | */
        VKFLY_CUSTOM_MODE_FW_TAKEOFF = 55,  /* Fixedwing Takeoff 固定翼起飞 | */
        VKFLY_CUSTOM_MODE_FW_GUIDE = 56,    /* Fixedwing Guide 固定翼指点飞行 | */
        VKFLY_CUSTOM_MODE_FW_LAND = 57,     /* Fixedwing Land 固定翼降落 | */
        VKFLY_CUSTOM_MODE_FW_RTL = 58,      /* Fixedwing Rtl 固定翼返航 | */
        VKFLY_CUSTOM_MODE_FW_GPS_FS = 59,   /* Fixedwing GpsFs 固定翼丢星盘旋 | */
        VKFLY_CUSTOM_MODE_ENUM_END = 60,    /*  | */
    };
};
