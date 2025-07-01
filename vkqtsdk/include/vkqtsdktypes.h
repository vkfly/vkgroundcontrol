/*
 * Data type in VKSDK
 */

#pragma once

#include <QObject>
#include <QList>

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
 * @brief 遥控器状态信息类
 * @property model 遥控器型号
 * @property rssi 遥控信号强度指示值
 */
class Vk_RcInfo : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString model READ rcModel NOTIFY modelUpdated)
    Q_PROPERTY(int rssi READ rssiValue NOTIFY rssiUpdated)

public:
    explicit Vk_RcInfo(QObject *parent = nullptr) : QObject(parent) {}

    /**
     * @brief 更新遥控器型号
     * @param model 新的遥控器型号字符串
     * 当型号发生变化时触发modelUpdated信号
     */
    void updateRcModel(const QString &model) {
        if (_rc_model != model) {
            _rc_model = model;
            emit modelUpdated();
        }
    }

    /**
     * @brief 更新RSSI值
     * @param rssi 新的信号强度值
     * 当RSSI值变化时触发rssiUpdated信号
     */
    void updateRssi(int rssi) {
        if (_rssi != rssi) {
            _rssi = rssi;
            emit rssiUpdated();
        }
    }

    // 获取当前遥控器型号
    QString rcModel() { return _rc_model; }
    // 获取当前RSSI信号强度值
    int rssiValue() { return _rssi; }

signals:
    // 遥控器型号更新信号
    void modelUpdated();
    // RSSI值更新信号
    void rssiUpdated();

private:
    QString _rc_model;  // 存储遥控器型号
    int _rssi;          // 存储信号强度值
};

//----------------------- 心跳包状态 -----------------------
/**
 * @class Vk_Heartbeat
 * @brief 系统心跳包数据管理类
 * @property heartbeatCustomMode 飞控自定义模式代码
 * @property lockStatus 飞控锁定状态（0=解锁, 1=锁定）
 * 用于检测系统存活状态和控制模式，包含飞控核心状态信息
 */
class Vk_Heartbeat : public QObject {
    Q_OBJECT
    // 所有属性变更均触发statusUpdated信号
    Q_PROPERTY(quint32 heartbeatCustomMode READ heartbeatCustomMode NOTIFY statusUpdated)
    Q_PROPERTY(quint8 heartbeatType READ heartbeatType NOTIFY statusUpdated)
    Q_PROPERTY(quint8 heartbeatAutopilot READ heartbeatAutopilot NOTIFY statusUpdated)
    Q_PROPERTY(quint8 heartbeatBaseMode READ heartbeatBaseMode NOTIFY statusUpdated)
    Q_PROPERTY(quint8 heartbeatSystemStatus READ heartbeatSystemStatus NOTIFY statusUpdated)
    Q_PROPERTY(int lockStatus READ getLockStatus NOTIFY statusUpdated)

public:
    explicit Vk_Heartbeat(QObject *parent = nullptr);

    /**
     * @brief 更新心跳包数据
     * @param status 心跳包原始数据结构指针
     * 解析底层心跳包数据并更新内部状态
     */
    void updateHeatBeatData(const struct VkHeartbeat* status);

    // 属性读取函数
    quint32 heartbeatCustomMode();  //< 获取自定义模式代码
    quint8 heartbeatType();         //< 获取飞控类型
    quint8 heartbeatAutopilot();    //< 获取自动驾驶类型
    quint8 heartbeatBaseMode();     //< 获取基础控制模式
    quint8 heartbeatSystemStatus(); //< 获取系统状态码

    // 更新飞控锁定状态（根据heartbeatBaseMode计算）
    void updateLockStatus();
    // 获取飞控锁定状态（0=解锁, 1=锁定）
    quint8 getLockStatus();

signals:
    // 心跳包状态更新信号（任何属性变更时触发）
    void statusUpdated();

private:
    VkHeartbeat* m_heatBeat;  // 原始心跳包数据存储
    quint8 lock_status;        // 飞控锁定状态缓存
};

//----------------------- 日志系统 -----------------------
/**
 * @class VkLogEntry
 * @brief 日志条目数据模型类
 * @property logid 日志唯一标识符
 * @property timestamp 日志创建时间戳（微秒）
 * @property size 日志文件大小（字节）
 * 表示单个日志文件的基础元信息
 */
class VkLogEntry : public QObject {
    Q_OBJECT
    Q_PROPERTY(int logid READ getId CONSTANT)
    Q_PROPERTY(qint64 timestamp READ getTimestamp CONSTANT)
    Q_PROPERTY(uint32_t size READ getSize CONSTANT)

public:
    // 构造函数（初始化所有属性）
    explicit VkLogEntry(int id, qint64 ts, uint32_t size, QObject *parent = nullptr)
        : QObject(parent), _logid(id), _ts(ts), _size(size) {}
    virtual ~VkLogEntry() = default;

public:
    int getId() { return _logid; }            //< 获取日志ID
    qint64 getTimestamp() { return _ts; }     //< 获取日志时间戳
    uint32_t getSize() { return _size; }      //< 获取日志文件大小

    int _logid;       // 日志唯一ID
    qint64 _ts;       // 时间戳（微秒）
    uint32_t _size;   // 文件大小（字节）
};

//----------------------- 系统状态 -----------------------
/**
 * @class VkSystemStatus
 * @brief 全局系统状态监控类
 * @property batteryVoltage 电池电压（伏特）
 * @property batteryRemaining 剩余电量百分比（0-100）
 * 监控传感器、电池、通信错误等关键系统指标
 */
class VkSystemStatus : public QObject {
    Q_OBJECT
    // 传感器状态掩码
    Q_PROPERTY(uint64_t onboardControlSensorsPresent READ systemStatusSensorsPresent NOTIFY statusUpdated)
    Q_PROPERTY(uint64_t onboardControlSensorsEnabled READ systemStatusSensorsEnabled NOTIFY statusUpdated)
    Q_PROPERTY(uint64_t onboardControlSensorsHealth READ systemStatusSensorsHealth NOTIFY statusUpdated)
    // 系统负载指标
    Q_PROPERTY(int systemLoad READ systemStatusLoad NOTIFY statusUpdated)
    // 电池相关属性
    Q_PROPERTY(float batteryVoltage READ systemStatusBatteryVoltage NOTIFY statusUpdated)
    Q_PROPERTY(float batteryCurrent READ systemStatusBatteryCurrent NOTIFY statusUpdated)
    Q_PROPERTY(int batteryRemaining  READ systemStatusBatteryRemaining NOTIFY statusUpdated)
    // 通信质量指标
    Q_PROPERTY(int commDropRate READ systemStatusDropRateComm NOTIFY statusUpdated)
    Q_PROPERTY(int commErrors READ systemStatusCommErrors NOTIFY statusUpdated)
    // 错误计数器
    Q_PROPERTY(int errorCount1 READ systemStatusErrorCount1 NOTIFY statusUpdated)
    Q_PROPERTY(int errorCount2 READ systemStatusErrorCount2 NOTIFY statusUpdated)
    Q_PROPERTY(int errorCount3 READ systemStatusErrorCount3 NOTIFY statusUpdated)
    Q_PROPERTY(int errorCount4 READ systemStatusErrorCount4 NOTIFY statusUpdated)

public:
    explicit VkSystemStatus(QObject *parent = nullptr);

    /**
     * @brief 更新系统状态数据
     * @param status 原始系统状态数据结构指针
     * 解析并更新所有系统状态属性
     */
    void updateData(const VkSysStatus *status);

    // 属性读取接口
    uint64_t systemStatusSensorsPresent();   //< 获取存在的传感器掩码
    uint64_t systemStatusSensorsEnabled();   //< 获取启用的传感器掩码
    uint64_t systemStatusSensorsHealth();    //< 获取传感器健康状态掩码
    int systemStatusLoad();                  //< 获取处理器负载（百分比）
    float systemStatusBatteryVoltage();      //< 获取电池电压（伏特）
    float systemStatusBatteryCurrent();      //< 获取电池电流（安培）
    int systemStatusDropRateComm();          //< 获取通信丢包率（百分比）
    int systemStatusCommErrors();            //< 获取通信错误计数
    int systemStatusErrorCount1();           //< 获取错误计数器1
    int systemStatusErrorCount2();           //< 获取错误计数器2
    int systemStatusErrorCount3();           //< 获取错误计数器3
    int systemStatusErrorCount4();           //< 获取错误计数器4
    int systemStatusBatteryRemaining();      //< 获取电池剩余电量（百分比）

signals:
    void statusUpdated();

private:
    VkSysStatus* m_status;  // 原始系统状态数据存储
};

//----------------------- 电池管理系统 -----------------------
/**
 * @class Vk_QingxieBms
 * @brief 倾斜电池专用BMS管理类（用于氢燃料电池等特殊系统）
 * @property batVoltage 电池电压（伏特）
 * @property gasTankPressure 氢气罐压力（kPa）
 * @property faultStatus 故障状态位掩码
 * 监控氢燃料电池系统的特殊参数
 */
