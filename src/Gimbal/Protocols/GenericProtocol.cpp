#include "GenericProtocol.h"
#include <QDebug>
#include <QDateTime>
#include <QJsonDocument>
#include <QJsonObject>

GenericProtocol::GenericProtocol(QObject *parent)
    : IGimbalProtocol(parent)
{
    qDebug() << "Generic Protocol initialized";
}

GenericProtocol::~GenericProtocol()
{
    qDebug() << "Generic Protocol destroyed";
}

QByteArray GenericProtocol::moveCommand(float xspeed, float yspeed)
{
    return QByteArray();
}

QByteArray GenericProtocol::stopMovementCommand()
{
    return QByteArray();
}

QByteArray GenericProtocol::setYawCommand(float angle)
{
    return QByteArray();
}

QByteArray GenericProtocol::setPitchCommand(float angle)
{ 
    return QByteArray();
}

QByteArray GenericProtocol::setYawPitchCommand(float yaw, float pitch)
{
    return QByteArray();
}

QByteArray GenericProtocol::zoomInCommand(float step)
{
    return QByteArray();
}

QByteArray GenericProtocol::zoomOutCommand(float step)
{
    return QByteArray();
}

QByteArray GenericProtocol::stopZoomCommand()
{
    return QByteArray();
}

QByteArray GenericProtocol::setZoomLevelCommand(float level)
{
   return QByteArray();
}

QByteArray GenericProtocol::takePhotoCommand()
{
   return QByteArray();
}

QByteArray GenericProtocol::startRecordingCommand()
{
    return QByteArray();
}

QByteArray GenericProtocol::stopRecordingCommand()
{
   return QByteArray();
}

QByteArray GenericProtocol::autoLockTargetCommand()
{
    return QByteArray();
}

QByteArray GenericProtocol::lockTargetCommand(int x, int y)
{
    return QByteArray();
}

QByteArray GenericProtocol::unlockTargetCommand()
{
    return QByteArray();
}

QByteArray GenericProtocol::centerPositionCommand()
{
   return QByteArray();
}

QByteArray GenericProtocol::lookDownCommand()
{
    return QByteArray();
}

QByteArray GenericProtocol::enableRangingCommand()
{
   return QByteArray();
}

QByteArray GenericProtocol::disableRangingCommand()
{
   return QByteArray();
}

void GenericProtocol::parseReceivedData(const QByteArray &data)
{

}

