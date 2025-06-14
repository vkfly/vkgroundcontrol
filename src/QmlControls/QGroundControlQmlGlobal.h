/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

// #include "QmlUnitsConversion.h"
#include "QGCLoggingCategory.h"

#include <QtCore/QTimer>
#include <QtCore/QPointF>
#include <QtPositioning/QGeoCoordinate>

// class MissionCommandTree;
// class QGCMapEngineManager;
class VKPalette;
class SettingsManager;
class VideoManager;
class FileDownloader;

Q_MOC_INCLUDE("VKPalette.h")
Q_MOC_INCLUDE("SettingsManager.h")
Q_MOC_INCLUDE("VideoManager.h")
Q_MOC_INCLUDE("FileDownloader.h")

class QGroundControlQmlGlobal : public QObject {
    Q_OBJECT

public:
    QGroundControlQmlGlobal(QObject *parent = nullptr);
    ~QGroundControlQmlGlobal();

    static void registerQmlTypes();

    enum AltMode {
        AltitudeModeMixed,              // Used by global altitude mode for mission planning
        AltitudeModeRelative,           // MAV_FRAME_GLOBAL_RELATIVE_ALT
        AltitudeModeAbsolute,           // MAV_FRAME_GLOBAL
        AltitudeModeCalcAboveTerrain,   // Absolute altitude above terrain calculated from terrain data
        AltitudeModeTerrainFrame,       // MAV_FRAME_GLOBAL_TERRAIN_ALT
        AltitudeModeNone,               // Being used as distance value unrelated to ground (for example distance to structure)
    };
    Q_ENUM(AltMode)

    Q_PROPERTY(QString              appName                 READ    appName                 CONSTANT)
    Q_PROPERTY(VideoManager*        videoManager            READ    videoManager            CONSTANT)
    Q_PROPERTY(SettingsManager*     settingsManager         READ    settingsManager         CONSTANT)
    Q_PROPERTY(bool                 airlinkSupported        READ    airlinkSupported        CONSTANT)
    Q_PROPERTY(VKPalette*          globalPalette           MEMBER  _globalPalette          CONSTANT)   ///< This palette will always return enabled colors
    Q_PROPERTY(bool                 singleFirmwareSupport   READ    singleFirmwareSupport   CONSTANT)
    Q_PROPERTY(bool                 singleVehicleSupport    READ    singleVehicleSupport    CONSTANT)
    Q_PROPERTY(bool                 px4ProFirmwareSupported READ    px4ProFirmwareSupported CONSTANT)
    Q_PROPERTY(int                  apmFirmwareSupported    READ    apmFirmwareSupported    CONSTANT)
    Q_PROPERTY(QGeoCoordinate       flightMapPosition       READ    flightMapPosition       WRITE setFlightMapPosition  NOTIFY flightMapPositionChanged)
    Q_PROPERTY(double               flightMapZoom           READ    flightMapZoom           WRITE setFlightMapZoom      NOTIFY flightMapZoomChanged)
    Q_PROPERTY(double               flightMapInitialZoom    MEMBER  _flightMapInitialZoom   CONSTANT)   ///< Zoom level to use when either gcs or vehicle shows up for first time

    Q_PROPERTY(QString  parameterFileExtension  READ parameterFileExtension CONSTANT)
    Q_PROPERTY(QString  missionFileExtension    READ missionFileExtension   CONSTANT)
    Q_PROPERTY(QString  telemetryFileExtension  READ telemetryFileExtension CONSTANT)

    Q_PROPERTY(QString qgcVersion       READ qgcVersion         CONSTANT)

    Q_PROPERTY(qreal zOrderTopMost              READ zOrderTopMost              CONSTANT) ///< z order for top most items, toolbar, main window sub view
    Q_PROPERTY(qreal zOrderWidgets              READ zOrderWidgets              CONSTANT) ///< z order value to widgets, for example: zoom controls, hud widgetss
    Q_PROPERTY(qreal zOrderMapItems             READ zOrderMapItems             CONSTANT)
    Q_PROPERTY(qreal zOrderVehicles             READ zOrderVehicles             CONSTANT)
    Q_PROPERTY(qreal zOrderWaypointIndicators   READ zOrderWaypointIndicators   CONSTANT)
    Q_PROPERTY(qreal zOrderTrajectoryLines      READ zOrderTrajectoryLines      CONSTANT)
    Q_PROPERTY(qreal zOrderWaypointLines        READ zOrderWaypointLines        CONSTANT)
    Q_PROPERTY(bool     hasAPMSupport           READ hasAPMSupport              CONSTANT)
    Q_PROPERTY(bool     hasMAVLinkInspector     READ hasMAVLinkInspector        CONSTANT)


    //-------------------------------------------------------------------------
    // Elevation Provider
    Q_PROPERTY(QString  elevationProviderName           READ elevationProviderName              CONSTANT)
    Q_PROPERTY(QString  elevationProviderNotice         READ elevationProviderNotice            CONSTANT)

    Q_PROPERTY(bool              utmspSupported           READ    utmspSupported              CONSTANT)

    Q_INVOKABLE void    saveGlobalSetting       (const QString& key, const QString& value);
    Q_INVOKABLE QString loadGlobalSetting       (const QString& key, const QString& defaultValue);
    Q_INVOKABLE void    saveBoolGlobalSetting   (const QString& key, bool value);
    Q_INVOKABLE bool    loadBoolGlobalSetting   (const QString& key, bool defaultValue);