class Vk_QingxieBms : public QObject {
    Q_OBJECT
    // 电压/电流参数
    Q_PROPERTY(float batVoltage READ batVoltage NOTIFY statusUpdated)
    Q_PROPERTY(float servoCurrent READ servoCurrent NOTIFY statusUpdated)
    Q_PROPERTY(float stackVoltage READ stackVoltage NOTIFY statusUpdated)
    Q_PROPERTY(float servoVoltage READ servoVoltage NOTIFY statusUpdated)
    Q_PROPERTY(float batRefuelCurrent READ batRefuelCurrent NOTIFY statusUpdated)
    // 压力参数
    Q_PROPERTY(quint16 gasTankPressure READ gasTankPressure NOTIFY statusUpdated)
    Q_PROPERTY(quint16 pipePressure READ pipePressure NOTIFY statusUpdated)
    // 温度参数
    Q_PROPERTY(quint16 pcbTemp READ pcbTemp NOTIFY statusUpdated)
    Q_PROPERTY(quint16 stackTemp READ stackTemp NOTIFY statusUpdated)
    // 状态标识
    Q_PROPERTY(quint16 workStatus READ workStatus NOTIFY statusUpdated)
    Q_PROPERTY(quint16 faultStatus READ faultStatus NOTIFY statusUpdated)
    Q_PROPERTY(quint8 selfCheck READ selfCheck NOTIFY statusUpdated)
    Q_PROPERTY(quint8 id READ id NOTIFY statusUpdated)

public:
    explicit Vk_QingxieBms(QObject *parent = nullptr);

    /**
     * @brief 更新BMS数据
     * @param status 原始BMS数据结构指针
     * 解析并更新所有燃料电池系统参数
     */
    void updateqingxieBmsData(const struct VkQingxieBms *status);

    // 属性访问接口
    float batVoltage() const;          //< 获取电池电压（V）
    float servoCurrent() const;        //< 获取伺服电流（A）
    float stackVoltage() const;        //< 获取电堆电压（V）
    float servoVoltage() const;        //< 获取伺服电压（V）
    float batRefuelCurrent() const;    //< 获取加注电流（A）
    quint16 gasTankPressure() const;   //< 获取气罐压力（kPa）
    quint16 pipePressure() const;      //< 获取管道压力（kPa）
    quint16 pcbTemp() const;           //< 获取PCB温度（℃）
    quint16 stackTemp() const;         //< 获取电堆温度（℃）
    quint16 workStatus() const;        //< 获取工作状态码
    quint16 faultStatus() const;       //< 获取故障状态掩码
    quint8 selfCheck() const;          //< 获取自检状态
    quint8 id() const;                 //< 获取BMS模块ID

signals:
    /// BMS状态更新信号（任何参数变更时触发）
    void statusUpdated();

private:
    VkQingxieBms *m_data; // 原始BMS数据存储
};

/**
 * @class Vk_BmsStatus
 * @brief 通用电池管理系统（BMS）状态类
 * @property cellVolt 单体电池电压列表（mV）
 * @property temperature 电池温度（℃）
 * @property health 电池健康状态（百分比）
 * 监控传统锂电池组的状态参数
 */
class Vk_BmsStatus : public QObject {
    Q_OBJECT
    // 基础参数
    Q_PROPERTY(quint32 timeBootMs READ timeBootMs NOTIFY statusUpdated)
    Q_PROPERTY(int voltage READ voltage NOTIFY statusUpdated)
    Q_PROPERTY(int current READ current NOTIFY statusUpdated)
    Q_PROPERTY(int16_t temperature READ temperature NOTIFY statusUpdated)
    // 电池单元参数
    Q_PROPERTY(uint16_t cellNum READ cellNum NOTIFY statusUpdated)
    Q_PROPERTY(QList<uint16_t> cellVolt READ cellVolt NOTIFY statusUpdated)
    // 寿命参数
    Q_PROPERTY(uint16_t cycCnt READ cycCnt NOTIFY statusUpdated)
    Q_PROPERTY(int8_t capPercent READ capPercent NOTIFY statusUpdated)
    // 标识参数
    Q_PROPERTY(uint8_t batId READ batId NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t health READ health NOTIFY statusUpdated)
    Q_PROPERTY(quint32 errCode READ errCode NOTIFY statusUpdated)

public:
    explicit Vk_BmsStatus(QObject *parent = nullptr);
    ~Vk_BmsStatus();

    /**
     * @brief 更新BMS状态数据
     * @param status 原始BMS状态数据结构指针
     * 解析并更新锂电池组的所有监控参数
     */
    void updatebmsStatusData(const VkBmsStatus *status);

    // 属性访问接口
    quint32 timeBootMs() const;           //< 获取启动时间戳（毫秒）
    int voltage() const;                  //< 获取总电压（mV）
    int current() const;                  //< 获取总电流（mA）
    int16_t temperature() const;          //< 获取温度（℃）
    uint16_t cellNum() const;             //< 获取电芯数量
    QList<uint16_t> cellVolt() const;     //< 获取电芯电压列表（mV）
    uint16_t cycCnt() const;              //< 获取循环次数
    int8_t capPercent() const;            //< 获取剩余容量百分比（0-100）
    uint8_t batId() const;                //< 获取电池组ID
    uint8_t health() const;               //< 获取健康状态（百分比）
    quint32 errCode() const;              //< 获取错误代码

signals:
    /// BMS状态更新信号（任何参数变更时触发）
    void statusUpdated();

private:
    VkBmsStatus *m_data;  // 原始BMS数据存储
};

//----------------------- 定位导航系统 -----------------------
/**
 * @class Vk_GlobalPositionInt
 * @brief 高精度全局位置数据管理类
 * @property lat 纬度(度)
 * @property relativeAlt 相对高度(米)
 * @property hdg 航向角(度)
 * 融合GNSS/INS的高精度定位信息，包含位置、高度、速度和航向数据
 */
class Vk_GlobalPositionInt : public QObject {
    Q_OBJECT

    // 位置参数
    Q_PROPERTY(double lat READ lat NOTIFY statusUpdated)
    Q_PROPERTY(double lon READ lon NOTIFY statusUpdated)
    Q_PROPERTY(float alt READ alt NOTIFY statusUpdated)
    Q_PROPERTY(float relativeAlt READ relativeAlt NOTIFY statusUpdated)
    // 速度参数
    Q_PROPERTY(double vx READ vx NOTIFY statusUpdated)
    Q_PROPERTY(double vy READ vy NOTIFY statusUpdated)
    Q_PROPERTY(float vz READ vz NOTIFY statusUpdated)
    // 方向参数
    Q_PROPERTY(float hdg READ hdg NOTIFY statusUpdated)

    Q_PROPERTY(float verticalSpeed READ verticalSpeed NOTIFY statusUpdated)    // 垂直速度(m/s)
    Q_PROPERTY(double horizontalSpeed READ horizontalSpeed NOTIFY statusUpdated) // 水平速度(m/s)

public:
    explicit Vk_GlobalPositionInt(QObject *parent = nullptr);

    /**
     * @brief 更新全局位置数据
     * @param status 原始位置数据结构指针
     * 解析并更新所有位置、速度、方向参数，同时计算水平和垂直速度
     */
    void updateGlobalPositionData(const struct VkGlobalPositionInt *status);

    // 位置访问接口
    double lat() const;        //< 获取纬度（度）
    double lon() const;        //< 获取经度（度）
    float alt() const;         //< 获取绝对高度（米，WGS84）
    float relativeAlt() const; //< 获取相对高度（米，相对于起飞点）

    // 速度访问接口
    double vx() const;         //< 获取X方向速度（东北天坐标系，m/s）
    double vy() const;         //< 获取Y方向速度（东北天坐标系，m/s）
    float vz() const;          //< 获取Z方向速度（东北天坐标系，m/s）

    // 方向访问接口
    float hdg() const;         // <获取航向角（度，0-360，正北为0）

    // 复合速度访问接口
    float verticalSpeed() const;    //< 获取垂直速度（m/s，正值为上升）
    double horizontalSpeed() const;  //< 获取水平速度（m/s）

signals:
    // 全局位置更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    double m_lat;             // 纬度存储（度）
    double m_lon;             // 经度存储（度）
    float m_alt;              // 绝对高度存储（米）
    float m_relativeAlt;      // 相对高度存储（米）
    double m_vx;              // X方向速度存储（m/s）
    double m_vy;              // Y方向速度存储（m/s）
    float m_vz;               // Z方向速度存储（m/s）
    float m_hdg;              // 航向角存储（度）
    float m_verticalSpeed;    // 垂直速度存储（m/s）
    double m_horizontalSpeed; // 水平速度存储（m/s）
};

/**
 * @class VkGnss
 * @brief GNSS原始数据容器类
 * @property gpsInputLatitude 原始纬度(度)
 * @property gpsInputHdop 水平精度因子
 * @property gpsInputFixType 定位类型
 * 存储从GPS模块接收的原始卫星定位数据
 */
