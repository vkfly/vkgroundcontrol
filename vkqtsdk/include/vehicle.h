#pragma once

#include <QObject>
#include <QGeoCoordinate>
#include <QList>
#include <QVariantMap>
#include "vkqtsdktypes.h"
#include "mission_model.h"
#include <QQmlPropertyMap>
Q_MOC_INCLUDE("vkqtsdktypes.h")
Q_MOC_INCLUDE("mission_model.h")

class VkVehicle : public QObject {
    Q_OBJECT

    // 系统唯一标识符
    Q_PROPERTY(int id READ getSysId CONSTANT)
    // 设备当前地理坐标（只读，变化时触发coordinateChanged信号）
    Q_PROPERTY(QGeoCoordinate coordinate READ getCoordinate NOTIFY coordinateChanged)
    // 设备设定的返航点坐标（只读，返航点变化时触发信号）
    Q_PROPERTY(QGeoCoordinate home READ getHome NOTIFY homePositionChanged)
    // 设备距返航点的直线距离（单位：米，距离变化时触发信号）
    Q_PROPERTY(double homeDistance READ homeDis NOTIFY homeDisChanged)
    // 设备朝向与返航点方向的夹角（单位：度，角度变化时触发信号）
    Q_PROPERTY(double headToHome READ homeDis NOTIFY headToHomeChanged)

    // 心跳包状态（用于检测设备在线状态）
    Q_PROPERTY(Vk_Heartbeat* heartbeat READ heartBeat CONSTANT)
    // 系统全局状态（如飞行模式、错误码等）
    Q_PROPERTY(VkSystemStatus* sysStatus READ sysStatus CONSTANT)

    // 电池管理系统（BMS）数据（倾斜电池专用）
    Q_PROPERTY(Vk_QingxieBms* qingxieBms READ qingxieBms CONSTANT)
    // 电池状态（电压、电流、温度等）
    Q_PROPERTY(Vk_BmsStatus* bmsStatus READ bmsStatus CONSTANT)

    // 主/备GNSS模块原始数据（如GPS/北斗定位信息）
    Q_PROPERTY(VkGnss* GNSS1 READ gpsInput1 CONSTANT)
    Q_PROPERTY(VkGnss* GNSS2 READ gpsInput2 CONSTANT)
    // RTK差分定位状态（定位精度、卫星数等）
    Q_PROPERTY(VkRtkMsg* RtkMsg READ rtkMsg CONSTANT)

    // 设备姿态数据（俯仰/横滚/偏航角）
    Q_PROPERTY(Vk_Attitude* attitude READ attitude CONSTANT)

    // 全球位置（高精度经纬度/海拔）
    Q_PROPERTY(Vk_GlobalPositionInt* globalPositionInt READ globalPositionInt CONSTANT)

    // 电机信号输出（用于控制电机/舵机）
    Q_PROPERTY(Vk_ServoOutputRaw* servoOutputRaw READ servoOutputRaw CONSTANT)
    // 当前执行的航点任务信息(暂时不用)
    Q_PROPERTY(Vk_MissionCurrent* missionCurrent READ missionCurrent CONSTANT)

    // 遥控器通道原始输入值（19个通道）
    Q_PROPERTY(Vk_RcChannels* rcChannels READ rcChannels CONSTANT)

    // 传感器模块版本（GNSS/雷达/称重）
    Q_PROPERTY(Vk_ComponentVersion* componentVersion READ componentVersion CONSTANT)
    Q_PROPERTY(Vk_ComponentVersion* FlightController READ flightController CONSTANT)
    Q_PROPERTY(Vk_ComponentVersion* GPSA READ gpsA CONSTANT)
    Q_PROPERTY(Vk_ComponentVersion* GPSB READ gpsB CONSTANT)
    Q_PROPERTY(Vk_ComponentVersion* RFront READ rfdFront CONSTANT)
    Q_PROPERTY(Vk_ComponentVersion* RRear READ rfdRear CONSTANT)
    Q_PROPERTY(Vk_ComponentVersion* RDown READ rfdDown CONSTANT)
    Q_PROPERTY(Vk_ComponentVersion* R360 READ rfd360 CONSTANT)
    Q_PROPERTY(QList<Vk_ComponentVersion*> Batteries READ batteries CONSTANT)
    Q_PROPERTY(QList<Vk_ComponentVersion*> ECUs READ ecus CONSTANT)
    Q_PROPERTY(Vk_ComponentVersion* Weigher READ weigher CONSTANT)

