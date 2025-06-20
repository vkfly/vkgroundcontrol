/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "SettingsGroup.h"
// #include "QGCCorePlugin.h"

#include <QtQml/QQmlEngine>

SettingsGroup::SettingsGroup(const QString& name, const QString& settingsGroup, QObject* parent)
    : QObject       (parent)
      // , _visible      (QGCCorePlugin::instance()->overrideSettingsGroupVisibility(name))
    , _visible(false)
    , _name         (name)
    , _settingsGroup(settingsGroup) {
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    _nameToMetaDataMap = FactMetaData::createMapFromJsonFile(QString(kJsonFile).arg(name), this);
}

SettingsFact* SettingsGroup::_createSettingsFact(const QString& factName) {
    FactMetaData* m = _nameToMetaDataMap[factName];
    if(!m) {
        qCritical() << "Fact name " << factName << "not found in" << QString(kJsonFile).arg(_name);
        exit(-1);
    }
    return new SettingsFact(_settingsGroup, m, this);
}

