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

    Q_PROPERTY(int id READ getSysId CONSTANT)
    Q_PROPERTY(QGeoCoordinate coordinate READ getCoordinate NOTIFY coordinateChanged)
    Q_PROPERTY(QGeoCoordinate home READ getHome NOTIFY homePositionChanged)
    Q_PROPERTY(double homeDis READ homeDis NOTIFY homeDisChanged)
    Q_PROPERTY(double headToHome READ homeDis NOTIFY headToHomeChanged)

    Q_PROPERTY(Vk_Heartbeat* heartbeat READ heartBeat CONSTANT)
    Q_PROPERTY(QList<VkLogEntry*> logs READ getLogEntries NOTIFY logChanged)
    Q_PROPERTY(VkSystemStatus* sysStatus READ sysStatus CONSTANT)

    Q_PROPERTY(Vk_QingxieBms* qingxieBms READ qingxieBms CONSTANT)
    Q_PROPERTY(Vk_BmsStatus* bmsStatus READ bmsStatus CONSTANT)

    Q_PROPERTY(VkGnss* GNSS1 READ gpsInput1 CONSTANT)
    Q_PROPERTY(VkGnss* GNSS2 READ gpsInput2 CONSTANT)
    Q_PROPERTY(VkRtkMsg* RtkMsg READ rtkMsg CONSTANT)
    Q_PROPERTY(Vk_Attitude* attitude READ attitude CONSTANT)
    Q_PROPERTY(Vk_ServoOutputRaw* servoOutputRaw READ servoOutputRaw CONSTANT)
    Q_PROPERTY(Vk_MissionCurrent* missionCurrent READ missionCurrent CONSTANT)
    Q_PROPERTY(Vk_RcChannels* rcChannels READ rcChannels CONSTANT)

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

    Q_PROPERTY(Vk_FmuStatus* fmuStatus READ fmuStatus CONSTANT)
    Q_PROPERTY(Vk_insStatus* insStatus READ insStatus CONSTANT)
    Q_PROPERTY(Vk_VfrHud* vfrHud READ vfrHud CONSTANT)
    Q_PROPERTY(Vk_ObstacleDistance* obstacleDistance READ obstacleDistance CONSTANT)
    Q_PROPERTY(Vk_HighLatency* highLatency READ highLatency CONSTANT)
    Q_PROPERTY(Vk_EscStatus* escStatus READ escStatus CONSTANT)

    Q_PROPERTY(Vk_ScaledImuStatus* scaledImuStatus READ scaledImuStatus NOTIFY scaledImuStatusChanged)
    Q_PROPERTY(Vk_ScaledImuStatus* scaledImu2Status READ scaledImu2Status NOTIFY scaledImu2StatusChanged)

    Q_PROPERTY(MissionModel* mission READ getMission NOTIFY missionChanged)

    Q_PROPERTY(QVariantMap parameters READ getParams NOTIFY paramChanged)

    Q_PROPERTY(Vk_GlobalPositionInt* globalPositionInt READ globalPositionInt CONSTANT)
    Q_PROPERTY(Vk_DistanceSensor* distanceSensor READ distanceSensor CONSTANT)
    Q_PROPERTY(Vk_WeigherState* weigherState READ weigherState CONSTANT)
    Q_PROPERTY(Vk_FormationLeader* formationLeader READ formationLeader CONSTANT)
    Q_PROPERTY(QQmlPropertyMap* payload READ getPayload CONSTANT)

public:
    VkVehicle(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~VkVehicle() = default;

    Q_INVOKABLE virtual void takeOff() = 0;
    Q_INVOKABLE virtual void motorTest(int motor, int percent, int timeoutSecs, bool showError) = 0;

    Q_INVOKABLE virtual void setParam(QString name, double value) = 0;

    Q_INVOKABLE virtual void newMission() = 0;
    Q_INVOKABLE virtual void clearMission() = 0;
    Q_INVOKABLE virtual void addWaypoint(double lat, double lon, double alt, int turnType = 0) = 0;
    Q_INVOKABLE virtual void addLandWaypoint(double lat, double lon, double alt, float speed = NAN) = 0;
    // Q_INVOKABLE virtual void addPhotoWaypoint(double lat, double lon, double alt) = 0;
    Q_INVOKABLE virtual void updateWaypoint(int idx) = 0;
    Q_INVOKABLE virtual void startMission(QString param1, int param2, int param3) = 0;
    Q_INVOKABLE virtual void uploadMission() = 0;
    Q_INVOKABLE virtual void uploadMissionModel(MissionModel* mission) = 0;
    Q_INVOKABLE virtual void downloadMission(MissionModel * mission) = 0;
    Q_INVOKABLE virtual void returnMission(QString param1, int param2) = 0;

    Q_INVOKABLE virtual double homeDis() const = 0;
    virtual QQmlPropertyMap* getPayload() = 0;

protected:
    virtual int getSysId() = 0;
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
};
