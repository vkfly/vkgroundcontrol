#pragma once

#include <QThread>
#include <QMutex>
#include <QSharedPointer>
#include "Link/GimbalLinkClient.h"
#include "Protocols/IGimbalProtocol.h"


class GimbalController : public QObject {
    Q_OBJECT
    
public:

    /**
     * @brief 吊舱类型枚举
     */
    enum GimbalType {
        SIYI_ZR10,       // SIYI ZR10
        SIYI_ZT30,       // SIYI ZT30
        YUNZHUO_C12,     // 云卓 C12
        YUNZHUO_C20,     // 云卓 C20
        XIANFEI_D80PRO,  // 先飞D80-Pro
        XIANFEI_Z1MINI,  // 先飞Z1-mini
        XIANGTUO,        // 翔拓
        TUOPU,           // 拓扑
        PINGLING_A40TR,  // 品灵-A40TRPRO
        DYT_PROTOCOL,    // 上博智像DYT协议
        CUSTOM_PROTOCOL  // 自定义协议（预留扩展）
    };
    Q_ENUM(GimbalType)

    explicit GimbalController(QObject *parent = nullptr);
    virtual ~GimbalController();

    static void registerQmlTypes();
    // 连接管理
    Q_INVOKABLE bool connectToGimbal(GimbalType type);
    Q_INVOKABLE void disconnectFromGimbal();
 
    // 基础控制接口
    Q_INVOKABLE void moveUp(float speed = 1.0f);
    Q_INVOKABLE void moveDown(float speed = 1.0f);
    Q_INVOKABLE void moveLeft(float speed = 1.0f);
    Q_INVOKABLE void moveRight(float speed = 1.0f);
    Q_INVOKABLE void stopMovement();
    
    // 姿态控制
    Q_INVOKABLE void setYaw(float angle);
    Q_INVOKABLE void setPitch(float angle);
    Q_INVOKABLE void setYawPitch(float yaw, float pitch);
    
    // 测距控制
    Q_INVOKABLE void enableRanging();
    Q_INVOKABLE void disableRanging();
    
    // 锁定控制
    Q_INVOKABLE void autoLockTarget();
    Q_INVOKABLE void lockTarget(int x, int y);
    Q_INVOKABLE void unlockTarget();
    
    // 拍照录像
    Q_INVOKABLE void takePhoto();
    Q_INVOKABLE void startRecording();
    Q_INVOKABLE void stopRecording();
    
    // 变焦控制
    Q_INVOKABLE void zoomIn(float step = 0.1f);
    Q_INVOKABLE void zoomOut(float step = 0.1f);
    Q_INVOKABLE void stopZoom();
    Q_INVOKABLE void setZoomLevel(float level);
    
    // 位置控制
    Q_INVOKABLE void centerPosition();
    Q_INVOKABLE void lookDown(); // 新增一键下视实现
    
    // 获取当前吊舱类型
    GimbalType currentGimbalType() const;
    
private slots:
    void onDataReceived(const QByteArray &data);
    void onLinkFailed(GimbalLinkClient *client);
    void initClient(const QString &schema);
    
    void onProtocolDataParsed(const QVariantMap &data);
    void onSendCommand(const QByteArray &data);

signals:
    void initLink(const QString &schema);
    void sendCommand(const QByteArray &data);

private:
    void createProtocol(GimbalType type);
    
    GimbalLinkClient *m_linkClient = nullptr;
    QThread *m_workerThread = nullptr;
    QSharedPointer<IGimbalProtocol> m_protocol;
    GimbalType m_currentType = CUSTOM_PROTOCOL;
    bool m_connected = false;

    void bind(QThread *thread);
    void initController();
    void _onGimbalTypeChanged(int gimbalType);

    template<typename Func>
    bool executeProtocolCommand(Func commandBuilder);
    
    bool executeProtocolCommand(std::function<QByteArray()> commandBuilder);
};
