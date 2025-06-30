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

class Vk_RcInfo : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString model READ rcModel NOTIFY modelUpdated)
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

class Vk_Heartbeat : public QObject {
    Q_OBJECT
    Q_PROPERTY(quint32 heartbeatCustomMode READ heartbeatCustomMode NOTIFY statusUpdated)
    Q_PROPERTY(quint8 heartbeatType READ heartbeatType NOTIFY statusUpdated)
    Q_PROPERTY(quint8 heartbeatAutopilot READ heartbeatAutopilot NOTIFY statusUpdated)
    Q_PROPERTY(quint8 heartbeatBaseMode READ heartbeatBaseMode NOTIFY statusUpdated)
    Q_PROPERTY(quint8 heartbeatSystemStatus READ heartbeatSystemStatus NOTIFY statusUpdated)
    Q_PROPERTY(int lockStatus READ getLockStatus NOTIFY statusUpdated)

public:
    explicit Vk_Heartbeat(QObject *parent = nullptr);

    void updateHeatBeatData(const struct VkHeartbeat* status);

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
    VkHeartbeat* m_heatBeat;
    quint8 lock_status;;
};


class VkLogEntry : public QObject {
    Q_OBJECT

    Q_PROPERTY(int logid READ getId CONSTANT)
    Q_PROPERTY(qint64 timestamp READ getTimestamp CONSTANT)
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

class VkSystemStatus : public QObject {
    Q_OBJECT

    Q_PROPERTY(uint64_t onboardControlSensorsPresent READ systemStatusSensorsPresent NOTIFY statusUpdated)
    Q_PROPERTY(uint64_t onboardControlSensorsEnabled READ systemStatusSensorsEnabled NOTIFY statusUpdated)
    Q_PROPERTY(uint64_t onboardControlSensorsHealth READ systemStatusSensorsHealth NOTIFY statusUpdated)
    Q_PROPERTY(int systemLoad READ systemStatusLoad NOTIFY statusUpdated)
    Q_PROPERTY(float batteryVoltage READ systemStatusBatteryVoltage NOTIFY statusUpdated)
    Q_PROPERTY(float batteryCurrent READ systemStatusBatteryCurrent NOTIFY statusUpdated)
    Q_PROPERTY(int commDropRate READ systemStatusDropRateComm NOTIFY statusUpdated)
    Q_PROPERTY(int commErrors READ systemStatusCommErrors NOTIFY statusUpdated)
    Q_PROPERTY(int errorCount1 READ systemStatusErrorCount1 NOTIFY statusUpdated)
    Q_PROPERTY(int errorCount2 READ systemStatusErrorCount2 NOTIFY statusUpdated)
    Q_PROPERTY(int errorCount3 READ systemStatusErrorCount3 NOTIFY statusUpdated)
    Q_PROPERTY(int errorCount4 READ systemStatusErrorCount4 NOTIFY statusUpdated)
    Q_PROPERTY(int batteryRemaining  READ systemStatusBatteryRemaining NOTIFY statusUpdated)

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
    VkSysStatus* m_status;
};

class Vk_QingxieBms : public QObject {
    Q_OBJECT

    // Q_PROPERTY 声明（与成员变量一一对应）
    Q_PROPERTY(float batVoltage READ batVoltage NOTIFY statusUpdated)
    Q_PROPERTY(float servoCurrent READ servoCurrent NOTIFY statusUpdated)
    Q_PROPERTY(float stackVoltage READ stackVoltage NOTIFY statusUpdated)
    Q_PROPERTY(float servoVoltage READ servoVoltage NOTIFY statusUpdated)
    Q_PROPERTY(float batRefuelCurrent READ batRefuelCurrent NOTIFY statusUpdated)
    Q_PROPERTY(quint16 gasTankPressure READ gasTankPressure NOTIFY statusUpdated)
    Q_PROPERTY(quint16 pipePressure READ pipePressure NOTIFY statusUpdated)
    Q_PROPERTY(quint16 pcbTemp READ pcbTemp NOTIFY statusUpdated)
    Q_PROPERTY(quint16 stackTemp READ stackTemp NOTIFY statusUpdated)
    Q_PROPERTY(quint16 workStatus READ workStatus NOTIFY statusUpdated)
    Q_PROPERTY(quint16 faultStatus READ faultStatus NOTIFY statusUpdated)
    Q_PROPERTY(quint8 selfCheck READ selfCheck NOTIFY statusUpdated)
    Q_PROPERTY(quint8 id READ id NOTIFY statusUpdated)

public:
    explicit Vk_QingxieBms(QObject *parent = nullptr);

