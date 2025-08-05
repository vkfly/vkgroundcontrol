#ifndef UAVCLIENT_H
#define UAVCLIENT_H

#include "vkudpserver.h"
#include <QCryptographicHash>
#include "../utils/CRC.h"
#include "../proto/ack.pb.h"
#include "../proto/uav.pb.h"
#include "../proto/uav-ctl.pb.h"
#include "../nanopb/pb.h"
#include "../nanopb/pb_encode.h"
#include "../nanopb/pb_decode.h"
#include "threadsafequeue.h"
#include "threadsafemap.h"

// 前向声明 nanopb 回调函数
bool string_encode_callback(pb_ostream_t *stream, const pb_field_t *field, void * const *arg);
bool string_decode_callback(pb_istream_t *stream, const pb_field_t *field, void **arg);
bool seq_encode_callback(pb_ostream_t *stream, const pb_field_t *field, void * const *arg);
bool seq_decode_callback(pb_istream_t *stream, const pb_field_t *field, void **arg);
bool wps_encode_callback(pb_ostream_t *stream, const pb_field_t *field, void * const *arg);
bool wps_decode_callback(pb_istream_t *stream, const pb_field_t *field, void **arg);

/*
  +----------+----+----+----+----+----+----+----------------+----+----+----+----+
  |  LEN(2B) |       SEQ(8B)     | CMD(2B) | payload...     |     CRC32(4B)     |
  +----------+----+----+----+----+----+----+----------------+----+----+----+----+
  LEN = 8 + 2 + 4 + PLD
  CRC = CRC(LEN + SEQ + CMD + PLD)
 */

typedef struct QueueItem {
    long ts;
    QByteArray data;
} QueueItem;

class UavClient : public VKUdpServer {
    Q_OBJECT

public:
    explicit UavClient(const QString &url, quint16 p, QObject *parent = nullptr);

    void sendRtTrackProto(const TrackProto &track) {
        sendProto(0, DT_TRACK, &track, TrackProto_fields);
    }

    void sendTrackProto(const TrackProto &track) {
        sendProto(seqN++, DT_TRACK, &track, TrackProto_fields);
    }

    void sendBatteryProto(const BatteryProto &battery) {
        sendProto(seqN++, DT_BATTERY, &battery, BatteryProto_fields);
    }

protected:
    void processReceived(const QByteArray &data) override;
    void idle() override;
    void prepare() override;

    virtual void confirmPackage(long seq) {};
    virtual void savePackage(long seq, const QByteArray &data) {}
    virtual QByteArray getResendPackage() {
        return QByteArray();
    }
    virtual long getInitialSeq() {
        return 1;
    }
    virtual void onReceived(const InstructionProto& msg) {}
    virtual void onReceived(const RouteProto& msg) {}
    virtual void onReceived(const WaypointGroupProto& msg) {}
    virtual void onReceived(const GimbalProto& msg) {}

private:
    void parseObject(quint64 rseq, int cmd, const uint8_t* data, int len);
    void resend();
    void addCrc(QByteArray &data, int len);
    int32_t crc(const uint8_t* data, int len);

    bool verifyPackage(const QByteArray &data, int off, int len);
    void addQueueItem(long ts, long seq, const QByteArray &data);
    void sendSAck(const QString& droneId, int64_t rseq) {
        SAckProto b = SAckProto_init_zero;
        b.seq = rseq;
        // 设置 droneId 回调
        b.droneId.funcs.encode = &string_encode_callback;
        b.droneId.arg = const_cast<QString*>(&droneId);
        sendProto(0, DT_SACK, &b, SAckProto_fields);
    }
    void sendProto(long seq, int type, const void* message, const pb_msgdesc_t* fields);
    QByteArray allocBuffer(long seq, int size, int cmd);

    static const int DT_ACK = 0xFEFE;
    static const int DT_SACK = 0xEFEF;
    static const int DT_TRACK = 1;
    static const int DT_BATTERY = 2;
    static const int DT_INST = 101;
    static const int DT_ROUTE = 102;
    static const int DT_WP = 103;
    static const int DT_GIMBAL = 104;
    static const int UDP_SIZE = 512;
    static const int UDP_TIMEOUT = 1000;

    ThreadSafeMap<long, QueueItem> queue;
    quint64 seqN = -1;
    QByteArray buf;
};

#endif // UAVCLIENT_H
