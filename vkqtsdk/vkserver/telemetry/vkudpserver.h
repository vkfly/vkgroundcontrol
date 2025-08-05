#ifndef VKUDPSERVER_H
#define VKUDPSERVER_H

#include <QObject>
#include <QUdpSocket>
#include <QHostAddress>
#include <QQueue>
#include <QDebug>
#include <QThread>
#include "threadsafequeue.h"

class VKUdpServer : public QThread {
    Q_OBJECT

public:
    explicit VKUdpServer(const QString &host, quint16 port, QObject *parent = nullptr);
    ~VKUdpServer();

    void send(const QByteArray &data);
    void send(const QByteArray &data, int off, int len);
    void stop() {
        this->quit();
        this->wait();
    }

protected:
    virtual void processReceived(const QByteArray &data) = 0;
    virtual void idle() {}
    virtual void prepare() {}
    void run() override;

private slots:
    void processPendingDatagrams();
    void processSendQueue();

private:
    void prepareSocket();
    QHostAddress getHostAddressFromDomainName(const QString& domainName);
    ThreadSafeQueue<QByteArray> sendQueue;
    QUdpSocket *udpSocket;
    QHostAddress host;
    quint16 port;
};

#endif // VKUDPSERVER_H