    // 更新数据的接口（假设外部数据通过结构体 VkQingxieBmsData 传递）
    void updateqingxieBmsData(const struct VkQingxieBms *status);

    // Q_PROPERTY 的 READ 函数声明
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
    VkQingxieBms *m_data; // 存储实际数据
};

class Vk_BmsStatus : public QObject {
    Q_OBJECT

    Q_PROPERTY(quint32 timeBootMs READ timeBootMs NOTIFY statusUpdated)
    Q_PROPERTY(int voltage READ voltage NOTIFY statusUpdated)
    Q_PROPERTY(int current READ current NOTIFY statusUpdated)
    Q_PROPERTY(int16_t temperature READ temperature NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t cellNum READ cellNum NOTIFY statusUpdated)
    Q_PROPERTY(QList<uint16_t> cellVolt READ cellVolt NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t cycCnt READ cycCnt NOTIFY statusUpdated)
    Q_PROPERTY(int8_t capPercent READ capPercent NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t batId READ batId NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t health READ health NOTIFY statusUpdated)
    Q_PROPERTY(quint32 errCode READ errCode NOTIFY statusUpdated)

public:
    explicit Vk_BmsStatus(QObject *parent = nullptr);
    ~Vk_BmsStatus();

    void updatebmsStatusData(const VkBmsStatus *status);

    quint32 timeBootMs() const;
    int voltage() const;
    int current() const;
    int16_t temperature() const;
    uint16_t cellNum() const;
    QList<uint16_t> cellVolt() const;
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

class Vk_GlobalPositionInt : public QObject {
    Q_OBJECT

    Q_PROPERTY(double lat READ lat NOTIFY statusUpdated)
    Q_PROPERTY(double lon READ lon NOTIFY statusUpdated)
    Q_PROPERTY(float alt READ alt NOTIFY statusUpdated)
    Q_PROPERTY(float relativeAlt READ relativeAlt NOTIFY statusUpdated)
    Q_PROPERTY(double vx READ vx NOTIFY statusUpdated)
    Q_PROPERTY(double vy READ vy NOTIFY statusUpdated)
    Q_PROPERTY(float vz READ vz NOTIFY statusUpdated)
    Q_PROPERTY(float hdg READ hdg NOTIFY statusUpdated)
    Q_PROPERTY(float verticalSpeed READ verticalSpeed NOTIFY statusUpdated)    // 新增垂直速度
    Q_PROPERTY(double horizontalSpeed READ horizontalSpeed NOTIFY statusUpdated) // 新增水平速度

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
    float verticalSpeed() const;    // 垂直速度 getter
    double horizontalSpeed() const;  // 水平速度 getter

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
    float m_verticalSpeed;     // 垂直速度存储
    double m_horizontalSpeed;   // 水平速度存储
};

class VkGnss : public QObject {
    Q_OBJECT

    Q_PROPERTY(uint64_t gpsInputTimeMicroseconds READ gpsInputTimeMicroseconds NOTIFY statusUpdated)
    Q_PROPERTY(uint32_t gpsInputTimeWeekMs READ gpsInputTimeWeekMs NOTIFY statusUpdated)
    Q_PROPERTY(double gpsInputLatitude READ gpsInputLatitude NOTIFY statusUpdated)
    Q_PROPERTY(double gpsInputLongitude READ gpsInputLongitude NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputAltitude READ gpsInputAltitude NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputHdop READ gpsInputHdop NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputVdop READ gpsInputVdop NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputVelocityNorth READ gpsInputVelocityNorth NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputVelocityEast READ gpsInputVelocityEast NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputVelocityDown READ gpsInputVelocityDown NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputSpeedAccuracy READ gpsInputSpeedAccuracy NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputHorizontalAccuracy READ gpsInputHorizontalAccuracy NOTIFY statusUpdated)
    Q_PROPERTY(float gpsInputVerticalAccuracy READ gpsInputVerticalAccuracy NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t gpsInputIgnoreFlags READ gpsInputIgnoreFlags NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t gpsInputTimeWeek READ gpsInputTimeWeek NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t gpsInputGpsId READ gpsInputGpsId NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t gpsInputFixType READ gpsInputFixType NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t gpsInputSatellitesVisible READ gpsInputSatellitesVisible NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t gpsInputYaw READ gpsInputYaw NOTIFY statusUpdated)

public:
    explicit VkGnss(QObject *parent = nullptr);

