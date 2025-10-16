#pragma once

#include <QObject>

class GimbalLinkClient : public QObject{
    Q_OBJECT

public:
    explicit GimbalLinkClient(QObject *parent = nullptr) {};
    virtual ~GimbalLinkClient() {};

signals:
    void dataReceived(const QByteArray &data);
    void linkFailed(GimbalLinkClient *client);

public:
    virtual void sendData(const QByteArray &data) = 0;
};
