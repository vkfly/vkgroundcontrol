/*
 * Data type in VKSDK
 */

#pragma once

#include <QList>
#include <QObject>

class VkHeartbeat;
class VkSysStatus;
class VkGpsInput;
class VkGps2Raw;
class VkAttitude;
class VkMissionItem;
class VkMissionCurrent;
class VkComponentVersion;
class VkFmuStatus;
class VkVfrHud;
class VkObstacleDistance;
class VkHighLatency;
class VkScaledImuStatus;
class VkWeigherState;
class VkParachuteStatus;
class VkBmsStatus;
class VkFormationLeaderStatus;

//----------------------- 遥控器信息 -----------------------
/**
 * @class Vk_RcInfo
 * @brief 遥控器状态信息类
 * @details 管理遥控器设备的基本信息，包括型号识别和信号强度监控。
 *          数据通过遥控器链路直接传输，格式为字符串协议（"type:型号" 和 "rssi:强度值"）
 */
class Vk_RcInfo : public QObject {
    Q_OBJECT

    /**
     * @brief 遥控器设备型号标识
     * @details 存储当前连接的遥控器设备型号信息，用于识别遥控器类型和兼容性检查。
     *          数据来源：遥控器通过 "type:型号" 格式的字符串协议传输
     */
    Q_PROPERTY(QString model READ rcModel NOTIFY modelUpdated)

    /**
     * @brief 遥控器信号强度指示值
     * @details RSSI（Received Signal Strength Indicator）值，表示遥控器与接收器之间的无线信号强度。
     *          数值越大表示信号越强，用于评估通信质量和连接稳定性。
     *          数据来源：遥控器通过 "rssi:强度值" 格式的字符串协议传输
     */
    Q_PROPERTY(int rssi READ rssiValue NOTIFY rssiUpdated)

public:
    explicit Vk_RcInfo(QObject *parent = nullptr) : QObject(parent) {}

    void updateRcModel(const QString &model) {
        if (_rc_model != model) {
            _rc_model = model;
            emit modelUpdated();
        }
    }

    void updateRssi(int rssi) {
        if (_rssi != rssi) {
            _rssi = rssi;
            emit rssiUpdated();
        }
    }

    QString rcModel() { return _rc_model; }
    int rssiValue() { return _rssi; }

signals:

    void modelUpdated();
    void rssiUpdated();

private:
    QString _rc_model;
    int _rssi;
};

//----------------------- 心跳包状态 -----------------------

/**
 * @class Vk_Heartbeat
 * @brief 飞控心跳包数据模型类
 * @details 主要功能：
 * - 监控飞控系统运行状态
 * - 获取飞控工作模式信息
 * - 检测飞控锁定/解锁状态
 * - 识别飞控硬件和软件类型
 */

class Vk_Heartbeat : public QObject {
    Q_OBJECT

    /**
     * @brief 飞控自定义模式代码
     * @details
     * - 1: VKFLY_CUSTOM_MODE_STANDBY - 待命模式
     * - 3: VKFLY_CUSTOM_MODE_ATTITUDE - 姿态模式
     * - 4: VKFLY_CUSTOM_MODE_POSHOLD - 定点模式
     * - 10: VKFLY_CUSTOM_MODE_TAKEOFF - 自动起飞
     * - 11: VKFLY_CUSTOM_MODE_LOITER - 自动悬停
     * - 12: VKFLY_CUSTOM_MODE_RTL - 自动返航
     * - 15: VKFLY_CUSTOM_MODE_CRUISE - 自动巡航
     * - 18: VKFLY_CUSTOM_MODE_GUIDE - 指点飞行
     * - 19: VKFLY_CUSTOM_MODE_LAND - 降落
     * - 20: VKFLY_CUSTOM_MODE_FSLAND - 迫降
     * - 21: VKFLY_CUSTOM_MODE_FOLLOW - 跟随
     * - 23: VKFLY_CUSTOM_MODE_WP_ORBIT - 航点环绕
     * - 24: VKFLY_CUSTOM_MODE_DYN_TAKEOFF - 动平台起飞
     * - 25: VKFLY_CUSTOM_MODE_DYN_LAND - 动平台降落
     * - 26: VKFLY_CUSTOM_MODE_OBAVOID - 自主避障
     * - 27: VKFLY_CUSTOM_MODE_OFFBOARD - OFFBOARD控制
     * - 28: VKFLY_CUSTOM_MODE_FORMATION - 队形编队
     * - 51: VKFLY_CUSTOM_MODE_FW_MANUL - 固定翼手动
     * - 52: VKFLY_CUSTOM_MODE_FW_ATTITUDE - 固定翼增稳
     * - 53: VKFLY_CUSTOM_MODE_FW_CRUISE - 固定翼巡航
     * - 54: VKFLY_CUSTOM_MODE_FW_CIRCLE - 固定翼盘旋
     * - 55: VKFLY_CUSTOM_MODE_FW_TAKEOFF - 固定翼起飞
     * - 56: VKFLY_CUSTOM_MODE_FW_GUIDE - 固定翼指点飞行
     * - 57: VKFLY_CUSTOM_MODE_FW_LAND - 固定翼降落
     * - 58: VKFLY_CUSTOM_MODE_FW_RTL - 固定翼返航
     * - 59: VKFLY_CUSTOM_MODE_FW_GPS_FS - 固定翼丢星盘旋
     */
    Q_PROPERTY(quint32 heartbeatCustomMode READ heartbeatCustomMode NOTIFY statusUpdated)
    /**
     * @brief 飞控设备类型标识
     * @details
     * - 0: MAV_TYPE_GENERIC - 通用微型飞行器
     * - 1: MAV_TYPE_FIXED_WING - 固定翼飞机
     * - 2: MAV_TYPE_QUADROTOR - 四旋翼
     * - 3: MAV_TYPE_COAXIAL - 同轴直升机
     * - 4: MAV_TYPE_HELICOPTER - 带尾桨的普通直升机
     * - 5: MAV_TYPE_ANTENNA_TRACKER - 地面天线跟踪器
     * - 6: MAV_TYPE_GCS - 地面控制站
     * - 7: MAV_TYPE_AIRSHIP - 飞艇
     * - 8: MAV_TYPE_FREE_BALLOON - 自由气球
     * - 9: MAV_TYPE_ROCKET - 火箭
     * - 10: MAV_TYPE_GROUND_ROVER - 地面车辆
     * - 11: MAV_TYPE_SURFACE_BOAT - 水面船只
     * - 12: MAV_TYPE_SUBMARINE - 潜艇
     * - 13: MAV_TYPE_HEXAROTOR - 六旋翼
     * - 14: MAV_TYPE_OCTOROTOR - 八旋翼
     * - 15: MAV_TYPE_TRICOPTER - 三旋翼
     * - 16: MAV_TYPE_FLAPPING_WING - 扑翼机
     * - 17: MAV_TYPE_KITE - 风筝
     * - 18: MAV_TYPE_ONBOARD_CONTROLLER - 机载控制器
     * - 19: MAV_TYPE_VTOL_TAILSITTER_DUOROTOR - 双旋翼尾座式垂直起降
     * - 20: MAV_TYPE_VTOL_TAILSITTER_QUADROTOR - 四旋翼尾座式垂直起降
     * - 21: MAV_TYPE_VTOL_TILTROTOR - 倾转旋翼垂直起降
     * - 22: MAV_TYPE_VTOL_FIXEDROTOR - 固定旋翼垂直起降
     * - 23: MAV_TYPE_VTOL_TAILSITTER - 尾座式垂直起降
     * - 24: MAV_TYPE_VTOL_TILTWING - 倾转翼垂直起降
     * - 25: MAV_TYPE_VTOL_RESERVED5 - 垂直起降预留类型5
     * - 26: MAV_TYPE_GIMBAL - 云台
     * - 27: MAV_TYPE_ADSB - ADS-B系统
     * - 28: MAV_TYPE_PARAFOIL - 翼伞
     * - 29: MAV_TYPE_DODECAROTOR - 十二旋翼
     * - 30: MAV_TYPE_CAMERA - 相机
     * - 31: MAV_TYPE_CHARGING_STATION - 充电站
     * - 32: MAV_TYPE_FLARM - FLARM防撞系统
     * - 33: MAV_TYPE_SERVO - 舵机
     * - 34: MAV_TYPE_ODID - 开放无人机ID
     * - 35: MAV_TYPE_DECAROTOR - 十旋翼
     * - 36: MAV_TYPE_BATTERY - 电池
     * - 37: MAV_TYPE_PARACHUTE - 降落伞
     * - 38: MAV_TYPE_LOG - 日志
     * - 39: MAV_TYPE_OSD - 屏显
     * - 40: MAV_TYPE_IMU - 惯性测量单元
     * - 41: MAV_TYPE_GPS - GPS
     * - 42: MAV_TYPE_WINCH - 绞盘
     * - 43: MAV_TYPE_GENERIC_MULTIROTOR - 通用多旋翼
     */
    Q_PROPERTY(quint8 heartbeatType READ heartbeatType NOTIFY statusUpdated)
    /**
     * @brief 自动驾驶系统类型
     * @details
     * - 0: MAV_AUTOPILOT_GENERIC - 通用自动驾驶系统，全功能支持
     * - 1: MAV_AUTOPILOT_RESERVED - 预留，供未来使用
     * - 2: MAV_AUTOPILOT_SLUGS - SLUGS自动驾驶系统
     * - 3: MAV_AUTOPILOT_ARDUPILOTMEGA - ArduPilot系统（Plane/Copter/Rover/Sub/Tracker）
     * - 4: MAV_AUTOPILOT_OPENPILOT - OpenPilot自动驾驶系统
     * - 5: MAV_AUTOPILOT_GENERIC_WAYPOINTS_ONLY - 仅支持简单航点的通用自动驾驶
     * - 6: MAV_AUTOPILOT_GENERIC_WAYPOINTS_AND_SIMPLE_NAVIGATION_ONLY - 支持航点和简单导航的通用自动驾驶
     * - 7: MAV_AUTOPILOT_GENERIC_MISSION_FULL - 支持完整任务命令集的通用自动驾驶
     * - 8: MAV_AUTOPILOT_INVALID - 无效自动驾驶（如地面站或其他MAVLink组件）
     * - 9: MAV_AUTOPILOT_PPZ - PPZ UAV自动驾驶系统
     * - 10: MAV_AUTOPILOT_UDB - UAV开发板
     * - 11: MAV_AUTOPILOT_FP - FlexiPilot自动驾驶
     * - 12: MAV_AUTOPILOT_PX4 - PX4自动驾驶系统
     * - 13: MAV_AUTOPILOT_SMACCMPILOT - SMACCMPilot自动驾驶
     * - 14: MAV_AUTOPILOT_AUTOQUAD - AutoQuad自动驾驶
     * - 15: MAV_AUTOPILOT_ARMAZILA - Armazila自动驾驶
     * - 16: MAV_AUTOPILOT_AEROB - Aerob自动驾驶
     * - 17: MAV_AUTOPILOT_ASLUAV - ASLUAV自动驾驶
     * - 18: MAV_AUTOPILOT_SMARTAP - SmartAP自动驾驶
     * - 19: MAV_AUTOPILOT_AIRRAILS - AirRails自动驾驶
     * - 20: MAV_AUTOPILOT_REFLEX - Fusion Reflex自动驾驶
     * - 30: MAV_AUTOPILOT_VKFLY - 微克飞控自动驾驶系统
     *
     */
    Q_PROPERTY(quint8 heartbeatAutopilot READ heartbeatAutopilot NOTIFY statusUpdated)
    /**
     * @brief 飞控基础工作模式
     * @details
     * - 1 (0b00000001): MAV_MODE_FLAG_CUSTOM_MODE_ENABLED - 自定义模式启用
     * - 2 (0b00000010): MAV_MODE_FLAG_TEST_ENABLED - 测试模式启用
     * - 4 (0b00000100): MAV_MODE_FLAG_AUTO_ENABLED - 自主模式启用，系统自主寻找目标位置
     * - 8 (0b00001000): MAV_MODE_FLAG_GUIDED_ENABLED - 引导模式启用，系统飞行航点/任务项目
     * - 16 (0b00010000): MAV_MODE_FLAG_STABILIZE_ENABLED - 稳定模式启用，系统电子稳定姿态
     * - 32 (0b00100000): MAV_MODE_FLAG_HIL_ENABLED - 硬件在环仿真启用
     * - 64 (0b01000000): MAV_MODE_FLAG_MANUAL_INPUT_ENABLED - 手动输入启用
     * - 128 (0b10000000): MAV_MODE_FLAG_SAFETY_ARMED - 安全解锁，电机启用/运行/可启动
     *
     * @note：这是一个位掩码字段，多个标志可以同时设置。
     * 例如：值为 129 (128+1) 表示同时启用了解锁状态和自定义模式。
     */
    Q_PROPERTY(quint8 heartbeatBaseMode READ heartbeatBaseMode NOTIFY statusUpdated)
    /**
     * @brief 系统运行状态码
     * @details
     * - 0: MAV_STATE_UNINIT - 系统未初始化，状态未知
     * - 1: MAV_STATE_BOOT - 系统正在启动中
     * - 2: MAV_STATE_CALIBRATING - 系统正在校准中，未准备好飞行
     * - 3: MAV_STATE_STANDBY - 系统待机状态，可随时启动
     * - 4: MAV_STATE_ACTIVE - 系统活跃状态，可能已经起飞，电机已启动
     * - 5: MAV_STATE_CRITICAL - 系统处于非正常飞行模式（故障安全），但仍可导航
     * - 6: MAV_STATE_EMERGENCY - 系统处于紧急状态，失去部分或全部控制，正在迫降
     * - 7: MAV_STATE_POWEROFF - 系统正在执行关机序列
     * - 8: MAV_STATE_FLIGHT_TERMINATION - 系统正在终止飞行（故障安全或命令终止）
     */
    Q_PROPERTY(quint8 heartbeatSystemStatus READ heartbeatSystemStatus NOTIFY statusUpdated)
    /**
     * @brief 飞控锁定状态
     * @details 飞控电机锁定状态，0表示解锁，1表示锁定
     */
    Q_PROPERTY(int lockStatus READ getLockStatus NOTIFY statusUpdated)

public:
    explicit Vk_Heartbeat(QObject *parent = nullptr);
    void updateHeatBeatData(const struct VkHeartbeat *status);
    quint32 heartbeatCustomMode();
    quint8 heartbeatType();
    quint8 heartbeatAutopilot();
    quint8 heartbeatBaseMode();
    quint8 heartbeatSystemStatus();
    void updateLockStatus();

