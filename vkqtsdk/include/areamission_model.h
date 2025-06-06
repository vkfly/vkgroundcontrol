// AreaMissionModels.h
#ifndef AreaMissionModel_H
#define AreaMissionModel_H

#include <QList>
#include <QAbstractListModel>
#include <QGeoCoordinate>

class AreaMissionModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit AreaMissionModel(QObject *parent = nullptr);
    class Point {
    public:
        double x, y;

        Point(double x = 0, double y = 0) : x(x), y(y) {}
    };

    struct Waypoint {
        int id;
        double longitude;
        double latitude;
    };
    class Lents {
    public:
        int steps;
        double lats;
        Lents(int steps, double lats) : steps(steps), lats(lats) {}
    };

    QVariantList pathList;
    int itemCount;
    int wpt_type_modes;
    //Q_PROPERTY(int itemCount READ getitemCount NOTIFY itemCountChanged)


    void getpath();

    bool checked=false;
    //void addData(const Waypoint &waypoint);

    Q_INVOKABLE void addWpt(double lon,double lat);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    //Q_INVOKABLE void simulateData(); // 添加一个仿真函数

    Q_INVOKABLE QVariantList path();
    Q_INVOKABLE QVariantList  areapath();

    // Q_INVOKABLE void removeindex(int index);
    QHash<int, QByteArray> roleNames() const override;

    int si(int i, int l);




    QVariantList pathLists;
    QVariantList setAreaPoint(QList<Waypoint> points,double jiange,double jiaodu);
    //QList<Point> setAreaPoint(QList<Point> points,double jiange,double jiaodu);
    // QList<Point> setPoints(QList<Point> polygon,double jiange,double jiaodu);

    QList<Point> setPoints(QList<Point> polygon,double jiange,double jiaodu);
    QList<Point> createRotatePolygon(QList<Point> latlngs, QList<Point> bounds, double rotate);
    Point createInlinePoint(Point p1, Point p2, double y) ;
    //Point  createInlinePoint(const Point p1, const Point& p2, double y);
    Point lat_lon_to_mercator(double lat, double lon);
    void  mercator_to_lat_lon(double x, double y, double& lat, double& lon) ;
    QList<Point> createPolygonBounds(QList<Point> points) ;
    Point transform(double x, double y, double tx, double ty, double deg, double sx, double sy);
    double distance1(const Point& p1, const Point& p2);
    Lents createLats(QList<Point> bounds, double space);
    void addData(const Waypoint &waypoint);
    //int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    //QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    //QHash<int, QByteArray> roleNames() const override;
    QList<Waypoint> m_waypoints;

    //Q_INVOKABLE void addWpt(double lon, double lat );
    //Q_INVOKABLE QVariantList path();
    Q_INVOKABLE void updateWaypointById(int id, double longitude, double latitude);
    Q_INVOKABLE int getcount();
    Q_INVOKABLE void clear();
    double jiange_value=10;
    double jiaodu_value=0;
    Q_INVOKABLE void setAngle(double angle);
    Q_INVOKABLE void setSpacing(double spacing);
signals:
    void pathChanged();
};

#endif // AreaMissionModels_H
