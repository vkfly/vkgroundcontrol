/*
 * TCP client with Qt
 */

#include "GimbalUartClient.h"
#include <QIODevice>
#include <QDebug>

GimbalUartClient::GimbalUartClient(QObject *parent) : GimbalLinkClient(parent) {
    uart = new QSerialPort(this);
    connect(uart, &QSerialPort::readyRead, this, &GimbalUartClient::onReadyRead);
}

GimbalUartClient::~GimbalUartClient() {
    if (uart->isOpen()) {
        uart->close();
    }
}

void GimbalUartClient::sendData(const QByteArray &data) {
    if (uart->isOpen()) {
        uart->write(data);
    }
}

void GimbalUartClient::onReadyRead() {
    QByteArray data = uart->readAll();
    emit dataReceived(data);
}

GimbalUartClient *GimbalUartClient::create(QString port, int baudrate, QString config, QObject *parent) {
    GimbalUartClient *client = new GimbalUartClient(parent);
    client->uart->setPortName(port);
    client->uart->setBaudRate(baudrate);

    QSerialPort::DataBits databits = QSerialPort::Data8;
    switch (config.mid(0, 1).toInt()) {
    case 5:
        databits = QSerialPort::Data5;
        break;
    case 6:
        databits = QSerialPort::Data6;
        break;
    case 7:
        databits = QSerialPort::Data7;
        break;
    default:
        databits = QSerialPort::Data8;
        break;
    }
    client->uart->setDataBits(databits);

    QString parity = config.mid(1, 1);
    if (parity == "e" || parity == "E") {
        client->uart->setParity(QSerialPort::EvenParity);
    } else if (parity == "o" || parity == "O") {
        client->uart->setParity(QSerialPort::OddParity);
    } else {
        client->uart->setParity(QSerialPort::NoParity);
    }

    QSerialPort::StopBits stopbits = QSerialPort::OneStop;
    switch (config.mid(2, 1).toInt()) {
    case 1:
        stopbits = QSerialPort::OneStop;
        break;
    case 2:
        stopbits = QSerialPort::TwoStop;
        break;
    }
    client->uart->setStopBits(stopbits);
    if (client->uart->open(QIODevice::ReadWrite)) {
        qDebug() << "uart opened";
        return client;
    }
    qDebug() << "uart open failed";
    return nullptr;
}