    quint8 getLockStatus();

signals:
    void statusUpdated();

private:
    VkHeartbeat *m_heatBeat;
    quint8 lock_status;
};

//----------------------- 日志系统 -----------------------

/**
 * @class VkLogEntry
 * @brief 飞控日志条目数据管理类
 * @details 该类用于管理和存储飞控系统中的日志文件信息。
 *          提供日志文件的基本属性访问，包括日志ID、时间戳和文件大小等关键信息。
 *          主要用于日志文件列表的显示和管理，支持日志文件的识别和选择操作。
 */
class VkLogEntry : public QObject {
    Q_OBJECT

    /**
     * @brief 日志文件唯一标识符
     * @details 该ID在飞控系统中是唯一的，用于日志文件的检索和下载操作。
     */
    Q_PROPERTY(int logid READ getId CONSTANT)
    /**
     * @brief 日志文件创建时间戳
     * @details 时间戳格式为UTC时间，自1970年1月1日以来的秒数，如果不可用则为0。
     *          用于日志文件的时间排序和筛选功能。
     */
    Q_PROPERTY(qint64 timestamp READ getTimestamp CONSTANT)
    /**
     * @brief 日志文件大小
     * @details 该值近似值，用于评估下载时间和存储空间需求。
     *          在日志管理界面中显示文件大小信息。
     */
    Q_PROPERTY(uint32_t size READ getSize CONSTANT)

public:
    explicit VkLogEntry(int id, qint64 ts, uint32_t size, QObject *parent = nullptr)
        : QObject(parent), _logid(id), _ts(ts), _size(size) {}

    virtual ~VkLogEntry() = default;

public:
    int getId() { return _logid; }
    qint64 getTimestamp() { return _ts; }
    uint32_t getSize() { return _size; }

    int _logid;
    qint64 _ts;
    uint32_t _size;
};

//----------------------- 系统状态 -----------------------
/**
 * @class VkSystemStatus
 * @brief 全局系统状态监控类
 * @details 该类用于监控并存储无人机系统的全局状态信息，包括传感器状态、通信质量指标、电池状态等。
 *          提供实时的系统状态数据更新和访问接口，用于系统状态监测、故障诊断和性能优化。
 */
class VkSystemStatus : public QObject {
    Q_OBJECT

    /**
     * @brief 机载控制器和传感器存在状态位图
     * @details 显示哪些机载控制器和传感器存在。值为0：不存在，值为1：存在
     */
    Q_PROPERTY(uint64_t onboardControlSensorsPresent READ systemStatusSensorsPresent NOTIFY statusUpdated)
    /**
     * @brief 机载控制器和传感器启用状态位图
     * @details 显示哪些机载控制器和传感器已启用。值为0：未启用，值为1：已启用
     */
    Q_PROPERTY(uint64_t onboardControlSensorsEnabled READ systemStatusSensorsEnabled NOTIFY statusUpdated)
    /**
     * @brief 机载控制器和传感器健康状态位图
     * @details 显示哪些机载控制器和传感器有错误（或正常运行）。值为0：错误，值为1：健康
     */
    Q_PROPERTY(uint64_t onboardControlSensorsHealth READ systemStatusSensorsHealth NOTIFY statusUpdated)
    /**
     * @brief 系统负载
     * @details 主循环时间的最大使用百分比，单位：十分之一百分比（d%），取值范围：[0-1000]，应始终低于1000
     */
    Q_PROPERTY(int systemLoad READ systemStatusLoad NOTIFY statusUpdated)

    /**
     * @brief 电池电压
     * @details 电池电压，单位：毫伏（mV），UINT16_MAX表示自驾仪未发送电压信息
     */
    Q_PROPERTY(float batteryVoltage READ systemStatusBatteryVoltage NOTIFY statusUpdated)
    /**
     * @brief 电池电流
     * @details 电池电流，单位：厘安培（cA），-1表示自驾仪未发送电流信息
     */
    Q_PROPERTY(float batteryCurrent READ systemStatusBatteryCurrent NOTIFY statusUpdated)
    /**
     * @brief 电池剩余电量
     * @details 电池剩余能量百分比，单位：百分比（%），-1表示自驾仪未发送剩余电量信息
     */
    Q_PROPERTY(int batteryRemaining READ systemStatusBatteryRemaining NOTIFY statusUpdated)

    /**
     * @brief 通信丢包率
     * @details 通信丢包率（UART、I2C、SPI、CAN），所有链路上的丢包（在MAV接收时损坏的数据包），单位：厘百分比（c%）
     */
    Q_PROPERTY(int commDropRate READ systemStatusDropRateComm NOTIFY statusUpdated)

    /**
     * @brief 通信错误计数
     * @details 通信错误（UART、I2C、SPI、CAN），所有链路上的丢包（在MAV接收时损坏的数据包）
     */
    Q_PROPERTY(int commErrors READ systemStatusCommErrors NOTIFY statusUpdated)
    /**
     * @brief 错误计数器
     * @details
     * - 位0 (1): GCS链路丢失
     * - 位1 (2): 电池电压低
     * - 位2 (4): 舵机输出平衡差
     * - 位3 (8): 舵机输出故障
     * - 位4 (16): 自驾仪系统温度过高
     * - 位5 (32): 自驾仪系统定位解算未就绪
     * - 位6 (64): 位置超出围栏范围
     * - 位7 (128): 避障MAVLink通信链路丢失
     * - 位8 (256): 电池BMS链路丢失
     * - 位9 (512): ECU燃料低
     * - 位10 (1024): ECU链路丢失
     * - 位11 (2048): 氢气压力低
     * - 位12 (4096): 超重
     */
    Q_PROPERTY(int errorCount1 READ systemStatusErrorCount1 NOTIFY statusUpdated)
    /**
     * @brief 预留
     */
    Q_PROPERTY(int errorCount2 READ systemStatusErrorCount2 NOTIFY statusUpdated)
    /**
     * @brief 预留
     */
    Q_PROPERTY(int errorCount3 READ systemStatusErrorCount3 NOTIFY statusUpdated)
    /**
     * @brief 预留
     */
    Q_PROPERTY(int errorCount4 READ systemStatusErrorCount4 NOTIFY statusUpdated)

public:
    explicit VkSystemStatus(QObject *parent = nullptr);

    void updateData(const VkSysStatus *status);
    uint64_t systemStatusSensorsPresent();
    uint64_t systemStatusSensorsEnabled();
    uint64_t systemStatusSensorsHealth();
    int systemStatusLoad();
    float systemStatusBatteryVoltage();
    float systemStatusBatteryCurrent();
    int systemStatusDropRateComm();
    int systemStatusCommErrors();
    int systemStatusErrorCount1();
    int systemStatusErrorCount2();
    int systemStatusErrorCount3();
    int systemStatusErrorCount4();
    int systemStatusBatteryRemaining();

signals:
    void statusUpdated();

private:
    VkSysStatus *m_status;
};

//----------------------- 电池管理系统 -----------------------
/**
 * @class Vk_QingxieBms
 * @brief 倾斜电池专用BMS管理类（用于氢燃料电池等特殊系统）
 * @details 监控氢燃料电池系统的特殊参数，包括电池电压、伺服电流、电堆电压等。
 */

class Vk_QingxieBms : public QObject {
    Q_OBJECT

    /**
     * @brief 电池电压
     * @details 单位：V，原始值(cV)除以100得到实际电压值
     */
    Q_PROPERTY(float batVoltage READ batVoltage NOTIFY statusUpdated)
    /**
     * @brief 伺服电流
     * @details 单位：A，原始值(cA)除以100得到实际电流值
     */
    Q_PROPERTY(float servoCurrent READ servoCurrent NOTIFY statusUpdated)
    /**
     * @brief 电堆电压
     * @details 单位：V，原始值(cV)除以100得到实际电压值
     */
    Q_PROPERTY(float stackVoltage READ stackVoltage NOTIFY statusUpdated)
    /**
     * @brief 伺服电压
     * @details 单位：V，原始值(cV)除以100得到实际电压值
     */
    Q_PROPERTY(float servoVoltage READ servoVoltage NOTIFY statusUpdated)
    /**
     * @brief 电池充电电流
     * @details 单位：A，原始值(cA)除以10得到实际电流值
     */
    Q_PROPERTY(float batRefuelCurrent READ batRefuelCurrent NOTIFY statusUpdated)

