#pragma once

#include <QAbstractListModel>
#include <QGeoCoordinate>
#include <QList>

/**
 * @brief 任务模型类，用于管理无人机航点任务
 *
 * MissionModel继承自QAbstractListModel，提供了完整的航点管理功能，
 * 包括航点的添加、删除、修改以及路径规划等功能。支持多种任务类型，
 * 如拍照、抛投、环绕等模式。
 *
 */
class MissionModel : public QAbstractListModel {
    Q_OBJECT

public:
    explicit MissionModel(QObject *parent = nullptr);

    /**
     * @brief 转弯类型枚举
     *
     * 定义航点转弯的方向类型
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
     * 定义航点可执行的任务类型
     */
    enum TaskType {
        TaskType_None, ///< 无任务
        Task1,         ///< 任务类型1
        Task2          ///< 任务类型2
    };
    Q_ENUM(TaskType)

    /**
     * @brief 获取航点数量
     * @return 航点总数
     */
    Q_PROPERTY(int itemCount READ getItemCount NOTIFY itemCountChanged)
    /**
     * @brief 获取路径坐标列表
     * @return 路径坐标列表
     */
    Q_PROPERTY(QList<QGeoCoordinate> path READ getPath NOTIFY pathChanged)

    /**
     * @brief 航点结构体
     *
     * 定义单个航点的所有属性，包括位置、速度、任务参数等
     */
    struct Waypoint {
        double lon;                                                     ///< 经度
        double lat;                                                     ///< 纬度
        double alt;                                                     ///< 高度
        double center_lon;                                              ///< 中心点经度
        double center_lat;                                              ///< 中心点纬度
        int16_t speed;                                                  ///< 飞行速度
        TurnType turnType;                                              ///< 转弯类型
        double turnParam1;                                              ///< 转弯参数1
        double turnParam2;                                              ///< 转弯参数2
        TaskType taskType;                                              ///< 任务类型
        double taskValue;                                               ///< 任务参数值
        uint16_t hover_time;                                            ///< 悬停时间（毫秒）
        uint8_t take_photo_action;                                      ///< 拍照触发动作
        uint8_t take_photo_mode;                                        ///< 拍照模式
        uint16_t take_photo_value;                                      ///< 拍照间隔（秒）
        uint8_t yuntai_action;                                          ///< 云台动作
        int8_t yuntai_pitch;                                            ///< 云台俯仰角度
        int16_t yuntai_heading;                                         ///< 云台航向角度
        uint8_t heading_mode;                                           ///< 航向模式
        int16_t heading_value;                                          ///< 航向值
        int16_t trow_height;                                            ///< 抛投对地高度
        int16_t trow_tongdao;                                           ///< 抛投通道
        int16_t huanrao_banjing;                                        ///< 环绕半径
        uint16_t huanrao_speed;                                         ///< 环绕速度
        uint16_t huanraoquanshu;                                        ///< 环绕圈数
        uint32_t wpt_type;                                              ///< 航点类型：0拍照航点 1抛投航点 2环绕模式
        uint32_t dis = 0;                                               ///< 距离
        uint32_t wpt_wuliu_AB = 0;                                      ///< 物流点类型：0物流途径点 1物流起始点 2物流点
        uint32_t wpt_type_mode = 0;                                     ///< 航点类型模式
        double dimian_haiba = std::numeric_limits<double>::quiet_NaN(); ///< 地面海拔高度
    };

    /**
     * @brief 航点中心结构体
     *
     * 定义航点中心点的基本信息
     */
    struct WaypointCenter {
        int id;     ///< 中心点ID
        double lon; ///< 中心点经度
        double lat; ///< 中心点纬度
    };

    bool checked = false; ///< 检查状态标志
    int wpt_type_modes;   ///< 航点类型模式

    /**
     * @brief 添加航点数据
     * @param waypoint 要添加的航点引用
     */
    void addData(Waypoint &waypoint);

    /**
     * @brief 设置航点模式
     * @param wpt_mode_id 航点模式ID
     */
    Q_INVOKABLE void setwpt_mode(int wpt_mode_id) { wpt_type_modes = wpt_mode_id; }

    /**
     * @brief 获取航点模式
     * @return 当前航点模式ID
     */
    Q_INVOKABLE int getwpt_mode() { return wpt_type_modes; }

    /**
     * @brief 添加航点（基础版本）
     * @param lon 经度
     * @param lat 纬度
     */
    Q_INVOKABLE void addWpt(double lon, double lat);

    /**
     * @brief 添加航点（物流版本）
     * @param lon 经度
     * @param lat 纬度
     * @param wpt_wuliu_AB 物流点类型：0物流途径点 1物流起始点 2物流点
     */
    Q_INVOKABLE void addWpt(double lon, double lat, int wpt_wuliu_AB);