class VkGnss : public QObject {
    Q_OBJECT

    // 时间参数
    Q_PROPERTY(uint64_t gpsInputTimeMicroseconds READ gpsInputTimeMicroseconds NOTIFY statusUpdated)
    Q_PROPERTY(uint32_t gpsInputTimeWeekMs READ gpsInputTimeWeekMs NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t gpsInputTimeWeek READ gpsInputTimeWeek NOTIFY statusUpdated)
    // 位置参数
    Q_PROPERTY(double gpsInputLatitude READ gpsInputLatitude NOTIFY statusUpdated)
    Q_PROPERTY(double gpsInputLongitude READ gpsInputLongitude NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputAltitude READ gpsInputAltitude NOTIFY statusUpdated)
    // 精度参数
    Q_PROPERTY(float gpsInputHdop READ gpsInputHdop NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputVdop READ gpsInputVdop NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputHorizontalAccuracy READ gpsInputHorizontalAccuracy NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputVerticalAccuracy READ gpsInputVerticalAccuracy NOTIFY statusUpdated)
    // 速度参数
    Q_PROPERTY(float gpsInputVelocityNorth READ gpsInputVelocityNorth NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputVelocityEast READ gpsInputVelocityEast NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputVelocityDown READ gpsInputVelocityDown NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputSpeedAccuracy READ gpsInputSpeedAccuracy NOTIFY statusUpdated)
    // 状态参数
    Q_PROPERTY(uint16_t gpsInputIgnoreFlags READ gpsInputIgnoreFlags NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t gpsInputGpsId READ gpsInputGpsId NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t gpsInputFixType READ gpsInputFixType NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t gpsInputSatellitesVisible READ gpsInputSatellitesVisible NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t gpsInputYaw READ gpsInputYaw NOTIFY statusUpdated)  // 航向角(度)

public:
    explicit VkGnss(QObject *parent = nullptr);

    /**
     * @brief 更新GNSS原始数据
     * @param status 原始GNSS数据结构指针
     * 解析并存储GPS模块的原始输出数据
     */
    void updateData(const VkGpsInput *status);

    // 时间访问接口
    uint64_t gpsInputTimeMicroseconds();  //< 获取GPS时间戳（微秒）
    uint32_t gpsInputTimeWeekMs();        //< 获取GPS周内毫秒数
    uint16_t gpsInputTimeWeek();          //< 获取GPS周数

    // 位置访问接口
    double gpsInputLatitude();            //< 获取原始纬度（度）
    double gpsInputLongitude();           //< 获取原始经度（度）
    float gpsInputAltitude();             //< 获取原始高度（米）

    // 精度访问接口
    float gpsInputHdop();                 //< 获取水平精度因子
    float gpsInputVdop();                 //< 获取垂直精度因子
    float gpsInputHorizontalAccuracy();   //< 获取水平定位精度（米）
    float gpsInputVerticalAccuracy();     //< 获取垂直定位精度（米）

    // 速度访问接口
    float gpsInputVelocityNorth();        //< 获取北向速度分量（m/s）
    float gpsInputVelocityEast();         //< 获取东向速度分量（m/s）
    float gpsInputVelocityDown();         //< 获取地向速度分量（m/s）
    float gpsInputSpeedAccuracy();        //< 获取速度精度估计（m/s）

    // 状态访问接口
    uint16_t gpsInputIgnoreFlags();       //< 获取忽略标志位掩码
    uint8_t gpsInputGpsId();              //< 获取GPS接收器ID
    uint8_t gpsInputFixType();            //< 获取定位类型（0=无定位，2=2D，3=3D）
    uint8_t gpsInputSatellitesVisible();  //< 获取可见卫星数量
    uint16_t gpsInputYaw();               //< 获取原始航向角（度，0-359.99）

signals:
    // GNSS数据更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    VkGpsInput* m_gnss;  // 原始GNSS数据存储
};

/**
 * @class VkRtkMsg
 * @brief RTK差分定位数据管理类
 * @property rtkMsgLatitude RTK纬度(度)
 * @property rtkMsgHorizontalAccuracy 水平定位精度(米)
 * @property rtkMsgFixType RTK定位类型
 * 存储高精度RTK定位系统的输出数据
 */
class VkRtkMsg : public QObject {
    Q_OBJECT

    // 位置参数
    Q_PROPERTY(double rtkMsgLatitude READ rtkMsgLatitude NOTIFY statusUpdated)
    Q_PROPERTY(double rtkMsgLongitude READ rtkMsgLongitude NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgAltitudeMsl READ rtkMsgAltitudeMsl NOTIFY statusUpdated)   // 平均海平面高度
    Q_PROPERTY(float rtkMsgAltitudeEllipsoid READ rtkMsgAltitudeEllipsoid NOTIFY statusUpdated) // 椭球高度

    // 精度参数
    Q_PROPERTY(quint16 rtkMsgHdop READ rtkMsgHdop NOTIFY statusUpdated)
    Q_PROPERTY(quint16 rtkMsgVdop READ rtkMsgVdop NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgHorizontalAccuracy READ rtkMsgHorizontalAccuracy NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgVerticalAccuracy READ rtkMsgVerticalAccuracy NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgSpeedAccuracy READ rtkMsgSpeedAccuracy NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgHeadingAccuracy READ rtkMsgHeadingAccuracy NOTIFY statusUpdated)

    // 运动参数
    Q_PROPERTY(float rtkMsgGroundSpeed READ rtkMsgGroundSpeed NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgCourseOverGround READ rtkMsgCourseOverGround NOTIFY statusUpdated) // 对地航向

    // 状态参数
    Q_PROPERTY(quint32 rtkMsgDgpsAge READ rtkMsgDgpsAge NOTIFY statusUpdated)  // 差分数据年龄
    Q_PROPERTY(quint8 rtkMsgFixType READ rtkMsgFixType NOTIFY statusUpdated)
    Q_PROPERTY(quint8 rtkMsgSatellitesVisible READ rtkMsgSatellitesVisible NOTIFY statusUpdated)
    Q_PROPERTY(quint8 rtkMsgDgpsSatellites READ rtkMsgDgpsSatellites NOTIFY statusUpdated) // 差分卫星数
    Q_PROPERTY(float rtkMsgYaw READ rtkMsgYaw NOTIFY statusUpdated)  // 偏航角(度)

public:
    explicit VkRtkMsg(QObject *parent = nullptr);

    /**
     * @brief 更新RTK定位数据
     * @param status 原始RTK数据结构指针
     * 解析并存储高精度RTK定位系统的输出
     */
    void updateData(const struct VkGps2Raw *status);

    // 位置访问接口
    double rtkMsgLatitude();            //< 获取RTK纬度（度）
    double rtkMsgLongitude();           //< 获取RTK经度（度）
    float rtkMsgAltitudeMsl();          //< 获取平均海平面高度（米）
    float rtkMsgAltitudeEllipsoid();    //< 获取椭球高度（米）

    // 精度访问接口
    quint16 rtkMsgHdop();               //< 获取RTK水平精度因子
    quint16 rtkMsgVdop();               //< 获取RTK垂直精度因子
    float rtkMsgHorizontalAccuracy();   //< 获取水平定位精度（米）
    float rtkMsgVerticalAccuracy();     //< 获取垂直定位精度（米）
    float rtkMsgSpeedAccuracy();        //< 获取速度精度（m/s）
    float rtkMsgHeadingAccuracy();      //< 获取航向精度（度）

    // 运动参数访问接口
    float rtkMsgGroundSpeed();          //< 获取地速（m/s）
    float rtkMsgCourseOverGround();     //< 获取对地航向（度，0-360）

    // 状态访问接口
    quint32 rtkMsgDgpsAge();            //< 获取差分数据年龄（毫秒）
    quint8 rtkMsgFixType();             //< 获取RTK定位类型（4=固定解，5=浮点解）
    quint8 rtkMsgSatellitesVisible();   //< 获取可见卫星数
    quint8 rtkMsgDgpsSatellites();      //< 获取用于差分的卫星数
    float rtkMsgYaw();                  //< 获取RTK计算的偏航角（度）

signals:
    // RTK数据更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    VkGps2Raw* m_rtk;  // 原始RTK数据存储
};

//----------------------- 姿态控制系统 -----------------------
/**
 * @class Vk_Attitude
 * @brief 飞行器姿态数据管理类
 * @property attitudeRoll 横滚角(弧度)
 * @property attitudePitch 俯仰角(弧度)
 * @property attitudeYawSpeed 偏航角速度(rad/s)
 * 存储来自IMU的实时姿态信息，包含欧拉角和角速度
 */
class Vk_Attitude : public QObject {
    Q_OBJECT