    // 飞行管理单元
    Q_PROPERTY(Vk_FmuStatus* fmuStatus READ fmuStatus CONSTANT)
    // 系统的状态数据自定义消息, 主要用于一些自定状态的传输和排故
    Q_PROPERTY(Vk_insStatus* insStatus READ insStatus CONSTANT)
    // 系统的状态数据自定义消息
    Q_PROPERTY(Vk_VfrHud* vfrHud READ vfrHud CONSTANT)

    // 障碍物距离信息
    Q_PROPERTY(Vk_ObstacleDistance* obstacleDistance READ obstacleDistance CONSTANT)
    // 高延迟通信状态
    Q_PROPERTY(Vk_HighLatency* highLatency READ highLatency CONSTANT)

    // 电子调速器（ESC）状态
    Q_PROPERTY(Vk_EscStatus* escStatus READ escStatus CONSTANT)

    // IMU传感器状态（主/备惯性测量单元）
    Q_PROPERTY(Vk_ScaledImuStatus* scaledImuStatus READ scaledImuStatus NOTIFY scaledImuStatusChanged)
    Q_PROPERTY(Vk_ScaledImuStatus* scaledImu2Status READ scaledImu2Status NOTIFY scaledImu2StatusChanged)

    // 当前加载的航点任务模型
    Q_PROPERTY(MissionModel* mission READ getMission NOTIFY missionChanged)

    // 飞控参数表，获取值
    Q_PROPERTY(QVariantMap parameters READ getParams NOTIFY paramChanged)

    // 距离传感器信息
    Q_PROPERTY(Vk_DistanceSensor* distanceSensor READ distanceSensor CONSTANT)
    // 称重模块实时状态
    Q_PROPERTY(Vk_WeigherState* weigherState READ weigherState CONSTANT)
    // 编队飞行中长机信息
    Q_PROPERTY(Vk_FormationLeader* formationLeader READ formationLeader CONSTANT)

    // 设备日志条目列表（日志更新时触发信号）
    Q_PROPERTY(QList<VkLogEntry*> logs READ getLogEntries NOTIFY logChanged)
    //Q_PROPERTY(float progress READ getProgress NOTIFY progressChanged)

    // 负载设备动态参数
    Q_PROPERTY(QQmlPropertyMap* payload READ getPayload CONSTANT)

