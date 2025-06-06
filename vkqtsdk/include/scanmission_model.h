#ifndef SCANLLISTMODEL_H
#define SCANLLISTMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QGeoCoordinate>
#include <cmath>
#include <iostream>
class ScanMissionModel : public QAbstractListModel {
    Q_OBJECT

public:
    QVariantList pathLists;
    explicit ScanMissionModel(QObject *parent = nullptr);
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

    struct Points {
        double x, y;

    };
    int offset_width = 300;
    int wpt_width = 150;
    struct Waypoints {
        int id;
        double longitude;
        double latitude;
        double altitude;
        int center_id;
        double center_longitude;
        double center_latitude;
        int16_t speed;
        TurnType turnType;
        double turnParam1;
        double turnParam2;
        TaskType taskType;
        double taskValue;
        uint16_t hover_time; //悬停时间
        uint8_t take_photo_action; //拍照触发动作
        uint8_t take_photo_mode; //拍照模式
        uint16_t take_photo_value; //拍照间隔
        uint8_t yuntai_action; //云台动作
        int8_t yuntai_pitch; //云台俯仰
        int16_t yuntai_heading; //云台航向
        uint8_t heading_mode;
        int16_t heading_value;
        //抛投模式类型
        int16_t trow_height; //抛投对地高度
        int16_t trow_tongdao; //抛投通道
        //环绕模式类型
        int16_t huanrao_banjing;
        uint16_t huanrao_speed;
        uint16_t huanraoquanshu;

        uint32_t wpt_type; //0拍照航点 1抛投航点 2 环绕模式
        uint32_t dis = 0;
        uint32_t wpt_wuliu_AB = 0; //0物流途径点 1物流起始点 2 物流点

        uint32_t wpt_type_mode = 0;
    };

    struct Waypoint_center {
        int id;
        double longitude;
        double latitude;
    };

    void getpath();
    int getitemCount() const {
        return m_waypoints.size();
    }

    bool checked = false;
    void addData(const Waypoints &waypoint);
    Q_INVOKABLE void addWpt(double lon, double lat );
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE QVariantList path();
    QHash<int, QByteArray> roleNames() const override;
    double roundToNDecimal(double number, int precision);
    void addWpts(int wpt_count, double longitude, double latitude, double altitude,
                 uint16_t hover_time,
                 int16_t speed,
                 uint8_t take_photo_action,
                 uint8_t take_photo_mode,
                 uint16_t take_photo_value,
                 uint8_t yuntai_action,
                 int8_t yuntai_pitch,
                 int16_t yuntai_heading,
                 uint8_t heading_mode,
                 int16_t heading_value,
                 uint32_t wpt_type,
                 int16_t trow_height, //抛投对地高度
                 int16_t trow_tongdao, //抛投通道
                 //环绕模式类型
                 int16_t huanrao_banjing,
                 uint16_t huanrao_speed,
                 uint16_t huanraoquanshu);
    Q_INVOKABLE void updateWaypointById(int id, double longitude, double latitude);
    Q_INVOKABLE void clear();
    Q_INVOKABLE void setJiange(int jiange);
    Q_INVOKABLE void setWidth(int width);
    Waypoints getItem(int item);
    Q_INVOKABLE int getcount();

private:
    // GeoOffset methods
    Points lat_lon_to_mercator(double lat, double lon) ;
    void mercator_to_lat_lon(double x, double y, double& lat, double& lon) ;
    Points calculate_normal( Points& p1,  Points& p2) ;
    QList<Points>  process_lat_lon_points( QList<Waypoints>& lat_lon_points);
    QList<Points> offset_points_width( QList<Points>& points, int offset_width, int offset_points_width) ;
    //QList<Points> process_lat_lon_points( QList<Waypoints>& lat_lon_points) ;
    QList<Waypoints> m_waypoints; //两个点和点之间的图标，方便中间添加航点
    QList<Points> m_points; //两个点和点之间的图标，方便中间添加航点
    // 常量
    static constexpr double EARTH_RADIUS = 6378137.0; // WGS84 地球半径
    static constexpr double DEG_TO_RAD = M_PI / 180.0;
    static constexpr double RAD_TO_DEG = 180.0 / M_PI;
    const double SEMI_MAJOR_AXIS = 6378137.0; // 长半轴 (WGS84)
    const double FLATTENING = 1.0 / 298.257223563; // 扁率 (WGS84)
    const double SCALE_FACTOR = 0.9996; // 缩放因子
    // 常量
    const double NORTHING_OFFSET = 10000000.0; // 南半球偏移量
    const double SEMI_MAJOR = 6378137.0;   // 长半轴
    const double ES = 0.00669437999014;    // 第一偏心率的平方
    double radian_to_degree(double radian);
    double degree_to_radian(double degree);
signals:
    void pathChanged();
    void itemCountChanged();
    void wptchangged();
    void haveBChanged();
};

#endif // SCANLLISTMODEL_H
