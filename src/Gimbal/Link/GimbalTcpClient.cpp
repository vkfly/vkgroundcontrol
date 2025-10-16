/*
 * TCP client with Qt
 */

#include "GimbalTcpClient.h"
#include <QThread>

GimbalTcpClient::GimbalTcpClient(QObject *parent) : GimbalLinkClient(parent) {
    tcp = new QTcpSocket();
    connect(tcp, &QTcpSocket::connected, this, &GimbalTcpClient::onConnected);
    connect(tcp, &QTcpSocket::readyRead, this, &GimbalTcpClient::onReadyRead);
    connect(tcp, &QTcpSocket::errorOccurred, this, &GimbalTcpClient::onError);
    connect(tcp, &QTcpSocket::disconnected, this, &GimbalTcpClient::onDisconnected);
}

GimbalTcpClient::GimbalTcpClient(QTcpSocket *socket, QObject *parent) : GimbalLinkClient(parent) {
    tcp = socket;
    connect(tcp, &QTcpSocket::readyRead, this, &GimbalTcpClient::onReadyRead);
    connect(tcp, &QTcpSocket::errorOccurred, this, &GimbalTcpClient::onError);
    connect(tcp, &QTcpSocket::disconnected, this, &GimbalTcpClient::onDisconnected);
}

GimbalTcpClient::~GimbalTcpClient() {
    tcp->close();
}

void GimbalTcpClient::sendData(const QByteArray &data) {
    if (tcp->state() == QAbstractSocket::ConnectedState) {
        tcp->write(data);
    } else {
        qWarning() << "TCP socket not connected, cannot send data";
    }
}

void GimbalTcpClient::onConnected() {
    qDebug() << "Connected to server";
}

void GimbalTcpClient::onReadyRead() {
    QByteArray data = tcp->readAll();
    emit dataReceived(data);
}

void GimbalTcpClient::onError(QAbstractSocket::SocketError error) {
    qDebug() << "TCP Error:" << error;
    emit linkFailed(this);
}

void GimbalTcpClient::onDisconnected() {
    qDebug() << "Disconnected from server";
    emit linkFailed(this);
}

GimbalTcpClient *GimbalTcpClient::create(QString serverAddress, int port, QObject *parent) {
    GimbalTcpClient *client = new GimbalTcpClient(parent);
    client->tcp->connectToHost(serverAddress, port);
    return client;
}

GimbalTcpClient *GimbalTcpClient::create(QTcpSocket *socket, QObject *parent) {
    GimbalTcpClient *client = new GimbalTcpClient(socket, parent);
    return client;
}