    void updateData(const VkGpsInput *status);

    uint64_t gpsInputTimeMicroseconds();
    uint32_t gpsInputTimeWeekMs();
    double gpsInputLatitude();
    double gpsInputLongitude();
    float gpsInputAltitude();
    float gpsInputHdop();
    float gpsInputVdop();
    float gpsInputVelocityNorth();
    float gpsInputVelocityEast();
    float gpsInputVelocityDown();
    float gpsInputSpeedAccuracy();
    float gpsInputHorizontalAccuracy();
    float gpsInputVerticalAccuracy();
    uint16_t gpsInputIgnoreFlags();
    uint16_t gpsInputTimeWeek();
    uint8_t gpsInputGpsId();
    uint8_t gpsInputFixType();
    uint8_t gpsInputSatellitesVisible();
    uint16_t gpsInputYaw();

signals:
    void statusUpdated();

private:
    VkGpsInput* m_gnss;
};

class VkRtkMsg : public QObject {
    Q_OBJECT

    Q_PROPERTY(double rtkMsgLatitude READ rtkMsgLatitude NOTIFY statusUpdated)
    Q_PROPERTY(double rtkMsgLongitude READ rtkMsgLongitude NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgAltitudeMsl READ rtkMsgAltitudeMsl NOTIFY statusUpdated)
    Q_PROPERTY(quint32 rtkMsgDgpsAge READ rtkMsgDgpsAge NOTIFY statusUpdated)
    Q_PROPERTY(quint16 rtkMsgHdop READ rtkMsgHdop NOTIFY statusUpdated)
    Q_PROPERTY(quint16 rtkMsgVdop READ rtkMsgVdop NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgGroundSpeed READ rtkMsgGroundSpeed NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgCourseOverGround READ rtkMsgCourseOverGround NOTIFY statusUpdated)
    Q_PROPERTY(quint8 rtkMsgFixType READ rtkMsgFixType NOTIFY statusUpdated)
    Q_PROPERTY(quint8 rtkMsgSatellitesVisible READ rtkMsgSatellitesVisible NOTIFY statusUpdated)
    Q_PROPERTY(quint8 rtkMsgDgpsSatellites READ rtkMsgDgpsSatellites NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgYaw READ rtkMsgYaw NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgAltitudeEllipsoid READ rtkMsgAltitudeEllipsoid NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgHorizontalAccuracy READ rtkMsgHorizontalAccuracy NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgVerticalAccuracy READ rtkMsgVerticalAccuracy NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgSpeedAccuracy READ rtkMsgSpeedAccuracy NOTIFY statusUpdated)
    Q_PROPERTY(float rtkMsgHeadingAccuracy READ rtkMsgHeadingAccuracy NOTIFY statusUpdated)

public:
    explicit VkRtkMsg(QObject *parent = nullptr);

    void updateData(const struct VkGps2Raw *status);

    double rtkMsgLatitude();
    double rtkMsgLongitude();
    float rtkMsgAltitudeMsl();
    quint32 rtkMsgDgpsAge();
    quint16 rtkMsgHdop();
    quint16 rtkMsgVdop();
    float rtkMsgGroundSpeed();
    float rtkMsgCourseOverGround();
    quint8 rtkMsgFixType();
    quint8 rtkMsgSatellitesVisible();
    quint8 rtkMsgDgpsSatellites();
    float rtkMsgYaw();
    float rtkMsgAltitudeEllipsoid();
    float rtkMsgHorizontalAccuracy();
    float rtkMsgVerticalAccuracy();
    float rtkMsgSpeedAccuracy();
    float rtkMsgHeadingAccuracy();

signals:
    void statusUpdated();

private:
    VkGps2Raw* m_rtk;
};


class Vk_Attitude : public QObject {
    Q_OBJECT

