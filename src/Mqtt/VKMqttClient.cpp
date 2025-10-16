#include "VKMqttClient.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QUuid>
#include <QQmlEngine>
#include <QTimer>
#include <QThread>
#include <QDateTime>
// #include <QMqttClient>
// #include <QMqttSubscription>
// #include <QMqttTopicName>
// #include <QMqttTopicFilter>
// #include <QMqttMessage>
#include <vehicle.h>
#include <vkqtsdk.h>
#include <vkqtsdktypes.h>
#include <objmanager.h>

#include "SettingsManager.h"
#include "AppSettings.h"

VKMqttClient::VKMqttClient(QObject *parent)
    : QObject(parent)
    , m_client(nullptr)
    , m_timer(nullptr)
{
    initialize();
}

VKMqttClient::~VKMqttClient()
{
    stop();
}


void VKMqttClient::registerQmlTypes()
{
    qmlRegisterType<VKMqttClient>("QGroundControl.VKMqttClient", 1, 0, "VKMqttClient");
}


void VKMqttClient::initialize()
{
    if (m_client) {
        return;
    }
    initTimer();
    initMqttClient();
}


bool VKMqttClient::start()
{
    if (m_client && m_client->state() == QMqttClient::Connected) {
        qDebug() << "VKMqttClient: Already connected";
        return true;
    }
    setClientConfig();
    m_client->connectToHost();
    return true;
}

void VKMqttClient::stop()
{
    m_timer->stop();
    if (m_client->state() == QMqttClient::Connected) {
        m_client->disconnectFromHost();
    }
}

bool VKMqttClient::connected() const
{
    return m_client && m_client->state() == QMqttClient::Connected;
}

void VKMqttClient::initMqttClient()
{
    if (m_client) return;
    m_client = new QMqttClient();
    qDebug() << "initMqttClient  threadId:" << QThread::currentThreadId();
    setupConnections();
}

void VKMqttClient::initTimer()
{
    if (!m_timer) {
        m_timer = new QTimer();
        m_timer->setInterval(1000);
        connect(m_timer, &QTimer::timeout, this, &VKMqttClient::onReportingTimer);
    }
}

void VKMqttClient::setupConnections()
{
    connect(m_client, &QMqttClient::connected, this, &VKMqttClient::onClientConnected);
    connect(m_client, &QMqttClient::disconnected, this, &VKMqttClient::onClientDisconnected);
    connect(m_client, &QMqttClient::errorChanged, this, &VKMqttClient::onClientError);
    connect(m_client, &QMqttClient::messageSent, this, &VKMqttClient::onMessagePublished);
}

void VKMqttClient::setClientConfig() {
    if(!m_client) return;

    m_client->setHostname(SettingsManager::instance()->appSettings()->mqttHost()->rawValueString());
    m_client->setPort(SettingsManager::instance()->appSettings()->mqttPort()->rawValue().toInt());
}


void VKMqttClient::subscribeToCommandTopic()
{
    if (!m_client || !connected()) {
        return;
    }

    QMqttSubscription* subscription = m_client->subscribe(QMqttTopicFilter("vk/ctl"), 1);
    if (subscription) {
        QObject::connect(subscription, &QMqttSubscription::messageReceived,
                         this, &VKMqttClient::onCommandMessageReceived);
        qDebug() << "VKMqttClient: Subscribed to vk/ctl topic";
    } else {
        qWarning() << "VKMqttClient: Failed to subscribe to vk/ctl topic";
    }
}


QByteArray VKMqttClient::serializeData(const QVariantMap& data) const
{
    QJsonObject json = QJsonObject::fromVariantMap(data);
    return QJsonDocument(json).toJson(QJsonDocument::Compact);
}

QByteArray VKMqttClient::serializeData(const QJsonObject& json) const
{
    return QJsonDocument(json).toJson(QJsonDocument::Compact);
}

