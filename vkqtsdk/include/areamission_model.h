// AreaMissionModels.h
#pragma once

#include <QAbstractListModel>
#include <QGeoCoordinate>
#include <QList>

/**
 * @brief 区域任务模型类
 *
 * 继承自 QAbstractListModel，用于管理区域任务中的航点数据和路径规划
 * 支持多边形区域的航线生成、航点管理和坐标转换等功能
 *
 */
class AreaMissionModel : public QAbstractListModel {
    Q_OBJECT

public:
    explicit AreaMissionModel(QObject *parent = nullptr);
    /**
     * @brief 二维点类
     *
     * 用于表示平面坐标系中的点
     */
    class Point {
    public:
        double x; ///< X坐标
        double y; ///< Y坐标
        Point(double x = 0, double y = 0) : x(x), y(y) {}
    };

    /**
     * @brief 航点结构体
     *
     * 用于存储航点的基本信息
     */
    struct Waypoint {
        int id;           ///< 航点ID
        double longitude; ///< 经度
        double latitude;  ///< 纬度
    };
    /**
     * @brief 纬度步长类
     *
     * 用于存储航线生成过程中的步长和纬度信息
     */
    class Lents {
    public:
        int steps;   ///< 步数
        double lats; ///< 纬度值

        Lents(int steps, double lats) : steps(steps), lats(lats) {}
    };

    QVariantList pathList; ///< 路径列表
    int itemCount;         ///< 航点数量
    int wpt_type_modes;    ///< 航点类型模式

    /**
     * @brief 获取路径
     */
    void getpath();

    bool checked = false; ///< 检查状态标志

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    /**
     * @brief 获取路径列表
     * @return 路径表
     */
    Q_INVOKABLE QVariantList path();

    /**
     * @brief 获取区域路径
     * @return 区域路径列表
     */
    Q_INVOKABLE QVariantList areapath();

    /**
     * @brief 添加航点
     * @param lon 经度
     * @param lat 纬度
     */
    Q_INVOKABLE void addWpt(double lon, double lat);

    /**
     * @brief 设置航线角度
     * @param angle 角度值（度）
     */
    Q_INVOKABLE void setAngle(double angle);

    /**
     * @brief 设置航线间距
     * @param spacing 间距值（米）
     */
    Q_INVOKABLE void setSpacing(double spacing);

    /**
     * @brief 根据ID更新航点坐标
     * @param id 航点ID
     * @param longitude 新经度
     * @param latitude 新纬度
     */
    Q_INVOKABLE void updateWaypointById(int id, double longitude, double latitude);

    /**
     * @brief 获取航点数量
     * @return 航点总数
     */
    Q_INVOKABLE int getcount();

    /**
     * @brief 清空所有航点
     */
    Q_INVOKABLE void clear();

    QHash<int, QByteArray> roleNames() const override;

    int si(int i, int l);

    QVariantList pathLists; ///< 路径列表集合

    /**
     * @brief 设置区域航点
     * @param points 航点列表
     * @param jiange 间距
     * @param jiaodu 角度
     * @return 生成的区域航点列表
     */
    QVariantList setAreaPoint(QList<Waypoint> points, double jiange, double jiaodu);

    /**
     * @brief 设置多边形航点
     * @param polygon 多边形顶点列表
     * @param jiange 航线间距
     * @param jiaodu 航线角度
     * @return 生成的航点列表
     */
    QList<Point> setPoints(QList<Point> polygon, double jiange, double jiaodu);

    /**
     * @brief 创建旋转后的多边形
     * @param latlngs 原始坐标点列表
     * @param bounds 边界点列表
     * @param rotate 旋转角度
     * @return 旋转后的点列表
     */
    QList<Point> createRotatePolygon(QList<Point> latlngs, QList<Point> bounds, double rotate);

    /**
     * @brief 创建内联点
     * @param p1 第一个点
     * @param p2 第二个点
     * @param y Y坐标值
     * @return 内联点
     */
    Point createInlinePoint(Point p1, Point p2, double y);

    /**
     * @brief 经纬度转墨卡托投影
     * @param lat 纬度
     * @param lon 经度
     * @return 墨卡托坐标点
     */
    Point lat_lon_to_mercator(double lat, double lon);

    /**
     * @brief 墨卡托投影转经纬度
     * @param x X坐标
     * @param y Y坐标
     * @param lat 输出纬度
     * @param lon 输出经度
     */
    void mercator_to_lat_lon(double x, double y, double &lat, double &lon);

    /**
     * @brief 创建多边形边界
     * @param points 点列表
     * @return 边界点列表
     */
    QList<Point> createPolygonBounds(QList<Point> points);

    /**
     * @brief 坐标变换
     * @param x X坐标
     * @param y Y坐标
     * @param tx X平移量
     * @param ty Y平移量
     * @param deg 旋转角度
     * @param sx X缩放比例
     * @param sy Y缩放比例
     * @return 变换后的点
     */
    Point transform(double x, double y, double tx, double ty, double deg, double sx, double sy);

    /**
     * @brief 计算两点间距离
     * @param p1 第一个点
     * @param p2 第二个点
     * @return 距离值
     */
    double distance1(const Point &p1, const Point &p2);

    /**
     * @brief 创建纬度步长
     * @param bounds 边界点列表
     * @param space 间距
     * @return 纬度步长对象
     */
    Lents createLats(QList<Point> bounds, double space);

    /**
     * @brief 添加航点数据
     * @param waypoint 航点对象
     */
    void addData(const Waypoint &waypoint);

    QList<Waypoint> m_waypoints; ///< 航点列表

    double jiange_value = 10; ///< 间距值，默认10米
    double jiaodu_value = 0;  ///< 角度值，默认0度

signals:

    void pathChanged();
};
