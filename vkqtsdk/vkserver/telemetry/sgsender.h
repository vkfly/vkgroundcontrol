#ifndef SGSENDER_H
#define SGSENDER_H

#include <QObject>
#include "uavsender.h"
#include "../vkdata.h"

class SgSender : public QObject {
    Q_OBJECT
public:
    explicit SgSender(QObject *parent = nullptr);
    void sendImu(const VehicleTelemetryData& info);

    void start() {
        sender.start();
    }

    void stop() {
        sender.stop();
    }
    
private:
    UavSender sender;

};

#endif // SGSENDER_H
