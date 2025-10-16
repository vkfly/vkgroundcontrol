
#pragma once

#include <QByteArray>
#include <QObject>

/**
 * @brief 吊舱协议接口
 * @details 定义了吊舱协议的通用接口，具体协议实现此接口
 */
class IGimbalProtocol : public QObject {
    Q_OBJECT

public:
    explicit IGimbalProtocol(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~IGimbalProtocol() = default;

    // 命令构建接口 - 与GimbalController外部接口名保持一致
    virtual QByteArray moveCommand(float xspeed, float yspeed) = 0;
    virtual QByteArray stopMovementCommand() = 0;
    virtual QByteArray setYawCommand(float angle) = 0;
    virtual QByteArray setPitchCommand(float angle) = 0;
    virtual QByteArray setYawPitchCommand(float yaw, float pitch) = 0;
    virtual QByteArray zoomInCommand(float step) = 0;
    virtual QByteArray zoomOutCommand(float step) = 0;
    virtual QByteArray stopZoomCommand() = 0;
    virtual QByteArray setZoomLevelCommand(float level) = 0;
    virtual QByteArray takePhotoCommand() = 0;
    virtual QByteArray startRecordingCommand() = 0;
    virtual QByteArray stopRecordingCommand() = 0;
    virtual QByteArray autoLockTargetCommand() = 0;
    virtual QByteArray lockTargetCommand(int x, int y) = 0;
    virtual QByteArray unlockTargetCommand() = 0;
    virtual QByteArray centerPositionCommand() = 0;
    virtual QByteArray lookDownCommand() = 0; // 新增一键下视命令构建接口
    virtual QByteArray enableRangingCommand() = 0;
    virtual QByteArray disableRangingCommand() = 0;

    // 数据解析接口
    virtual void parseReceivedData(const QByteArray &data) = 0;

signals:
    /**
     * @brief 命令构建完成信号
     */
    void commandReady(const QByteArray &command);

    /**
     * @brief 数据解析完成信号
     */
    void dataParsed(const QVariantMap &parsedData);
};