    // 时间参数
    Q_PROPERTY(quint32 attitudeTimeBootMs READ attitudeTimeBootMs NOTIFY statusUpdated)
    // 姿态角参数（弧度）
    Q_PROPERTY(float attitudeRoll READ attitudeRoll NOTIFY statusUpdated)
    Q_PROPERTY(float attitudePitch READ attitudePitch NOTIFY statusUpdated)
    Q_PROPERTY(float attitudeYaw READ attitudeYaw NOTIFY statusUpdated)
    // 角速度参数（rad/s）
    Q_PROPERTY(float attitudeRollSpeed READ attitudeRollSpeed NOTIFY statusUpdated)
    Q_PROPERTY(float attitudePitchSpeed READ attitudePitchSpeed NOTIFY statusUpdated)
    Q_PROPERTY(float attitudeYawSpeed READ attitudeYawSpeed NOTIFY statusUpdated)

public:
    explicit Vk_Attitude(QObject *parent = nullptr);

    /**
     * @brief 更新姿态数据
     * @param status 原始姿态数据结构指针
     * 解析并存储IMU输出的飞行器姿态信息
     */
    void updateData(const VkAttitude *status);

    // 时间访问接口
    quint32 attitudeTimeBootMs();  //< 获取姿态数据时间戳（毫秒）

    // 姿态角访问接口
    float attitudeRoll();          //< 获取横滚角（弧度，-π~π）
    float attitudePitch();         //< 获取俯仰角（弧度，-π~π）
    float attitudeYaw();           //< 获取偏航角（弧度，-π~π）

    // 角速度访问接口
    float attitudeRollSpeed();     //< 获取横滚角速度（rad/s）
    float attitudePitchSpeed();    //< 获取俯仰角速度（rad/s）
    float attitudeYawSpeed();      //< 获取偏航角速度（rad/s）

    /**
     * @brief 角度范围限制函数
     * @param angle 输入角度（弧度）
     * @return 限制在-π到π范围内的角度
     * 用于将任意角度值规范到主值区间
     */
    float limitAngleToPMPIf(double angle);

signals:
    /// 姿态数据更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    VkAttitude* m_attitude;  // 原始姿态数据存储
};

//----------------------- 执行机构 -----------------------
/**
 * @class Vk_ServoOutputRaw
 * @brief 舵机输出原始值管理类
 * @property servoOutputRaw 19个通道的PWM输出值
 * 反映实际输出到电机/舵机的控制信号
 */
class Vk_ServoOutputRaw : public QObject {
    Q_OBJECT

    // 时间参数
    Q_PROPERTY(uint32_t timeBootMs READ timeBootMs NOTIFY statusUpdated)
    // 舵机输出值
    Q_PROPERTY(QList<int> servoOutputRaw READ servoOutputRaw NOTIFY statusUpdated)

public:
    explicit Vk_ServoOutputRaw(QObject *parent = nullptr);

    /**
     * @brief 更新舵机输出数据
     * @param data 原始舵机输出数据结构指针
     * 存储所有通道的PWM输出值（通常为1100-1900μs）
     */
    void upServoOutputRawdateData(const struct VkServoOutputRaw* data);

    // 时间访问接口
    uint32_t timeBootMs();  ///< 获取舵机数据时间戳（毫秒）

    // 舵机输出访问接口
    QList<int> servoOutputRaw();  ///< 获取19个通道的PWM输出值列表（μs）

signals:
    // 舵机输出更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    uint32_t time_boot_ms;    // 时间戳存储
    QList<int> m_servoBuffer; // PWM输出值存储（19通道）
};

//----------------------- 任务系统 -----------------------
/**
 * @class Vk_MissionCurrent
 * @brief 当前任务状态管理类
 * @property missionCurrentSeq 当前航点序号
 * @property missionState 任务执行状态
 * @property fencePlanId 地理围栏计划ID
 * 监控任务执行过程中的实时状态和计划信息
 */
class Vk_MissionCurrent : public QObject {
    Q_OBJECT
    // 任务进度参数
    Q_PROPERTY(quint16 missionCurrentSeq READ missionCurrentSeq NOTIFY statusUpdated)
    Q_PROPERTY(quint16 missionTotalItems READ missionTotalItems NOTIFY statusUpdated)
    // 状态标识参数
    Q_PROPERTY(quint8 missionState READ missionState NOTIFY statusUpdated)  // 0=未开始, 1=执行中, 2=暂停, 3=完成
    Q_PROPERTY(quint8 missionMode READ missionMode NOTIFY statusUpdated)    // 任务模式
    // 计划标识参数
    Q_PROPERTY(quint32 missionPlanId READ missionPlanId NOTIFY statusUpdated)
    Q_PROPERTY(quint32 fencePlanId READ fencePlanId NOTIFY statusUpdated)   // 地理围栏ID
    Q_PROPERTY(quint32 rallyPointsId READ rallyPointsId NOTIFY statusUpdated) // 集结点ID

public:
    explicit Vk_MissionCurrent(QObject *parent = nullptr);

    /**
     * @brief 更新任务状态数据
     * @param data 原始任务状态数据结构指针
     * 存储当前任务执行的进度和状态信息
     */
    void updateMissionCurrentData(const struct VkMissionCurrent* data);

    // 任务进度访问接口
    quint16 missionCurrentSeq();  //< 获取当前执行的航点序号
    quint16 missionTotalItems();  //< 获取任务总航点数

    // 状态标识访问接口
    quint8 missionState();        //< 获取任务执行状态（0=未开始,1=执行中,2=暂停,3=完成）
    quint8 missionMode();         //< 获取任务模式（自动、返航、降落等）

    // 计划标识访问接口
    quint32 missionPlanId();      //< 获取任务计划唯一ID
    quint32 fencePlanId();        //< 获取地理围栏计划ID
    quint32 rallyPointsId();      //< 获取集结点计划ID

signals:
    /// 任务状态更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    VkMissionCurrent* m_current;  // 原始任务状态数据存储
};

//----------------------- 遥控输入 -----------------------
/**
 * @class Vk_RcChannels
 * @brief 遥控器通道数据管理类
 * @property rcChannelsRaw 19个通道的原始值(μs)
 * @property rcRssiValue 遥控信号强度(0-100%)
 * 解析并存储遥控器输入的原始通道数据和信号质量
 */
class Vk_RcChannels : public QObject {
    Q_OBJECT
    Q_PROPERTY(QList<int> rcChannelsRaw READ rcChannelsRaw NOTIFY statusUpdated)  // 19通道PWM值(1100-1900μs)
    Q_PROPERTY(quint8 rcRssiValue READ rcRssiValue NOTIFY statusUpdated)          // 信号强度百分比

public:
    explicit Vk_RcChannels(QObject *parent = nullptr);

    /**
     * @brief 更新遥控通道数据
     * @param data 原始遥控通道数据结构指针
     * 解析并存储19个通道的PWM值和RSSI信号强度
     */
    void updateRcChannelsData(const struct VkRcChannels* data);

    QList<int> rcChannelsRaw();  //< 获取19个通道的原始PWM值列表(μs)
    int rcRssiValue();           //< 获取遥控信号强度(0-100%)

signals:
    /// 遥控数据更新信号（任何通道值或信号强度变化时触发）
    void statusUpdated();

private:
    QList<int> m_channelsRaw;  // 19通道PWM值存储
    int m_rssi;                // 信号强度存储
};

//----------------------- 硬件版本管理 -----------------------
/**
 * @class Vk_ComponentVersion
 * @brief 硬件组件版本信息管理类
 * @property hardwareVersion 硬件版本号
 * @property firmwareVersion 固件版本号
 * @property serialNumber 设备序列号
 * 存储和管理系统各组件的版本和标识信息
 */
class Vk_ComponentVersion : public QObject {
    Q_OBJECT
    Q_PROPERTY(quint16 componentId READ componentId NOTIFY statusUpdated)       // 组件ID
    Q_PROPERTY(QString hardwareVersion READ hardwareVersion NOTIFY statusUpdated) // 硬件版本字符串
    Q_PROPERTY(QString firmwareVersion READ firmwareVersion NOTIFY statusUpdated) // 固件版本字符串
    Q_PROPERTY(QString serialNumber READ serialNumber NOTIFY statusUpdated)     // 序列号字符串
    Q_PROPERTY(QString manufactoryName READ manufactoryName NOTIFY statusUpdated) // 制造商名称
    Q_PROPERTY(QString deviceModel READ deviceModel NOTIFY statusUpdated)       // 设备型号

public:
    explicit Vk_ComponentVersion(QObject *parent = nullptr);

    /**
     * @brief 更新组件版本信息
     * @param data 原始版本信息结构指针
     * 解析并存储硬件组件的标识和版本信息
     */
    void updateComponentData(const struct VkComponentVersion* data);

    quint16 componentId();        //< 获取组件ID
    QString hardwareVersion();    //< 获取硬件版本号字符串
    QString firmwareVersion();    //< 获取固件版本号字符串
    QString serialNumber();       //< 获取设备序列号
    QString manufactoryName();    //< 获取制造商名称
    QString deviceModel();        //< 获取设备型号

signals:
    /// 版本信息更新信号（任何信息变化时触发）
    void statusUpdated();

private:
    struct VkComponentVersion* m_component;  // 原始版本数据存储
};

