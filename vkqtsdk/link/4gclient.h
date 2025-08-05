#pragma once

#include "../linkclient.h"
#include <QTcpSocket>
#include <qobject.h>

class FourGClient : public LinkClient {
    Q_OBJECT

private:
    FourGClient(QObject *parent = nullptr);

public:
    ~FourGClient();

public:
    void sendData(const QByteArray &data) override;
    void timerEvent(QTimerEvent *event) override;

private slots:
    void onConnected();
    void onReadyRead();
    void onDisconnected();
    void onError(QAbstractSocket::SocketError error);

private:
    QTcpSocket *tcp;
    QString license;
    int timerId = -1;
    int state = 0;

public:
    static FourGClient *create(QString serverAddress, int port, QString license, QObject *parent = nullptr);
};