    Q_PROPERTY(quint32 attitudeTimeBootMs READ attitudeTimeBootMs NOTIFY statusUpdated)
    Q_PROPERTY(float attitudeRoll READ attitudeRoll NOTIFY statusUpdated)
    Q_PROPERTY(float attitudePitch READ attitudePitch NOTIFY statusUpdated)
    Q_PROPERTY(float attitudeYaw READ attitudeYaw NOTIFY statusUpdated)
    Q_PROPERTY(float attitudeRollSpeed READ attitudeRollSpeed NOTIFY statusUpdated)
    Q_PROPERTY(float attitudePitchSpeed READ attitudePitchSpeed NOTIFY statusUpdated)
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
    VkAttitude* m_attitude;
};

class Vk_ServoOutputRaw : public QObject {
    Q_OBJECT

    Q_PROPERTY(uint32_t timeBootMs READ timeBootMs NOTIFY statusUpdated)
    Q_PROPERTY(QList<int> servoOutputRaw READ servoOutputRaw NOTIFY statusUpdated)

public:
    explicit Vk_ServoOutputRaw(QObject *parent = nullptr);

    void upServoOutputRawdateData(const struct VkServoOutputRaw* data);

    uint32_t timeBootMs();
    QList<int> servoOutputRaw();

signals:
    void statusUpdated();

private:
    uint32_t time_boot_ms;
    QList<int> m_servoBuffer;
};

class Vk_MissionCurrent : public QObject {
    Q_OBJECT
    Q_PROPERTY(quint16 missionCurrentSeq READ missionCurrentSeq NOTIFY statusUpdated)
    Q_PROPERTY(quint16 missionTotalItems READ missionTotalItems NOTIFY statusUpdated)
    Q_PROPERTY(quint8 missionState READ missionState NOTIFY statusUpdated)
    Q_PROPERTY(quint8 missionMode READ missionMode NOTIFY statusUpdated)
    Q_PROPERTY(quint32 missionPlanId READ missionPlanId NOTIFY statusUpdated)
    Q_PROPERTY(quint32 fencePlanId READ fencePlanId NOTIFY statusUpdated)
    Q_PROPERTY(quint32 rallyPointsId READ rallyPointsId NOTIFY statusUpdated)

public:
    explicit Vk_MissionCurrent(QObject *parent = nullptr);

    void updateMissionCurrentData(const struct VkMissionCurrent* data);

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
    VkMissionCurrent* m_current;
};

class Vk_RcChannels : public QObject {
    Q_OBJECT
    Q_PROPERTY(QList<int> rcChannelsRaw READ rcChannelsRaw NOTIFY statusUpdated)
    Q_PROPERTY(quint8 rcRssiValue READ rcRssiValue NOTIFY statusUpdated)

public:
    explicit Vk_RcChannels(QObject *parent = nullptr);

    void updateRcChannelsData(const struct VkRcChannels* data);

    QList<int> rcChannelsRaw();
    int rcRssiValue();

signals:
    void statusUpdated();

private:
    QList<int> m_channelsRaw;
    int m_rssi;
};

class Vk_ComponentVersion : public QObject {
    Q_OBJECT
    Q_PROPERTY(quint16 componentId READ componentId NOTIFY statusUpdated)
    Q_PROPERTY(QString hardwareVersion READ hardwareVersion NOTIFY statusUpdated)
    Q_PROPERTY(QString firmwareVersion READ firmwareVersion NOTIFY statusUpdated)
    Q_PROPERTY(QString serialNumber READ serialNumber NOTIFY statusUpdated)
    Q_PROPERTY(QString manufactoryName READ manufactoryName NOTIFY statusUpdated)
    Q_PROPERTY(QString deviceModel READ deviceModel NOTIFY statusUpdated)

public:
    explicit Vk_ComponentVersion(QObject *parent = nullptr);

    void updateComponentData(const struct VkComponentVersion* data);

