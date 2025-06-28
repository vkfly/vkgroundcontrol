/*
 * VKSDK implemented with Qt
 */

#pragma once

#include <QObject>
#include <QList>
#include <QString>

class VkObjManager;
class Vk_RcInfo;

Q_MOC_INCLUDE("objmanager.h")

class VkSdkInstance : public QObject {
    Q_OBJECT

    Q_PROPERTY(VkObjManager* vehicleManager READ getManager CONSTANT)
    Q_PROPERTY(Vk_RcInfo *rcInfo READ getRcInfo CONSTANT)

public:
    /**
     * @brief Starts the link with a given schema.
     * @param schema The schema to use for the link. The supported schemas are "udp", "tcp", "serial".
     *      Example: "udp://127.0.0.1:14540" for UDP connection,
     *               "tcp://127.0.0.1:14540" for TCP connection,
     *               "serial:///dev/ttyUSB0:115200:8N1" for serial port connection.
     */
    Q_INVOKABLE virtual void startLink(QString schema) = 0;
    Q_INVOKABLE virtual void startRcLink(QString schema) = 0;

    /**
     * @brief Stops the link with the vehicle.
     */
    Q_INVOKABLE virtual void stopLink() = 0;

    /**
     * @brief enumerate available serial ports
     */
    Q_INVOKABLE virtual QList<QString> availableSerialPorts() = 0;

    Q_INVOKABLE virtual void saveLinkConfig(const QStringList &config) = 0;
    Q_INVOKABLE virtual QStringList loadLinkConfig() = 0;

signals:
    void commandAck(int sysid, int cmdid, int errcode);

    // 当收到载荷数据时，会触发这个信号
    void payloadDataReceived(int sysid, int addr, const QByteArray &payload);

    // 这个信号用于发送载荷命令
    void payloadCommand(int sysid, int addr, const QByteArray &command);

public:
    virtual VkObjManager *getManager() = 0;

protected:
    virtual Vk_RcInfo *getRcInfo() = 0;

    explicit VkSdkInstance(QObject *parent = nullptr) : QObject(parent) {}
    ~VkSdkInstance() {}

public:
    static void initSdk(const QString &userid, const QString &signature);
    static void registerQmlData();
    static VkSdkInstance *instance();
};

class VkSdk : public QObject {
    Q_OBJECT

public:
    // data types
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

    enum VKFLY_SYS_STATUS_SENSOR_EXTEND {
        VKFLY_SYS_STATUS_SENSOR_GPS2 = 4,             /* GPS2 | */
        VKFLY_SYS_STATUS_SENSOR_RTK_GPS = 8,          /* RTK GPS | */
        VKFLY_SYS_STATUS_SDCARD = 16,                 /* Onboard SD card | */
        VKFLY_SYS_STATUS_SENSOR_EXTEND_ENUM_END = 17, /*  | */
    };
    Q_ENUM(VKFLY_SYS_STATUS_SENSOR_EXTEND)

    enum VKFLY_CUSTOM_MODE {
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
        VKFLY_CUSTOM_MODE_ENUM_END = 29     /*  | */
    };
};
