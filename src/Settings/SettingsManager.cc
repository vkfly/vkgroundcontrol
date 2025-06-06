/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "SettingsManager.h"
#include "QGCLoggingCategory.h"
#include "VideoSettings.h"
#include "AppSettings.h"
#include "FlightMapSettings.h"
#include "MapsSettings.h"

// #ifdef QGC_VIEWER3D
//     #include "Viewer3DSettings.h"
// #endif

#include <QtCore/qapplicationstatic.h>
#include <QtQml/qqml.h>

QGC_LOGGING_CATEGORY(SettingsManagerLog, "qgc.settings.settingsmanager")

Q_APPLICATION_STATIC(SettingsManager, _settingsManagerInstance);

SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent) {
    // qCDebug(SettingsManagerLog) << Q_FUNC_INFO << this;
}

SettingsManager::~SettingsManager() {
    // qCDebug(SettingsManagerLog) << Q_FUNC_INFO << this;
}

SettingsManager *SettingsManager::instance() {
    return _settingsManagerInstance();
}

void SettingsManager::registerQmlTypes() {
    (void) qmlRegisterUncreatableType<SettingsManager>("QGroundControl.SettingsManager", 1, 0, "SettingsManager", "Reference only");
}

void SettingsManager::init() {
    _appSettings = new AppSettings(this);
    _flightMapSettings = new FlightMapSettings(this);
    _mapsSettings = new MapsSettings(this);
    _videoSettings = new VideoSettings(this);
}

AppSettings *SettingsManager::appSettings() const {
    return _appSettings;
}

FlightMapSettings *SettingsManager::flightMapSettings() const {
    return _flightMapSettings;
}

MapsSettings *SettingsManager::mapsSettings() const {
    return _mapsSettings;
}

VideoSettings *SettingsManager::videoSettings() const {
    return _videoSettings;
}
