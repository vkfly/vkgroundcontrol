#pragma once

#include "IGimbalProtocol.h"
#include <QTimer>
#include <QByteArray>
#include <QVariantMap>

/**
 * @brief DYT协议实现类
 * @details 实现上博智像DYT协议的具体通信协议
 */
class DYTProtocol : public IGimbalProtocol {
    Q_OBJECT
    
public:
    explicit DYTProtocol(QObject *parent = nullptr);
    virtual ~DYTProtocol() = default;
    
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
    QByteArray lookDownCommand() override; // 新增一键下视命令实现
    QByteArray enableRangingCommand() override;
    QByteArray disableRangingCommand() override;
    
    void parseReceivedData(const QByteArray &data) override;
    
private:
    // DYT协议相关的私有方法
    QByteArray createDYTPacket(quint8 command, qint16 paramx, qint16 paramy, quint8 param3, qint8 param4);
    static quint8 calculateChecksum(const QByteArray &data, int startIndex);
    QByteArray createNetworkPacket(const QByteArray &dytData);
    
};