    /** @brief 气罐压力 */
    Q_PROPERTY(quint16 gasTankPressure READ gasTankPressure NOTIFY statusUpdated)
    /** @brief 管道压力 */
    Q_PROPERTY(quint16 pipePressure READ pipePressure NOTIFY statusUpdated)
    /** @brief PCB温度 */
    Q_PROPERTY(quint16 pcbTemp READ pcbTemp NOTIFY statusUpdated)
    /** @brief 电堆温度 */
    Q_PROPERTY(quint16 stackTemp READ stackTemp NOTIFY statusUpdated)
    /** @brief 工作状态码 */
    Q_PROPERTY(quint16 workStatus READ workStatus NOTIFY statusUpdated)
    /** @brief 故障状态掩码 */
    Q_PROPERTY(quint16 faultStatus READ faultStatus NOTIFY statusUpdated)
    /** @brief 自检状态 */
    Q_PROPERTY(quint8 selfCheck READ selfCheck NOTIFY statusUpdated)
    /** @brief BMS模块ID */
    Q_PROPERTY(quint8 id READ id NOTIFY statusUpdated)

public:
    explicit Vk_QingxieBms(QObject *parent = nullptr);
    void updateqingxieBmsData(const struct VkQingxieBms *status);
    float batVoltage() const;
    float servoCurrent() const;
    float stackVoltage() const;
    float servoVoltage() const;
    float batRefuelCurrent() const;
    quint16 gasTankPressure() const;
    quint16 pipePressure() const;
    quint16 pcbTemp() const;
    quint16 stackTemp() const;
    quint16 workStatus() const;
    quint16 faultStatus() const;
    quint8 selfCheck() const;
    quint8 id() const;

signals:
    void statusUpdated();

private:
    VkQingxieBms *m_data;
};

/**
 * @class Vk_BmsStatus
 * @brief 通用电池管理系统（BMS）状态类
 * @details 监控传统锂电池组的状态参数，包括电压电流监测、温度管理、
 * 容量估算、健康状态评估等功能
 */
class Vk_BmsStatus : public QObject {
    Q_OBJECT

    /** @brief 总电压 (V) */
    Q_PROPERTY(float voltage READ voltage NOTIFY statusUpdated)
    /** @brief 总电流 (A)  */
    Q_PROPERTY(float current READ current NOTIFY statusUpdated)
    /** @brief 电池温度 (°C) */
    Q_PROPERTY(int16_t temperature READ temperature NOTIFY statusUpdated)
    /** @brief 单体电池电压列表 (V)  */
    Q_PROPERTY(QList<float> cellVolt READ cellVolt NOTIFY statusUpdated)

    /** @brief 循环次数 */
    Q_PROPERTY(uint16_t cycCnt READ cycCnt NOTIFY statusUpdated)
    /** @brief 剩余容量百分比 (%) */
    Q_PROPERTY(int8_t capPercent READ capPercent NOTIFY statusUpdated)

    /** @brief 电池编号 (0-5) */
    Q_PROPERTY(uint8_t batId READ batId NOTIFY statusUpdated)
    /** @brief 电池健康度 (%) */
    Q_PROPERTY(uint8_t health READ health NOTIFY statusUpdated)
    /** @brief 故障码 (0为无故障) */
    Q_PROPERTY(quint32 errCode READ errCode NOTIFY statusUpdated)

public:
    explicit Vk_BmsStatus(QObject *parent = nullptr);

    ~Vk_BmsStatus();

    void updatebmsStatusData(const VkBmsStatus *status);
    float voltage() const;
    float current() const;
    int16_t temperature() const;
    QList<float> cellVolt() const;
    uint16_t cycCnt() const;
    int8_t capPercent() const;
    uint8_t batId() const;
    uint8_t health() const;
    quint32 errCode() const;

signals:
    void statusUpdated();

private:
    VkBmsStatus *m_data;
};

//----------------------- 定位导航系统 -----------------------
/**
 * @class Vk_GlobalPositionInt
 * @brief 高精度全局位置数据管理类
 * @details 该类用于管理和存储无人机的全局位置信息，包括位置坐标、速度矢量、航向角等关键飞行参数。
 * 提供实时的位置数据更新和访问接口，支持多种坐标系统和速度计算。
 */
class Vk_GlobalPositionInt : public QObject {
    Q_OBJECT

    /** @brief 纬度坐标 (度，从 degE7 转换而来，除以 1e7) */
    Q_PROPERTY(double lat READ lat NOTIFY statusUpdated)
    /** @brief 经度坐标 (度，从 degE7 转换而来，除以 1e7) */
    Q_PROPERTY(double lon READ lon NOTIFY statusUpdated)
    /** @brief 绝对高度 (m) */
    Q_PROPERTY(float alt READ alt NOTIFY statusUpdated)
    /** @brief 相对高度 (m) */
    Q_PROPERTY(float relativeAlt READ relativeAlt NOTIFY statusUpdated)

    /** @brief X轴速度分量 (m/s，正北方向) */
    Q_PROPERTY(double vx READ vx NOTIFY statusUpdated)
    /** @brief Y轴速度分量 (m/s，正东方向) */
    Q_PROPERTY(double vy READ vy NOTIFY statusUpdated)
    /** @brief Z轴速度分量 (m/s，正下方向) */
    Q_PROPERTY(float vz READ vz NOTIFY statusUpdated)

    /** @brief 航向角 (度，0-359.99度，正北为0) */
    Q_PROPERTY(float hdg READ hdg NOTIFY statusUpdated)

    /** @brief 垂直速度(m/s，正值为上升) */
    Q_PROPERTY(float verticalSpeed READ verticalSpeed NOTIFY statusUpdated)
    /** @brief 水平速度(m/s) */
    Q_PROPERTY(double horizontalSpeed READ horizontalSpeed NOTIFY statusUpdated)

public:
    explicit Vk_GlobalPositionInt(QObject *parent = nullptr);
    void updateGlobalPositionData(const struct VkGlobalPositionInt *status);
    double lat() const;
    double lon() const;
    float alt() const;
    float relativeAlt() const;
    double vx() const;
    double vy() const;
    float vz() const;
    float hdg() const;
    float verticalSpeed() const;
    double horizontalSpeed() const;

signals:
    void statusUpdated();

private:
    double m_lat;
    double m_lon;
    float m_alt;
    float m_relativeAlt;
    double m_vx;
    double m_vy;
    float m_vz;
    float m_hdg;
    float m_verticalSpeed;
    double m_horizontalSpeed;
};

/**
 * @class VkGnss
 * @brief GNSS原始数据容器类
 * @details 该类用于管理和存储从GPS/GNSS模块接收的原始卫星定位数据，包括时间信息、
 * 位置坐标、精度参数、速度矢量和系统状态等关键导航信息。
 */
class VkGnss : public QObject {
    Q_OBJECT

    /** @brief 时间戳（微秒），UNIX纪元时间或系统启动时间，接收端可通过数值大小推断时间格式 */
    Q_PROPERTY(uint64_t gpsInputTimeMicroseconds READ gpsInputTimeMicroseconds NOTIFY statusUpdated)
    /** @brief GPS周内时间（毫秒），从GPS周开始的时间 */
    Q_PROPERTY(uint32_t gpsInputTimeWeekMs READ gpsInputTimeWeekMs NOTIFY statusUpdated)
    /** @brief GPS周数，GPS周编号 */
    Q_PROPERTY(uint16_t gpsInputTimeWeek READ gpsInputTimeWeek NOTIFY statusUpdated)

    /** @brief 纬度（度），WGS84坐标系，从degE7转换（除以1e7） */
    Q_PROPERTY(double gpsInputLatitude READ gpsInputLatitude NOTIFY statusUpdated)
    /** @brief 经度（度），WGS84坐标系，从degE7转换（除以1e7） */
    Q_PROPERTY(double gpsInputLongitude READ gpsInputLongitude NOTIFY statusUpdated)
    /** @brief 高度（米），海平面高度，正值向上 */
    Q_PROPERTY(float gpsInputAltitude READ gpsInputAltitude NOTIFY statusUpdated)

    /** @brief 水平精度因子，GPS HDOP水平位置精度稀释（无单位），未知时设为UINT16_MAX */
    Q_PROPERTY(float gpsInputHdop READ gpsInputHdop NOTIFY statusUpdated)
    /** @brief 垂直精度因子，GPS VDOP垂直位置精度稀释（无单位），未知时设为UINT16_MAX */
    Q_PROPERTY(float gpsInputVdop READ gpsInputVdop NOTIFY statusUpdated)
    /** @brief 水平精度（米），GPS水平位置精度 */
    Q_PROPERTY(float gpsInputHorizontalAccuracy READ gpsInputHorizontalAccuracy NOTIFY statusUpdated)
    /** @brief 垂直精度（米），GPS垂直位置精度 */
    Q_PROPERTY(float gpsInputVerticalAccuracy READ gpsInputVerticalAccuracy NOTIFY statusUpdated)

    /** @brief 北向速度（米/秒），地固NED坐标系中GPS北向速度 */
    Q_PROPERTY(float gpsInputVelocityNorth READ gpsInputVelocityNorth NOTIFY statusUpdated)
    /** @brief 东向速度（米/秒），地固NED坐标系中GPS东向速度 */
    Q_PROPERTY(float gpsInputVelocityEast READ gpsInputVelocityEast NOTIFY statusUpdated)
    /** @brief 下向速度（米/秒），地固NED坐标系中GPS下向速度 */
    Q_PROPERTY(float gpsInputVelocityDown READ gpsInputVelocityDown NOTIFY statusUpdated)
    /** @brief 速度精度（米/秒），GPS速度测量精度 */
    Q_PROPERTY(float gpsInputSpeedAccuracy READ gpsInputSpeedAccuracy NOTIFY statusUpdated)

    /** @brief 忽略标志位图，指示忽略哪些GPS输入字段，其他字段必须提供 */
    Q_PROPERTY(uint16_t gpsInputIgnoreFlags READ gpsInputIgnoreFlags NOTIFY statusUpdated)
    /** @brief GPS设备ID，多GPS输入时的GPS标识符 */
    Q_PROPERTY(uint8_t gpsInputGpsId READ gpsInputGpsId NOTIFY statusUpdated)
    /** @brief 定位类型，0-1: 无定位, 2: 2D定位, 3: 3D定位, 4: 3D+DGPS, 5: 3D+RTK */
    Q_PROPERTY(uint8_t gpsInputFixType READ gpsInputFixType NOTIFY statusUpdated)
    /** @brief 可见卫星数量，当前可见的卫星数目 */
    Q_PROPERTY(uint8_t gpsInputSatellitesVisible READ gpsInputSatellitesVisible NOTIFY statusUpdated)
    /** @brief 偏航角（厘度），载体相对地球北向的偏航角，0表示不可用，36000表示正北 */
    Q_PROPERTY(uint16_t gpsInputYaw READ gpsInputYaw NOTIFY statusUpdated)

public:
    explicit VkGnss(QObject *parent = nullptr);
    void updateData(const VkGpsInput *status);
    uint64_t gpsInputTimeMicroseconds();
    uint32_t gpsInputTimeWeekMs();
    uint16_t gpsInputTimeWeek();
    double gpsInputLatitude();
    double gpsInputLongitude();
    float gpsInputAltitude();
    float gpsInputHdop();
    float gpsInputVdop();
    float gpsInputHorizontalAccuracy();
    float gpsInputVerticalAccuracy();
    float gpsInputVelocityNorth();
    float gpsInputVelocityEast();
    float gpsInputVelocityDown();
    float gpsInputSpeedAccuracy();
    uint16_t gpsInputIgnoreFlags();
    uint8_t gpsInputGpsId();
    uint8_t gpsInputFixType();
    uint8_t gpsInputSatellitesVisible();
    uint16_t gpsInputYaw();

signals:
    void statusUpdated();

private:
    VkGpsInput *m_gnss;
};