//----------------------- 导航系统 -----------------------
/**
 * @class Vk_insStatus
 * @brief 惯性导航系统状态管理类
 * @property navStatus 导航状态标志
 * @property rawGpsAlt 原始GPS高度(米)
 * @property magCalibStage 磁力计校准阶段(0-5)
 * 存储INS系统的内部状态、原始数据和校准信息
 */
class Vk_insStatus : public QObject {
    Q_OBJECT
    // 时间参数
    Q_PROPERTY(uint32_t timeBootMs READ timeBootMs NOTIFY statusUpdated)
    // 传感器参数
    Q_PROPERTY(float g0 READ g0 NOTIFY statusUpdated)                   // 重力加速度(m/s²)
    Q_PROPERTY(int32_t rawLatitude READ rawLatitude NOTIFY statusUpdated)  // 原始纬度(1e-7度)
    Q_PROPERTY(int32_t rawLongitude READ rawLongitude NOTIFY statusUpdated)// 原始经度(1e-7度)
    Q_PROPERTY(float baroAlt READ baroAlt NOTIFY statusUpdated)         // 气压计高度(米)
    Q_PROPERTY(float rawGpsAlt READ rawGpsAlt NOTIFY statusUpdated)      // 原始GPS高度(米)
    Q_PROPERTY(int16_t temperature READ temperature NOTIFY statusUpdated) // IMU温度(℃)
    // 状态标志
    Q_PROPERTY(uint8_t navStatus READ navStatus NOTIFY statusUpdated)    // 导航状态标志
    Q_PROPERTY(uint8_t sFlag1 READ sFlag1 NOTIFY statusUpdated)          // 状态标志1
    Q_PROPERTY(uint8_t sFlag2 READ sFlag2 NOTIFY statusUpdated)          // 状态标志2
    Q_PROPERTY(uint8_t sFlag3 READ sFlag3 NOTIFY statusUpdated)          // 状态标志3
    Q_PROPERTY(uint8_t sFlag4 READ sFlag4 NOTIFY statusUpdated)          // 状态标志4
    Q_PROPERTY(uint8_t sFlag5 READ sFlag5 NOTIFY statusUpdated)          // 状态标志5
    Q_PROPERTY(uint8_t sFlag6 READ sFlag6 NOTIFY statusUpdated)          // 状态标志6
    // 校准参数
    Q_PROPERTY(uint8_t magCalibStage READ magCalibStage NOTIFY statusUpdated)  // 磁力计校准阶段(0-5)
    Q_PROPERTY(uint8_t solvPsatNum READ solvPsatNum NOTIFY statusUpdated)      // 位置解算卫星数
    Q_PROPERTY(uint8_t solvHsatNum READ solvHsatNum NOTIFY statusUpdated)      // 高度解算卫星数
    Q_PROPERTY(uint8_t vibeCoe READ vibeCoe NOTIFY statusUpdated)              // 振动系数

public:
    explicit Vk_insStatus(QObject *parent = nullptr);
    ~Vk_insStatus();

    /**
     * @brief 更新INS状态数据
     * @param data 原始INS状态数据结构指针
     * 解析并存储惯性导航系统的内部状态和原始数据
     */
    void updateVkinsData(const struct VkinsStatus* data);

    // 时间访问接口
    uint32_t timeBootMs();  ///< 获取INS数据时间戳(毫秒)

    // 传感器数据接口
    float g0();             //< 获取重力加速度值(m/s²)
    int32_t rawLatitude();  //< 获取原始纬度值(1e-7度)
    int32_t rawLongitude(); //< 获取原始经度值(1e-7度)
    float baroAlt();        //< 获取气压计高度(米)
    float rawGpsAlt();      //< 获取原始GPS高度(米)
    int16_t temperature();  //< 获取IMU温度(℃)

    // 状态标志接口
    uint8_t navStatus();    //< 获取导航状态标志
    uint8_t sFlag1();       //< 获取状态标志1
    uint8_t sFlag2();       //< 获取状态标志2
    uint8_t sFlag3();       //< 获取状态标志3
    uint8_t sFlag4();       //< 获取状态标志4
    uint8_t sFlag5();       //< 获取状态标志5
    uint8_t sFlag6();       //<

    // 校准参数接口
    uint8_t magCalibStage();  //< 获取磁力计校准阶段(0=未校准,1-4=校准中,5=完成)
    uint8_t solvPsatNum();    //< 获取位置解算卫星数
    uint8_t solvHsatNum();    //< 获取高度解算卫星数
    uint8_t vibeCoe();        //< 获取振动系数(0-100)

signals:
    /// INS状态更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    struct VkinsStatus* m_vkinsStatus;  // 原始INS数据存储
};

/**
 * @class Vk_FmuStatus
 * @brief 飞行管理单元状态管理类
 * @property flightTime 累计飞行时间(秒)
 * @property rtlReason 返航原因代码(0-255)
 * @property servoState 舵机状态标志位掩码
 * 监控飞行控制核心模块的状态和关键参数
 */
class Vk_FmuStatus : public QObject {
    Q_OBJECT
    // 时间参数
    Q_PROPERTY(uint32_t timeBootMs READ timeBootMs NOTIFY statusUpdated)
    // 飞行参数
    Q_PROPERTY(uint32_t flightTime READ flightTime NOTIFY statusUpdated)  // 累计飞行时间(秒)
    Q_PROPERTY(uint32_t distToTar READ distToTar NOTIFY statusUpdated)    // 目标点距离(米)
    Q_PROPERTY(int flightDist READ flightDist NOTIFY statusUpdated)       // 总飞行距离(米)
    // 电源参数
    Q_PROPERTY(uint16_t upsVolt READ upsVolt NOTIFY statusUpdated)        // 备用电源电压(mV)
    Q_PROPERTY(uint16_t adcVolt READ adcVolt NOTIFY statusUpdated)        // ADC输入电压(mV)
    // 状态标志
    Q_PROPERTY(uint16_t servoState READ servoState NOTIFY statusUpdated)  // 舵机状态位掩码
    Q_PROPERTY(uint8_t rtlReason READ rtlReason NOTIFY statusUpdated)     // 返航原因代码
    Q_PROPERTY(uint8_t loiterReason READ loiterReason NOTIFY statusUpdated) // 盘旋原因代码
    Q_PROPERTY(uint8_t sFlag3 READ sFlag3 NOTIFY statusUpdated)           // 状态标志3

public:
    explicit Vk_FmuStatus(QObject *parent = nullptr);

    /**
     * @brief 更新FMU状态数据
     * @param data 原始FMU状态数据结构指针
     * 解析并存储飞行管理单元的关键状态参数
     */
    void updateFmuStatus(const struct VkFmuStatus* data);

    // 时间访问接口
    uint32_t timeBootMs() const;  //< 获取FMU数据时间戳(毫秒)

    // 飞行参数接口
    uint32_t flightTime() const;  //< 获取累计飞行时间(秒)
    uint32_t distToTar() const;   //< 获取当前目标点距离(米)
    int flightDist() const;       //< 获取总飞行距离(米)

    // 电源参数接口
    uint16_t upsVolt() const;     //< 获取备用电源电压(mV)
    uint16_t adcVolt() const;     //< 获取ADC输入电压(mV)

    // 状态标志接口
    uint16_t servoState() const;  //< 获取舵机状态位掩码(每bit对应一个舵机)
    uint8_t rtlReason() const;    //< 获取返航原因代码(1=低电量,2=遥控丢失,3=地理围栏)
    uint8_t loiterReason() const; //< 获取盘旋原因代码(1=等待指令,2=避障)
    uint8_t sFlag3() const;       //< 获取状态标志3

signals:
    /// FMU状态更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    struct VkFmuStatus* m_fmuStatus;  // 原始FMU数据存储
};

//----------------------- 飞行状态 -----------------------
/**
 * @class Vk_VfrHud
 * @brief 可视化飞行数据管理类
 * @property airspeed 空速(m/s)
 * @property groundspeed 地速(m/s)
 * @property climb 爬升率(m/s)
 * 综合飞行状态信息（HUD显示的核心参数）
 */
class Vk_VfrHud : public QObject {
    Q_OBJECT
    // 速度参数
    Q_PROPERTY(float airspeed READ systemAirspeed NOTIFY statusUpdated)       // 空速(m/s)
    Q_PROPERTY(float groundspeed READ systemGroundspeed NOTIFY statusUpdated) // 地速(m/s)
    // 高度参数
    Q_PROPERTY(float alt READ systemAltitude NOTIFY statusUpdated)            // 海拔高度(米)
    // 运动参数
    Q_PROPERTY(float climb READ systemClimbRate NOTIFY statusUpdated)         // 爬升率(m/s)
    Q_PROPERTY(int16_t heading READ systemHeading NOTIFY statusUpdated)       // 航向角(度)
    // 控制参数
    Q_PROPERTY(uint16_t throttle READ systemThrottle NOTIFY statusUpdated)    // 油门百分比(0-100)

public:
    explicit Vk_VfrHud(QObject *parent = nullptr);