    /**
     * @brief 获取模型行数
     * @param parent 父索引（默认为无效索引）
     * @return 航点总数
     */
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    /**
     * @brief 获取指定索引的数据
     * @param index 模型索引
     * @param role 数据角色（默认为DisplayRole）
     * @return 对应角色的数据
     */
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    /**
     * @brief 获取角色名称映射
     * @return 角色ID到角色名称的映射表
     */
    QHash<int, QByteArray> roleNames() const override;

    /**
     * @brief 设置路径闭合状态
     * @param checked true表示路径闭合，false表示路径开放
     */
    Q_INVOKABLE void setRoute_Closure(bool checked);

    /**
     * @brief 移除指定索引的航点
     * @param index 要移除的航点索引
     */
    Q_INVOKABLE void removeAt(int index);

    /**
     * @brief 在指定索引处插入航点
     * @param index 插入位置的索引
     */
    Q_INVOKABLE void insertAt(int index);

    /**
     * @brief 根据ID更新航点信息（完整版本）
     * @param id 航点ID
     * @param longitude 经度
     * @param latitude 纬度
     * @param altitude 高度
     * @param speed 飞行速度
     * @param hover_time 悬停时间（毫秒）
     * @param take_photo_action 拍照触发动作
     * @param take_photo_mode 拍照模式
     * @param take_photo_value 拍照间隔（秒）
     * @param yuntai_action 云台动作
     * @param yuntai_pitch 云台俯仰角度
     * @param yuntai_heading 云台航向角度
     * @param heading_mode 航向模式
     * @param heading_value 航向值
     * @param trow_height 抛投对地高度
     * @param trow_tongdao 抛投通道
     * @param huanrao_banjing 环绕半径
     * @param huanrao_speed 环绕速度
     * @param huanraoquanshu 环绕圈数
     * @param wpt_type 航点类型：0拍照航点 1抛投航点 2环绕模式
     */
    Q_INVOKABLE void updateWaypointById(int id, double longitude, double latitude, double altitude, double speed,
                                        int hover_time, int take_photo_action, int take_photo_mode,
                                        int take_photo_value, int yuntai_action, int yuntai_pitch, int yuntai_heading,
                                        int heading_mode, int heading_value, int trow_height, int trow_tongdao,
                                        int huanrao_banjing, int huanrao_speed, int huanraoquanshu, int wpt_type);

    /**
     * @brief 将数字四舍五入到指定精度
     * @param number 要处理的数字
     * @param precision 精度（小数位数）
     * @return 四舍五入后的数字
     */
    double roundToNDecimal(double number, int precision);
    /**
     * @brief 添加详细航点信息
     * @param longitude 经度
     * @param latitude 纬度
     * @param altitude 高度
     * @param hover_time 悬停时间（毫秒）
     * @param speed 飞行速度
     * @param take_photo_action 拍照触发动作
     * @param take_photo_mode 拍照模式
     * @param take_photo_value 拍照间隔（秒）
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
    Q_INVOKABLE void addWpts(double longitude, double latitude, double altitude, uint16_t hover_time, int16_t speed,
                             uint8_t take_photo_action, uint8_t take_photo_mode, uint16_t take_photo_value,
                             uint8_t yuntai_action, int8_t yuntai_pitch, int16_t yuntai_heading, uint8_t heading_mode,
                             int16_t heading_value, uint32_t wpt_type, int16_t trow_height, int16_t trow_tongdao,
                             int16_t huanrao_banjing, uint16_t huanrao_speed, uint16_t huanraoquanshu);

    /**
     * @brief 添加带计数的详细航点信息
     * @param wpt_count 航点计数
     * @param longitude 经度
     * @param latitude 纬度
     * @param altitude 高度
     * @param hover_time 悬停时间（毫秒）
     * @param speed 飞行速度
     * @param take_photo_action 拍照触发动作
     * @param take_photo_mode 拍照模式
     * @param take_photo_value 拍照间隔（秒）
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
     * @param wpt_wuliu_AB 物流点类型
     */
    Q_INVOKABLE void addWptabs(int wpt_count, double longitude, double latitude, double altitude, uint16_t hover_time,
                               int16_t speed, uint8_t take_photo_action, uint8_t take_photo_mode,
                               uint16_t take_photo_value, uint8_t yuntai_action, int8_t yuntai_pitch,
                               int16_t yuntai_heading, uint8_t heading_mode, int16_t heading_value, uint32_t wpt_type,
                               int16_t trow_height, int16_t trow_tongdao, int16_t huanrao_banjing,
                               uint16_t huanrao_speed, uint16_t huanraoquanshu, uint32_t wpt_wuliu_AB);
    /**
     * @brief 添加简化航点信息
     * @param wpt_count 航点计数
     * @param lon 经度
     * @param lat 纬度
     * @param alt 高度
     * @param hover_time 悬停时间
     * @param speed 飞行速度
     * @param take_photo_action 拍照触发动作
     * @param take_photo_mode 拍照模式
     * @param take_photo_value 拍照间隔
     * @param wpt_type 航点类型
     */
    Q_INVOKABLE void addwppts(int wpt_count, double lon, double lat, double alt, int hover_time, int speed,
                              int take_photo_action, int take_photo_mode, int take_photo_value, int wpt_type);

