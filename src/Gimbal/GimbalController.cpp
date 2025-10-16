#include <QThread>
#include <QMetaObject>
#include <QDebug>

#include "GimbalController.h"
#include "Protocols/DytProtocol.h"
#include "Protocols/GenericProtocol.h"
#include "Link/ClientFactory.h"
#include "SettingsManager.h"
#include "VideoSettings.h"

#include <QtQml/QQmlEngine>

GimbalController::GimbalController(QObject *parent)
    : QObject(parent)
    , m_linkClient(nullptr)
    , m_workerThread(nullptr)
    , m_protocol(nullptr)
    , m_currentType(CUSTOM_PROTOCOL)
    , m_connected(false)
{
    if (!m_workerThread) {
        m_workerThread = new QThread();
        bind(m_workerThread);
        m_workerThread->start();
        qDebug() << "GimbalController";
    }
    // 添加gimbalType监听
    (void) connect(SettingsManager::instance()->videoSettings()->gimbalType(), &Fact::rawValueChanged, this, [this](const QVariant & value) {
        _onGimbalTypeChanged(value.toInt());
    });

    _onGimbalTypeChanged(SettingsManager::instance()->videoSettings()->gimbalType()->rawValue().toInt());
}

GimbalController::~GimbalController()
{
    if(m_workerThread) {
        m_workerThread->quit();
        m_workerThread->wait();
        m_workerThread->deleteLater();
    }
}

void GimbalController::registerQmlTypes() {
    (void) qmlRegisterUncreatableType<GimbalController>("VKGroundControl.GimbalController", 1, 0, "GimbalController", "Reference only");
}

bool GimbalController::connectToGimbal(GimbalType type)
{
    qDebug() << "connectToGimbal:" << "Type:" << type;
    if (m_connected) {
        qWarning() << "Already connected to gimbal";
        return false;
    }
    qDebug() << "connectToGimbal";
    // 根据吊舱类型确定默认连接地址
    QString address;
    switch (type) {
        case SIYI_ZR10:
        case SIYI_ZT30:
            address = "udp://192.168.144.25:37260";
            break;
        case YUNZHUO_C12:
        case YUNZHUO_C20:
        case XIANFEI_D80PRO:
        case XIANFEI_Z1MINI:
        case DYT_PROTOCOL:
            address = "tcp://192.168.2.119:2000";
            break;
        case XIANGTUO:
        case PINGLING_A40TR:
            address = "udp://192.168.144.119:8080";
            break;
        case TUOPU:
            address = "udp://192.168.144.108:8080";
            break;
        default:
        case CUSTOM_PROTOCOL:
            address = "udp://192.168.144.108:8080";
            break;
    }
    createProtocol(type);
    if (!m_protocol) {
        qWarning() << "Failed to create protocol for gimbal type:" << type;
        return false;
    }
    
    m_currentType = type;
    
    connect(m_protocol.data(), &IGimbalProtocol::dataParsed,
            this, &GimbalController::onProtocolDataParsed);
    emit initLink(address);
    m_connected = true;
    qDebug() << "Connecting to gimbal:" << address << "Type:" << type;
    return true;
}

void GimbalController::disconnectFromGimbal()
{
    if (!m_connected) {
        return;
    }
    m_connected = false;
    if (m_linkClient) {
        m_linkClient->deleteLater();
        m_linkClient = nullptr;
    }
    if (m_protocol) {
        disconnect(m_protocol.data(), nullptr, this, nullptr);
        m_protocol.reset();
    }
}

void GimbalController::bind(QThread *thread)
{
    if (thread) {
        moveToThread(thread);
    }
    connect(thread, &QThread::started, this, &GimbalController::initController);
    connect(thread, &QThread::finished, this, &GimbalController::disconnectFromGimbal);
}

void GimbalController::initController()
{
    connect(this, &GimbalController::initLink, this, &GimbalController::initClient);
    connect(this, &GimbalController::sendCommand, this, &GimbalController::onSendCommand);
}


void GimbalController::moveUp(float speed)
{
    executeProtocolCommand([this, speed]() {
        return m_protocol->moveCommand(0.0f, speed);
    });
}

void GimbalController::moveDown(float speed)
{
    executeProtocolCommand([this, speed]() {
        return m_protocol->moveCommand(0.0f, -speed);
    });
}

void GimbalController::moveLeft(float speed)
{
    executeProtocolCommand([this, speed]() {
        return m_protocol->moveCommand(-speed, 0.0f);
    });
}

void GimbalController::moveRight(float speed)
{
    executeProtocolCommand([this, speed]() {
        return m_protocol->moveCommand(speed, 0.0f);
    });
}

void GimbalController::stopMovement()
{
    executeProtocolCommand([this]() {
        return m_protocol->stopMovementCommand();
    });
}

void GimbalController::setYaw(float angle)
{
    executeProtocolCommand([this, angle]() {
        return m_protocol->setYawCommand(angle);
    });
}

void GimbalController::setPitch(float angle)
{
    executeProtocolCommand([this, angle]() {
        return m_protocol->setPitchCommand(angle);
    });
}

