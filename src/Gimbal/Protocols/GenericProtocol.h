#ifndef GENERICPROTOCOL_H
#define GENERICPROTOCOL_H

#include "IGimbalProtocol.h"
#include <QObject>
#include <QByteArray>
#include <QVariantMap>

class GenericProtocol : public IGimbalProtocol
{
    Q_OBJECT

public:
    explicit GenericProtocol(QObject *parent = nullptr);
    virtual ~GenericProtocol();

    // IGimbalProtocol接口实现
    QByteArray moveCommand(float xspeed, float yspeed) override;
    QByteArray stopMovementCommand() override;
    QByteArray setYawCommand(float angle) override;
    QByteArray setPitchCommand(float angle) override;
    QByteArray setYawPitchCommand(float yaw, float pitch) override;
    QByteArray zoomInCommand(float step) override;
    QByteArray zoomOutCommand(float step) override;
    QByteArray stopZoomCommand() override;
    QByteArray setZoomLevelCommand(float level) override;
    QByteArray takePhotoCommand() override;
    QByteArray startRecordingCommand() override;
    QByteArray stopRecordingCommand() override;
    QByteArray autoLockTargetCommand() override;
    QByteArray lockTargetCommand(int x, int y) override;
    QByteArray unlockTargetCommand() override;
    QByteArray centerPositionCommand() override;
    QByteArray lookDownCommand() override;
    QByteArray enableRangingCommand() override;
    QByteArray disableRangingCommand() override;
    
    void parseReceivedData(const QByteArray &data) override;

signals:
    void dataParsed(const QVariantMap &data);

private:
    void parseStatusData(const QByteArray &data);
    
    // 通用协议常量
    static const int MAX_PACKET_SIZE = 1024;
    
    QByteArray m_receiveBuffer;
};

#endif // GENERICPROTOCOL_H