/**
 * @class VkRtkMsg
 * @brief RTK差分定位数据管理类
 * @details 管理和提供RTK（Real-Time Kinematic）实时动态差分定位系统的高精度位置、
 * 速度、精度和状态信息。RTK技术通过差分修正可以达到厘米级的定位精度，
 * 广泛应用于精密测量、自动驾驶和无人机导航等领域。
 * 该类封装了RTK定位系统的完整输出数据，包括WGS84坐标系下的位置信息、
 * 各种精度指标、运动状态参数以及定位质量评估数据。
 */

class VkRtkMsg : public QObject {
    Q_OBJECT

    /**
     * @brief RTK纬度坐标
     * @details WGS84坐标系下的纬度值，单位为度，范围-90°到+90°
     */
    Q_PROPERTY(double rtkMsgLatitude READ rtkMsgLatitude NOTIFY statusUpdated)
    /**
     * @brief RTK经度坐标
     * @details WGS84坐标系下的经度值，单位为度，范围-180°到+180°
     */
    Q_PROPERTY(double rtkMsgLongitude READ rtkMsgLongitude NOTIFY statusUpdated)
    /**
     * @brief 平均海平面高度
     * @details 相对于平均海平面的高度值，单位为米，正值表示海平面以上
     */
    Q_PROPERTY(float rtkMsgAltitudeMsl READ rtkMsgAltitudeMsl NOTIFY statusUpdated)
    /**
     * @brief 椭球高度
     * @details 相对于WGS84椭球面的高度值，单位为米
     */
    Q_PROPERTY(float rtkMsgAltitudeEllipsoid READ rtkMsgAltitudeEllipsoid NOTIFY statusUpdated)

    /**
     * @brief 水平精度因子
     * @details HDOP值，表示水平方向的几何精度衰减因子，值越小精度越高，无量纲值
     */
    Q_PROPERTY(quint16 rtkMsgHdop READ rtkMsgHdop NOTIFY statusUpdated)
    /**
     * @brief 垂直精度因子
     * @details VDOP值，表示垂直方向的几何精度衰减因子，值越小精度越高，无量纲值
     */
    Q_PROPERTY(quint16 rtkMsgVdop READ rtkMsgVdop NOTIFY statusUpdated)
    /**
     * @brief 水平定位精度
     * @details 水平方向的定位精度估计值，单位为米，表示95%置信度下的误差范围
     */
    Q_PROPERTY(float rtkMsgHorizontalAccuracy READ rtkMsgHorizontalAccuracy NOTIFY statusUpdated)
    /**
     * @brief 垂直定位精度
     * @details 垂直方向的定位精度估计值，单位为米，表示95%置信度下的误差范围
     */
    Q_PROPERTY(float rtkMsgVerticalAccuracy READ rtkMsgVerticalAccuracy NOTIFY statusUpdated)

    /**
     * @brief 速度测量精度
     * @details 速度测量的精度估计值，单位为米，表示速度测量的不确定度
     */
    Q_PROPERTY(float rtkMsgSpeedAccuracy READ rtkMsgSpeedAccuracy NOTIFY statusUpdated)
    /**
     * @brief 航向测量精度
     * @details 航向角测量的精度估计值，单位为度，表示航向测量的不确定度
     */
    Q_PROPERTY(float rtkMsgHeadingAccuracy READ rtkMsgHeadingAccuracy NOTIFY statusUpdated)

    /**
     * @brief 地面速度
     * @details 载体相对于地面的运动速度，单位为m/s
     */
    Q_PROPERTY(float rtkMsgGroundSpeed READ rtkMsgGroundSpeed NOTIFY statusUpdated)
    /**
     * @brief 对地航向角
     * @details 载体运动方向相对于正北方向的角度，单位为度，范围0°-360°
     */
    Q_PROPERTY(float rtkMsgCourseOverGround READ rtkMsgCourseOverGround NOTIFY statusUpdated)

    /**
     * @brief 差分数据年龄
     * @details 差分修正数据的时效性，单位为毫秒，值越小表示数据越新
     */
    Q_PROPERTY(quint32 rtkMsgDgpsAge READ rtkMsgDgpsAge NOTIFY statusUpdated)
    /**
     * @brief RTK定位解算类型
     * @details 定位解的质量类型：0=无效，1=单点定位，2=差分，3=PPS，4=RTK固定解，5=RTK浮点解
     */
    Q_PROPERTY(quint8 rtkMsgFixType READ rtkMsgFixType NOTIFY statusUpdated)
    /**
     * @brief 可见卫星数量
     * @details 当前可见并参与定位解算的卫星总数
     */
    Q_PROPERTY(quint8 rtkMsgSatellitesVisible READ rtkMsgSatellitesVisible NOTIFY statusUpdated)
    /**
     * @brief 差分卫星数量
     * @details 用于差分修正的卫星数量，影响RTK定位精度
     */
    Q_PROPERTY(quint8 rtkMsgDgpsSatellites READ rtkMsgDgpsSatellites NOTIFY statusUpdated)
    /**
     * @brief RTK偏航角
     * @details RTK系统计算的载体偏航角，单位为度，范围0°-360°
     */
    Q_PROPERTY(float rtkMsgYaw READ rtkMsgYaw NOTIFY statusUpdated)

public:
    explicit VkRtkMsg(QObject *parent = nullptr);

    double rtkMsgLatitude();

    double rtkMsgLongitude();

    float rtkMsgAltitudeMsl();

    float rtkMsgAltitudeEllipsoid();

    quint16 rtkMsgHdop();

    quint16 rtkMsgVdop();

    float rtkMsgHorizontalAccuracy();

    float rtkMsgVerticalAccuracy();

    float rtkMsgSpeedAccuracy();

    float rtkMsgHeadingAccuracy();

    float rtkMsgGroundSpeed();

    float rtkMsgCourseOverGround();

    quint32 rtkMsgDgpsAge();

    quint8 rtkMsgFixType();

    quint8 rtkMsgSatellitesVisible();

    quint8 rtkMsgDgpsSatellites();

    float rtkMsgYaw();
    void updateData(const struct VkGps2Raw *status);

signals:
    void statusUpdated();

private:
    VkGps2Raw *m_rtk;
};

//----------------------- 姿态控制系统 -----------------------
/**
 * @class Vk_Attitude
 * @brief 飞行器姿态数据管理类
 * @details 该类负责管理和存储飞行器的实时姿态信息，包括三轴欧拉角（横滚、俯仰、偏航）
 * 和对应的角速度数据。数据来源于IMU（惯性测量单元），为飞行控制系统提供关键的
 * 姿态反馈信息，用于姿态稳定和控制算法的实现。
 */
class Vk_Attitude : public QObject {
    Q_OBJECT

    /**
     * @brief 姿态数据时间戳
     * @details 系统启动后的毫秒数，用于标识姿态数据的采集时间，
     * 确保数据的时序性和同步性
     */
    Q_PROPERTY(quint32 attitudeTimeBootMs READ attitudeTimeBootMs NOTIFY statusUpdated)
    /**
     * @brief 横滚角
     * @details 飞行器绕X轴（机体纵轴）的旋转角度，单位为弧度，
     * 取值范围：-π ~ +π，正值表示右倾，负值表示左倾
     */
    Q_PROPERTY(float attitudeRoll READ attitudeRoll NOTIFY statusUpdated)
    /**
     * @brief 俯仰角
     * @details 飞行器绕Y轴（机体横轴）的旋转角度，单位为弧度，
     * 取值范围：-π ~ +π，正值表示机头上仰，负值表示机头下俯
     */
    Q_PROPERTY(float attitudePitch READ attitudePitch NOTIFY statusUpdated)
    /**
     * @brief 偏航角
     * @details 飞行器绕Z轴（机体竖轴）的旋转角度，单位为弧度，
     * 取值范围：-π ~ +π，正值表示顺时针旋转，负值表示逆时针旋转
     */
    Q_PROPERTY(float attitudeYaw READ attitudeYaw NOTIFY statusUpdated)

    /**
     * @brief 横滚角速度
     * @details 飞行器绕X轴的角速度，单位为弧度/秒(rad/s)，
     * 反映横滚运动的快慢，用于姿态控制和稳定性分析
     */
    Q_PROPERTY(float attitudeRollSpeed READ attitudeRollSpeed NOTIFY statusUpdated)
    /**
     * @brief 俯仰角速度
     * @details 飞行器绕Y轴的角速度，单位为弧度/秒(rad/s)，
     * 反映俯仰运动的快慢，用于姿态控制和稳定性分析
     */
    Q_PROPERTY(float attitudePitchSpeed READ attitudePitchSpeed NOTIFY statusUpdated)
    /**
     * @brief 偏航角速度
     * @details 飞行器绕Z轴的角速度，单位为弧度/秒(rad/s)，
     * 反映偏航运动的快慢，用于航向控制和转弯性能分析
     */
    Q_PROPERTY(float attitudeYawSpeed READ attitudeYawSpeed NOTIFY statusUpdated)

public:
    explicit Vk_Attitude(QObject *parent = nullptr);
    void updateData(const VkAttitude *status);
    quint32 attitudeTimeBootMs();
    float attitudeRoll();
    float attitudePitch();
    float attitudeYaw();
    float attitudeRollSpeed();
    float attitudePitchSpeed();
    float attitudeYawSpeed();
    float limitAngleToPMPIf(double angle);

signals:
    void statusUpdated();

private:
    VkAttitude *m_attitude;
};

//----------------------- 执行机构 -----------------------
/**
 * @class Vk_ServoOutputRaw
 * @brief 舵机输出原始值管理类
 * @details 管理和存储飞行器所有舵机/电机通道的PWM输出信号，
 *          提供实时的控制信号监控功能，用于调试和状态监控
 *          飞控周期向外发送, 默认 5hz. 包含各通道电机控制PWM信号的值
 */
class Vk_ServoOutputRaw : public QObject {
    Q_OBJECT

    /**
     * @brief 数据时间戳
     * @details 时间戳，单位为微秒(us)。可以是UNIX纪元时间或系统启动后的时间，
     *          接收端可通过数值大小推断时间戳格式（1970年以来或系统启动以来）
     */
    Q_PROPERTY(uint32_t timeBootMs READ timeBootMs NOTIFY statusUpdated)
    /**
     * @brief 舵机输出PWM值列表
     * @details 包含16个舵机通道的PWM输出值，单位为微秒(us)。
     *          对于垂起固定翼飞机：M1~M4/M9~M12为旋翼电机，M5~M8/M13~M16为固定翼舵面舵机。
     *          数组索引0-15分别对应servo1_raw到servo16_raw
     */
    Q_PROPERTY(QList<int> servoOutputRaw READ servoOutputRaw NOTIFY statusUpdated)

public:
    explicit Vk_ServoOutputRaw(QObject *parent = nullptr);
    void upServoOutputRawdateData(const struct VkServoOutputRaw *data);
    uint32_t timeBootMs();
    QList<int> servoOutputRaw();

signals:
    void statusUpdated();

private:
    uint32_t time_boot_ms;
    QList<int> m_servoBuffer;
};

//----------------------- 任务系统 -----------------------
/**
 * @class Vk_MissionCurrent
 * @brief 当前任务点消息
 * @details 负责监控和管理无人机任务执行过程中的实时状态信息，包括航点进度、
 *          执行状态、任务模式以及相关计划的标识信息。提供完整的任务状态跟踪
 *          和状态变化通知功能，支持任务规划系统的实时监控需求。
 *          飞控定期下传, 默认 1hz. 包含当前任务航点序号等信息. 注意 seq 字段从 0 开始
 */