void GimbalController::setYawPitch(float yaw, float pitch)
{
    executeProtocolCommand([this, yaw, pitch]() {
        return m_protocol->setYawPitchCommand(yaw, pitch);
    });
}

void GimbalController::enableRanging()
{
    executeProtocolCommand([this]() {
        return m_protocol->enableRangingCommand();
    });
}

void GimbalController::disableRanging()
{
    executeProtocolCommand([this]() {
        return m_protocol->disableRangingCommand();
    });
}

void GimbalController::autoLockTarget()
{
    executeProtocolCommand([this]() {
        return m_protocol->autoLockTargetCommand();
    });
}

void GimbalController::lockTarget(int x, int y)
{
    executeProtocolCommand([this, x, y]() {
        return m_protocol->lockTargetCommand(x, y);
    });
}

void GimbalController::unlockTarget()
{
    executeProtocolCommand([this]() {
        return m_protocol->unlockTargetCommand();
    });
}

void GimbalController::takePhoto()
{
    executeProtocolCommand([this]() {
        return m_protocol->takePhotoCommand();
    });
}

void GimbalController::startRecording()
{
    executeProtocolCommand([this]() {
        return m_protocol->startRecordingCommand();
    });
}

void GimbalController::stopRecording()
{
    executeProtocolCommand([this]() {
        return m_protocol->stopRecordingCommand();
    });
}

void GimbalController::zoomIn(float step)
{
    executeProtocolCommand([this, step]() {
        return m_protocol->zoomInCommand(step);
    });
}

void GimbalController::zoomOut(float step)
{
    executeProtocolCommand([this, step]() {
        return m_protocol->zoomOutCommand(step);
    });
}

void GimbalController::stopZoom()
{
    executeProtocolCommand([this]() {
        return m_protocol->stopZoomCommand();
    });
}

void GimbalController::setZoomLevel(float level)
{
    executeProtocolCommand([this, level]() {
        return m_protocol->setZoomLevelCommand(level);
    });
}

void GimbalController::centerPosition()
{
    executeProtocolCommand([this]() {
        return m_protocol->centerPositionCommand();
    });
}

void GimbalController::lookDown()
{
    executeProtocolCommand([this]() {
        return m_protocol->lookDownCommand();
    });
}

GimbalController::GimbalType GimbalController::currentGimbalType() const
{
    return m_currentType;
}

void GimbalController::onSendCommand(const QByteArray &data)
{
    if (!m_linkClient || !m_connected) {
        qWarning() << "Cannot send command: not connected";
        return;
    }
    m_linkClient->sendData(data);
}

void GimbalController::createProtocol(GimbalType type)
{
    if (m_protocol) {
        disconnect(m_protocol.data(), nullptr, this, nullptr);
        m_protocol.reset();
    }
    
    // 根据类型创建对应的协议实例
    switch (type) {
    case DYT_PROTOCOL:
        m_protocol = QSharedPointer<IGimbalProtocol>(new DYTProtocol());
        qDebug() << "Created DYT protocol";
        break;
    case YUNZHUO_C12:
    case YUNZHUO_C20:
    case XIANFEI_D80PRO:
    case XIANFEI_Z1MINI:
    case XIANGTUO:
    case TUOPU:
    case PINGLING_A40TR:
    case CUSTOM_PROTOCOL:
    case SIYI_ZR10:
    case SIYI_ZT30:
    default:
        m_protocol = QSharedPointer<IGimbalProtocol>(new GenericProtocol());
        break;
    }
}


void GimbalController::onDataReceived(const QByteArray &data)
{
    if (m_protocol) {
        m_protocol->parseReceivedData(data);
    }
    
}

void GimbalController::onLinkFailed(GimbalLinkClient *client)
{
    Q_UNUSED(client)
    qDebug() << "onLinkFailed";
    disconnectFromGimbal();
}

void GimbalController::initClient(const QString &schema)
{
    if (m_linkClient) {
        m_linkClient->deleteLater();
    }
    
    m_linkClient = ClientFactory::createClient(schema);
    connect(m_linkClient, &GimbalLinkClient::dataReceived,
            this, &GimbalController::onDataReceived);
    connect(m_linkClient, &GimbalLinkClient::linkFailed,
            this, &GimbalController::onLinkFailed);
}

void GimbalController::onProtocolDataParsed(const QVariantMap &data)
{

}

// 在文件末尾添加
template<typename Func>
bool GimbalController::executeProtocolCommand(Func commandBuilder)
{
    if (!m_protocol) {
        qWarning() << "Protocol not initialized";
        return false;
    }
    
    if (!m_connected) {
        qWarning() << "Gimbal not connected";
        return false;
    }
    
    try {
        QByteArray command = commandBuilder();
        sendCommand(command);
        return true;
    } catch (const std::exception& e) {
        qWarning() << "Failed to execute protocol command:" << e.what();
        return false;
    }
}

void GimbalController::_onGimbalTypeChanged(int gimbalType) {
    GimbalController::GimbalType type = static_cast<GimbalController::GimbalType>(gimbalType);
    disconnectFromGimbal();
    connectToGimbal(type);
}
