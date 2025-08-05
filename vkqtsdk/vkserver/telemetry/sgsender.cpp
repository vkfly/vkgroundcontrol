#include "sgsender.h"

SgSender::SgSender(QObject *parent)
    : QObject{parent}
{}

void SgSender::sendImu(const VehicleTelemetryData &info) {
    sender.sendImu(info);
}