class Vk_MissionCurrent : public QObject {
    Q_OBJECT

    /**
     * @brief 当前执行航点序号
     * @details 表示任务中当前正在执行或即将执行的航点编号，从0开始计数。
     *          该值随任务进度实时更新，用于跟踪任务执行的具体位置。
     */
    Q_PROPERTY(quint16 missionCurrentSeq READ missionCurrentSeq NOTIFY statusUpdated)
    /**
     * @brief 任务总航点数量
     * @details 当前任务计划中包含的航点总数，用于计算任务完成进度百分比。
     *          该值在任务加载时确定，任务执行过程中保持不变。
     */
    Q_PROPERTY(quint16 missionTotalItems READ missionTotalItems NOTIFY statusUpdated)

    /**
     * @brief 任务执行状态标识
     * @details 表示当前任务的执行状态：
     *          - 0: 任务未开始（待机状态）
     *          - 1: 任务执行中（正常飞行）
     *          - 2: 任务暂停（悬停等待）
     *          - 3: 任务完成（已结束）
     */
    Q_PROPERTY(quint8 missionState READ missionState NOTIFY statusUpdated)
    /**
     * @brief 任务执行模式
     * @details 指示当前的任务执行模式，如自动模式、返航模式、降落模式等。
     *          不同模式下飞行器的行为和控制逻辑会有所差异。
     */
    Q_PROPERTY(quint8 missionMode READ missionMode NOTIFY statusUpdated)
    /**
     * @brief 任务计划唯一标识
     * @details 当前执行任务计划的唯一ID，用于区分不同的任务计划。
     *          该ID在任务规划时生成，确保任务的可追溯性和唯一性。
     */
    Q_PROPERTY(quint32 missionPlanId READ missionPlanId NOTIFY statusUpdated)
    /**
     * @brief 地理围栏计划标识
     * @details 与当前任务关联的地理围栏计划ID，用于安全边界控制。
     *          地理围栏定义了飞行器的安全活动区域，防止越界飞行。
     */
    Q_PROPERTY(quint32 fencePlanId READ fencePlanId NOTIFY statusUpdated)
    /**
     * @brief 集结点计划标识
     * @details 与当前任务关联的集结点计划ID，用于紧急情况下的备用降落点。
     *          集结点提供了任务中断或紧急情况下的安全着陆选择。
     */
    Q_PROPERTY(quint32 rallyPointsId READ rallyPointsId NOTIFY statusUpdated)

public:
    explicit Vk_MissionCurrent(QObject *parent = nullptr);
    void updateMissionCurrentData(const struct VkMissionCurrent *data);
    quint16 missionCurrentSeq();
    quint16 missionTotalItems();
    quint8 missionState();
    quint8 missionMode();
    quint32 missionPlanId();
    quint32 fencePlanId();
    quint32 rallyPointsId();

signals:
    void statusUpdated();

private:
    VkMissionCurrent *m_current;
};

//----------------------- 遥控输入 -----------------------
/**
 * @class Vk_RcChannels
 * @brief 遥控器通道数据管理类
 * @details 负责接收、解析和管理遥控器发送的多通道控制信号数据。
 *          支持最多19个遥控通道的PWM信号处理，同时监控遥控信号的
 *          强度和质量。为飞行控制系统提供实时的遥控输入状态信息。
 */
class Vk_RcChannels : public QObject {
    Q_OBJECT

    /**
     * @brief 遥控器通道原始PWM值列表
     * @details 包含最多18个有效遥控通道的原始PWM值，单位为微秒(us)。
     *          每个通道值范围通常为1000-2000μs，标准中位值为1500μs。
     *          实际通道数量由飞控接收到的遥控器通道数决定，最多支持18个通道。
     *          通道映射：
     *          - 通道1-4：主控制通道（油门、副翼、升降舵、方向舵）
     *          - 通道5-8：辅助控制通道（飞行模式、云台控制等）
     *          - 通道9-18：扩展控制通道
     */
    Q_PROPERTY(QList<int> rcChannelsRaw READ rcChannelsRaw NOTIFY statusUpdated)
    /**
     * @brief 接收信号强度指示值
     * @details 表示遥控器与接收器之间的信号强度，范围0-254，255表示无效/未知。
     *          该值以设备相关的单位/比例表示：
     *          - 0：信号最弱或无信号
     *          - 254：信号最强
     *          - 255：无效或未知信号强度
     *          信号强度影响控制响应和可靠性。
     */
    Q_PROPERTY(quint8 rcRssiValue READ rcRssiValue NOTIFY statusUpdated)

public:
    explicit Vk_RcChannels(QObject *parent = nullptr);
    void updateRcChannelsData(const struct VkRcChannels *data);
    QList<int> rcChannelsRaw();

    int rcRssiValue();

signals:
    void statusUpdated();

private:
    QList<int> m_channelsRaw;
    int m_rssi;
};

//----------------------- 硬件版本管理 -----------------------
/**
 * @class Vk_ComponentVersion
 * @brief 硬件组件版本信息管理类
 * @details 负责管理和存储系统中各个硬件组件的版本信息和标识数据。
 *          支持飞控、GPS、传感器等多种组件的版本追踪，提供统一的
 *          版本信息查询接口，便于系统诊断、兼容性检查和维护管理。
 */
class Vk_ComponentVersion : public QObject {
    Q_OBJECT

    /**
     * @brief 组件编号
     * @details 设备组件的唯一标识符，用于区分不同的设备组件：
     *          - 0: 全部组件（用于查询所有设备信息）
     *          - 1: 飞控组件
     *          - 其他值: 参考vkqtsdk.h中VKFLY_USER_COMP_ID定义的组件类型
     */
    Q_PROPERTY(quint16 componentId READ componentId NOTIFY statusUpdated)
    /**
     * @brief 硬件版本号
     * @details 设备的硬件版本信息，以字符串形式表示。
     *          最大长度为16字节，包含硬件版本的详细信息，
     *          用于识别硬件的设计版本和制造批次。
     */
    Q_PROPERTY(QString hardwareVersion READ hardwareVersion NOTIFY statusUpdated)
    /**
     * @brief 固件版本号
     * @details 设备的软件/固件版本信息，以字符串形式表示。
     *          最大长度为16字节，包含固件版本的详细信息，
     *          决定了硬件的功能特性和协议兼容性。
     */
    Q_PROPERTY(QString firmwareVersion READ firmwareVersion NOTIFY statusUpdated)

    /**
     * @brief 序列号
     * @details 设备的唯一序列号标识，用于设备的唯一识别。
     *          最大长度为16字节，每个设备都有唯一的序列号，
     *          用于设备追踪、保修管理和防伪验证。
     */
    Q_PROPERTY(QString serialNumber READ serialNumber NOTIFY statusUpdated)
    /**
     * @brief 制造商
     * @details 设备制造商的名称或标识信息。
     *          最大长度为16字节，标识设备的生产厂商，
     *          用于识别设备来源和技术支持联系。
     */
    Q_PROPERTY(QString manufactoryName READ manufactoryName NOTIFY statusUpdated)
    /**
     * @brief 设备型号
     * @details 设备的具体型号信息，用于标识设备的规格和类型。
     *          最大长度为16字节，包含设备的型号标识，
     *          用于确定设备的技术规格和功能特性。
     */
    Q_PROPERTY(QString deviceModel READ deviceModel NOTIFY statusUpdated)

public:
    explicit Vk_ComponentVersion(QObject *parent = nullptr);
    void updateComponentData(const struct VkComponentVersion *status);

    quint16 componentId();

    QString hardwareVersion();

    QString firmwareVersion();

    QString serialNumber();

    QString manufactoryName();

    QString deviceModel();

signals:
    void statusUpdated();

private:
    struct VkComponentVersion *m_component;
};

//----------------------- 导航系统 -----------------------
/**
 * @class Vk_insStatus
 * @brief 惯性导航系统状态管理类
 * @details 存储INS系统的内部状态、原始数据和校准信息
 */
class Vk_insStatus : public QObject {
    Q_OBJECT
    /**
     * @brief INS系统启动时间戳
     * @details 惯性导航系统启动后的毫秒计数，用于数据时序同步和
     *          系统运行时间监控。该时间戳从系统启动开始累计。
     */
    Q_PROPERTY(uint32_t timeBootMs READ timeBootMs NOTIFY statusUpdated)

    /**
     * @brief 重力加速度测量值
     * @details 当前位置的重力加速度值，单位为m/s²。该值用于惯性导航
     *          计算中的重力补偿，确保姿态和位置解算的准确性。
     */
    Q_PROPERTY(float g0 READ g0 NOTIFY statusUpdated)

    /**
     * @brief 原始GPS纬度坐标
     * @details GPS接收器提供的原始纬度值，单位为1e-7度（度×10^7）。
     *          该值未经过滤波处理，保持GPS原始精度用于导航解算。
     */
    Q_PROPERTY(int32_t rawLatitude READ rawLatitude NOTIFY statusUpdated)

    /**
     * @brief 原始GPS经度坐标
     * @details GPS接收器提供的原始经度值，单位为1e-7度（度×10^7）。
     *          该值未经过滤波处理，保持GPS原始精度用于导航解算。
     */
    Q_PROPERTY(int32_t rawLongitude READ rawLongitude NOTIFY statusUpdated)

    /**
     * @brief 气压计高度测量值
     * @details 基于大气压力计算的海拔高度，单位为米。该高度相对于
     *          标准大气压力，用于高度控制和垂直导航。
     */
    Q_PROPERTY(float baroAlt READ baroAlt NOTIFY statusUpdated)

    /**
     * @brief 原始GPS高度数据
     * @details GPS接收器提供的原始高度值，单位为米。该值为椭球高度，
     *          需要与大地水准面高度进行转换以获得真实海拔。
     */
    Q_PROPERTY(float rawGpsAlt READ rawGpsAlt NOTIFY statusUpdated)

    /**
     * @brief IMU传感器温度
     * @details 惯性测量单元的内部温度，单位为摄氏度。温度监控用于
     *          传感器温度补偿和系统热管理，确保测量精度。
     */
    Q_PROPERTY(int16_t temperature READ temperature NOTIFY statusUpdated)

    /**
     * @brief 导航系统状态标志
     * @details 惯性导航系统的综合状态指示，包含初始化状态、对准状态、
     *          导航模式等关键信息的位掩码表示。
     */
    Q_PROPERTY(uint8_t navStatus READ navStatus NOTIFY statusUpdated)

    /**
     * @brief 系统状态标志位1
     * @details 第一组系统状态位，包含传感器健康状态、校准状态等
     *          基础系统信息的位掩码表示。
     */
    Q_PROPERTY(uint8_t sFlag1 READ sFlag1 NOTIFY statusUpdated)

    /**
     * @brief 系统状态标志位2
     * @details 第二组系统状态位，包含导航模式、滤波器状态等
     *          高级功能信息的位掩码表示。
     */
    Q_PROPERTY(uint8_t sFlag2 READ sFlag2 NOTIFY statusUpdated)

    /**
     * @brief 系统状态标志位3
     * @details 第三组系统状态位，包含外部传感器状态、数据融合状态等
     *          扩展功能信息的位掩码表示。
     */
    Q_PROPERTY(uint8_t sFlag3 READ sFlag3 NOTIFY statusUpdated)

    /**
     * @brief 系统状态标志位4
     * @details 第四组系统状态位，包含通信状态、数据链路状态等
     *          连接相关信息的位掩码表示。
     */
    Q_PROPERTY(uint8_t sFlag4 READ sFlag4 NOTIFY statusUpdated)

