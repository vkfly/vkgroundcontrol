#include "uavclient.h"
#include <QDataStream>
#include <QDateTime>
#include <QByteArray>
#include "../utils/memory.h"
#include "../proto/ack.pb.h"
#include "../proto/uav.pb.h"
#include "../proto/uav-ctl.pb.h"
#include "../nanopb/pb_decode.h"
#include "../nanopb/pb_encode.h"


UavClient::UavClient(const QString &url, quint16 port, QObject *parent)
    : VKUdpServer(url, port, parent) {}

void UavClient::processReceived(const QByteArray &data) {
    int off = 0;
    MemoryHelper::Reader r((uint8_t*)data.data(), data.length());
    while (data.size() - off >= 16) {
        quint16 packLen = r.readU16LE();
        if (data.size() - off < packLen + 2) {
            return;
        }
        if (verifyPackage(data, off, packLen + 2)) {
            int64_t rseq = r.readS64LE();
            int32_t cmd = r.readU16LE();
            qDebug() << "packlen" << QString::number(packLen) << "rseq" << QString::number(rseq) << "cmd" << QString::number(cmd);
            parseObject(rseq, cmd, (const uint8_t*)data.constData() + off + 12, packLen - 14);
        } else {
            qWarning() << "CRC error";
        }
        off += packLen + 2;
    }
}

// nanopb 回调函数用于处理字符串字段
bool string_decode_callback(pb_istream_t *stream, const pb_field_t *field, void **arg) {
    QString *str = static_cast<QString*>(*arg);
    if (str == nullptr) {
        str = new QString();
        *arg = str;
    }
    
    uint8_t buffer[256];
    if (stream->bytes_left > sizeof(buffer) - 1) {
        return false;
    }
    
    if (!pb_read(stream, buffer, stream->bytes_left)) {
        return false;
    }
    
    buffer[stream->bytes_left] = '\0';
    *str = QString::fromUtf8(reinterpret_cast<const char*>(buffer));
    return true;
}

// nanopb 回调函数用于处理重复字段
bool seq_decode_callback(pb_istream_t *stream, const pb_field_t *field, void **arg) {
    QList<uint64_t> *seq_list = static_cast<QList<uint64_t>*>(*arg);
    if (seq_list == nullptr) {
        seq_list = new QList<uint64_t>();
        *arg = seq_list;
    }
    
    uint64_t value;
    if (!pb_decode_varint(stream, &value)) {
        return false;
    }
    
    seq_list->append(value);
    return true;
}

// nanopb 回调函数用于处理 WaypointProto 重复字段
bool wps_decode_callback(pb_istream_t *stream, const pb_field_t *field, void **arg) {
    QList<WaypointProto> *wps_list = static_cast<QList<WaypointProto>*>(*arg);
    if (wps_list == nullptr) {
        wps_list = new QList<WaypointProto>();
        *arg = wps_list;
    }
    
    WaypointProto wp = WaypointProto_init_zero;
    if (!pb_decode(stream, WaypointProto_fields, &wp)) {
        return false;
    }
    
    wps_list->append(wp);
    return true;
}

void UavClient::parseObject(quint64 rseq, int cmd, const uint8_t* data, int len) {
    pb_istream_t stream = pb_istream_from_buffer(data, len);
    
    switch (cmd) {
        case DT_ACK: {
             qDebug() << "dt_ack";
             AckProto ack = AckProto_init_zero;
             QList<uint64_t> seq_list;
             
             // 设置回调函数
             ack.seq.funcs.decode = &seq_decode_callback;
             ack.seq.arg = &seq_list;
             
             if (pb_decode(&stream, AckProto_fields, &ack)) {
                 qDebug() << "AckProto parsed successfully";
                 qDebug() << "AckProto seq size:" << seq_list.size();
                 for (int i = 0; i < seq_list.size(); ++i) {
                     qDebug() << "AckProto seq[" << i << "]:" << seq_list[i];
                     quint64 seq = seq_list[i];
                     queue.remove(seq);
                     confirmPackage(seq);
                 }
             } else {
                 qDebug() << "Failed to parse AckProto";
             }
             break;
         }
        case DT_INST: {
            InstructionProto inst = InstructionProto_init_zero;
            QString droneId;
            
            // 设置回调函数
            inst.droneId.funcs.decode = &string_decode_callback;
            inst.droneId.arg = &droneId;
            
            if (pb_decode(&stream, InstructionProto_fields, &inst)) {
                sendSAck(droneId, rseq);
                onReceived(inst);
            }
            break;
        }
        case DT_ROUTE: {
            RouteProto route = RouteProto_init_zero;
            QString droneId;
            
            // 设置回调函数
            route.droneId.funcs.decode = &string_decode_callback;
            route.droneId.arg = &droneId;
            
            if (pb_decode(&stream, RouteProto_fields, &route)) {
                sendSAck(droneId, rseq);
                onReceived(route);
            }
            break;
        }
        case DT_WP: {
            WaypointGroupProto wps = WaypointGroupProto_init_zero;
            QString droneId;
            
            // 设置回调函数
            wps.droneId.funcs.decode = &string_decode_callback;
            wps.droneId.arg = &droneId;
            
            if (pb_decode(&stream, WaypointGroupProto_fields, &wps)) {
                sendSAck(droneId, rseq);
                onReceived(wps);
            }
            break;
        }
        case DT_GIMBAL: {
            GimbalProto gimbal = GimbalProto_init_zero;
            QString droneId;
            
            // 设置回调函数
            gimbal.droneId.funcs.decode = &string_decode_callback;
            gimbal.droneId.arg = &droneId;
            
            if (pb_decode(&stream, GimbalProto_fields, &gimbal)) {
                sendSAck(droneId, rseq);
                onReceived(gimbal);
            }
            break;
        }
    }
}

