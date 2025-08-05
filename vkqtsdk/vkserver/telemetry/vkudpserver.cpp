#include "vkudpserver.h"
#include <QThread>
#include <QHostInfo>

VKUdpServer::VKUdpServer(const QString &h, quint16 p, QObject *parent)
    : QThread(parent) {
    host = getHostAddressFromDomainName(h);
    port = p;
    prepareSocket();
}

VKUdpServer::~VKUdpServer() {
    stop();
    udpSocket->close();
    delete udpSocket;
}

void VKUdpServer::prepareSocket() {
    prepare();
    udpSocket = new QUdpSocket(this);
    udpSocket->bind(QHostAddress::Any);
    udpSocket->setReadBufferSize(2048);
}

void VKUdpServer::send(const QByteArray &data) {
    sendQueue.enqueue(data);
    if (this->isRunning()) {
        QMetaObject::invokeMethod(this, "processSendQueue", Qt::QueuedConnection);
    }
}

void VKUdpServer::send(const QByteArray &data, int off, int len) {
    QByteArray buf = data.mid(off, len);
    sendQueue.enqueue(buf);

    if (this->isRunning()) {
        QMetaObject::invokeMethod(this, "processSendQueue", Qt::QueuedConnection);
    }
}

void VKUdpServer::run() {
    connect(udpSocket, &QUdpSocket::readyRead, this, &VKUdpServer::processPendingDatagrams, Qt::UniqueConnection);
    processSendQueue();
    exec();
}


void VKUdpServer::processPendingDatagrams() {
    while (udpSocket->hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(udpSocket->pendingDatagramSize());
        udpSocket->readDatagram(datagram.data(), datagram.size());
        processReceived(datagram);
    }
}

void VKUdpServer::processSendQueue() {
    while (!sendQueue.isEmpty()) {
        QByteArray data = sendQueue.dequeue();
        qDebug() << "host" << host << "port" << QString::number(port);
        if(!host.isNull()) {
            udpSocket->writeDatagram(data, host, port);
        }
    }
    // Call idle after processing
    idle();
}

QHostAddress VKUdpServer::getHostAddressFromDomainName(const QString& domainName) {
    QHostInfo hostInfo = QHostInfo::fromName(domainName);
    if (hostInfo.error() == QHostInfo::NoError) {
        QList<QHostAddress> addresses = hostInfo.addresses();
        if (!addresses.isEmpty()) {
            QHostAddress targetAddress = addresses.first();
            return targetAddress;
        }
        return QHostAddress();
    }
    return QHostAddress();
}