    /**
     * @brief 系统状态标志位5
     * @details 第五组系统状态位，包含高级导航功能、精密定位状态等
     *          专业功能信息的位掩码表示。
     */
    Q_PROPERTY(uint8_t sFlag5 READ sFlag5 NOTIFY statusUpdated)

    /**
     * @brief 系统状态标志位6
     * @details 第六组系统状态位，包含系统诊断、错误状态等
     *          故障检测信息的位掩码表示。
     */
    Q_PROPERTY(uint8_t sFlag6 READ sFlag6 NOTIFY statusUpdated)

    /**
     * @brief 磁力计校准阶段指示
     * @details 磁力计校准过程的当前阶段，取值范围0-5：
     *          0=未校准，1-4=校准进行中，5=校准完成。
     *          用于指导用户完成磁力计校准操作。
     */
    Q_PROPERTY(uint8_t magCalibStage READ magCalibStage NOTIFY statusUpdated)

    /**
     * @brief 位置解算卫星数量
     * @details 当前用于位置解算的GPS卫星数量。卫星数量直接影响
     *          定位精度，通常需要4颗以上卫星进行三维定位。
     */
    Q_PROPERTY(uint8_t solvPsatNum READ solvPsatNum NOTIFY statusUpdated)

    /**
     * @brief 高度解算卫星数量
     * @details 当前用于高度解算的GPS卫星数量。高度解算对卫星几何
     *          分布要求较高，影响垂直方向的定位精度。
     */
    Q_PROPERTY(uint8_t solvHsatNum READ solvHsatNum NOTIFY statusUpdated)

    /**
     * @brief 系统振动系数
     * @details 系统振动强度指标，取值范围0-100。该值反映飞行器的
     *          机械振动水平，过高的振动会影响传感器精度和飞行稳定性。
     */
    Q_PROPERTY(uint8_t vibeCoe READ vibeCoe NOTIFY statusUpdated)

public:
    explicit Vk_insStatus(QObject *parent = nullptr);
    ~Vk_insStatus();
    void updateVkinsData(const struct VkinsStatus *data);
    uint32_t timeBootMs();
    float g0();
    int32_t rawLatitude();
    int32_t rawLongitude();
    float baroAlt();
    float rawGpsAlt();
    int16_t temperature();
    uint8_t navStatus();
    uint8_t sFlag1();
    uint8_t sFlag2();
    uint8_t sFlag3();
    uint8_t sFlag4();
    uint8_t sFlag5();
    uint8_t sFlag6();
    uint8_t magCalibStage();
    uint8_t solvPsatNum();
    uint8_t solvHsatNum();
    uint8_t vibeCoe();

signals:
    void statusUpdated();

private:
    struct VkinsStatus *m_vkinsStatus;
};

/**
 * @class Vk_FmuStatus
 * @brief 飞行管理单元状态管理类
 * 监控飞行控制核心模块的状态和关键参数
 */
class Vk_FmuStatus : public QObject {
    Q_OBJECT

    /**
     * @brief 获取系统启动时间戳
     * @details 飞行管理单元从系统启动开始的时间戳，单位为毫秒(ms)。
     *          该时间戳用于同步各个子系统的数据时序，确保数据的时间一致性。
     */
    Q_PROPERTY(uint32_t timeBootMs READ timeBootMs NOTIFY statusUpdated)
    /**
     * @brief 获取累计飞行时间
     * @details 飞行器本次上电后的累计飞行时间，单位为秒(s)。
     *          从解锁开始计时，到上锁结束，记录实际飞行时长。
     */
    Q_PROPERTY(uint32_t flightTime READ flightTime NOTIFY statusUpdated)
    /**
     * @brief 获取目标点距离
     * @details 当前位置到目标航点的直线距离，单位为厘米(cm)。
     *          在自动飞行模式下，显示到下一个航点的距离；在手动模式下可能为0。
     */
    Q_PROPERTY(uint32_t distToTar READ distToTar NOTIFY statusUpdated)
    /**
     * @brief 获取总飞行距离
     * @details 飞行器本次上电后的累计飞行距离，单位为米(m)。
     *          记录飞行器实际移动的总路径长度，用于飞行统计和维护计划。
     */
    Q_PROPERTY(int flightDist READ flightDist NOTIFY statusUpdated)

    /**
     * @brief 获取备用电源电压
     * @details UPS(不间断电源)的电压值，单位为0.1V。
     *          监控备用电源状态，确保在主电源故障时系统能够安全关机或紧急降落。
     */
    Q_PROPERTY(uint16_t upsVolt READ upsVolt NOTIFY statusUpdated)
    /**
     * @brief 获取ADC输入电压
     * @details 模数转换器检测到的输入电压值，单位为0.1V。
     *          用于监控系统电源状态和电压稳定性，防止电压异常导致的系统故障。
     */
    Q_PROPERTY(uint16_t adcVolt READ adcVolt NOTIFY statusUpdated)
    /**
     * @brief 获取舵机状态位掩码
     * @details 舵机工作状态的位图表示，每个位对应一个舵机通道。
     *          位值为1表示舵机正常工作，位值为0表示舵机关闭或故障。
     *          用于监控动力系统和控制面的工作状态。
     */
    Q_PROPERTY(uint16_t servoState READ servoState NOTIFY statusUpdated)
    /**
     * @brief 获取返航原因代码
     * @details 触发返航(RTL)模式的原因标识，参考VKFLY_RTL_REASON枚举。
     *          常见原因包括：低电量、遥控丢失、地理围栏、手动触发等。
     *          用于故障诊断和飞行安全分析。
     */
    Q_PROPERTY(uint8_t rtlReason READ rtlReason NOTIFY statusUpdated)
    /**
     * @brief 获取盘旋原因代码
     * @details 触发盘旋(Loiter)模式的原因标识，参考VKFLY_LOITER_REASON枚举。
     *          常见原因包括：等待指令、避障、任务暂停等。
     *          用于了解飞行器当前的行为状态。
     */
    Q_PROPERTY(uint8_t loiterReason READ loiterReason NOTIFY statusUpdated)
    /**
     * @brief 获取状态标志3
     * @details FMU的第3个状态标志字节，用于扩展状态信息。
     *          具体位定义由飞控固件决定，通常用于特殊功能状态指示。
     */
    Q_PROPERTY(uint8_t sFlag3 READ sFlag3 NOTIFY statusUpdated)

public:
    explicit Vk_FmuStatus(QObject *parent = nullptr);
    void updateFmuStatus(const struct VkFmuStatus *data);
    uint32_t timeBootMs() const;
    uint32_t flightTime() const;
    uint32_t distToTar() const;
    int flightDist() const;
    uint16_t upsVolt() const;
    uint16_t adcVolt() const;
    uint16_t servoState() const;
    uint8_t rtlReason() const;
    uint8_t loiterReason() const;
    uint8_t sFlag3() const;

signals:
    void statusUpdated();

private:
    struct VkFmuStatus *m_fmuStatus;
};

//----------------------- 飞行状态 -----------------------
/**
 * @class Vk_VfrHud
 * @brief 可视化飞行数据管理类
 * 综合飞行状态信息（HUD显示的核心参数）
 */

class Vk_VfrHud : public QObject {
    Q_OBJECT

    /**
     * @brief 获取飞行器空速
     * @details 适合飞行器类型的速度形式，对于标准飞机通常是校准空速(CAS)或指示空速(IAS)，
     *          飞行员可以使用其中任一种来估计失速速度。单位：m/s
     */
    Q_PROPERTY(float airspeed READ systemAirspeed NOTIFY statusUpdated)
    /**
     * @brief 获取地面速度
     * @details 当前相对于地面的速度。单位：m/s
     */
    Q_PROPERTY(float groundspeed READ systemGroundspeed NOTIFY statusUpdated)
    /**
     * @brief 获取海拔高度
     * @details 当前海拔高度(MSL - 平均海平面)。单位：m
     */
    Q_PROPERTY(float alt READ systemAltitude NOTIFY statusUpdated)
    /**
     * @brief 获取爬升率
     * @details 当前垂直爬升速度，正值表示上升，负值表示下降。单位：m/s
     */
    Q_PROPERTY(float climb READ systemClimbRate NOTIFY statusUpdated)
    /**
     * @brief 获取航向角
     * @details 当前罗盘航向角(0-360度，0度为正北方向)。单位：度
     */
    Q_PROPERTY(int16_t heading READ systemHeading NOTIFY statusUpdated)
    /**
     * @brief 获取油门设置
     * @details 当前油门设置百分比(0到100%)。单位：%
     */
    Q_PROPERTY(uint16_t throttle READ systemThrottle NOTIFY statusUpdated)

public:
    explicit Vk_VfrHud(QObject *parent = nullptr);
    void updateVfrHudData(const struct VkVfrHud *data);
    float systemAirspeed();
    float systemGroundspeed();
    float systemAltitude();
    float systemClimbRate();
    int16_t systemHeading();
    uint16_t systemThrottle();

signals:
    void statusUpdated();

private:
    struct VkVfrHud *m_vfrHud;
};

//----------------------- 动力系统 -----------------------
/**
 * @class Vk_EscStatus
 * @brief 电调状态监控管理类
 * 多电机的实时状态监测和告警
 */
class Vk_EscStatus : public QObject {
    Q_OBJECT

    /**
     * @brief 电调数据时间戳
     * @details 毫秒时间戳，表示电调状态数据的采集时间，单位为毫秒(ms)
     */
    Q_PROPERTY(uint64_t timestamp READ timestamp NOTIFY dataUpdated)
    /**
     * @brief 本组第一个电调索引序号
     * @details 电调组索引，自增4。第一组为0，第二组为4，第三组为8，依次类推。
     * 每4个电调作为一组发送一帧数据，通过此字段区分不同组别。
     * 有效值范围：0-60，且必须是4的倍数。
     */
    Q_PROPERTY(uint8_t index READ index NOTIFY dataUpdated)
    /**
     * @brief 电调转速数组
     * @details 4个电调的转速数据，单位：1rpm（转/分钟）。
     * 负值表示反向旋转，正值表示正向旋转。
     * 数组长度固定为4，对应一组中的4个电调。
     */
    Q_PROPERTY(QList<int> rpm READ rpm NOTIFY dataUpdated)

    /**
     * @brief 电调电压数组
     * @details 4个电调的电压测量值，单位：V（伏特）。
     * 反映各电调的供电电压状态，用于监控电源系统健康状况。
     * 数组长度固定为4，对应一组中的4个电调。
     */
    Q_PROPERTY(QList<float> voltage READ voltage NOTIFY dataUpdated)
    /**
     * @brief 电调电流数组
     * @details 4个电调的电流测量值，单位：A（安培）。
     * 反映各电调的功耗情况，用于监控负载状态和功率分配。
     * 数组长度固定为4，对应一组中的4个电调。
     */
    Q_PROPERTY(QList<float> current READ current NOTIFY dataUpdated)

    /**
     * @brief 电调状态字数组
     * @details 4个电调的状态标志位，不同品牌型号有不同的状态定义。
     * 通常包含错误码、工作模式、保护状态等信息。
     * 具体含义需参考对应电调厂商的技术文档。
     * 数组长度固定为4，对应一组中的4个电调。
     */
    Q_PROPERTY(QList<uint> status READ status NOTIFY dataUpdated)
    /**
     * @brief 电调温度数组
     * @details 4个电调的温度测量值，单位：degC（摄氏度）。
     * 用于监控电调的热状态，防止过热损坏。
     * 数组长度固定为4，对应一组中的4个电调。
     */
    Q_PROPERTY(QList<int> temperature READ temperature NOTIFY dataUpdated)

public:
    explicit Vk_EscStatus(QObject *parent = nullptr);
    void updateEscStatusData(const struct VkEscStatus *data);
    uint64_t timestamp();
    uint8_t index();
    QList<int> rpm();
    QList<float> voltage();
    QList<float> current();
    QList<uint> status();
    QList<int> temperature();

signals:
    void dataUpdated();

private:
    uint64_t m_timestamp;
    QList<int> m_rpm;
    QList<float> m_voltage;
    QList<float> m_current;
    QList<uint> m_status;
    QList<int> m_temperature;
    uint8_t m_index;
};

