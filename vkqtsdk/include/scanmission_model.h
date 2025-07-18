#pragma once

#include <QAbstractListModel>
#include <QGeoCoordinate>
#include <QList>

/**
 * @brief 扫描任务模型类
 *
 * 继承自 QAbstractListModel，用于管理扫描任务中的航点数据。
 * 提供航点的添加、删除、修改等功能，支持多种任务类型和转弯模式。
 *
 */
class ScanMissionModel : public QAbstractListModel {
    Q_OBJECT

public:
    explicit ScanMissionModel(QObject *parent = nullptr);

    /**
     * @brief 路径列表
     *
     * 存储航点路径的变体列表，用于QML界面显示
     */
    QVariantList pathLists;

    /**
     * @brief 转弯类型枚举
     *
     * 定义航点间的转弯方式
     */
    enum TurnType {
        TurnType_None, ///< 无转弯
        Left,          ///< 左转
        Right          ///< 右转
    };
    Q_ENUM(TurnType)

    /**
     * @brief 任务类型枚举
     *
     * 定义不同的任务执行类型
     */
    enum TaskType {
        TaskType_None, ///< 无任务
        Task1,         ///< 任务类型1
        Task2          ///< 任务类型2
    };
    Q_ENUM(TaskType)

    /**
     * @brief 点坐标结构体
     *
     * 用于存储二维坐标点信息
     */
    struct Points {
        double x, y; ///< X和Y坐标值
    };

    /**
     * @brief 偏移宽度
     *
     * 航点间的偏移宽度，默认为300
     */
    int offset_width = 300;

    /**
     * @brief 航点宽度
     *
     * 航点的宽度参数，默认为150
     */
    int wpt_width = 150;

    /**
     * @brief 航点结构体
     *
     * 包含航点的完整信息，包括位置、任务参数、云台控制等
     */
    struct Waypoints {
        int id;                     ///< 航点ID
        double longitude;           ///< 经度
        double latitude;            ///< 纬度
        double altitude;            ///< 高度
        int center_id;              ///< 中心点ID
        double center_longitude;    ///< 中心点经度
        double center_latitude;     ///< 中心点纬度
        int16_t speed;              ///< 飞行速度
        TurnType turnType;          ///< 转弯类型
        double turnParam1;          ///< 转弯参数1
        double turnParam2;          ///< 转弯参数2
        TaskType taskType;          ///< 任务类型
        double taskValue;           ///< 任务值
        uint16_t hover_time;        ///< 悬停时间
        uint8_t take_photo_action;  ///< 拍照触发动作
        uint8_t take_photo_mode;    ///< 拍照模式
        uint16_t take_photo_value;  ///< 拍照间隔
        uint8_t yuntai_action;      ///< 云台动作
        int8_t yuntai_pitch;        ///< 云台俯仰角度
        int16_t yuntai_heading;     ///< 云台航向角度
        uint8_t heading_mode;       ///< 航向模式
        int16_t heading_value;      ///< 航向值
        int16_t trow_height;        ///< 抛投对地高度
        int16_t trow_tongdao;       ///< 抛投通道
        int16_t huanrao_banjing;    ///< 环绕半径
        uint16_t huanrao_speed;     ///< 环绕速度
        uint16_t huanraoquanshu;    ///< 环绕圈数
        uint32_t wpt_type;          ///< 航点类型：0拍照航点 1抛投航点 2环绕模式
        uint32_t dis = 0;           ///< 距离
        uint32_t wpt_wuliu_AB = 0;  ///< 物流点类型：0物流途径点 1物流起始点 2物流点
        uint32_t wpt_type_mode = 0; ///< 航点类型模式
    };

    /**
     * @brief 航点中心结构体
     *
     * 用于存储航点中心点的基本信息
     */
    struct Waypoint_center {
        int id;           ///< 中心点ID
        double longitude; ///< 中心点经度
        double latitude;  ///< 中心点纬度
    };

    /**
     * @brief 获取路径
     *
     * 生成并更新当前的航点路径
     */
    void getpath();

    /**
     * @brief 获取航点数量
     * @return 当前航点的总数量
     */
    int getitemCount() const { return m_waypoints.size(); }

    /**
     * @brief 检查状态标志
     *
     * 用于标识当前的检查状态
     */
    bool checked = false;

    /**
     * @brief 添加航点数据
     * @param waypoint 要添加的航点对象
     */
    void addData(const Waypoints &waypoint);

    /**
     * @brief 添加航点
     * @param lon 经度
     * @param lat 纬度
     */
    Q_INVOKABLE void addWpt(double lon, double lat);

    /**
     * @brief 获取行数
     * @param parent 父索引
     * @return 模型中的行数
     */
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    /**
     * @brief 获取数据
     * @param index 模型索引
     * @param role 数据角色
     * @return 指定索引和角色的数据
     */
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    /**
     * @brief 获取路径列表
     * @return 航点路径的变体列表
     */
    Q_INVOKABLE QVariantList path();

    /**
     * @brief 获取角色名称
     * @return 角色名称的哈希表
     */
    QHash<int, QByteArray> roleNames() const override;