    Q_INVOKABLE void    deleteAllSettingsNextBoot       ();
    Q_INVOKABLE void    clearDeleteAllSettingsNextBoot  ();

    Q_INVOKABLE void    startPX4MockLink            (bool sendStatusText);
    Q_INVOKABLE void    startGenericMockLink        (bool sendStatusText);
    Q_INVOKABLE void    startAPMArduCopterMockLink  (bool sendStatusText);
    Q_INVOKABLE void    startAPMArduPlaneMockLink   (bool sendStatusText);
    Q_INVOKABLE void    startAPMArduSubMockLink     (bool sendStatusText);
    Q_INVOKABLE void    startAPMArduRoverMockLink   (bool sendStatusText);
    Q_INVOKABLE void    stopOneMockLink             (void);

    /// Returns the list of available logging category names.
    Q_INVOKABLE QStringList loggingCategories(void) const {
        return QGCLoggingCategoryRegister::instance()->registeredCategories();
    }

    /// Turns on/off logging for the specified category. State is saved in app settings.
    Q_INVOKABLE void setCategoryLoggingOn(const QString& category, bool enable) {
        QGCLoggingCategoryRegister::instance()->setCategoryLoggingOn(category, enable);
    }

    /// Returns true if logging is turned on for the specified category.
    Q_INVOKABLE bool categoryLoggingOn(const QString& category) {
        return QGCLoggingCategoryRegister::instance()->categoryLoggingOn(category);
    }

    /// Updates the logging filter rules after settings have changed
    Q_INVOKABLE void updateLoggingFilterRules(void) {
        QGCLoggingCategoryRegister::instance()->setFilterRulesFromSettings(QString());
    }

    Q_INVOKABLE bool linesIntersect(QPointF xLine1, QPointF yLine1, QPointF xLine2, QPointF yLine2);

    Q_INVOKABLE QString altitudeModeExtraUnits(AltMode altMode);        ///< String shown in the FactTextField.extraUnits ui
    Q_INVOKABLE QString altitudeModeShortDescription(AltMode altMode);  ///< String shown when a user needs to select an altitude mode

    // Property accessors

    QString                 appName             ();
    VideoManager*           videoManager        ()  {
        return _videoManager;
    }
    SettingsManager*        settingsManager     ()  {
        return _settingsManager;
    }
    static QGeoCoordinate   flightMapPosition   ()  {
        return _coord;
    }
    static double           flightMapZoom       ()  {
        return _zoom;
    }

#ifndef QGC_AIRLINK_DISABLED
    bool                    airlinkSupported    ()  {
        return true;
    }
#else
    bool                    airlinkSupported    ()  {
        return false;
    }
#endif

    qreal zOrderTopMost             () {
        return 1000;
    }
    qreal zOrderWidgets             () {
        return 100;
    }
    qreal zOrderMapItems            () {
        return 50;
    }
    qreal zOrderWaypointIndicators  () {
        return 50;
    }
    qreal zOrderVehicles            () {
        return 49;
    }
    qreal zOrderTrajectoryLines     () {
        return 48;
    }
    qreal zOrderWaypointLines       () {
        return 47;
    }

#if defined(QGC_NO_ARDUPILOT_DIALECT)
    bool    hasAPMSupport           () {
        return false;
    }
#else
    bool    hasAPMSupport           () {
        return true;
    }
#endif

#if defined(QGC_DISABLE_MAVLINK_INSPECTOR)
    bool    hasMAVLinkInspector     () {
        return false;
    }
#else
    bool    hasMAVLinkInspector     () {
        return true;
    }
#endif

    QString elevationProviderName   ();
    QString elevationProviderNotice ();

    bool    singleFirmwareSupport   ();
    bool    singleVehicleSupport    ();
    bool    px4ProFirmwareSupported ();
    bool    apmFirmwareSupported    ();

    void    setFlightMapPosition        (QGeoCoordinate& coordinate);
    void    setFlightMapZoom            (double zoom);

    QString parameterFileExtension  (void) const;
    QString missionFileExtension    (void) const;
    QString telemetryFileExtension  (void) const;

    QString qgcVersion              (void) const;

#ifdef QGC_UTM_ADAPTER
    UTMSPManager* utmspManager() {
        return _utmspManager;
    }
    bool utmspSupported() {
        return true;
    }
#else
    bool utmspSupported() {
        return false;
    }
#endif

signals:
    void isMultiplexingEnabledChanged   (bool enabled);
    void mavlinkSystemIDChanged         (int id);
    void flightMapPositionChanged       (QGeoCoordinate flightMapPosition);
    void flightMapZoomChanged           (double flightMapZoom);

private:

    VideoManager*           _videoManager           = nullptr;
    SettingsManager*        _settingsManager        = nullptr;
    VKPalette*             _globalPalette          = nullptr;
    double                  _flightMapInitialZoom   = 17.0;
    QStringList             _altitudeModeEnumString;

    static QGeoCoordinate   _coord;
    static double           _zoom;
    QTimer                  _flightMapPositionSettledTimer;

    static constexpr const char* kQmlGlobalKeyName = "QGCQml";

    static constexpr const char* _flightMapPositionSettingsGroup =          "FlightMapPosition";
    static constexpr const char* _flightMapPositionLatitudeSettingsKey =    "Latitude";
    static constexpr const char* _flightMapPositionLongitudeSettingsKey =   "Longitude";
    static constexpr const char* _flightMapZoomSettingsKey =                "FlightMapZoom";
};