    /**
     * @brief 更新HUD飞行数据
     * @param data 原始HUD数据结构指针
     * 解析并存储飞行状态的核心参数（用于HUD显示）
     */
    void updateVfrHudData(const struct VkVfrHud* data);

    float systemAirspeed();    //< 获取空速(m/s)
    float systemGroundspeed(); //< 获取地速(m/s)
    float systemAltitude();    //< 获取海拔高度(米)
    float systemClimbRate();   //< 获取爬升率(m/s，正值上升)
    int16_t systemHeading();   //< 获取航向角(度，0-360)
    uint16_t systemThrottle(); //< 获取油门百分比(0-100)

signals:
    /// HUD数据更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    struct VkVfrHud* m_vfrHud;  // 原始HUD数据存储
};

//----------------------- 动力系统 -----------------------
/**
 * @class Vk_EscStatus
 * @brief 电调状态监控管理类
 * @property rpm 电机转速列表(RPM)
 * @property temperature 电调温度列表(℃)
 * @property status 电调状态标志位掩码
 * 多电机的实时状态监测和告警
 */
class Vk_EscStatus : public QObject {
    Q_OBJECT
    // 基础参数
    Q_PROPERTY(uint64_t timestamp READ timestamp NOTIFY dataUpdated)   // 时间戳(μs)
    Q_PROPERTY(uint8_t index READ index NOTIFY dataUpdated)            // 电调组索引
    // 电机参数列表（每个电调）
    Q_PROPERTY(QList<int> rpm READ rpm NOTIFY dataUpdated)             // 转速列表(RPM)
    Q_PROPERTY(QList<float> voltage READ voltage NOTIFY dataUpdated)   // 电压列表(V)
    Q_PROPERTY(QList<float> current READ current NOTIFY dataUpdated)   // 电流列表(A)
    Q_PROPERTY(QList<uint> status READ status NOTIFY dataUpdated)      // 状态标志列表
    Q_PROPERTY(QList<int> temperature READ temperature NOTIFY dataUpdated) // 温度列表(℃)

public:
    explicit Vk_EscStatus(QObject *parent = nullptr);

    /**
     * @brief 更新电调状态数据
     * @param data 原始电调状态数据结构指针
     * 解析并存储所有电机的运行参数和状态
     */
    void updateEscStatusData(const struct VkEscStatus* data);

    // 基础参数接口
    uint64_t timestamp();  //< 获取电调数据时间戳(μs)
    uint8_t index();       //< 获取电调组索引(0-3)

    // 电机参数接口（列表索引对应电机号）
    QList<int> rpm();        //< 获取所有电机转速列表(RPM)
    QList<float> voltage();  //< 获取所有电机电压列表(V)
    QList<float> current();  //< 获取所有电机电流列表(A)
    QList<uint> status();    //< 获取所有电调状态标志列表
    QList<int> temperature(); //< 获取所有电调温度列表(℃)

signals:
    /// 电调数据更新信号（任何参数变化时触发）
    void dataUpdated();

private:
    uint64_t m_timestamp;    // 时间戳存储
    QList<int> m_rpm;        // 转速存储列表
    QList<float> m_voltage;  // 电压存储列表
    QList<float> m_current;  // 电流存储列表
    QList<uint> m_status;    // 状态标志存储列表
    QList<int> m_temperature;// 温度存储列表
    uint8_t m_index;         // 电调组索引
};

//----------------------- 感知系统 -----------------------
/**
 * @class Vk_ObstacleDistance
 * @brief 全向障碍物距离数据管理类
 * @property distances 72方向距离值数组(cm)
 * @property angleOffset 起始角度偏移(弧度)
 * @property sensorType 传感器类型(0=激光,1=超声波,2=红外)
 * 360°避障系统的原始距离数据采集和管理
 */
class Vk_ObstacleDistance : public QObject {
    Q_OBJECT
    // 基础参数
    Q_PROPERTY(int minDistance READ minDistance NOTIFY dataUpdated)  // 最小有效距离(cm)
    Q_PROPERTY(int maxDistance READ maxDistance NOTIFY dataUpdated)  // 最大有效距离(cm)
    // 传感器参数
    Q_PROPERTY(uint8_t sensorType READ sensorType NOTIFY dataUpdated) // 传感器类型
    Q_PROPERTY(uint8_t increment READ increment NOTIFY dataUpdated)   // 角度增量(度)
    Q_PROPERTY(float incrementF READ incrementF NOTIFY dataUpdated)   // 角度增量(浮点)
    Q_PROPERTY(float angleOffset READ angleOffset NOTIFY dataUpdated) // 起始角度偏移(弧度)
    Q_PROPERTY(uint8_t frame READ frame NOTIFY dataUpdated)          // 坐标系类型
    // 距离数据
    Q_PROPERTY(QList<int> distances READ distances NOTIFY dataUpdated) // 72方向距离值(cm)

public:
    explicit Vk_ObstacleDistance(QObject *parent = nullptr);

    /**
     * @brief 更新障碍物距离数据
     * @param data 原始障碍物距离数据结构指针
     * 解析并存储360°避障系统的原始距离数据
     */
    void updateobstacleDistanceData(const struct VkObstacleDistance* data);

    // 基础参数接口
    int minDistance();       //< 获取最小有效距离(cm)
    int maxDistance();       //< 获取最大有效距离(cm)

    // 传感器参数接口
    uint8_t sensorType();    //< 获取传感器类型(0=激光,1=超声波,2=红外)
    uint8_t increment();     //< 获取角度增量(度)
    float incrementF();      //< 获取角度增量(浮点值)
    float angleOffset();     //< 获取起始角度偏移(弧度，0=正前方)
    uint8_t frame();         //< 获取坐标系类型(0=机体坐标系,1=地理坐标系)

    // 距离数据接口
    QList<int> distances();  //< 获取72个方向的障碍物距离列表(cm, 65535=无效)

signals:
    /// 障碍物数据更新信号（任何参数变化时触发）
    void dataUpdated();

private:
    int m_distances[72];     // 72方向距离值存储
    int m_minDistance;       // 最小有效距离
    int m_maxDistance;       // 最大有效距离
    uint8_t m_sensorType;    // 传感器类型
    uint8_t m_increment;     // 角度增量
    float m_incrementF;      // 浮点角度增量
    float m_angleOffset;     // 起始角度偏移
    uint8_t m_frame;         // 坐标系类型

    struct VkObstacleDistance* m_obstacleDistance; // 原始数据存储
};

//----------------------- 单距离传感器 -----------------------
/**
 * @class Vk_DistanceSensor
 * @brief 单距离传感器数据管理类
 * @property currentDistance 当前测量距离(cm)
 * @property horizontalFov 水平视场角(弧度)
 * @property quaternion 传感器安装姿态(四元数)
 * 管理单个距离传感器（如激光雷达、超声波）的详细参数和测量数据
 */
class Vk_DistanceSensor : public QObject {
    Q_OBJECT
    // 基础参数
    Q_PROPERTY(uint16_t minDistance READ minDistance NOTIFY updated)    // 最小测量距离(cm)
    Q_PROPERTY(uint16_t maxDistance READ maxDistance NOTIFY updated)    // 最大测量距离(cm)
    Q_PROPERTY(double currentDistance READ currentDistance NOTIFY updated) // 当前距离(cm)
    // 标识参数
    Q_PROPERTY(uint8_t sensorType READ sensorType NOTIFY updated)       // 传感器类型
    Q_PROPERTY(uint8_t sensorId READ sensorId NOTIFY updated)           // 传感器ID
    Q_PROPERTY(uint8_t orientation READ orientation NOTIFY updated)     // 安装方向
    // 校准参数
    Q_PROPERTY(uint8_t covariance READ covariance NOTIFY updated)       // 测量协方差
    // 视场参数
    Q_PROPERTY(float horizontalFov READ horizontalFov NOTIFY updated)   // 水平视场角(弧度)
    Q_PROPERTY(float verticalFov READ verticalFov NOTIFY updated)       // 垂直视场角(弧度)
    // 姿态参数
    Q_PROPERTY(float quaternionW READ quaternionW NOTIFY updated)       // 四元数W分量
    Q_PROPERTY(float quaternionX READ quaternionX NOTIFY updated)       // 四元数X分量
    Q_PROPERTY(float quaternionY READ quaternionY NOTIFY updated)       // 四元数Y分量
    Q_PROPERTY(float quaternionZ READ quaternionZ NOTIFY updated)       // 四元数Z分量
    // 质量参数
    Q_PROPERTY(uint8_t signalQuality READ signalQuality NOTIFY updated) // 信号质量(0-100)

public:
    explicit Vk_DistanceSensor(QObject *parent = nullptr);

    /**
     * @brief 更新距离传感器数据
     * @param data 原始距离传感器数据结构指针
     * 解析并存储距离传感器的测量参数和状态信息
     */
    void updatedistanceSensorData(const struct VkDistanceSensorStatus *data);

    // 基础参数接口
    uint16_t minDistance() const;     //< 获取最小有效距离(cm)
    uint16_t maxDistance() const;     //< 获取最大有效距离(cm)
    double currentDistance() const;   //< 获取当前测量距离(cm)

