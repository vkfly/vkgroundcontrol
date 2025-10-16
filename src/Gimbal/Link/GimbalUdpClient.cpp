/*
 * UDP client with Qt
 */

#include "GimbalUdpClient.h"

GimbalUdpClient::GimbalUdpClient(QObject *parent) : GimbalLinkClient(parent) {
    udp = new QUdpSocket(this);
    isFake = false;
    connect(udp, &QUdpSocket::readyRead, this, &GimbalUdpClient::readPendingDatagrams);
}

// for udp server, no need to read data
GimbalUdpClient::GimbalUdpClient(QUdpSocket *udp, QObject *parent) : GimbalLinkClient(parent) {
    this->udp = udp;
    isFake = true;
}

GimbalUdpClient::~GimbalUdpClient() {
    if (!isFake) {
        udp->close();
    }
}

void GimbalUdpClient::sendData(const QByteArray &data) {
    udp->writeDatagram(data, peerAddr, port);
}

void GimbalUdpClient::readPendingDatagrams() {
    while (udp->hasPendingDatagrams()) {
        QByteArray data;
        data.resize(udp->pendingDatagramSize());
        udp->readDatagram(data.data(), data.size());
        emit dataReceived(data);
    }
}

GimbalUdpClient *GimbalUdpClient::create(QString addr, int port, QObject *parent) {
    GimbalUdpClient *client = new GimbalUdpClient(parent);
    client->peerAddr = QHostAddress(addr);
    client->port = port;
    return client;
}

GimbalUdpClient *GimbalUdpClient::create(QUdpSocket *udp, QHostAddress addr, int port, QObject *parent) {
    GimbalUdpClient *client = new GimbalUdpClient(udp, parent);
    client->peerAddr = addr;
    client->port = port;
    return client;
}