    quint16 componentId();
    QString hardwareVersion();
    QString firmwareVersion();
    QString serialNumber();
    QString manufactoryName();
    QString deviceModel();

signals:
    void statusUpdated();

private:
    struct VkComponentVersion* m_component;
};

class Vk_insStatus : public QObject {
    Q_OBJECT
    Q_PROPERTY(uint32_t timeBootMs READ timeBootMs NOTIFY statusUpdated)
    Q_PROPERTY(float g0 READ g0 NOTIFY statusUpdated)
    Q_PROPERTY(int32_t rawLatitude READ rawLatitude NOTIFY statusUpdated)
    Q_PROPERTY(int32_t rawLongitude READ rawLongitude NOTIFY statusUpdated)
    Q_PROPERTY(float baroAlt READ baroAlt NOTIFY statusUpdated)
    Q_PROPERTY(float rawGpsAlt READ rawGpsAlt NOTIFY statusUpdated)
    Q_PROPERTY(int16_t temperature READ temperature NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t navStatus READ navStatus NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t sFlag1 READ sFlag1 NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t sFlag2 READ sFlag2 NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t sFlag3 READ sFlag3 NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t sFlag4 READ sFlag4 NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t sFlag5 READ sFlag5 NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t sFlag6 READ sFlag6 NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t magCalibStage READ magCalibStage NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t solvPsatNum READ solvPsatNum NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t solvHsatNum READ solvHsatNum NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t vibeCoe READ vibeCoe NOTIFY statusUpdated)

public:
    explicit Vk_insStatus(QObject *parent = nullptr);
    ~Vk_insStatus();

    void updateVkinsData(const struct VkinsStatus* data);

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
    struct VkinsStatus* m_vkinsStatus;
};

class Vk_FmuStatus : public QObject {
    Q_OBJECT
    Q_PROPERTY(uint32_t timeBootMs READ timeBootMs NOTIFY statusUpdated)
    Q_PROPERTY(uint32_t flightTime READ flightTime NOTIFY statusUpdated)
    Q_PROPERTY(uint32_t distToTar READ distToTar NOTIFY statusUpdated)
    Q_PROPERTY(int flightDist READ flightDist NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t upsVolt READ upsVolt NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t adcVolt READ adcVolt NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t servoState READ servoState NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t rtlReason READ rtlReason NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t loiterReason READ loiterReason NOTIFY statusUpdated)
    Q_PROPERTY(uint8_t sFlag3 READ sFlag3 NOTIFY statusUpdated)

public:
    explicit Vk_FmuStatus(QObject *parent = nullptr);

    void updateFmuStatus(const struct VkFmuStatus* data);

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
    struct VkFmuStatus* m_fmuStatus;
};

class Vk_VfrHud : public QObject {
    Q_OBJECT

    Q_PROPERTY(float airspeed READ systemAirspeed NOTIFY statusUpdated)
    Q_PROPERTY(float groundspeed READ systemGroundspeed NOTIFY statusUpdated)
    Q_PROPERTY(float alt READ systemAltitude NOTIFY statusUpdated)
    Q_PROPERTY(float climb READ systemClimbRate NOTIFY statusUpdated)
    Q_PROPERTY(int16_t heading READ systemHeading NOTIFY statusUpdated)
    Q_PROPERTY(uint16_t throttle READ systemThrottle NOTIFY statusUpdated)

public:
    explicit Vk_VfrHud(QObject *parent = nullptr);

    void updateVfrHudData(const struct VkVfrHud* data);

    float systemAirspeed();
    float systemGroundspeed();
    float systemAltitude();
    float systemClimbRate();
    int16_t systemHeading();
    uint16_t systemThrottle();

signals:
    void statusUpdated();

private:
    struct VkVfrHud* m_vfrHud;
};

class Vk_EscStatus : public QObject {
    Q_OBJECT
    // 属性声明（与MAVLink字段对应）
    Q_PROPERTY(uint64_t timestamp READ timestamp NOTIFY dataUpdated)
    Q_PROPERTY(QList<int> rpm READ rpm NOTIFY dataUpdated)
    Q_PROPERTY(QList<float> voltage READ voltage NOTIFY dataUpdated)
    Q_PROPERTY(QList<float> current READ current NOTIFY dataUpdated)
    Q_PROPERTY(QList<uint> status READ status NOTIFY dataUpdated)
    Q_PROPERTY(QList<int> temperature READ temperature NOTIFY dataUpdated)
    Q_PROPERTY(uint8_t index READ index NOTIFY dataUpdated)

public:
    explicit Vk_EscStatus(QObject *parent = nullptr);