    /**
     * @brief 批量更新所有航点信息
     * @param altitude 高度
     * @param speed 飞行速度
     * @param hover_time 悬停时间（毫秒）
     * @param take_photo_action 拍照触发动作
     * @param take_photo_mode 拍照模式
     * @param take_photo_value 拍照间隔（秒）
     * @param yuntai_action 云台动作
     * @param yuntai_pitch 云台俯仰角度
     * @param yuntai_heading 云台航向角度
     * @param heading_mode 航向模式
     * @param heading_value 航向值
     * @param trow_height 抛投对地高度
     * @param trow_tongdao 抛投通道
     * @param huanrao_banjing 环绕半径
     * @param huanrao_speed 环绕速度
     * @param huanraoquanshu 环绕圈数
     * @param wpt_type 航点类型：0拍照航点 1抛投航点 2环绕模式
     */
    Q_INVOKABLE void updateAllWaypointById(double altitude, double speed, int hover_time, int take_photo_action,
                                           int take_photo_mode, int take_photo_value, int yuntai_action,
                                           int yuntai_pitch, int yuntai_heading, int heading_mode, int heading_value,
                                           int trow_height, int trow_tongdao, int huanrao_banjing, int huanrao_speed,
                                           int huanraoquanshu, int wpt_type);

    /**
     * @brief 根据ID更新航点位置（简化版本）
     * @param id 航点ID
     * @param longitude 经度
     * @param latitude 纬度
     */
    Q_INVOKABLE void updateWaypointById(int id, double longitude, double latitude);

    /**
     * @brief 根据ID更新航点海拔高度
     * @param id 航点ID
     * @param haiba_alt 海拔高度
     */
    Q_INVOKABLE void updateAltById(int id, double haiba_alt);

    /**
     * @brief 清空所有航点
     */
    Q_INVOKABLE void clear();

    /**
     * @brief 设置抛投方式
     * @param throwtype 抛投类型：原高度抛投设置为-1，降低高度抛投设置为1-10
     */
    Q_INVOKABLE void setThrowType(int throwtype);

    /**
     * @brief 设置所有航点的高度
     * @param alt 高度值
     */
    Q_INVOKABLE void setAllAlt(double alt);

    /**
     * @brief 设置所有航点的悬停时间
     * @param hovertime 悬停时间（毫秒）
     */
    Q_INVOKABLE void setAllHoverTime(int hovertime);

    /**
     * @brief 设置所有航点的抛投通道
     * @param pao1 抛投通道1开关
     * @param pao2 抛投通道2开关
     * @param pao3 抛投通道3开关
     * @param pao4 抛投通道4开关
     * @param pao5 抛投通道5开关
     * @param pao6 抛投通道6开关
     * @param pao7 抛投通道7开关
     * @param pao8 抛投通道8开关
     */
    Q_INVOKABLE void setAlltrow_tongdao(bool pao1, bool pao2, bool pao3, bool pao4, bool pao5, bool pao6, bool pao7,
                                        bool pao8);

    /**
     * @brief 设置所有航点的飞行速度
     * @param speed 飞行速度
     */
    Q_INVOKABLE void setAllSpeed(double speed);

    /**
     * @brief 获取指定索引的航点
     * @param item 航点索引
     * @return 航点对象
     */
    Waypoint getItem(int item) const { return m_waypoints[item]; }

private:
    QList<Waypoint> m_waypoints;  ///< 航点列表
    QList<QGeoCoordinate> m_path; ///< 路径坐标列表

    /**
     * @brief 构建路径
     *
     * 根据当前航点列表重新构建飞行路径
     */
    void build_path();

    /**
     * @brief 更新指定索引航点的中心点
     * @param index 航点索引
     */
    void update_center(int index);

    QList<QGeoCoordinate> getPath() const { return m_path; }

public:
    int getItemCount() const { return m_waypoints.size(); }

signals:

    void pathChanged();

    void itemCountChanged();
};
