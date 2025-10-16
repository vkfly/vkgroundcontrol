#include "DytProtocol.h"
#include "Utilities/memory.h"
#include <QDateTime>
#include <QDebug>

// ============================================================================
// DYTProtocol Implementation
// ============================================================================

DYTProtocol::DYTProtocol(QObject *parent) : IGimbalProtocol(parent) { qDebug() << "DYTProtocol initialized"; }

QByteArray DYTProtocol::moveCommand(float xspeed, float yspeed) {
    qint16 yawParam = static_cast<qint16>(xspeed * 10);
    qint16 pitchParam = static_cast<qint16>(yspeed * 10);
    return createDYTPacket(0x24, yawParam, pitchParam, 0, 0);
}

QByteArray DYTProtocol::stopMovementCommand() {
    // 停止移动命令：0x24，所有参数为0
    return createDYTPacket(0x24, 0, 0, 0, 0);
}

QByteArray DYTProtocol::setYawCommand(float angle) {
    // 设置偏航角命令：0x3b
    qint16 yawParam = static_cast<qint16>(angle * 100);
    return createDYTPacket(0x3b, yawParam, 0, 0, 0);
}

QByteArray DYTProtocol::setPitchCommand(float angle) {
    // 设置俯仰角命令：0x3b
    qint16 pitchParam = static_cast<qint16>(angle * 100);
    return createDYTPacket(0x3b, 0, pitchParam, 0, 0);
}

QByteArray DYTProtocol::setYawPitchCommand(float yaw, float pitch) {
    // 设置偏航和俯仰角命令：0x3b
    // 参数：yaw * 100, pitch * 100 (转换为整数)
    qint16 yawParam = static_cast<qint16>(yaw * 100);
    qint16 pitchParam = static_cast<qint16>(pitch * 100);

    return createDYTPacket(0x3b, yawParam, pitchParam, 0, 0);
}

QByteArray DYTProtocol::zoomInCommand(float step) {
    // 变焦放大命令：0x25
    quint8 zoomParam = static_cast<quint8>(step);

    return createDYTPacket(0x25, 0, 0, 0, zoomParam);
}

QByteArray DYTProtocol::zoomOutCommand(float step) {
    // 变焦缩小命令：0x25
    qint8 zoomParam = static_cast<qint8>(-step);
    return createDYTPacket(0x25, 0, 0, 0, zoomParam);
}

QByteArray DYTProtocol::stopZoomCommand() {
    // 停止变焦命令：0x25
    return createDYTPacket(0x25, 0, 0, 0, 0);
}

QByteArray DYTProtocol::setZoomLevelCommand(float level) {
    // 设置变焦级别命令：0x25
    quint8 zoomParam = static_cast<quint8>(level);

    return createDYTPacket(0x25, 0, 0, 0, zoomParam);
}

QByteArray DYTProtocol::takePhotoCommand() {
    // 拍照命令：0x5b
    return createDYTPacket(0x5b, 0, 0, 0, 0);
}

QByteArray DYTProtocol::startRecordingCommand() {
    // 开始录像命令：0x09
    return createDYTPacket(0x09, 0, 0, 0, 0);
}

QByteArray DYTProtocol::stopRecordingCommand() {
    // 停止录像命令：0x0a
    return createDYTPacket(0x0a, 0, 0, 0, 0);
}

QByteArray DYTProtocol::autoLockTargetCommand() { return createDYTPacket(0x0f, 0, 0, 0, 0); }

QByteArray DYTProtocol::lockTargetCommand(int x, int y) {
    // 锁定目标命令：0x0d
    qint16 xParam = static_cast<qint16>(x);
    qint16 yParam = static_cast<qint16>(y);

    return createDYTPacket(0x0d, xParam, yParam, 1, 0);
}

QByteArray DYTProtocol::unlockTargetCommand() {
    // 解锁命令：0x0e
    return createDYTPacket(0x0e, 0, 0, 0, 0);
}

QByteArray DYTProtocol::centerPositionCommand() {
    // 居中命令：0x2b
    return createDYTPacket(0x2b, 0, 0, 0, 0);
}

QByteArray DYTProtocol::enableRangingCommand() {
    // 启用测距命令：0x2d
    return createDYTPacket(0x2d, 0, 0, 0, 0);
}

QByteArray DYTProtocol::disableRangingCommand() {
    // 禁用测距命令：0x2e
    return createDYTPacket(0x2e, 0, 0, 0, 0);
}

// DYT协议二进制编码方法
QByteArray DYTProtocol::createDYTPacket(quint8 command, qint16 paramx, qint16 paramy, quint8 param3, qint8 param4) {
    QByteArray packet(16, 0x00);
    MemoryHelper::Writer writer(packet.data(), packet.size());
    writer.writeI8(static_cast<int8_t>(0xEB));
    writer.writeI8(static_cast<int8_t>(0x90));
    writer.writeI8(static_cast<int8_t>(command));
    writer.writeI16LE(paramx);
    writer.writeI16LE(paramy);
    writer.writeI8(static_cast<int8_t>(param3));
    writer.writeI8(static_cast<int8_t>(param4));
    uint8_t back[6] = {0};
    writer.writeBytes(back, 6);
    // 计算并写入校验和
    quint8 checksum = calculateChecksum(packet, 0);
    writer.writeI8(static_cast<int8_t>(checksum));

    qDebug() << "DYT packet built:" << packet.toHex();
    return createNetworkPacket(packet);
}

quint8 DYTProtocol::calculateChecksum(const QByteArray &data, int startIndex) {
    // 计算校验和：从指定索引开始累加到倒数第二个字节（不包括校验和字节本身）
    quint8 checksum = 0;
    int endIndex = data.size() - 1; // 不包括最后的校验和字节

    for (int i = startIndex; i < endIndex; ++i) {
        checksum += static_cast<quint8>(data[i]);
    }

    return checksum;
}

// 网络传输协议封装实现
QByteArray DYTProtocol::createNetworkPacket(const QByteArray &dytData) {
    if (dytData.isEmpty()) {
        qWarning() << "DYT data is empty, cannot create network packet";
        return QByteArray();
    }

    int totalLength = 2 + 1 + dytData.size() + 1;
    QByteArray networkPacket(totalLength, 0x00);
    MemoryHelper::Writer writer(networkPacket.data(), networkPacket.size());
    writer.writeI8(0xEB);
    writer.writeI8(0x90);
    writer.writeI8(static_cast<quint8>(dytData.size()));
    writer.writeBytes(const_cast<void *>(static_cast<const void *>(dytData.constData())), dytData.size());
    quint8 checksum = calculateChecksum(networkPacket, 3);
    writer.writeI8(checksum);
    qDebug() << "DYT packet built:" << networkPacket.toHex();
    return networkPacket;
}

void DYTProtocol::parseReceivedData(const QByteArray &data) {
    if ((uint8_t)data[0] != 0xEE) {
        qDebug() << "invalid header: " << data[0];
        return;
    }
    if ((uint8_t)data[1] != 0x16) {
        qDebug() << "invalid header: " << data[1];
        return;
    }
    MemoryHelper::Reader reader(const_cast<void *>(static_cast<const void *>(data.data())), data.size());
    reader.readS8();
    reader.readS8();
    reader.readS8();
    reader.readS8();
    reader.readS8();
    reader.readS8();
    reader.readS16LE();
    reader.readS16LE();
    reader.readS16LE();
    reader.readS16LE();
}

QByteArray DYTProtocol::lookDownCommand() {
    qint16 yawParam = 0;
    qint16 pitchParam = -9000;
    return createDYTPacket(0x26, yawParam, pitchParam, 0, 0);
}
