#pragma once

#include "GimbalLinkClient.h"
#include <QtSerialPort/qserialport.h>

class GimbalUartClient : public GimbalLinkClient {
    Q_OBJECT

private:
    GimbalUartClient(QObject *parent = nullptr);

public:
    ~GimbalUartClient();

public:
    void sendData(const QByteArray &data) override;

private slots:
    void onReadyRead();

private:
    QSerialPort *uart;

public:
    static GimbalUartClient *create(QString port, int baudrate, QString parity, QObject *parent = nullptr);
};