    // 当前操作进度（如升级执行进度）
    Q_PROPERTY(int getCurrentProgress READ getCurrentProgress NOTIFY getCurrentProgressChanged)

public:
    VkVehicle(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~VkVehicle() = default;

    /**
     * @brief 起飞
     */
    Q_INVOKABLE virtual void takeOff() = 0;

    /**
     * @brief 测试电机，以怠速旋转
     * @param motor 电机编号，从0开始
     */
    Q_INVOKABLE virtual void motorTest(int motor) = 0;

    /**
     * @brief 开始设备校准
     * @param calType 校准设备类型，2: 磁力计 3: 遥控器 15: 水平校准
     */
    Q_INVOKABLE virtual void startCalibration(int calType) = 0;

    /**
     * @brief 停止设备校准
     * @param calType 校准设备类型，同startCalibration。
     * @note 目前只有遥控器校准需要停止
     */
    Q_INVOKABLE virtual void stopCalibration(int calType) = 0;

    /**
     * @brief 设置参数
     * @param name 参数名称
     * @param value 参数值
     */
    Q_INVOKABLE virtual void setParam(QString name, double value) = 0;

    /**
     * @brief 清除航点
     */
    Q_INVOKABLE virtual void clearMission() = 0;

    // /**
    //  * @brief 添加航点
    //  * @param name 参数名称
    //  * @param value 参数值
    //  */
    // Q_INVOKABLE virtual void addWaypoint(double lat, double lon, double alt, int turnType = 0) = 0;

    // /**
    //  * @brief 设置参数
    //  * @param name 参数名称
    //  * @param value 参数值
    //  */
    // Q_INVOKABLE virtual void addLandWaypoint(double lat, double lon, double alt, float speed = NAN) = 0;
    // Q_INVOKABLE virtual void addPhotoWaypoint(double lat, double lon, double alt) = 0;

    // /**
    //  * @brief 设置参数
    //  * @param name 参数名称
    //  * @param value 参数值
    //  */
    // Q_INVOKABLE virtual void updateWaypoint(int idx) = 0;

    /**
     * @brief 开始执行飞行任务
     * @param wpid 起始航点序号,0-UINT16_MAX. NAN表示忽略该参数，飞控根据执行方式从0或最后一点开始
     * @param execMode 任务执行模式：
     *     - 0: 顺序执行, 正常执行航点动作
     *     - 1: 顺序执行, 略过航点动作
     *     - 2: 逆序执行, 正常航点动作
     *     - 3: 逆序执行, 忽略航点动作
     * @param doneAct 任务完成动作：
     *     - 0: 悬停
     *     - 1: 返航回 home
     *     - 2: 原地降落
     *     - 3: 返回回备降点
     *     - 4: 返航回 home, 按顺序航线执行
     *     - 5: 返航回 home, 按逆序航线执行
     *     - 6: 重新执行循环航线
     */
    Q_INVOKABLE virtual void startMission(int wpid, int execMode, int doneAct) = 0;

    // Q_INVOKABLE virtual void uploadMission() = 0;

    /**
     * @brief 上传指定任务模型
     * @param mission 任务模型指针，包含完整航点信息
     *
     * @warning 调用方需保证mission对象生命周期
     */
    Q_INVOKABLE virtual void uploadMissionModel(MissionModel* mission) = 0;

    /**
     * @brief 从飞行器下载任务到本地模型
     * @param mission 目标任务模型指针（用于接收下载数据）
     *
     * @note 下载完成后将触发mission模型的missionChanged信号
     */
    Q_INVOKABLE virtual void downloadMission(MissionModel * mission) = 0;

    /**
     * @brief 执行返航任务
     * @param wpid wpid 起始航点序号,0-UINT16_MAX. NAN表示忽略该参数，飞控根据执行方式从0或最后一点开始
     * @param execMode 返航执行模式：
     *     - 0: 直线返航
     *     - 1: 沿航线正序返航
     *     - 2: 沿航线逆序返航
     */
    Q_INVOKABLE virtual void returnMission(int wpid, int execMode) = 0;

    /**
     * @brief 进入Offboard外部控制模式
     * 切换至外部控制模式，需配合MAVLink消息持续发送控制指令
     */
    Q_INVOKABLE virtual void offboard() = 0;

    /**
     * @brief 取消当前执行的指令
     * 中断正在执行的任务/动作，包括：下载日志/升级固件/下载航点/上传航点
     */
    Q_INVOKABLE virtual void cancelCurrentCommand() = 0;

    /**
     * @brief 获取日志列表
     */
    Q_INVOKABLE virtual void getLogList() = 0;

    /**
     * @brief 擦除所有日志
     */
    Q_INVOKABLE virtual void eraseLogs() = 0;

    /**
     * @brief 下载日志
     * @param logDir 存放日志文件的目录
     * @param logid 日志id，从VkLogEntry中获取
     */
    Q_INVOKABLE virtual void downloadLog(const QString& logFilePath, int logid) = 0;

    /**
     * @brief 升级固件
     * @param filePath 固件文件名
     */
    Q_INVOKABLE virtual void upgradeFirmware(const QString &filePath) = 0;

    /**
     * @brief 获取载荷设备控制接口
     * @return QQmlPropertyMap指针，用于动态访问载荷参数
     */
    virtual QQmlPropertyMap* getPayload() = 0;

protected:
    virtual int getSysId() = 0;
    virtual double homeDis() const = 0;
    virtual Vk_Heartbeat* heartBeat() = 0;
    virtual Vk_QingxieBms* qingxieBms() = 0;
    virtual Vk_BmsStatus* bmsStatus() = 0;
    virtual QGeoCoordinate getCoordinate() = 0;
    virtual VkSystemStatus* sysStatus() = 0;
    virtual QGeoCoordinate getHome() = 0;
    virtual QList<VkLogEntry*> getLogEntries() = 0;
    virtual VkGnss* gpsInput1() = 0;
    virtual VkGnss* gpsInput2() = 0;
    virtual VkRtkMsg* rtkMsg() = 0;
    virtual Vk_Attitude* attitude() = 0;
    virtual Vk_ServoOutputRaw* servoOutputRaw() = 0;
    virtual Vk_MissionCurrent* missionCurrent() = 0;
    virtual Vk_RcChannels* rcChannels() = 0;

    virtual Vk_ComponentVersion* componentVersion() = 0;
    virtual Vk_ComponentVersion* flightController() = 0;
    virtual Vk_ComponentVersion* gpsA() = 0;
    virtual Vk_ComponentVersion* gpsB() = 0;
    virtual Vk_ComponentVersion* rfdFront() = 0;
    virtual Vk_ComponentVersion* rfdRear() = 0;
    virtual Vk_ComponentVersion* rfdDown() = 0;
    virtual Vk_ComponentVersion* rfd360() = 0;
    virtual QList<Vk_ComponentVersion*> batteries() = 0;
    virtual QList<Vk_ComponentVersion*> ecus() = 0;
    virtual Vk_ComponentVersion* weigher() = 0;

    virtual Vk_FmuStatus* fmuStatus() = 0;
    virtual Vk_insStatus* insStatus() = 0;
    virtual Vk_VfrHud* vfrHud() = 0;
    virtual Vk_ObstacleDistance* obstacleDistance() = 0;
    virtual Vk_HighLatency* highLatency() = 0;
    virtual Vk_EscStatus* escStatus() = 0;

    virtual Vk_ScaledImuStatus* scaledImuStatus() = 0;
    virtual Vk_ScaledImuStatus* scaledImu2Status() = 0;

    virtual Vk_GlobalPositionInt* globalPositionInt() = 0;

    virtual MissionModel* getMission() = 0;

    virtual QMap<QString, QVariant> getParams() = 0;

    virtual Vk_DistanceSensor* distanceSensor() = 0;
    virtual Vk_WeigherState* weigherState() = 0;

    virtual Vk_FormationLeader* formationLeader() = 0;
    virtual Vk_ParachuteStatus* parachuteStatus() = 0;
    virtual float getProgress() = 0;


    virtual int getCurrentProgress() = 0;

signals:
    void heartBeat(const Vk_Heartbeat *msg);
    void coordinateChanged(const QGeoCoordinate &coord);
    void homePositionChanged(const QGeoCoordinate &coord);
    void homeDisChanged();
    void headToHomeChanged();
    void sysStatusChanged(const VkSystemStatus *msg);
    void qingxieBmsChanged(const VkQingxieBms *msg);
    void bmsStatusChanged(const VkBmsStatus *msg);
    void gnssChanged(const VkGnss *msg);
    void rtkMsgChanged(const VkRtkMsg *msg);
    void attitudeChanged(const Vk_Attitude *msg);
    void servoOutputRaweChanged(const Vk_ServoOutputRaw *msg);
    void missionCurrentChanged(const Vk_MissionCurrent *msg);
    void rcChannelsChanged(const Vk_RcChannels *msg);
    void componentVersionChanged(const Vk_ComponentVersion *msg);
    void fmuStatusChanged(const Vk_FmuStatus *msg);
    void insStatusChanged(const Vk_insStatus *msg);
    void vfrHudStatusChanged(const Vk_VfrHud *msg);
    void obstacleDistanceChanged(const Vk_ObstacleDistance *msg);
    void highLatencyChanged(const Vk_HighLatency *msg);
    void highLatencyChanged(const Vk_EscStatus *msg);

    void scaledImuStatusChanged(const Vk_ScaledImuStatus *msg);
    void scaledImu2StatusChanged(const Vk_ScaledImuStatus *msg);

    void otherglobalPositionChanged(const Vk_GlobalPositionInt *msg);

    void distanceSensoChanged(const Vk_DistanceSensor *msg);

    void weigherStateChanged(const Vk_WeigherState *msg);
    void formationLeaderChanged(const Vk_FormationLeader *msg);

    void logChanged();

    void missionChanged();
    void paramChanged();
    void progressChanged();

    void getCurrentProgressChanged();
};
