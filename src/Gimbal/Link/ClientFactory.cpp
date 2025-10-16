#include "ClientFactory.h"
#include "GimbalTcpClient.h"
#include "GimbalUdpClient.h"
#include "GimbalUartClient.h"
#include <QDebug>

GimbalLinkClient* ClientFactory::createClient(const QString& schema, QObject* parent)
{
    if (schema.isEmpty()) {
        qWarning() << "Empty schema provided";
        return nullptr;
    }

    // TCP连接: tcp://ip:port
    if (schema.startsWith("tcp://")) {
        QString addr = schema.mid(6);
        QString ip;
        int port;
        if (!parseIpAddress(addr, ip, port)) {
            qWarning() << "Invalid TCP schema:" << schema;
            return nullptr;
        }
        return GimbalTcpClient::create(ip, port, parent);
    }
    
    // UDP连接: udp://ip:port
    if (schema.startsWith("udp://")) {
        QString addr = schema.mid(6);
        QString ip;
        int port;
        if (!parseIpAddress(addr, ip, port)) {
            qWarning() << "Invalid UDP schema:" << schema;
            return nullptr;
        }
        return GimbalUdpClient::create(ip, port, parent);
    }
    
    // 串口连接: serial://port:baudrate:config
    if (schema.startsWith("serial://")) {
        QString config = schema.mid(9);
        QString port, parity;
        int baudrate;
        if (!parseSerialConfig(config, port, baudrate, parity)) {
            qWarning() << "Invalid Serial schema:" << schema;
            return nullptr;
        }
        return GimbalUartClient::create(port, baudrate, parity, parent);
    }
    
    qWarning() << "Unsupported schema:" << schema;
    return nullptr;
}

bool ClientFactory::parseIpAddress(const QString& addr, QString& ip, int& port)
{
    int colonIndex = addr.indexOf(":");
    if (colonIndex == -1) {
        return false;
    }
    
    ip = addr.left(colonIndex);
    bool ok;
    port = addr.mid(colonIndex + 1).toInt(&ok);
    
    return ok && !ip.isEmpty() && port > 0 && port <= 65535;
}

bool ClientFactory::parseSerialConfig(const QString& config, QString& port, int& baudrate, QString& parity)
{
    QStringList parts = config.split(":");
    if (parts.size() < 2) {
        return false;
    }
    
    port = parts[0];
    bool ok;
    baudrate = parts[1].toInt(&ok);
    if (!ok || baudrate <= 0) {
        return false;
    }
    
    // 默认配置为8N1
    parity = (parts.size() >= 3) ? parts[2] : "8N1";
    
    return !port.isEmpty();
}