//----------------------- 感知系统 -----------------------
/**
 * @class Vk_ObstacleDistance
 * @brief 全向障碍物距离数据管理类
 * 360°避障系统的原始距离数据采集和管理
 */
class Vk_ObstacleDistance : public QObject {
    Q_OBJECT

    /**
     * @brief 最小有效距离
     * @details 传感器能够检测到的最小有效距离，单位为厘米(cm)
     */
    Q_PROPERTY(int minDistance READ minDistance NOTIFY dataUpdated)
    /**
     * @brief 最大有效距离
     * @details 传感器能够检测到的最大有效距离，单位为厘米(cm)
     */
    Q_PROPERTY(int maxDistance READ maxDistance NOTIFY dataUpdated)

    /**
     * @brief 传感器类型
     * @details 障碍物检测传感器的类型标识(0=激光雷达,1=超声波,2=红外)
     */
    Q_PROPERTY(uint8_t sensorType READ sensorType NOTIFY dataUpdated)
    /**
     * @brief 角度增量(整数)
     * @details 相邻检测方向之间的角度间隔，单位为度
     */
    Q_PROPERTY(uint8_t increment READ increment NOTIFY dataUpdated)
    /**
     * @brief 角度增量(浮点)
     * @details 相邻检测方向之间的精确角度间隔，单位为度
     */
    Q_PROPERTY(float incrementF READ incrementF NOTIFY dataUpdated)
    /**
     * @brief 起始角度偏移
     * @details 第一个检测方向相对于机体正前方的角度偏移，单位为弧度
     */
    Q_PROPERTY(float angleOffset READ angleOffset NOTIFY dataUpdated)
    /**
     * @brief 坐标系类型
     * @details 距离数据所使用的坐标系(0=机体坐标系,1=地理坐标系)
     */
    Q_PROPERTY(uint8_t frame READ frame NOTIFY dataUpdated)

    /**
     * @brief 72方向距离值
     * @details 360°范围内72个方向的障碍物距离测量值，单位为厘米(cm)，65535表示无效数据
     */
    Q_PROPERTY(QList<int> distances READ distances NOTIFY dataUpdated)

public:
    explicit Vk_ObstacleDistance(QObject *parent = nullptr);

    void updateobstacleDistanceData(const struct VkObstacleDistance *data);
    int minDistance();
    int maxDistance();
    uint8_t sensorType();
    uint8_t increment();
    float incrementF();
    float angleOffset();
    uint8_t frame();
    QList<int> distances();

signals:
    void dataUpdated();

private:
    int m_distances[72];
    int m_minDistance;
    int m_maxDistance;
    uint8_t m_sensorType;
    uint8_t m_increment;
    float m_incrementF;
    float m_angleOffset;
    uint8_t m_frame;

    struct VkObstacleDistance *m_obstacleDistance;
};

//----------------------- 单距离传感器 -----------------------
/**
 * @class Vk_DistanceSensor
 * @brief 单距离传感器数据管理类
 * @details 管理单个距离传感器（如激光雷达、超声波）的详细参数和测量数据
 */
class Vk_DistanceSensor : public QObject {
    Q_OBJECT

    /**
     * @brief 最小测量距离
     * @details 传感器能够准确测量的最小距离，单位为米(m)
     */
    Q_PROPERTY(float minDistance READ minDistance NOTIFY updated)
    /**
     * @brief 最大测量距离
     * @details 传感器能够准确测量的最大距离，单位为米(m)
     */
    Q_PROPERTY(float maxDistance READ maxDistance NOTIFY updated)
    /**
     * @brief 当前测量距离
     * @details 传感器当前测量到的距离值，单位为米(m)
     */
    Q_PROPERTY(float currentDistance READ currentDistance NOTIFY updated)

    /**
     * @brief 传感器类型
     * @details 距离传感器的类型标识(0=激光雷达,1=超声波,2=红外)
     */
    Q_PROPERTY(uint8_t sensorType READ sensorType NOTIFY updated)
    /**
     * @brief 传感器ID
     * @details 传感器的唯一标识符，用于区分多个同类型传感器
     */
    Q_PROPERTY(uint8_t sensorId READ sensorId NOTIFY updated)
    /**
     * @brief 安装方向
     * @details 传感器在飞行器上的安装方向(0=前,1=后,2=左,3=右等)
     */
    Q_PROPERTY(uint8_t orientation READ orientation NOTIFY updated)

    /**
     * @brief 测量协方差
     * @details 传感器测量的不确定性参数，范围0-255
     */
    Q_PROPERTY(uint8_t covariance READ covariance NOTIFY updated)

    /**
     * @brief 水平视场角
     * @details 传感器水平方向的检测视场角，单位为弧度
     */
    Q_PROPERTY(float horizontalFov READ horizontalFov NOTIFY updated)
    /**
     * @brief 垂直视场角
     * @details 传感器垂直方向的检测视场角，单位为弧度
     */
    Q_PROPERTY(float verticalFov READ verticalFov NOTIFY updated)

    /**
     * @brief 四元数W分量
     * @details 传感器安装姿态四元数的W(实部)分量
     */
    Q_PROPERTY(float quaternionW READ quaternionW NOTIFY updated)
    /**
     * @brief 四元数X分量
     * @details 传感器安装姿态四元数的X分量
     */
    Q_PROPERTY(float quaternionX READ quaternionX NOTIFY updated)
    /**
     * @brief 四元数Y分量
     * @details 传感器安装姿态四元数的Y分量
     */
    Q_PROPERTY(float quaternionY READ quaternionY NOTIFY updated)
    /**
     * @brief 四元数Z分量
     * @details 传感器安装姿态四元数的Z分量
     */
    Q_PROPERTY(float quaternionZ READ quaternionZ NOTIFY updated)

    /**
     * @brief 信号质量
     * @details 传感器信号的质量评估，范围0-100，100表示最佳质量
     */
    Q_PROPERTY(uint8_t signalQuality READ signalQuality NOTIFY updated)

public:
    explicit Vk_DistanceSensor(QObject *parent = nullptr);

    void updatedistanceSensorData(const struct VkDistanceSensorStatus *data);
    float minDistance() const;
    float maxDistance() const;
    float currentDistance() const;
    uint8_t sensorType() const;
    uint8_t sensorId() const;
    uint8_t orientation() const;
    uint8_t covariance() const;
    float horizontalFov() const;
    float verticalFov() const;
    float quaternionW() const;
    float quaternionX() const;
    float quaternionY() const;
    float quaternionZ() const;
    uint8_t signalQuality() const;

signals:
    void updated();

private:
    struct VkDistanceSensorStatus *m_data;
};

//----------------------- 通信系统 -----------------------
/**
 * @class Vk_HighLatency
 * @brief 高延迟链路状态管理类
 * @details 管理卫星通信等长距离链路的压缩状态数据
 */
class Vk_HighLatency : public QObject {
    Q_OBJECT

    /**
     * @brief 自定义飞行模式
     * @details 用户定义的飞行模式代码，用于扩展标准飞行模式
     */
    Q_PROPERTY(quint32 customMode READ customMode NOTIFY dataUpdated)
    /**
     * @brief 当前纬度
     * @details 飞行器当前位置的纬度坐标，单位为度
     */
    Q_PROPERTY(float latitude READ latitude NOTIFY dataUpdated)
    /**
     * @brief 当前经度
     * @details 飞行器当前位置的经度坐标，单位为度
     */
    Q_PROPERTY(float longitude READ longitude NOTIFY dataUpdated)

    /**
     * @brief 横滚角
     * @details 飞行器绕X轴的旋转角度，单位为弧度
     */
    Q_PROPERTY(float roll READ roll NOTIFY dataUpdated)
    /**
     * @brief 俯仰角
     * @details 飞行器绕Y轴的旋转角度，单位为弧度
     */
    Q_PROPERTY(float pitch READ pitch NOTIFY dataUpdated)
    /**
     * @brief 当前航向角
     * @details 飞行器当前的航向角度，单位为弧度
     */
    Q_PROPERTY(float heading READ heading NOTIFY dataUpdated)
    /**
     * @brief 目标航向角
     * @details 飞行器期望达到的航向角度，单位为弧度
     */
    Q_PROPERTY(float headingSp READ headingSp NOTIFY dataUpdated)

    /**
     * @brief 海拔高度
     * @details 飞行器当前的海拔高度，单位为米
     */
    Q_PROPERTY(qint16 altitudeAmsl READ altitudeAmsl NOTIFY dataUpdated)
    /**
     * @brief 目标高度
     * @details 飞行器期望达到的海拔高度，单位为米
     */
    Q_PROPERTY(qint16 altitudeSp READ altitudeSp NOTIFY dataUpdated)

    /**
     * @brief 目标航点距离
     * @details 飞行器到当前目标航点的直线距离，单位为米
     */
    Q_PROPERTY(quint16 wpDistance READ wpDistance NOTIFY dataUpdated)
    /**
     * @brief 目标航点序号
     * @details 当前正在飞向的航点在任务中的序号
     */
    Q_PROPERTY(quint8 wpNum READ wpNum NOTIFY dataUpdated)

    /**
     * @brief 基础飞行模式
     * @details 飞行器的基础飞行模式位掩码
     */
    Q_PROPERTY(quint8 baseMode READ baseMode NOTIFY dataUpdated)
    /**
     * @brief 着陆状态
     * @details 飞行器的着陆状态(0=空中,1=地面)
     */
    Q_PROPERTY(quint8 landedState READ landedState NOTIFY dataUpdated)
    /**
     * @brief 油门百分比
     * @details 当前油门开度百分比，范围0-100
     */
    Q_PROPERTY(qint8 throttle READ throttle NOTIFY dataUpdated)

    /**
     * @brief 空速
     * @details 飞行器相对于空气的速度，单位为米/秒
     */
    Q_PROPERTY(quint8 airspeed READ airspeed NOTIFY dataUpdated)
    /**
     * @brief 目标空速
     * @details 飞行器期望达到的空速，单位为米/秒
     */
    Q_PROPERTY(quint8 airspeedSp READ airspeedSp NOTIFY dataUpdated)
    /**
     * @brief 地速
     * @details 飞行器相对于地面的速度，单位为米/秒
     */
    Q_PROPERTY(quint8 groundspeed READ groundspeed NOTIFY dataUpdated)
    /**
     * @brief 爬升率
     * @details 飞行器的垂直速度，正值为上升，负值为下降，单位为米/秒
     */
    Q_PROPERTY(qint8 climbRate READ climbRate NOTIFY dataUpdated)

    /**
     * @brief GPS卫星数
     * @details 当前接收到的GPS卫星数量
     */
    Q_PROPERTY(quint8 gpsNsat READ gpsNsat NOTIFY dataUpdated)
    /**
     * @brief GPS定位类型
     * @details GPS定位的质量类型(0-5，数值越大精度越高)
     */
    Q_PROPERTY(quint8 gpsFixType READ gpsFixType NOTIFY dataUpdated)

    // 电源参数
    /**
     * @brief 剩余电量百分比
     * @details 电池剩余电量的百分比，范围0-100
     */
    Q_PROPERTY(quint8 batteryRemaining READ batteryRemaining NOTIFY dataUpdated)