void UavClient::idle() {
    resend();
}

void UavClient::prepare() {
    seqN = getInitialSeq();
}

void UavClient::resend() {
    int total = 0;
    long current = QDateTime::currentMSecsSinceEpoch();
    if(!queue.isEmpty()) {
        for(long key : queue.keys()) {
            QueueItem item = queue.get(key);
            if(current - item.ts < UDP_TIMEOUT) {
                continue;
            }
            if(total + item.data.length() > UDP_SIZE) {
                break;
            }
            buf = item.data;
            total += item.data.length();
        }
        if (total > 0) {
            send(buf, 0, total);
        }
        return;
    }
    while(true) {
        QByteArray data = getResendPackage();
        if(data.length() == 0 || data.length() + total > UDP_SIZE) {
            break;
        }
        long seq = MemoryHelper::LittleEndian::getS64((uint8_t*)data.data() + 2);
        addQueueItem(current, seq, data);
        buf = data;
        total += data.length();
    }
    if(total > 0) {
        send(buf, 0, total);
    }
}

void UavClient::addCrc(QByteArray &data, int len) {
    int32_t crc32_value = crc((const uint8_t*)data.data(), len);
    MemoryHelper::LittleEndian::putI32((uint8_t*)data.data() + len, crc32_value);
}

int32_t UavClient::crc(const uint8_t* data, int len) {
    uint32_t crc32_value = CRC::Calculate(data, len, CRC::CRC_32());
    return crc32_value;
}

bool UavClient::verifyPackage(const QByteArray &data, int off, int len) {
    int32_t crc1 = MemoryHelper::LittleEndian::getS32((uint8_t*)data.data() + off + len - 4);
    quint32 crc2 = crc((const uint8_t*)data.data() + off, len - 4);
    return crc1 == crc2;
}

void UavClient::addQueueItem(long ts, long seq, const QByteArray &data) {
    if (queue.size() > 100) {
        return;
    }
    QueueItem item = {ts, data};
    queue.put(seq, item);
}

// nanopb 回调函数用于编码字符串字段
bool string_encode_callback(pb_ostream_t *stream, const pb_field_t *field, void * const *arg) {
    const QString *str = static_cast<const QString*>(*arg);
    if (str == nullptr || str->isEmpty()) {
        return true;
    }
    
    QByteArray utf8_data = str->toUtf8();
    if (!pb_encode_tag_for_field(stream, field)) {
        return false;
    }
    
    return pb_encode_string(stream, reinterpret_cast<const uint8_t*>(utf8_data.data()), utf8_data.size());
}

// nanopb 回调函数用于编码重复字段
bool seq_encode_callback(pb_ostream_t *stream, const pb_field_t *field, void * const *arg) {
    const QList<uint64_t> *seq_list = static_cast<const QList<uint64_t>*>(*arg);
    if (seq_list == nullptr) {
        return true;
    }
    
    for (const auto& value : *seq_list) {
        if (!pb_encode_tag_for_field(stream, field)) {
            return false;
        }
        if (!pb_encode_varint(stream, value)) {
            return false;
        }
    }
    return true;
}

// nanopb 回调函数用于编码 WaypointProto 重复字段
bool wps_encode_callback(pb_ostream_t *stream, const pb_field_t *field, void * const *arg) {
    const QList<WaypointProto> *wps_list = static_cast<const QList<WaypointProto>*>(*arg);
    if (wps_list == nullptr) {
        return true;
    }
    
    for (const auto& wp : *wps_list) {
        if (!pb_encode_tag_for_field(stream, field)) {
            return false;
        }
        if (!pb_encode_submessage(stream, WaypointProto_fields, &wp)) {
            return false;
        }
    }
    return true;
}

void UavClient::sendProto(long seq, int cmd, const void* message, const pb_msgdesc_t* fields) {
    if (seq < 0) {
        return;
    }
    
    uint8_t buffer[1024];
    pb_ostream_t stream = pb_ostream_from_buffer(buffer, sizeof(buffer));
    
    if (pb_encode(&stream, fields, message)) {
        int size = stream.bytes_written;
        QByteArray out = allocBuffer(seq, size, cmd);
        memcpy(out.data() + 12, buffer, size);
        addCrc(out, size + 12);
        send(out);
        if(seq > 0) {
            addQueueItem(QDateTime::currentMSecsSinceEpoch(), seq, out);
            savePackage(seq, out);
        }
    } else {
        // 序列化失败处理
        qDebug() << "nanopb encode failed";
    }
}

QByteArray UavClient::allocBuffer(long seq, int size, int cmd) {
    qsizetype sizeValue = static_cast<qsizetype>(size) + 16;
    QByteArray out;
    out.resize(sizeValue);
    uint8_t* bytes = (uint8_t*)out.data();
    MemoryHelper::LittleEndian::putI16(bytes, size + 14);
    MemoryHelper::LittleEndian::putI64(bytes + 2, seq);
    MemoryHelper::LittleEndian::putI16(bytes + 10, (int16_t)cmd);
    return out;
}