QJsonObject VKMqttClient::generateReportData(const VkVehicle* vehicle) const
{
    QJsonObject root;
    QJsonObject msg;

    // root["fcu_model"] = "V10Pro";
    root["drone_id"] = vehicle->property("id").value<int>();
    qint64 currentTime = QDateTime::currentSecsSinceEpoch();
    msg["unix_time"] = QString::number(currentTime);
    if (vehicle) {
        Vk_GlobalPositionInt* position = vehicle->property("globalPositionInt").value<Vk_GlobalPositionInt *>();
        if (position) {
            msg["latitude"] = QString::number(position->lat(), 'f', 7);
            msg["longitude"] = QString::number(position->lon(), 'f', 7);
            msg["altitude"] = QString::number(position->alt(), 'f', 1);
            msg["relative_altitude"] = QString::number(position->relativeAlt(), 'f', 1);
            msg["v_speed"] = QString::number(position->verticalSpeed(), 'f', 1);
            msg["h_speed"] = QString::number(position->horizontalSpeed(), 'f', 1);
        } else {
            msg["latitude"] = "0.0000000";
            msg["longitude"] = "0.0000000";
            msg["altitude"] = "0.0";
            msg["relative_altitude"] = "0.0";
            msg["v_speed"] = "0.0";
            msg["h_speed"] = "0.0";
        }

        Vk_Attitude* attitude = vehicle->property("attitude").value<Vk_Attitude *>();
        if (attitude) {
            msg["pitch_angle"] = QString::number(attitude->attitudePitch(), 'f', 1);
            msg["roll_angle"] = QString::number(attitude->attitudeRoll(), 'f', 1);
            msg["yaw_angle"] = QString::number(attitude->attitudeYaw(), 'f', 1);
        } else {
            msg["pitch_angle"] = "0";
            msg["roll_angle"] = "0";
            msg["yaw_angle"] = "0";
        }

        VkSystemStatus* sysStatus = vehicle->property("sysStatus").value<VkSystemStatus *>();
        if (sysStatus) {
            msg["fcu_vol"] = QString::number(sysStatus->property("batteryVoltage").toFloat(), 'f', 2);
            msg["error1"] = QString::number(sysStatus->property("errorCount1").toInt());
            msg["error2"] = QString::number(sysStatus->property("errorCount2").toInt());
        } else {
            msg["fcu_vol"] = "0.00";
        }

        Vk_FmuStatus* fmuStatus = vehicle->property("fmuStatus").value<Vk_FmuStatus *>();
        if (fmuStatus) {
            msg["flyed_time"] = QString::number(fmuStatus->flightTime());
        } else {
            msg["flyed_time"] = "0";
        }


    }
    root["msg"] = msg;
    return root;
}


void VKMqttClient::onClientConnected()
{
    qDebug() << "VKMqttClient: Successfully connected to MQTT broker at"
             << m_client->hostname() << ":" << m_client->port();
    m_timer->start();
    subscribeToCommandTopic();
    emit connectionStateChanged();
}

void VKMqttClient::onClientDisconnected()
{
    qDebug() << "VKMqttClient: onClientDisconnected";
    emit connectionStateChanged();
    stop();
}

void VKMqttClient::onClientError(QMqttClient::ClientError error)
{
    QString errorString;
    switch (error) {
        case QMqttClient::NoError:
            return;
        case QMqttClient::InvalidProtocolVersion:
            errorString = "Invalid protocol version";
            break;
        case QMqttClient::IdRejected:
            errorString = "Client ID rejected";
            break;
        case QMqttClient::ServerUnavailable:
            errorString = "Server unavailable";
            break;
        case QMqttClient::BadUsernameOrPassword:
            errorString = "Bad username or password";
            break;
        case QMqttClient::NotAuthorized:
            errorString = "Not authorized";
            break;
        case QMqttClient::TransportInvalid:
            errorString = "Transport invalid";
            break;
        case QMqttClient::ProtocolViolation:
            errorString = "Protocol violation";
            break;
        case QMqttClient::UnknownError:
        default:
            errorString = "Unknown error";
            break;
    }

    emit connectionStateChanged();
    emit errorOccurred(errorString);
    qWarning() << "VKMqttClient: Client error:" << errorString;
}

void VKMqttClient::onMessagePublished()
{
    qDebug() << "onMessagePublished";
}

