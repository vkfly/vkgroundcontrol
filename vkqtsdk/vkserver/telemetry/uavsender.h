#ifndef UAVSENDER_H
#define UAVSENDER_H

#include<QByteArray>
#include "uavclient.h"
#include "../vkdata.h"

class UavSender: public UavClient {

public:
    explicit UavSender();
    void sendImu(const VehicleTelemetryData& info);

protected:
    void confirmPackage(long seq) override;
    void savePackage(long seq, const QByteArray& data) override;
    QByteArray getResendPackage() override;
    long getInitialSeq() override;
    void onReceived(const InstructionProto& msg) override;
    void onReceived(const RouteProto& msg) override;
    void onReceived(const WaypointGroupProto& msg) override;
    void onReceived(const GimbalProto& msg) override;

private:
    long minId = 0;
};

#endif // UAVSENDER_H
