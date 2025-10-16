#pragma once

#include <QObject>
#include <QJsonObject>
#include <QVariantMap>
#include <QTimer>
#include <QThread>
#include <qtmqtt/qmqttclient.h>
#include <qtmqtt/qmqttmessage.h>
#include <memory>

class VkObjManager;
class VkVehicle;


class VKMqttClient : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(bool isConnected READ connected NOTIFY connectionStateChanged)

public:

    enum class CommandType : int {
        TakeOff = 0,
        Land,
        ReturnMission,
        FlyToPoint,
        LookAtPoint,
        CancelFlyToPoint,
        CancelLookAtPoint
    };
    Q_ENUM(CommandType)
    
    struct CommandParams {
        int droneId = 0;
        CommandType commandType = CommandType::TakeOff;
        double param1 = 0.0;
        double param2 = 0.0;
        double param3 = 0.0;
        double param4 = 0.0;
        double param5 = 0.0;

        CommandParams() = default;
        CommandParams(int id, CommandType cmd) 
            : droneId(id), commandType(cmd) {}
    };

    explicit VKMqttClient(QObject *parent = nullptr);
    ~VKMqttClient();
    static void registerQmlTypes();
    void initialize();
    Q_INVOKABLE bool start();
    Q_INVOKABLE void stop();
    bool connected() const;

signals:
    void connectionStateChanged();
    void errorOccurred(const QString& error);
    void dataSent(const QString& topic, qint64 messageId);
    void sendFailed(const QString& topic, const QString& error);
    void brokerHostChanged(const QString& host);
    void brokerPortChanged(quint16 port);
    void usernameChanged(const QString& user);
    void passwordChanged(const QString& pass);

private slots:

    void onClientConnected();
    void onClientDisconnected();
    void onClientError(QMqttClient::ClientError error);
    void onMessagePublished();
    void onCommandMessageReceived(const QMqttMessage& message);
    void onReportingTimer();

private:

    void initMqttClient();
    void initTimer();
    
    void setupConnections();
    void setClientConfig();
    
    void subscribeToCommandTopic();
    void processCommandMessage(const QJsonObject& command);
    void execCommand(const CommandParams& params);
    QByteArray serializeData(const QVariantMap& data) const;
    QByteArray serializeData(const QJsonObject& json) const;
    QJsonObject generateReportData(const VkVehicle* vehicle) const;

private:
    QMqttClient* m_client;
    QTimer* m_timer;
};

