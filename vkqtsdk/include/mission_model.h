#pragma once

#include <QAbstractListModel>
#include <QGeoCoordinate>
#include <QList>

class MissionModel : public QAbstractListModel {
    Q_OBJECT

public:
    explicit MissionModel(QObject *parent = nullptr);
    enum TurnType {
        TurnType_None,
        Left,
        Right
    };
    Q_ENUM(TurnType)

    enum TaskType {
        TaskType_None,
        Task1,
        Task2
    };
    Q_ENUM(TaskType)

    Q_PROPERTY(int itemCount READ getItemCount NOTIFY itemCountChanged)
    Q_PROPERTY(QList<QGeoCoordinate> path READ getPath NOTIFY pathChanged)

    struct Waypoint {
        double lon;
        double lat;
        double alt;
        double center_lon;
        double center_lat;
        int16_t speed;
        TurnType turnType;
        double turnParam1;
        double turnParam2;
        TaskType taskType;
        double taskValue;
        uint16_t hover_time;       // 悬停时间
        uint8_t take_photo_action; // 拍照触发动作
        uint8_t take_photo_mode;   // 拍照模式
        uint16_t take_photo_value; // 拍照间隔
        uint8_t yuntai_action;     // 云台动作
        int8_t yuntai_pitch;       // 云台俯仰
        int16_t yuntai_heading;    // 云台航向
        uint8_t heading_mode;
        int16_t heading_value;
        // 抛投模式类型
        int16_t trow_height;  // 抛投对地高度
        int16_t trow_tongdao; // 抛投通道
        // 环绕模式类型
        int16_t huanrao_banjing;
        uint16_t huanrao_speed;
        uint16_t huanraoquanshu;

        uint32_t wpt_type; // 0拍照航点 1抛投航点 2 环绕模式
        uint32_t dis = 0;
        uint32_t wpt_wuliu_AB = 0; // 0物流途径点 1物流起始点 2 物流点

        uint32_t wpt_type_mode = 0;
        double dimian_haiba = std::numeric_limits<double>::quiet_NaN();
    };

    struct WaypointCenter {
        int id;
        double lon;
        double lat;
    };

    bool checked = false;
    int wpt_type_modes;

    void addData(Waypoint &waypoint);

    Q_INVOKABLE void setwpt_mode(int wpt_mode_id) { wpt_type_modes = wpt_mode_id; }
    Q_INVOKABLE int getwpt_mode() { return wpt_type_modes; }
    Q_INVOKABLE void addWpt(double lon, double lat);
    Q_INVOKABLE void addWpt(double lon, double lat, int wpt_wuliu_AB);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void setRoute_Closure(bool checked);

    Q_INVOKABLE void removeAt(int index);
    Q_INVOKABLE void insertAt(int index);

    // 更新航点
    Q_INVOKABLE void updateWaypointById(
        int id, double longitude, double latitude, double altitude, double speed,
        int hover_time,       // 悬停时间
        int take_photo_action, // 拍照触发动作
        int take_photo_mode, // 拍照模式
        int take_photo_value, // 拍照间隔
        int yuntai_action, // 云台动作
        int yuntai_pitch, // 云台俯仰
        int yuntai_heading, // 云台航向
        int heading_mode, int heading_value,
        int trow_height, // 抛投对地高度
        int trow_tongdao, // 抛投通道
        // 环绕模式类型
        int huanrao_banjing, int huanrao_speed, int huanraoquanshu,
        int wpt_type // 0拍照航点 1抛投航点 2 环绕模式
    );
    double roundToNDecimal(double number, int precision);
    Q_INVOKABLE void addWpts(double longitude, double latitude, double altitude, uint16_t hover_time,
                             int16_t speed, uint8_t take_photo_action, uint8_t take_photo_mode,
                             uint16_t take_photo_value, uint8_t yuntai_action, int8_t yuntai_pitch,
                             int16_t yuntai_heading, uint8_t heading_mode, int16_t heading_value, uint32_t wpt_type,
                             int16_t trow_height,  // 抛投对地高度
                             int16_t trow_tongdao, // 抛投通道
                             // 环绕模式类型
                             int16_t huanrao_banjing, uint16_t huanrao_speed, uint16_t huanraoquanshu);
    Q_INVOKABLE void addWptabs(int wpt_count, double longitude, double latitude, double altitude, uint16_t hover_time,
                               int16_t speed, uint8_t take_photo_action, uint8_t take_photo_mode,
                               uint16_t take_photo_value, uint8_t yuntai_action, int8_t yuntai_pitch,
                               int16_t yuntai_heading, uint8_t heading_mode, int16_t heading_value, uint32_t wpt_type,
                               int16_t trow_height,  // 抛投对地高度
                               int16_t trow_tongdao, // 抛投通道
                               // 环绕模式类型
                               int16_t huanrao_banjing, uint16_t huanrao_speed, uint16_t huanraoquanshu,
                               uint32_t wpt_wuliu_AB);
    Q_INVOKABLE void addwppts(int wpt_count, double lon, double lat, double alt, int hover_time, int speed,
                              int take_photo_action, int take_photo_mode, int take_photo_value, int wpt_type);
    Q_INVOKABLE void updateAllWaypointById(
        double altitude, double speed,
        int hover_time,       // 悬停时间
        int take_photo_action, // 拍照触发动作
        int take_photo_mode, // 拍照模式
        int take_photo_value, // 拍照间隔
        int yuntai_action, // 云台动作
        int yuntai_pitch, // 云台俯仰
        int yuntai_heading, // 云台航向
        int heading_mode, int heading_value,
        int trow_height, // 抛投对地高度
        int trow_tongdao, // 抛投通道
        // 环绕模式类型
        int huanrao_banjing, int huanrao_speed, int huanraoquanshu,
        int wpt_type // 0拍照航点 1抛投航点 2 环绕模式
    );

    Q_INVOKABLE void updateWaypointById(int id, double longitude, double latitude);
    Q_INVOKABLE void updateAltById(int id, double haiba_alt);
    Q_INVOKABLE void clear();
    Q_INVOKABLE void setThrowType(int throwtype); // 设置抛投方式  原高度抛投设置为-1   降低高度抛投设置为1-10
    Q_INVOKABLE void setAllAlt(double alt);
    Q_INVOKABLE void setAllHoverTime(int hovertime);
    Q_INVOKABLE void setAlltrow_tongdao(bool pao1, bool pao2, bool pao3, bool pao4, bool pao5, bool pao6, bool pao7,
                                        bool pao8);
    Q_INVOKABLE void setAllSpeed(double speed);

    Waypoint getItem(int item) const { return m_waypoints[item]; }

private:
    QList<Waypoint> m_waypoints;
    QList<QGeoCoordinate> m_path;

    void build_path();
    void update_center(int index);

    QList<QGeoCoordinate> getPath() const { return m_path; }

public:
    int getItemCount() const { return m_waypoints.size(); }

signals:
    void pathChanged();
    void itemCountChanged();
};
