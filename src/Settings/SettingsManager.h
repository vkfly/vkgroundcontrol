/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include <QtCore/QLoggingCategory>
#include <QtCore/QObject>
#include <QtQmlIntegration/QtQmlIntegration>

class AppSettings;
class FlightMapSettings;
// class FlyViewSettings;
class MapsSettings;
class VideoSettings;

Q_DECLARE_LOGGING_CATEGORY(SettingsManagerLog)

/// Provides access to all app settings
class SettingsManager : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("")
    Q_MOC_INCLUDE("AppSettings.h")
    Q_MOC_INCLUDE("FlightMapSettings.h")
    // Q_MOC_INCLUDE("FlyViewSettings.h")
    Q_MOC_INCLUDE("MapsSettings.h")
    Q_MOC_INCLUDE("VideoSettings.h")
    Q_PROPERTY(QObject *appSettings                     READ appSettings                    CONSTANT)
    Q_PROPERTY(QObject *flightMapSettings               READ flightMapSettings              CONSTANT)
    // Q_PROPERTY(QObject *flyViewSettings                 READ flyViewSettings                CONSTANT)
    Q_PROPERTY(QObject *mapsSettings                    READ mapsSettings                   CONSTANT)
    Q_PROPERTY(QObject *videoSettings                   READ videoSettings                  CONSTANT)
public:
    SettingsManager(QObject *parent = nullptr);
    ~SettingsManager();

    static SettingsManager *instance();
    static void registerQmlTypes();

    void init();
    AppSettings *appSettings() const;
    FlightMapSettings *flightMapSettings() const;
    // FlyViewSettings *flyViewSettings() const;
    MapsSettings *mapsSettings() const;
    VideoSettings *videoSettings() const;

private:
    AppSettings *_appSettings = nullptr;
    FlightMapSettings *_flightMapSettings = nullptr;
    MapsSettings *_mapsSettings = nullptr;
    VideoSettings *_videoSettings = nullptr;
    // FlyViewSettings *_flyViewSettings = nullptr;

};