    // 数据更新接口
    void updateEscStatusData(const struct VkEscStatus* data);

    // 属性访问方法
    uint64_t timestamp();
    QList<int> rpm();
    QList<float> voltage();
    QList<float> current();
    QList<uint> status();
    QList<int> temperature();
    uint8_t index();

signals:
    void dataUpdated(); // 数据更新信号

private:
    // 成员变量（与MAVLink消息字段对齐）
    uint64_t m_timestamp;
    QList<int> m_rpm;         // int32_t → int
    QList<float> m_voltage;
    QList<float> m_current;
    QList<uint> m_status;     // uint32_t → uint
    QList<int> m_temperature; // int16_t → int
    uint8_t m_index;
};

class Vk_ObstacleDistance : public QObject {
    Q_OBJECT
    Q_PROPERTY(uint64_t timeUsec READ timeUsec NOTIFY dataUpdated)
    Q_PROPERTY(int minDistance READ minDistance NOTIFY dataUpdated)
    Q_PROPERTY(int maxDistance READ maxDistance NOTIFY dataUpdated)
    Q_PROPERTY(uint8_t sensorType READ sensorType NOTIFY dataUpdated)
    Q_PROPERTY(uint8_t increment READ increment NOTIFY dataUpdated)
    Q_PROPERTY(float incrementF READ incrementF NOTIFY dataUpdated)
    Q_PROPERTY(float angleOffset READ angleOffset NOTIFY dataUpdated)
    Q_PROPERTY(uint8_t frame READ frame NOTIFY dataUpdated)
    Q_PROPERTY(QList<int> distances READ distances NOTIFY dataUpdated)

public:
    explicit Vk_ObstacleDistance(QObject *parent = nullptr);

    void updateobstacleDistanceData(const struct VkObstacleDistance* data);

    // 属性访问方法
    uint64_t timeUsec();
    int minDistance();
    int maxDistance();
    uint8_t sensorType();
    uint8_t increment();
    float incrementF();
    float angleOffset();
    uint8_t frame();

    // 数组访问方法
    QList<int> distances();

signals:
    void dataUpdated(); // 数据更新信号

private:
    uint64_t m_timeUsec;
    int m_distances[72]={65535,65535,65535,65535,65535,65535,65535,65535,65535,65535,65535};
    int m_minDistance;
    int m_maxDistance;
    uint8_t m_sensorType;
    uint8_t m_increment;
    float m_incrementF;
    float m_angleOffset;
    uint8_t m_frame;

    struct VkObstacleDistance* m_obstacleDistance;
};

class Vk_DistanceSensor : public QObject
{
    Q_OBJECT

    Q_PROPERTY(uint32_t timeBootMs READ timeBootMs NOTIFY updated)
    Q_PROPERTY(uint16_t minDistance READ minDistance NOTIFY updated)
    Q_PROPERTY(uint16_t maxDistance READ maxDistance NOTIFY updated)
    Q_PROPERTY(double currentDistance READ currentDistance NOTIFY updated)
    Q_PROPERTY(uint8_t sensorType READ sensorType NOTIFY updated)
    Q_PROPERTY(uint8_t sensorId READ sensorId NOTIFY updated)
    Q_PROPERTY(uint8_t orientation READ orientation NOTIFY updated)
    Q_PROPERTY(uint8_t covariance READ covariance NOTIFY updated)
    Q_PROPERTY(float horizontalFov READ horizontalFov NOTIFY updated)
    Q_PROPERTY(float verticalFov READ verticalFov NOTIFY updated)
    Q_PROPERTY(float quaternionW READ quaternionW NOTIFY updated)
    Q_PROPERTY(float quaternionX READ quaternionX NOTIFY updated)
    Q_PROPERTY(float quaternionY READ quaternionY NOTIFY updated)
    Q_PROPERTY(float quaternionZ READ quaternionZ NOTIFY updated)
    Q_PROPERTY(uint8_t signalQuality READ signalQuality NOTIFY updated)

public:
    explicit Vk_DistanceSensor(QObject *parent = nullptr);

