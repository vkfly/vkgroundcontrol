#pragma once

#include "GimbalLinkClient.h"
#include <QTcpSocket>

class GimbalTcpClient : public GimbalLinkClient {
    Q_OBJECT

private:
    GimbalTcpClient(QObject *parent = nullptr);
    GimbalTcpClient(QTcpSocket *socket, QObject *parent = nullptr);

public:
    ~GimbalTcpClient();

public:
    void sendData(const QByteArray &data) override;

private slots:
    void onConnected();
    void onReadyRead();
    void onDisconnected();
    void onError(QAbstractSocket::SocketError error);

private:
    QTcpSocket *tcp;

public:
    static GimbalTcpClient *create(QString serverAddress, int port, QObject *parent = nullptr);
    static GimbalTcpClient *create(QTcpSocket *socket, QObject *parent = nullptr);
};