    // 标识参数接口
    uint8_t sensorType() const;       //< 获取传感器类型(0=激光雷达,1=超声波,2=红外)
    uint8_t sensorId() const;         //< 获取传感器唯一ID
    uint8_t orientation() const;      //< 获取安装方向(0=前,1=后,2=左,3=右等)

    // 校准参数接口
    uint8_t covariance() const;       //< 获取测量协方差(0-255)

    // 视场参数接口
    float horizontalFov() const;      //< 获取水平视场角(弧度)
    float verticalFov() const;        //< 获取垂直视场角(弧度)

    // 姿态参数接口
    float quaternionW() const;        //< 获取安装姿态四元数W分量
    float quaternionX() const;        //< 获取安装姿态四元数X分量
    float quaternionY() const;        //< 获取安装姿态四元数Y分量
    float quaternionZ() const;        //< 获取安装姿态四元数Z分量

    // 质量参数接口
    uint8_t signalQuality() const;    //< 获取信号质量(0-100,100=最佳)

signals:
    /// 距离传感器数据更新信号（任何参数变化时触发）
    void updated();

private:
    struct VkDistanceSensorStatus* m_distanceSensorData;  // 原始数据存储
};

//----------------------- 通信系统 -----------------------
/**
 * @class Vk_HighLatency
 * @brief 高延迟链路状态管理类
 * @property wpDistance 距目标航点距离(米)
 * @property gpsNsat GPS卫星数
 * @property failsafe 故障保护状态(0=正常,1=激活)
 * 管理卫星通信等长距离链路的压缩状态数据
 */
class Vk_HighLatency : public QObject {
    Q_OBJECT
    // 位置参数
    Q_PROPERTY(quint32 customMode READ customMode NOTIFY dataUpdated) // 自定义模式
    Q_PROPERTY(float latitude READ latitude NOTIFY dataUpdated)       // 纬度(度)
    Q_PROPERTY(float longitude READ longitude NOTIFY dataUpdated)     // 经度(度)
    // 姿态参数
    Q_PROPERTY(float roll READ roll NOTIFY dataUpdated)               // 横滚角(弧度)
    Q_PROPERTY(float pitch READ pitch NOTIFY dataUpdated)             // 俯仰角(弧度)
    Q_PROPERTY(float heading READ heading NOTIFY dataUpdated)         // 航向角(弧度)
    Q_PROPERTY(float headingSp READ headingSp NOTIFY dataUpdated)     // 目标航向(弧度)
    // 高度参数
    Q_PROPERTY(qint16 altitudeAmsl READ altitudeAmsl NOTIFY dataUpdated) // 海拔高度(米)
    Q_PROPERTY(qint16 altitudeSp READ altitudeSp NOTIFY dataUpdated)   // 目标高度(米)
    // 导航参数
    Q_PROPERTY(quint16 wpDistance READ wpDistance NOTIFY dataUpdated) // 目标航点距离(米)
    Q_PROPERTY(quint8 wpNum READ wpNum NOTIFY dataUpdated)            // 目标航点序号
    // 控制参数
    Q_PROPERTY(quint8 baseMode READ baseMode NOTIFY dataUpdated)      // 基础飞行模式
    Q_PROPERTY(quint8 landedState READ landedState NOTIFY dataUpdated) // 着陆状态
    Q_PROPERTY(qint8 throttle READ throttle NOTIFY dataUpdated)       // 油门百分比(0-100)
    // 速度参数
    Q_PROPERTY(quint8 airspeed READ airspeed NOTIFY dataUpdated)      // 空速(m/s)
    Q_PROPERTY(quint8 airspeedSp READ airspeedSp NOTIFY dataUpdated)  // 目标空速(m/s)
    Q_PROPERTY(quint8 groundspeed READ groundspeed NOTIFY dataUpdated) // 地速(m/s)
    Q_PROPERTY(qint8 climbRate READ climbRate NOTIFY dataUpdated)     // 爬升率(m/s)
    // GPS参数
    Q_PROPERTY(quint8 gpsNsat READ gpsNsat NOTIFY dataUpdated)        // GPS卫星数
    Q_PROPERTY(quint8 gpsFixType READ gpsFixType NOTIFY dataUpdated)  // GPS定位类型
    // 电源参数
    Q_PROPERTY(quint8 batteryRemaining READ batteryRemaining NOTIFY dataUpdated) // 剩余电量(%)
    // 环境参数
    Q_PROPERTY(qint8 temperature READ temperature NOTIFY dataUpdated) // 内部温度(℃)
    Q_PROPERTY(qint8 temperatureAir READ temperatureAir NOTIFY dataUpdated) // 外部温度(℃)
    // 安全参数
    Q_PROPERTY(quint8 failsafe READ failsafe NOTIFY dataUpdated)      // 故障保护状态

public:
    explicit Vk_HighLatency(QObject* parent = nullptr);
    ~Vk_HighLatency();

    /**
     * @brief 更新高延迟链路数据
     * @param data 原始高延迟数据结构指针
     * 解析并存储压缩的飞行状态数据（用于卫星通信等低带宽链路）
     */
    void updatehighLatencyData(const struct VkHighLatency* data);

    // 位置参数接口
    quint32 customMode();      //< 获取自定义飞行模式代码
    float latitude();          //< 获取当前纬度(度)
    float longitude();         //< 获取当前经度(度)

    // 姿态参数接口
    float roll();              //< 获取横滚角(弧度)
    float pitch();             //< 获取俯仰角(弧度)
    float heading();           //< 获取当前航向角(弧度)
    float headingSp();         //< 获取目标航向角(弧度)

    // 高度参数接口
    qint16 altitudeAmsl();     //< 获取海拔高度(米)
    qint16 altitudeSp();       //< 获取目标高度(米)

    // 导航参数接口
    quint16 wpDistance();      //< 获取目标航点距离(米)
    quint8 wpNum();            //< 获取目标航点序号

    // 控制参数接口
    quint8 baseMode();         //< 获取基础飞行模式位掩码
    quint8 landedState();      //< 获取着陆状态(0=空中,1=地面)
    qint8 throttle();          //< 获取油门百分比(0-100)

    // 速度参数接口
    quint8 airspeed();         //< 获取空速(m/s)
    quint8 airspeedSp();       //< 获取目标空速(m/s)
    quint8 groundspeed();      //< 获取地速(m/s)
    qint8 climbRate();         //< 获取爬升率(m/s)

    // GPS参数接口
    quint8 gpsNsat();          //< 获取GPS卫星数
    quint8 gpsFixType();       //< 获取GPS定位类型(0-5)

    // 电源参数接口
    quint8 batteryRemaining(); //< 获取剩余电量百分比(0-100)

    // 环境参数接口
    qint8 temperature();       //< 获取内部温度(℃)
    qint8 temperatureAir();    //< 获取外部空气温度(℃)

    // 安全参数接口
    quint8 failsafe();         //< 获取故障保护状态(0=正常,1=激活)

signals:
    /// 高延迟数据更新信号（任何参数变化时触发）
    void dataUpdated();

private:
    struct VkHighLatency* m_highLatency;  // 原始数据存储
};

//----------------------- 传感器系统 -----------------------
/**
 * @class Vk_ScaledImuStatus
 * @brief 缩放IMU数据管理类
 * @property xacc X轴加速度(mG)
 * @property zgyro Z轴角速度(mrad/s)
 * @property temperature IMU温度(℃)
 * 管理惯性测量单元(IMU)的预处理输出数据
 */
class Vk_ScaledImuStatus : public QObject {
    Q_OBJECT
    // 加速度参数
    Q_PROPERTY(int16_t xacc READ systemXacc NOTIFY statusUpdated)  // X轴加速度(mG)
    Q_PROPERTY(int16_t yacc READ systemYacc NOTIFY statusUpdated)  // Y轴加速度(mG)
    Q_PROPERTY(int16_t zacc READ systemZacc NOTIFY statusUpdated)  // Z轴加速度(mG)
    // 角速度参数
    Q_PROPERTY(int16_t xgyro READ systemXgyro NOTIFY statusUpdated) // X轴角速度(mrad/s)
    Q_PROPERTY(int16_t ygyro READ systemYgyro NOTIFY statusUpdated) // Y轴角速度(mrad/s)
    Q_PROPERTY(int16_t zgyro READ systemZgyro NOTIFY statusUpdated) // Z轴角速度(mrad/s)
    // 磁力计参数
    Q_PROPERTY(int16_t xmag READ systemXmag NOTIFY statusUpdated)  // X轴磁力(mGauss)
    Q_PROPERTY(int16_t ymag READ systemYmag NOTIFY statusUpdated)  // Y轴磁力(mGauss)
    Q_PROPERTY(int16_t zmag READ systemZmag NOTIFY statusUpdated)  // Z轴磁力(mGauss)
    // 温度参数
    Q_PROPERTY(int8_t temperature READ systemTemperature NOTIFY statusUpdated) // IMU温度(℃)

public:
    explicit Vk_ScaledImuStatus(QObject *parent = nullptr);
    ~Vk_ScaledImuStatus();

