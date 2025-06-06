/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "DeviceInfo.h"
#include "QGCLoggingCategory.h"

#include <QtCore/qapplicationstatic.h>
#include <QtNetwork/QNetworkInformation>

QGC_LOGGING_CATEGORY(QGCDeviceInfoLog, "qgc.utilities.deviceinfo")

namespace QGCDeviceInfo
{

//  TODO:
//    - reachabilityChanged()
//    - Allow to select by transportMedium()

bool isInternetAvailable()
{
    if (QNetworkInformation::availableBackends().isEmpty()) return false;

    if (!QNetworkInformation::loadDefaultBackend()) return false;

    if (!QNetworkInformation::loadBackendByFeatures(QNetworkInformation::Feature::Reachability)) return false;

    const QNetworkInformation::Reachability reachability = QNetworkInformation::instance()->reachability();

    return (reachability == QNetworkInformation::Reachability::Online);
}

bool isNetworkEthernet()
{
    if (QNetworkInformation::availableBackends().isEmpty()) return false;

    if (!QNetworkInformation::loadDefaultBackend()) return false;

    return (QNetworkInformation::instance()->transportMedium() == QNetworkInformation::TransportMedium::Ethernet);
}

////////////////////////////////////////////////////////////////////


} // namespace QGCDeviceInfo
