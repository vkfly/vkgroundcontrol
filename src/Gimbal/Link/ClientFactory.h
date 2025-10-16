#pragma once

#include "GimbalLinkClient.h"
#include <QString>
#include <QObject>

/**
 * @brief 客户端工厂类
 * @details 负责根据连接协议字符串创建相应的LinkClient实例
 *          支持TCP、UDP、串口和4G连接
 */
class ClientFactory
{
public:
    /**
     * @brief 根据协议字符串创建客户端
     * @param schema 协议字符串，支持以下格式：
     *               - tcp://ip:port
     *               - udp://ip:port  
     *               - serial://port:baudrate:config
     * @param parent 父对象
     * @return 创建的LinkClient指针，失败返回nullptr
     */
    static GimbalLinkClient* createClient(const QString& schema, QObject* parent = nullptr);

private:
    // 辅助解析函数
    static bool parseIpAddress(const QString& addr, QString& ip, int& port);
    static bool parseSerialConfig(const QString& config, QString& port, int& baudrate, QString& parity);
};