    /**
     * @brief 更新IMU数据
     * @param data 原始IMU数据结构指针
     * 解析并存储惯性测量单元的预处理输出
     */
    void updateImuData(const struct VkScaledImuStatus* data);

    // 加速度接口
    int16_t systemXacc();  //< 获取X轴加速度(mG, 1G=1000mG)
    int16_t systemYacc();  //< 获取Y轴加速度(mG)
    int16_t systemZacc();  //< 获取Z轴加速度(mG)

    // 角速度接口
    int16_t systemXgyro(); //< 获取X轴角速度(mrad/s)
    int16_t systemYgyro(); //< 获取Y轴角速度(mrad/s)
    int16_t systemZgyro(); //< 获取Z轴角速度(mrad/s)

    // 磁力计接口
    int16_t systemXmag();  //< 获取X轴磁力(mGauss)
    int16_t systemYmag();  //< 获取Y轴磁力(mGauss)
    int16_t systemZmag();  //< 获取Z轴磁力(mGauss)

    // 温度接口
    int8_t systemTemperature(); //< 获取IMU温度(℃)

signals:
    /// IMU数据更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    struct VkScaledImuStatus* m_scaledImu;  // 原始IMU数据存储
};

//----------------------- 编队飞行 -----------------------
/**
 * @class Vk_FormationLeader
 * @brief 编队长机状态管理类
 * @property lat 长机纬度(度)
 * @property vn 长机北向速度(m/s)
 * @property formationType 编队类型(0-5)
 * 管理多机编队飞行中长机的状态信息
 */
class Vk_FormationLeader : public QObject {
    Q_OBJECT
    // 基础参数
    Q_PROPERTY(quint32 timestamp READ timestamp NOTIFY statusUpdated) // 时间戳(毫秒)
    Q_PROPERTY(quint32 state READ state NOTIFY statusUpdated)         // 长机状态
    // 位置参数
    Q_PROPERTY(double lat READ lat NOTIFY statusUpdated)              // 纬度(度)
    Q_PROPERTY(double lon READ lon NOTIFY statusUpdated)              // 经度(度)
    Q_PROPERTY(float msl READ msl NOTIFY statusUpdated)               // 海拔高度(米)
    // 速度参数
    Q_PROPERTY(float ve READ ve NOTIFY statusUpdated)                 // 东向速度(m/s)
    Q_PROPERTY(float vn READ vn NOTIFY statusUpdated)                 // 北向速度(m/s)
    Q_PROPERTY(float vu READ vu NOTIFY statusUpdated)                 // 天向速度(m/s)
    // 姿态参数
    Q_PROPERTY(float yaw READ yaw NOTIFY statusUpdated)               // 航向角(弧度)
    // 编队参数
    Q_PROPERTY(float xDist READ xDist NOTIFY statusUpdated)           // X方向间距(米)
    Q_PROPERTY(float yDist READ yDist NOTIFY statusUpdated)           // Y方向间距(米)
    Q_PROPERTY(float zDist READ zDist NOTIFY statusUpdated)           // Z方向间距(米)
    Q_PROPERTY(quint16 rectColNum READ rectColNum NOTIFY statusUpdated) // 矩形队列列数
    Q_PROPERTY(quint8 formationType READ formationType NOTIFY statusUpdated) // 编队类型

public:
    explicit Vk_FormationLeader(QObject *parent = nullptr);

    /**
     * @brief 更新编队数据
     * @param data 原始编队数据结构指针
     * 解析并存储编队长机的状态信息
     */
    void updateFormationData(const VkFormationLeaderStatus* data);

    // 基础参数接口
    quint32 timestamp() const;  //< 获取数据时间戳(毫秒)
    quint32 state() const;      //< 获取长机状态(0=正常,1=异常)

    // 位置参数接口
    double lat() const;         //< 获取长机纬度(度)
    double lon() const;         //< 获取长机经度(度)
    float msl() const;          //< 获取长机海拔高度(米)

    // 速度参数接口
    float ve() const;           //< 获取长机东向速度(m/s)
    float vn() const;           //< 获取长机北向速度(m/s)
    float vu() const;           //< 获取长机天向速度(m/s)

    // 姿态参数接口
    float yaw() const;          //< 获取长机航向角(弧度)

    // 编队参数接口
    float xDist() const;        //< 获取X方向间距设定(米)
    float yDist() const;        //< 获取Y方向间距设定(米)
    float zDist() const;        //< 获取Z方向间距设定(米)
    quint16 rectColNum() const; //< 获取矩形队列列数
    quint8 formationType() const; //< 获取编队类型(1编队集结 2编队解散 3设置队形)

signals:
    /// 编队数据更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    VkFormationLeaderStatus* m_formationLeader; // 原始数据存储
};

//----------------------- 安全系统 -----------------------
/**
 * @class Vk_ParachuteStatus
 * @brief 降落伞状态管理类
 * @property state 降落伞状态(0=收起,1=展开)
 * @property autoLaunch 自动开伞设置(0=禁用,1=启用)
 * @property errCode 错误代码(0=正常)
 * 管理应急降落系统的状态监控
 */
class Vk_ParachuteStatus : public QObject {
    Q_OBJECT
    // 基础参数
    Q_PROPERTY(quint32 timestamp READ timestamp NOTIFY statusUpdated) // 时间戳(毫秒)
    // 电源参数
    Q_PROPERTY(float backvolt READ backvolt NOTIFY statusUpdated)     // 备用电源电压(V)
    // 状态参数
    Q_PROPERTY(quint16 errCode READ errCode NOTIFY statusUpdated)     // 错误代码
    Q_PROPERTY(quint8 state READ state NOTIFY statusUpdated)          // 降落伞状态
    Q_PROPERTY(quint8 autoLaunch READ autoLaunch NOTIFY statusUpdated) // 自动开伞设置
    Q_PROPERTY(quint8 uavCmd READ uavCmd NOTIFY statusUpdated)        // 无人机控制命令

public:
    explicit Vk_ParachuteStatus(QObject *parent = nullptr);
    ~Vk_ParachuteStatus();

    /**
     * @brief 更新降落伞数据
     * @param data 原始降落伞数据结构指针
     * 解析并存储应急降落系统的状态
     */
    void updateParachuteData(const VkParachuteStatus* data);

    // 基础参数接口
    quint32 timestamp() const;  //< 获取数据时间戳(毫秒)

    // 电源参数接口
    float backvolt() const;     //< 获取备用电源电压(V)

    // 状态参数接口
    quint16 errCode() const;    //< 获取错误代码(0-未就绪 1-就绪 2-已开伞 3-故障)
    quint8 state() const;       //< 获取降落伞状态(0=收起,1=展开)
    quint8 autoLaunch() const;  //< 获取自动开伞设置(0-不启用 1-启动)
    quint8 uavCmd() const;      //< 获取无人机控制命令(0-无 1-停桨)

signals:
    /// 降落伞状态更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    VkParachuteStatus* m_parachuteStatus;  // 原始数据存储
};

//----------------------- 任务载荷 -----------------------
/**
 * @class Vk_WeigherState
 * @brief 称重器状态管理类
 * @property weight 当前重量值(g)
 * @property workState 工作状态(0=空闲,1=工作中)
 * @property errCode 错误代码(0=正常)
 * 管理农业喷洒、货物运输的重量监测系统
 */
class Vk_WeigherState : public QObject {
    Q_OBJECT
    // 基础参数
    Q_PROPERTY(quint32 timestamp READ timestamp NOTIFY statusUpdated) // 时间戳(毫秒)
    // 重量参数
    Q_PROPERTY(quint32 weight READ weight NOTIFY statusUpdated)       // 当前重量(g)
    Q_PROPERTY(quint16 weightD READ weightD NOTIFY statusUpdated)     // 重量变化率(g/s)
    // 状态参数
    Q_PROPERTY(quint8 workState READ workState NOTIFY statusUpdated)  // 工作状态
    Q_PROPERTY(quint8 errCode READ errCode NOTIFY statusUpdated)      // 错误代码

public:
    explicit Vk_WeigherState(QObject *parent = nullptr);

    /**
     * @brief 更新称重器数据
     * @param data 原始称重器数据结构指针
     * 解析并存储重量监测系统的状态
     */
    void updateWeigherData(const VkWeigherState* data);

    // 基础参数接口
    quint32 timestamp() const;  //< 获取数据时间戳(毫秒)

    // 重量参数接口
    quint32 weight() const;     //< 获取当前重量(g)
    quint16 weightD() const;    //< 获取重量变化率(g/s)

    // 状态参数接口
    quint8 workState() const;   //< 获取工作状态(0=空闲,1=工作中)
    quint8 errCode() const;     //< 获取错误代码(0=正常,1-255=错误)

signals:
    /// 称重器状态更新信号（任何参数变化时触发）
    void statusUpdated();

private:
    VkWeigherState* m_weigherState; // 原始数据存储
};