    void updatedistanceSensorData(const struct VkDistanceSensorStatus *data);

    uint32_t timeBootMs() const;
    uint16_t minDistance() const;
    uint16_t maxDistance() const;
    double currentDistance() const;
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
    struct VkDistanceSensorStatus* m_distanceSensorData;
};

class Vk_HighLatency : public QObject {
    Q_OBJECT

    Q_PROPERTY(quint32 customMode READ customMode NOTIFY dataUpdated)
    Q_PROPERTY(float latitude READ latitude NOTIFY dataUpdated)
    Q_PROPERTY(float longitude READ longitude NOTIFY dataUpdated)
    Q_PROPERTY(float roll READ roll NOTIFY dataUpdated)
    Q_PROPERTY(float pitch READ pitch NOTIFY dataUpdated)
    Q_PROPERTY(float heading READ heading NOTIFY dataUpdated)
    Q_PROPERTY(float headingSp READ headingSp NOTIFY dataUpdated)
    Q_PROPERTY(qint16 altitudeAmsl READ altitudeAmsl NOTIFY dataUpdated)
    Q_PROPERTY(qint16 altitudeSp READ altitudeSp NOTIFY dataUpdated)
    Q_PROPERTY(quint16 wpDistance READ wpDistance NOTIFY dataUpdated)
    Q_PROPERTY(quint8 baseMode READ baseMode NOTIFY dataUpdated)
    Q_PROPERTY(quint8 landedState READ landedState NOTIFY dataUpdated)
    Q_PROPERTY(qint8 throttle READ throttle NOTIFY dataUpdated)
    Q_PROPERTY(quint8 airspeed READ airspeed NOTIFY dataUpdated)
    Q_PROPERTY(quint8 airspeedSp READ airspeedSp NOTIFY dataUpdated)
    Q_PROPERTY(quint8 groundspeed READ groundspeed NOTIFY dataUpdated)
    Q_PROPERTY(qint8 climbRate READ climbRate NOTIFY dataUpdated)
    Q_PROPERTY(quint8 gpsNsat READ gpsNsat NOTIFY dataUpdated)
    Q_PROPERTY(quint8 gpsFixType READ gpsFixType NOTIFY dataUpdated)
    Q_PROPERTY(quint8 batteryRemaining READ batteryRemaining NOTIFY dataUpdated)
    Q_PROPERTY(qint8 temperature READ temperature NOTIFY dataUpdated)
    Q_PROPERTY(qint8 temperatureAir READ temperatureAir NOTIFY dataUpdated)
    Q_PROPERTY(quint8 failsafe READ failsafe NOTIFY dataUpdated)
    Q_PROPERTY(quint8 wpNum READ wpNum NOTIFY dataUpdated)

public:
    explicit Vk_HighLatency(QObject* parent = nullptr);
    ~Vk_HighLatency();

    void updatehighLatencyData(const struct VkHighLatency* data);

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
    quint8 wpNum();

signals:
    void dataUpdated();

private:
    struct VkHighLatency* m_highLatency;
};

class Vk_ScaledImuStatus : public QObject {
    Q_OBJECT

    Q_PROPERTY(int16_t xacc READ systemXacc NOTIFY statusUpdated)
    Q_PROPERTY(int16_t yacc READ systemYacc NOTIFY statusUpdated)
    Q_PROPERTY(int16_t zacc READ systemZacc NOTIFY statusUpdated)
    Q_PROPERTY(int16_t xgyro READ systemXgyro NOTIFY statusUpdated)
    Q_PROPERTY(int16_t ygyro READ systemYgyro NOTIFY statusUpdated)
    Q_PROPERTY(int16_t zgyro READ systemZgyro NOTIFY statusUpdated)
    Q_PROPERTY(int16_t xmag READ systemXmag NOTIFY statusUpdated)
    Q_PROPERTY(int16_t ymag READ systemYmag NOTIFY statusUpdated)
    Q_PROPERTY(int16_t zmag READ systemZmag NOTIFY statusUpdated)
    Q_PROPERTY(int8_t temperature READ systemTemperature NOTIFY statusUpdated)

