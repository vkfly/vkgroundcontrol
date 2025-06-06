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
#include <QtPositioning/QGeoPositionInfo>

Q_DECLARE_LOGGING_CATEGORY(QGCDeviceInfoLog)

namespace QGCDeviceInfo
{

bool isInternetAvailable();
bool isNetworkEthernet();

////////////////////////////////////////////////////////////////////

}