    /**
     * @brief 数值四舍五入
     * @param number 要处理的数值
     * @param precision 精度位数
     * @return 四舍五入后的数值
     */
    double roundToNDecimal(double number, int precision);

    /**
     * @brief 添加航点
     * @param wpt_count 航点数量
     * @param longitude 经度
     * @param latitude 纬度
     * @param altitude 高度
     * @param hover_time 悬停时间
     * @param speed 飞行速度
     * @param take_photo_action 拍照触发动作
     * @param take_photo_mode 拍照模式
     * @param take_photo_value 拍照间隔
     * @param yuntai_action 云台动作
     * @param yuntai_pitch 云台俯仰角度
     * @param yuntai_heading 云台航向角度
     * @param heading_mode 航向模式
     * @param heading_value 航向值
     * @param wpt_type 航点类型
     * @param trow_height 抛投对地高度
     * @param trow_tongdao 抛投通道
     * @param huanrao_banjing 环绕半径
     * @param huanrao_speed 环绕速度
     * @param huanraoquanshu 环绕圈数
     */
    void addWpts(int wpt_count, double longitude, double latitude, double altitude, uint16_t hover_time, int16_t speed,
                 uint8_t take_photo_action, uint8_t take_photo_mode, uint16_t take_photo_value, uint8_t yuntai_action,
                 int8_t yuntai_pitch, int16_t yuntai_heading, uint8_t heading_mode, int16_t heading_value,
                 uint32_t wpt_type, int16_t trow_height, int16_t trow_tongdao, int16_t huanrao_banjing,
                 uint16_t huanrao_speed, uint16_t huanraoquanshu);

    /**
     * @brief 根据ID更新航点
     * @param id 航点ID
     * @param longitude 新的经度
     * @param latitude 新的纬度
     */
    Q_INVOKABLE void updateWaypointById(int id, double longitude, double latitude);

    /**
     * @brief 清空所有航点
     */
    Q_INVOKABLE void clear();

    /**
     * @brief 设置间隔
     * @param jiange 间隔值
     */
    Q_INVOKABLE void setJiange(int jiange);

    /**
     * @brief 设置宽度
     * @param width 宽度值
     */
    Q_INVOKABLE void setWidth(int width);

    /**
     * @brief 获取指定项目的航点
     * @param item 项目索引
     * @return 航点对象
     */
    Waypoints getItem(int item);

    /**
     * @brief 获取航点总数
     * @return 航点数量
     */
    Q_INVOKABLE int getcount();

private:
    /**
     * @brief 地理坐标转换为墨卡托投影坐标
     * @param lat 纬度
     * @param lon 经度
     * @return 墨卡托投影坐标点
     */
    Points lat_lon_to_mercator(double lat, double lon);

    /**
     * @brief 墨卡托投影坐标转换为地理坐标
     * @param x X坐标
     * @param y Y坐标
     * @param lat 输出纬度
     * @param lon 输出经度
     */
    void mercator_to_lat_lon(double x, double y, double &lat, double &lon);

    /**
     * @brief 计算两点间的法向量
     * @param p1 第一个点
     * @param p2 第二个点
     * @return 法向量点
     */
    Points calculate_normal(Points &p1, Points &p2);

    /**
     * @brief 处理经纬度点列表
     * @param lat_lon_points 经纬度航点列表
     * @return 处理后的点列表
     */
    QList<Points> process_lat_lon_points(QList<Waypoints> &lat_lon_points);

    /**
     * @brief 根据宽度偏移点
     * @param points 原始点列表
     * @param offset_width 偏移宽度
     * @param offset_points_width 点偏移宽度
     * @return 偏移后的点列表
     */
    QList<Points> offset_points_width(QList<Points> &points, int offset_width, int offset_points_width);

    /**
     * @brief 航点列表
     *
     * 存储所有航点数据，用于航点管理和路径规划
     */
    QList<Waypoints> m_waypoints;

    /**
     * @brief 点列表
     *
     * 存储处理后的坐标点，用于路径计算
     */
    QList<Points> m_points;

    static constexpr double EARTH_RADIUS = 6378137.0;  ///< WGS84 地球半径
    static constexpr double DEG_TO_RAD = M_PI / 180.0; ///< 角度转弧度系数
    static constexpr double RAD_TO_DEG = 180.0 / M_PI; ///< 弧度转角度系数
    const double SEMI_MAJOR_AXIS = 6378137.0;          ///< 长半轴 (WGS84)
    const double FLATTENING = 1.0 / 298.257223563;     ///< 扁率 (WGS84)
    const double SCALE_FACTOR = 0.9996;                ///< 缩放因子
    const double NORTHING_OFFSET = 10000000.0;         ///< 南半球偏移量
    const double SEMI_MAJOR = 6378137.0;               ///< 长半轴
    const double ES = 0.00669437999014;                ///< 第一偏心率的平方

    /**
     * @brief 弧度转角度
     * @param radian 弧度值
     * @return 角度值
     */
    double radian_to_degree(double radian);

    /**
     * @brief 角度转弧度
     * @param degree 角度值
     * @return 弧度值
     */
    double degree_to_radian(double degree);
signals:

    void pathChanged();

    void itemCountChanged();

    void wptchangged();

    void haveBChanged();
};
