#include "uavsender.h"
#include <QDateTime>

UavSender::UavSender(): UavClient("iotx.jiagutech.com", 9527) {}

void UavSender::onReceived(const InstructionProto& msg) {
    switch (msg.inst) {
        case 1: //解锁
            break;
        case 2: //起飞
            break;
        case 3: //去作业
            break;
        case 4: //返航
            break;
        case 5: //降落
            break;
        case 6: //悬停
            break;
        case 7: //继续作业
            break;
        case 8: //开始推流
            break;
        case 9: //结束推流
            break;
        default:
            break;
    }
}

void UavSender::onReceived(const RouteProto& msg) {
    // 处理 RouteProto 消息
}

void UavSender::onReceived(const WaypointGroupProto& msg) {
    // 处理 WaypointGroupProto 消息
}

void UavSender::onReceived(const GimbalProto& msg) {
    // 处理 GimbalProto 消息
}

void UavSender::sendImu(const VehicleTelemetryData& info) {
    if(!isRunning()) {
        return;
    }
    bool onAir = false;
    TrackProto msg = TrackProto_init_zero;
    
    // 设置字符串字段的回调
    QString droneIdStr = QString::number(info.sn);
    msg.droneId.funcs.encode = &string_encode_callback;
    msg.droneId.arg = &droneIdStr;
    msg.timestamp = QDateTime::currentMSecsSinceEpoch();
    msg.lat = info.lat;
    msg.lng = info.lon;
    msg.alt = info.alt * 100;
    msg.height = info.height * 100;
    msg.roll = info.roll * 10;
    msg.pitch = info.pitch * 10;
    msg.yaw = info.yaw * 10;
    msg.vvel = info.vspeed * 100;
    msg.hvel = info.hspeed * 100;
    qDebug() << "sendImu" << msg.lat << msg.lng << msg.alt <<msg.height << msg.roll << msg.pitch << msg.yaw << msg.vvel << QString::number(msg.hvel,'f',1);
    if(info.onAir) {
        sendTrackProto(msg);
    } else {
        sendRtTrackProto(msg);
    }
}

void UavSender::confirmPackage(long seq) {
    //        XgsDB.removeSample(seq)
}

void UavSender::savePackage(long seq, const QByteArray& data) {
    //        XgsDB.addSample(seq, data)
}

QByteArray UavSender::getResendPackage() {
    // val s = XgsDB.getSample(minId)
    //         if (s == null) {
    //             minId = 0
    //             return null
    //         }
    //         minId = s._id
    //       return s.data
    return QByteArray();
}

long UavSender::getInitialSeq() {
    // return XgsDB.maxSampleId() + 1
    return 1;
}