   public:
    explicit Vk_ScaledImuStatus(QObject *parent = nullptr);
    ~Vk_ScaledImuStatus();

    void updateImuData(const struct VkScaledImuStatus* data);

    int16_t systemXacc();
    int16_t systemYacc();
    int16_t systemZacc();
    int16_t systemXgyro();
    int16_t systemYgyro();
    int16_t systemZgyro();
    int16_t systemXmag();
    int16_t systemYmag();
    int16_t systemZmag();
    int8_t systemTemperature();

signals:
    void statusUpdated();

private:
    struct VkScaledImuStatus* m_scaledImu;  // 用来保存状态数据
};

class Vk_FormationLeader : public QObject {
    Q_OBJECT

    Q_PROPERTY(quint32 timestamp READ timestamp NOTIFY statusUpdated)
    Q_PROPERTY(quint32 state READ state NOTIFY statusUpdated)
    Q_PROPERTY(double lat READ lat NOTIFY statusUpdated)
    Q_PROPERTY(double lon READ lon NOTIFY statusUpdated)
    Q_PROPERTY(float msl READ msl NOTIFY statusUpdated)
    Q_PROPERTY(float ve READ ve NOTIFY statusUpdated)
    Q_PROPERTY(float vn READ vn NOTIFY statusUpdated)
    Q_PROPERTY(float vu READ vu NOTIFY statusUpdated)
    Q_PROPERTY(float yaw READ yaw NOTIFY statusUpdated)
    Q_PROPERTY(float xDist READ xDist NOTIFY statusUpdated)
    Q_PROPERTY(float yDist READ yDist NOTIFY statusUpdated)
    Q_PROPERTY(float zDist READ zDist NOTIFY statusUpdated)
    Q_PROPERTY(quint16 rectColNum READ rectColNum NOTIFY statusUpdated)
    Q_PROPERTY(quint8 formationType READ formationType NOTIFY statusUpdated)

public:
    explicit Vk_FormationLeader(QObject *parent = nullptr);


    void updateFormationData(const VkFormationLeaderStatus* data);

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
    VkFormationLeaderStatus* m_formationLeader; // 实际数据存储
};

class Vk_ParachuteStatus : public QObject {
    Q_OBJECT

    Q_PROPERTY(quint32 timestamp READ timestamp NOTIFY statusUpdated)
    Q_PROPERTY(float backvolt READ backvolt NOTIFY statusUpdated)
    Q_PROPERTY(quint16 errCode READ errCode NOTIFY statusUpdated)
    Q_PROPERTY(quint8 state READ state NOTIFY statusUpdated)
    Q_PROPERTY(quint8 autoLaunch READ autoLaunch NOTIFY statusUpdated)
    Q_PROPERTY(quint8 uavCmd READ uavCmd NOTIFY statusUpdated)

public:
    explicit Vk_ParachuteStatus(QObject *parent = nullptr);
    ~Vk_ParachuteStatus();

           // 数据更新接口
    void updateParachuteData(const VkParachuteStatus* data);
    quint32 timestamp() const;
    float backvolt() const;
    quint16 errCode() const;
    quint8 state() const;
    quint8 autoLaunch() const;
    quint8 uavCmd() const;

signals:
    void statusUpdated();  // 数据更新信号

private:
    VkParachuteStatus* m_parachuteStatus;  // 实际数据存储
};

class Vk_WeigherState : public QObject {
    Q_OBJECT
    Q_PROPERTY(quint32 timestamp READ timestamp NOTIFY statusUpdated)
    Q_PROPERTY(quint32 weight READ weight NOTIFY statusUpdated)
    Q_PROPERTY(quint16 weightD READ weightD NOTIFY statusUpdated)
    Q_PROPERTY(quint8 workState READ workState NOTIFY statusUpdated)
    Q_PROPERTY(quint8 errCode READ errCode NOTIFY statusUpdated)

public:
    explicit Vk_WeigherState(QObject *parent = nullptr);

    void updateWeigherData(const VkWeigherState* data);

    quint32 timestamp() const;
    quint32 weight() const;
    quint16 weightD() const;
    quint8 workState() const;
    quint8 errCode() const;

signals:
    void statusUpdated();

private:
    VkWeigherState* m_weigherState; // 实际数据存储
};