    // 环境参数
    /**
     * @brief 内部温度
     * @details 飞行器内部的温度，单位为摄氏度
     */
    Q_PROPERTY(qint8 temperature READ temperature NOTIFY dataUpdated)
    /**
     * @brief 外部空气温度
     * @details 飞行器外部环境的空气温度，单位为摄氏度
     */
    Q_PROPERTY(qint8 temperatureAir READ temperatureAir NOTIFY dataUpdated)

    // 安全参数
    /**
     * @brief 故障保护状态
     * @details 故障保护系统的激活状态(0=正常,1=激活)
     */
    Q_PROPERTY(quint8 failsafe READ failsafe NOTIFY dataUpdated)

public:
    explicit Vk_HighLatency(QObject *parent = nullptr);
    ~Vk_HighLatency();
    void updatehighLatencyData(const struct VkHighLatency *data);

    quint32 customMode();
    float latitude();
    float longitude();
    float roll();
    float pitch();
    float heading();
    float headingSp();
    qint16 altitudeAmsl();
    qint16 altitudeSp();
    quint16 wpDistance();
    quint8 wpNum();
    quint8 baseMode();
    quint8 landedState();
    qint8 throttle();
    quint8 airspeed();
    quint8 airspeedSp();
    quint8 groundspeed();
    qint8 climbRate();
    quint8 gpsNsat();
    quint8 gpsFixType();
    quint8 batteryRemaining();
    qint8 temperature();
    qint8 temperatureAir();
    quint8 failsafe();

signals:
    void dataUpdated();

private:
    struct VkHighLatency *m_highLatency;
};

//----------------------- 传感器系统 -----------------------
/**
 * @class Vk_ScaledImuStatus
 * @brief IMU数据管理类
 * @details 管理惯性测量单元(IMU)的预处理输出数据
 */
class Vk_ImuStatus : public QObject {
    Q_OBJECT

    /**
     * @brief X轴加速度
     * @details IMU测量的X轴方向加速度，单位为米/秒²
     */
    Q_PROPERTY(float xacc READ systemXacc NOTIFY statusUpdated)
    /**
     * @brief Y轴加速度
     * @details IMU测量的Y轴方向加速度，单位为米/秒²
     */
    Q_PROPERTY(float yacc READ systemYacc NOTIFY statusUpdated)
    /**
     * @brief Z轴加速度
     * @details IMU测量的Z轴方向加速度，单位为米/秒²
     */
    Q_PROPERTY(float zacc READ systemZacc NOTIFY statusUpdated)
    /**
     * @brief X轴角速度
     * @details IMU测量的绕X轴旋转的角速度，单位为度/秒
     */
    Q_PROPERTY(float xgyro READ systemXgyro NOTIFY statusUpdated)
    /**
     * @brief Y轴角速度
     * @details IMU测量的绕Y轴旋转的角速度，单位为度/秒
     */
    Q_PROPERTY(float ygyro READ systemYgyro NOTIFY statusUpdated)
    /**
     * @brief Z轴角速度
     * @details IMU测量的绕Z轴旋转的角速度，单位为度/秒
     */
    Q_PROPERTY(float zgyro READ systemZgyro NOTIFY statusUpdated)
    /**
     * @brief X轴磁力
     * @details IMU测量的X轴方向磁场强度，单位为高斯
     */
    Q_PROPERTY(float xmag READ systemXmag NOTIFY statusUpdated)
    /**
     * @brief Y轴磁力
     * @details IMU测量的Y轴方向磁场强度，单位为高斯
     */
    Q_PROPERTY(float ymag READ systemYmag NOTIFY statusUpdated)
    /**
     * @brief Z轴磁力
     * @details IMU测量的Z轴方向磁场强度，单位为高斯
     */
    Q_PROPERTY(float zmag READ systemZmag NOTIFY statusUpdated)
    /**
     * @brief IMU温度
     * @details 惯性测量单元的工作温度，单位为摄氏度
     */
    Q_PROPERTY(float temperature READ systemTemperature NOTIFY statusUpdated)

public:
    explicit Vk_ImuStatus(QObject *parent = nullptr);
    ~Vk_ImuStatus();

    void updateImuData(const struct VkScaledImuStatus *data);
    float systemXacc();
    float systemYacc();
    float systemZacc();
    float systemXgyro();
    float systemYgyro();
    float systemZgyro();
    float systemXmag();
    float systemYmag();
    float systemZmag();
    float systemTemperature();

signals:

    void statusUpdated();

private:
    struct VkScaledImuStatus *m_scaledImu;
};

//----------------------- 编队飞行 -----------------------
/**
 * @class Vk_FormationLeader
 * @brief 编队长机状态管理类
 * 管理多机编队飞行中长机的状态信息
 */
class Vk_FormationLeader : public QObject {
    Q_OBJECT

    /**
     * @brief 编队飞行长机信息时间戳
     * @details 本地时间戳，单位：毫秒(ms)
     */
    Q_PROPERTY(quint32 timestamp READ timestamp NOTIFY statusUpdated)
    /**
     * @brief 长机状态字
     * @details 编队长机的状态位图，用于表示长机的各种状态信息
     */
    Q_PROPERTY(quint32 state READ state NOTIFY statusUpdated)
    /**
     * @brief 纬度
     * @details 编队长机的纬度坐标，单位：度(deg)
     */
    Q_PROPERTY(double lat READ lat NOTIFY statusUpdated)
    /**
     * @brief 经度
     * @details 编队长机的经度坐标，单位：度(deg)
     */
    Q_PROPERTY(double lon READ lon NOTIFY statusUpdated)
    /**
     * @brief 海拔高度
     * @details 编队长机的海拔高度，单位：米(m)
     */
    Q_PROPERTY(float msl READ msl NOTIFY statusUpdated)
    /**
     * @brief 东向速度
     * @details 编队长机的东向速度分量，单位：米/秒(m/s)
     */
    Q_PROPERTY(float ve READ ve NOTIFY statusUpdated)
    /**
     * @brief 北向速度
     * @details 编队长机的北向速度分量，单位：米/秒(m/s)
     */
    Q_PROPERTY(float vn READ vn NOTIFY statusUpdated)
    /**
     * @brief 天向速度
     * @details 编队长机的天向(垂直向上)速度分量，单位：米/秒(m/s)
     */
    Q_PROPERTY(float vu READ vu NOTIFY statusUpdated)
    /**
     * @brief 机头航向
     * @details 编队长机的机头航向角，北偏东为正，单位：度(deg)
     */
    Q_PROPERTY(float yaw READ yaw NOTIFY statusUpdated)
    /**
     * @brief 机间左右间距
     * @details 编队中飞机之间的左右间距，单位：米(m)
     */
    Q_PROPERTY(float xDist READ xDist NOTIFY statusUpdated)
    /**
     * @brief 机间前后间距
     * @details 编队中飞机之间的前后间距，单位：米(m)
     */
    Q_PROPERTY(float yDist READ yDist NOTIFY statusUpdated)
    /**
     * @brief 机间高度间距
     * @details 编队中飞机之间的高度间距，单位：米(m)
     */
    Q_PROPERTY(float zDist READ zDist NOTIFY statusUpdated)
    /**
     * @brief 矩形队形列数
     * @details 矩形编队队形的列数，单位：个
     */
    Q_PROPERTY(quint16 rectColNum READ rectColNum NOTIFY statusUpdated)
    /**
     * @brief 队形类型
     * @details 编队的队形类型，参考 VKFLY_FORMATION_TYPE 枚举定义
     */
    Q_PROPERTY(quint8 formationType READ formationType NOTIFY statusUpdated)

public:
    explicit Vk_FormationLeader(QObject *parent = nullptr);
    void updateFormationData(const VkFormationLeaderStatus *data);
    quint32 timestamp() const;
    quint32 state() const;
    double lat() const;
    double lon() const;
    float msl() const;
    float ve() const;
    float vn() const;
    float vu() const;
    float yaw() const;
    float xDist() const;
    float yDist() const;
    float zDist() const;
    quint16 rectColNum() const;
    quint8 formationType() const;

signals:
    void statusUpdated();

private:
    VkFormationLeaderStatus *m_formationLeader;
};

//----------------------- 安全系统 -----------------------
/**
 * @class Vk_ParachuteStatus
 * @brief 降落伞状态管理类
 * 管理应急降落系统的状态监控
 */
class Vk_ParachuteStatus : public QObject {
    Q_OBJECT
    /**
     * @brief 降落伞数据时间戳
     * @details 毫秒时间戳，从系统启动开始计算，单位：毫秒(ms)
     */
    Q_PROPERTY(quint32 timestamp READ timestamp NOTIFY statusUpdated)
    /**
     * @brief 备用供电电压
     * @details 降落伞系统的备用电源电压，单位：伏特(V)
     */
    Q_PROPERTY(float backvolt READ backvolt NOTIFY statusUpdated)
    /**
     * @brief 降落伞故障码
     * @details 降落伞系统的错误代码，用于诊断系统故障
     */
    Q_PROPERTY(quint16 errCode READ errCode NOTIFY statusUpdated)
    /**
     * @brief 降落伞状态
     * @details 降落伞当前状态：0-未就绪，1-就绪，2-已开伞，3-故障
     */
    Q_PROPERTY(quint8 state READ state NOTIFY statusUpdated)
    /**
     * @brief 自动开伞设置
     * @details 伞自主触发开关：0-不启用，1-启动
     */
    Q_PROPERTY(quint8 autoLaunch READ autoLaunch NOTIFY statusUpdated)
    /**
     * @brief 无人机控制命令
     * @details 伞给飞控的命令：0-无命令，1-停桨
     */
    Q_PROPERTY(quint8 uavCmd READ uavCmd NOTIFY statusUpdated)

public:
    explicit Vk_ParachuteStatus(QObject *parent = nullptr);
    ~Vk_ParachuteStatus();
    void updateParachuteData(const VkParachuteStatus *data);
    quint32 timestamp() const;
    float backvolt() const;
    quint16 errCode() const;
    quint8 state() const;
    quint8 autoLaunch() const;
    quint8 uavCmd() const;

signals:

    void statusUpdated();

private:
    VkParachuteStatus *m_parachuteStatus;
};

//----------------------- 任务载荷 -----------------------
/**
 * @class Vk_WeigherState
 * @brief 称重器状态管理类
 * 管理农业喷洒、货物运输的重量监测系统
 */
class Vk_WeigherState : public QObject {
    Q_OBJECT

    /**
     * @brief 称重器重量
     * @details 当前称重器测量的重量值，单位：克(g)
     */
    Q_PROPERTY(quint32 weight READ weight NOTIFY statusUpdated)
    /**
     * @brief 称重器重量变化率
     * @details 重量的变化速率，单位：克每秒(g/s)
     */
    Q_PROPERTY(quint16 weightD READ weightD NOTIFY statusUpdated)
    /**
     * @brief 称重器工作状态
     * @details 称重器当前的工作状态码
     */
    Q_PROPERTY(quint8 workState READ workState NOTIFY statusUpdated)
    /**
     * @brief 称重器故障码
     * @details 称重器系统的错误代码，用于诊断系统故障
     */
    Q_PROPERTY(quint8 errCode READ errCode NOTIFY statusUpdated)

public:
    explicit Vk_WeigherState(QObject *parent = nullptr);

    void updateWeigherData(const VkWeigherState *data);
    quint32 weight() const;
    quint16 weightD() const;
    quint8 workState() const;
    quint8 errCode() const;

signals:
    void statusUpdated();

private:
    VkWeigherState *m_data;
};
