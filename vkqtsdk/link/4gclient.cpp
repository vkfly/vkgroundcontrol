/*
 * TCP client with Qt
 */

#include "4gclient.h"
#include <QTimerEvent>

FourGClient::FourGClient(QObject *parent) : LinkClient(parent) {
    tcp = new QTcpSocket(this);
    connect(tcp, &QTcpSocket::connected, this, &FourGClient::onConnected);
    connect(tcp, &QTcpSocket::readyRead, this, &FourGClient::onReadyRead);
    connect(tcp, &QTcpSocket::errorOccurred, this, &FourGClient::onError);
    connect(tcp, &QTcpSocket::disconnected, this, &FourGClient::onDisconnected);
}

FourGClient::~FourGClient() {
    // Kill timer if it's still active
    if (timerId >= 0) {
        killTimer(timerId);
        timerId = -1;
    }

    tcp->close();
}

void FourGClient::sendData(const QByteArray &data) {
    if (state > 0) { // 当未认证成功的时候不发送数据，以免破坏认证流程
        tcp->write(data);
    }
}

void FourGClient::onConnected() {
    // Kill any existing timer before starting a new one
    if (timerId >= 0) {
        killTimer(timerId);
    }
    timerId = startTimer(2000);
    tcp->write(license.toUtf8());
}

void FourGClient::timerEvent(QTimerEvent *event) {
    if (event->timerId() == timerId) {
        tcp->write(license.toUtf8());
    }
}

void FourGClient::onReadyRead() {
    // 收到数据意味着认证成功了
    if (timerId >= 0) {
        killTimer(timerId);
        timerId = -1;
    }
    state = 1;
    QByteArray data = tcp->readAll();
    emit dataReceived(data);
}

void FourGClient::onError(QAbstractSocket::SocketError error) {
    qDebug() << "TCP Error:" << error;
    // Kill timer if it's still active
    if (timerId >= 0) {
        killTimer(timerId);
        timerId = -1;
    }
}

void FourGClient::onDisconnected() {
    qDebug() << "Disconnected from server";
    // Kill timer if it's still active
    if (timerId >= 0) {
        killTimer(timerId);
        timerId = -1;
    }
    emit linkFailed(this);
}

FourGClient *FourGClient::create(QString serverAddress, int port, QString license, QObject *parent) {
    FourGClient *client = new FourGClient(parent);
    client->license = "{" + license + "}";
    client->tcp->connectToHost(serverAddress, port);
    return client;
}
