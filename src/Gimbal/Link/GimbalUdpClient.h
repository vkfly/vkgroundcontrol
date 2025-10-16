#pragma once

#include "GimbalLinkClient.h"
#include <QHostAddress>
#include <QUdpSocket>

class GimbalUdpClient : public GimbalLinkClient {
    Q_OBJECT

private:
    explicit GimbalUdpClient(QObject *parent = nullptr);
    explicit GimbalUdpClient(QUdpSocket *udp, QObject *parent = nullptr);

public:
    ~GimbalUdpClient();

public:
    void sendData(const QByteArray &data) override;

private slots:
    void readPendingDatagrams();

private:
    QUdpSocket *udp;
    QHostAddress peerAddr;
    int port;
    bool isFake; // borrow udp server socket

public:
    static GimbalUdpClient *create(QString addr, int port, QObject *parent = nullptr);
    static GimbalUdpClient *create(QUdpSocket *udp, QHostAddress addr, int port, QObject *parent = nullptr);
};