void VKMqttClient::onCommandMessageReceived(const QMqttMessage& message)
{
    QByteArray payload = message.payload();
    QMqttTopicName topic = message.topic();

    Q_UNUSED(topic)

    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(payload, &error);

    if (error.error != QJsonParseError::NoError) {
        qWarning() << "VKMqttClient: Failed to parse command JSON:" << error.errorString();
        return;
    }

    if (!doc.isObject()) {
        qWarning() << "VKMqttClient: Command message is not a JSON object";
        return;
    }

    processCommandMessage(doc.object());
}

void VKMqttClient::processCommandMessage(const QJsonObject& command)
{
    if (!command.contains("droneIds") || !command.contains("command")) {
        qWarning() << "VKMqttClient: Command message missing required fields";
        return;
    }

    QJsonArray droneIdsArray = command["droneIds"].toArray();
    CommandType cmdType = static_cast<CommandType>(command["command"].toInt());

    // 创建命令参数结构体
    CommandParams params;
    params.commandType = cmdType;
    params.param1 = command.value("param1").toDouble(0.0);
    params.param2 = command.value("param2").toDouble(0.0);
    params.param3 = command.value("param3").toDouble(0.0);
    params.param4 = command.value("param4").toDouble(0.0);
    params.param5 = command.value("param5").toDouble(0.0);

    // 为每个无人机执行命令
    for (const auto& droneIdValue : droneIdsArray) {
        params.droneId = droneIdValue.toInt();
        execCommand(params);
    }
}

void VKMqttClient::execCommand(const CommandParams& params) {
    VkObjManager* vehicleManager = VkSdkInstance::instance()->getManager();
    if (!vehicleManager) {
        qWarning() << "VKMqttClient: No vehicle manager available for command processing";
        return;
    }

    auto vehicle = vehicleManager->getVehicle(params.droneId);
    if (!vehicle) {
        qWarning() << "VKMqttClient: Vehicle with ID" << params.droneId << "not found";
        return;
    }

    qDebug() << "VKMqttClient: Executing command" << static_cast<int>(params.commandType)
             << "on vehicle" << params.droneId
             << "params:" << params.param1 << params.param2 << params.param3 << params.param4 << params.param5;

    switch (params.commandType) {
    case CommandType::TakeOff:
        qDebug() << "CommandType::TakeOff";
        vehicle->takeOff();
        break;
    case CommandType::Land:
        vehicle->landAtCurrentPosition();
        break;
    case CommandType::ReturnMission:
        qDebug() << "CommandType::ReturnMission";
        vehicle->returnMission(NAN, 0);
        break;
    case CommandType::FlyToPoint:
        vehicle->flyCurrentPoint(params.param1, params.param2, params.param3, params.param4, params.param5);
        break;
    case CommandType::CancelFlyToPoint:
        vehicle->cancelFlyCurrentPoint();
        break;
    case CommandType::LookAtPoint:
        vehicle->lookAtCurrentPoint(params.param1, params.param2);
        break;
    case CommandType::CancelLookAtPoint:
        vehicle->cancelLookAtCurrentPoint();
        break;
    default:
        qWarning() << "VKMqttClient: Unknown command type" << static_cast<int>(params.commandType);
        break;
    }
}

void VKMqttClient::onReportingTimer()
{
    if (!connected()) {
        qDebug() << "VKMqttClient: Not connected, skipping telemetry publish";
        return;
    }
    VkObjManager* vehicleManager = VkSdkInstance::instance()->getManager();
    if (vehicleManager) {
        auto vehicles = vehicleManager->property("vehicles").value<QList<VkVehicle *>>();
        if (!vehicles.isEmpty()) {
            for (auto vehicle : vehicles) {
                QJsonObject reportData = generateReportData(vehicle);
                QByteArray payload = serializeData(reportData);
                                qint32 messageId = m_client->publish(QMqttTopicName("vk/imu"), payload, 0, false);
                if (messageId != -1) {
                    // qDebug() << "VKMqttClient: Telemetry data published successfully, messageId:" << messageId
                    //          << "Data:" << payload;
                } else {
                    // qWarning() << "VKMqttClient: Failed to publish telemetry data";
                }
            }
        }
    }
}

