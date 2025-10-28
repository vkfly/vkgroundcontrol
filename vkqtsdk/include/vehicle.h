#pragma once

#include "mission_model.h"
#include "vkqtsdktypes.h"
#include <QGeoCoordinate>
#include <QList>
#include <QObject>
#include <QQmlPropertyMap>
#include <QVariantMap>

/**
 * @class VkVehicle
 * @brief 无人机设备抽象基类
 *
 * 该类定义了无人机设备的通用接口，包括飞行控制、状态监控、
 * 传感器数据获取、任务管理等功能。所有具体的无人机设备类
 * 都应继承此抽象基类并实现其纯虚函数。
 *
 * 主要功能模块：
 * - 飞行控制：起飞、降落、返航、指点飞行等
 * - 状态监控：心跳、系统状态、电池状态等
 * - 传感器数据：GNSS、IMU、姿态、距离传感器等
 * - 任务管理：航点任务上传下载、执行控制等
 * - 参数管理：飞控参数读写、持久化存储等
 * - 日志管理：日志列表获取、下载、擦除等
 * - 固件升级：固件文件上传与升级进度监控
 */
class VkVehicle : public QObject {
    Q_OBJECT

    /**
     * @brief 获取系统唯一标识符
     */
    Q_PROPERTY(int id READ getSysId CONSTANT)

    /**
     * @brief 获取设备当前地理坐标
     */
    Q_PROPERTY(QGeoCoordinate coordinate READ getCoordinate NOTIFY coordinateChanged)

    /**
     * @brief 获取设备设定的返航点坐标
     */
    Q_PROPERTY(QGeoCoordinate home READ getHome NOTIFY homePositionChanged)

    /**
     * @brief 获取设备距返航点的直线距离
     */
    Q_PROPERTY(double homeDistance READ homeDis NOTIFY homeDisChanged)

    Q_PROPERTY(double headToHome READ homeDis NOTIFY headToHomeChanged)

    /**
     * @brief 获取心跳包状态
     */
    Q_PROPERTY(Vk_Heartbeat *heartbeat READ heartBeat CONSTANT)

    /**
     * @brief 获取系统全局状态
     */
    Q_PROPERTY(VkSystemStatus *sysStatus READ sysStatus CONSTANT)

    /**
     * @brief 获取电池管理系统（BMS）数据
     */
    Q_PROPERTY(Vk_QingxieBms *qingxieBms READ qingxieBms CONSTANT)

    /**
     * @brief 获取电池状态信息
     */
    Q_PROPERTY(Vk_BmsStatus *bmsStatus READ bmsStatus CONSTANT)

    /**
     * @brief 获取主GNSS模块原始数据
     */
    Q_PROPERTY(VkGnss *GNSS1 READ gpsInput1 CONSTANT)

    /**
     * @brief 获取备用GNSS模块原始数据
     */
    Q_PROPERTY(VkGnss *GNSS2 READ gpsInput2 CONSTANT)

    /**
     * @brief 获取RTK差分定位状态
     */
    Q_PROPERTY(VkRtkMsg *RtkMsg READ rtkMsg CONSTANT)

    /**
     * @brief 获取设备姿态数据
     */
    Q_PROPERTY(Vk_Attitude *attitude READ attitude CONSTANT)

    /**
     * @brief 获取全球位置信息
     */
    Q_PROPERTY(Vk_GlobalPositionInt *globalPositionInt READ globalPositionInt CONSTANT)

    /**
     * @brief 获取电机信号输出
     */
    Q_PROPERTY(Vk_ServoOutputRaw *servoOutputRaw READ servoOutputRaw CONSTANT)

    /**
     * @brief 获取当前执行的航点任务信息
     */
    Q_PROPERTY(Vk_MissionCurrent *missionCurrent READ missionCurrent CONSTANT)

    /**
     * @brief 获取遥控器通道原始输入值
     */
    Q_PROPERTY(Vk_RcChannels *rcChannels READ rcChannels CONSTANT)

    /**
     * @brief 获取组件版本信息
     */
    Q_PROPERTY(Vk_ComponentVersion *componentVersion READ componentVersion CONSTANT)

    /**
     * @brief 获取飞行控制器版本信息
     */
    Q_PROPERTY(Vk_ComponentVersion *FlightController READ flightController CONSTANT)

    /**
     * @brief 获取主GPS模块版本信息
     */
    Q_PROPERTY(Vk_ComponentVersion *GPSA READ gpsA CONSTANT)

    /**
     * @brief 获取备用GPS模块版本信息
     */
    Q_PROPERTY(Vk_ComponentVersion *GPSB READ gpsB CONSTANT)

    /**
     * @brief 获取前向雷达模块版本信息
     */
    Q_PROPERTY(Vk_ComponentVersion *RFront READ rfdFront CONSTANT)

    /**
     * @brief 获取后向雷达模块版本信息
     */
    Q_PROPERTY(Vk_ComponentVersion *RRear READ rfdRear CONSTANT)

    /**
     * @brief 获取下视雷达模块版本信息
     */
    Q_PROPERTY(Vk_ComponentVersion *RDown READ rfdDown CONSTANT)

    /**
     * @brief 获取360度雷达模块版本信息
     */
    Q_PROPERTY(Vk_ComponentVersion *R360 READ rfd360 CONSTANT)

    /**
     * @brief 获取电池模块版本信息列表
     */
    Q_PROPERTY(QList<Vk_ComponentVersion *> Batteries READ batteries CONSTANT)

    /**
     * @brief 获取电子控制单元版本信息列表
     */
    Q_PROPERTY(QList<Vk_ComponentVersion *> ECUs READ ecus CONSTANT)

    /**
     * @brief 获取称重模块版本信息
     */
    Q_PROPERTY(Vk_ComponentVersion *Weigher READ weigher CONSTANT)

    /**
     * @brief 获取飞行管理单元状态
     */
    Q_PROPERTY(Vk_FmuStatus *fmuStatus READ fmuStatus CONSTANT)

    /**
     * @brief 获取惯性导航系统状态
     */
    Q_PROPERTY(Vk_insStatus *insStatus READ insStatus CONSTANT)

    /**
     * @brief 获取VFR HUD显示数据
     */
    Q_PROPERTY(Vk_VfrHud *vfrHud READ vfrHud CONSTANT)

    /**
     * @brief 获取障碍物距离信息
     */
    Q_PROPERTY(Vk_ObstacleDistance *obstacleDistance READ obstacleDistance CONSTANT)

    /**
     * @brief 获取高延迟通信状态
     */
    Q_PROPERTY(Vk_HighLatency *highLatency READ highLatency CONSTANT)

    /**
     * @brief 获取电子调速器（ESC）状态
     */
    Q_PROPERTY(Vk_EscStatus *escStatus READ escStatus CONSTANT)

    /**
     * @brief 获取主IMU传感器状态
     */
    Q_PROPERTY(Vk_ImuStatus *imuStatus READ scaledImuStatus NOTIFY imuStatusChanged)

    /**
     * @brief 获取备用IMU传感器状态
     */
    Q_PROPERTY(Vk_ImuStatus *imu2Status READ scaledImu2Status NOTIFY imu2StatusChanged)

    /**
     * @brief 获取当前加载的航点任务模型
     */
    Q_PROPERTY(MissionModel *mission READ getMission NOTIFY missionChanged)

    /**
     * @brief 飞控参数表
     * @details 用于管理和访问飞控的所有配置参数。参数系统支持读取、设置和监控飞控的各种配置项，
     *          包括飞行控制参数、传感器校准参数、安全设置等。每个参数使用16字节的参数ID作为唯一标识符。
     *
     *          参数操作功能：
     *          - 单个参数读取：通过参数名称读取指定参数的当前值
     *          - 参数表读取：一次性读取所有飞控参数列表
     *          - 参数设置：修改指定参数的数值并发送到飞控
     *          - 参数监控：实时监控参数变化并触发相应事件
     *
     *          支持的参数类型：
     *          - 整型参数：包括8位、16位、32位有符号和无符号整数
     *          - 浮点参数：32位单精度浮点数
     *          - 字符参数：单字节字符类型
     *
     *          主要参数分类：
     *
     *          **系统基础参数：**
     *          - MAV_SYS_ID：系统ID（1-255），通信标识符
     *          - MAV_COMP_ID：组件ID（1-255），组件标识符
     *          - AIRFRAME：飞机布局类型，定义动力配置
     *          - BOOT_MODE：系统启动模式（0-正常启动，1-U盘模式）
     *          - MLOG_MODE：数据记录模式（0-不记录，1-解锁到上锁，2-上电到落锁，3-上电到下电）
     *
     *          **安全保护参数：**
     *          - VOLT1_LOW_VAL/VOLT2_LOW_VAL：一级/二级电压低阈值（V）
     *          - VCAP1_LOW_VAL/VCAP2_LOW_VAL：一级/二级电量低阈值（%）
     *          - H2P_LOW1_VAL/H2P_LOW2_VAL：一级/二级氢气压低阈值（MPa）
     *          - FUEL_LOW1_VAL/FUEL_LOW2_VAL：一级/二级ECU油量低阈值（%）
     *          - FS_CONF_A：失控保护设置，配置各种保护动作
     *          - ALT_LIM_UP1/ALT_LIM_UP2：1级/2级高度限制（m）
     *          - MAX_HOR_DIST：最远水平距离（m）
     *
     *          **飞行控制参数：**
     *          - MC_XY_CRUISE：默认旋翼巡航速度（2-25 m/s）
     *          - TOF_ALT_M：默认起飞高度（1-5000 m）
     *          - RTL_ALT_M：默认返航高度（0-5000 m）
     *          - CIR_RAD_DFLT：默认环绕/盘旋半径（1-10000 m）
     *          - TILT_ANG_MAX：最大倾斜角度（10-45 deg）
     *          - YAW_SPD_MAX：最大航向角速度（10-120 deg/s）
     *
     *          **速度限制参数：**
     *          - MAN_VELH_MAX：手动模式最大水平速度（2-20 m/s）
     *          - MAN_VELU_MAX：手动模式最大爬升速度（1-10 m/s）
     *          - MAN_VELD_MAX：手动模式最大下降速度（1-10 m/s）
     *          - AUTO_VELU_MAX：自动模式最大爬升速度（0.5-8 m/s）
     *          - AUTO_VELD_MAX：自动模式最大下降速度（0.2-5 m/s）
     *          - AUTO_VELV_LND：自动模式降落接地速度（0.2-0.6 m/s）
     *
     *          **控制器参数：**
     *          - MC_RP_ANG_KP：旋翼横滚俯仰角度比例系数（200-800）
     *          - MC_YAW_ANG_KP：旋翼航向角度比例系数（200-800）
     *          - MC_RSPD_KP/KI/KD：旋翼横滚角速度PID参数
     *          - MC_PSPD_KP/KI/KD：旋翼俯仰角速度PID参数
     *          - MC_YSPD_KP/KI/KD：旋翼航向角速度PID参数
     *          - MC_PXY_KP：旋翼水平位置比例系数（20-150）
     *          - MC_VXY_KP/KI/KD：旋翼水平速度PID参数
     *          - MC_PZ_KP：旋翼高度位置比例系数（20-150）
     *          - MC_VZ_KP：旋翼垂直速度比例系数（300-500）
     *          - MC_AZ_KP/KI：旋翼垂直加速度PI参数
     *
     *          **传感器校准参数：**
     *          - GYRO0/1_XOFF/YOFF/ZOFF：陀螺仪零位偏移（-10~10 rad/s）
     *          - ACC0/1_XOFF/YOFF/ZOFF：加速度计零位偏移（-10~10 m/s²）
     *          - ACC0/1_XXSCALE/YYSCALE/ZZSCALE：加速度计校准系数
     *          - MAG0/1_XOFF/YOFF/ZOFF：磁力计零位偏移（-10~10 Gauss）
     *          - MAG0/1_XXSCALE/YYSCALE/ZZSCALE：磁力计校准系数
     *          - IMU_ATT_ROFF0/POFF0/YOFF0：IMU水平偏移角度（-180~180 deg）
     *
     *          **安装偏差参数：**
     *          - IMU_PXOFF/PYOFF/PZOFF：飞控IMU安装距离偏差（-1000~1000 cm）
     *          - GPS_ANT_XOFF/YOFF/ZOFF：普通GPS天线安装距离偏差（-1000~1000 cm）
     *          - RTK_ANT_XOFF/YOFF/ZOFF：RTK定位天线安装距离偏差（-1000~1000 cm）
     *          - RTK_H_COMP：RTK测向天线安装角度偏差（-180~180 deg）
     *
     *          **电池校准参数：**
     *          - BAT_V_DIV0/1/2/3：电压通道校准比例系数（0-1000）
     *          - BAT_V_OFF0/1/2/3：电压通道校准偏移（-100~100 V）
     *
     *          **载荷控制参数：**
     *          - GIMB_RTM_RCCH：载荷回中遥控器通道映射（0-18）
     *          - GIMB_MROI_RCCH：载荷ROI遥控器通道映射（0-18）
     *          - GIMB_PHO_RCCH：载荷拍照遥控器通道映射（0-18）
     *          - GIMB_REC_RCCH：载荷录像遥控器通道映射（0-18）
     *          - PHO_SIG_TYPE：拍照信号类型（0-低电平，1-高电平，2-PWM）
     *          - PHO_PWM_OFF/ON：拍照PWM信号待命/触发值（0-10000 us）
     *          - PHO_SIG_TIME：拍照触发信号持续时间（0-20000 ms）
     *
     *          **抛投系统参数：**
     *          - THROW_RCCH1~10：抛投1-10遥控器通道映射（0-18）
     *          - THROW_CH1~10：抛投1-10 PWM输出通道映射（0-16）
     *          - THROW_CH1~10_ON/OFF：抛投1-10打开/关闭PWM值（0-2500）
     *          - PARACHUTE_RCCH：降落伞遥控器通道映射（0-18）
     *          - PARACHUTE_CH：降落伞PWM输出通道映射（7-16）
     *
     *          **高级控制参数：**
     *          - OBAVOID_DIST：障碍悬停距离（2-8 m）
     *          - OBAVOID_ACT：避障动作（0-不开启，1-悬停，2-爬高）
     *          - FOLLOW_DIST：默认跟随距离（2-1000 m）
     *          - PREC_LAND_ERR：精准降落误差范围（0.05-1.0 m）
     *          - LADRC_EN：LADRC控制开关（0-不启用，1-启用）
     *          - WIND_COMP_KP：抗风补偿（0-1）
     *
     *          参数值范围和单位根据具体参数而定，部分参数修改后需要重启飞控才能生效。
     *          详细的参数说明和配置建议请参考飞控参数文档。
     */
    Q_PROPERTY(QVariantMap parameters READ getParams NOTIFY paramChanged)

    /**
     * @property distanceSensor
     * @brief 距离传感器信息
     * 各种距离传感器（激光雷达、超声波等）的测距数据和状态信息
     */
    Q_PROPERTY(Vk_DistanceSensor *distanceSensor READ distanceSensor CONSTANT)

    /**
     * @property weigherState
     * @brief 称重模块实时状态
     * 载重传感器的实时重量数据、校准状态和工作模式
     */
    Q_PROPERTY(Vk_WeigherState *weigherState READ weigherState CONSTANT)

    /**
     * @brief 编队飞行中长机信息
     * 编队飞行模式下长机的位置、状态和指令信息
     */
    Q_PROPERTY(Vk_FormationLeader *formationLeader READ formationLeader CONSTANT)

    /**
     * @brief 获取设备日志条目列表
     */
    Q_PROPERTY(QList<VkLogEntry *> logs READ getLogEntries NOTIFY logChanged)

    /**
     * @brief 获取载荷设备控制接口
     */
    Q_PROPERTY(QQmlPropertyMap *payload READ getPayload CONSTANT)

    /**
     * @brief 获取升级进度 0~100
     */
    Q_PROPERTY(int upgradeProgress READ getUpgradeProgress NOTIFY upgradeProgressChanged)

    /**
     * @brief 获取日志下载进度 0~100
     */
    Q_PROPERTY(int downloadLogProgress READ getDownloadLogProgress NOTIFY downloadLogProgressChanged)

    /**
     * @brief 获取设备连接状态
     */
    Q_PROPERTY(bool isConnected READ getIsConnected NOTIFY isConnectedChanged)

public:
    VkVehicle(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~VkVehicle() = default;

    /**
     * @brief 起飞
     */
    Q_INVOKABLE virtual void takeOff() = 0;

    /**
     * @brief 设置返航点
     */
    Q_INVOKABLE virtual void setHome(double latitude, double longitude) = 0;

    /**
     * @brief 原地降落
     */
    Q_INVOKABLE virtual void landAtCurrentPosition() = 0;

    /**
     * @brief 测试电机，以怠速旋转
     * @param motor 电机编号，从0开始
     */
    Q_INVOKABLE virtual void motorTest(int motor) = 0;

    /**
     * @brief 开始设备校准
     * @param calType 校准设备类型，2: 磁力计 3: 遥控器 15: 水平校准
     */
    Q_INVOKABLE virtual void startCalibration(int calType) = 0;

    /**
     * @brief 停止设备校准
     * @param calType 校准设备类型，同startCalibration。
     * @note 目前只有遥控器校准需要停止
     */
    Q_INVOKABLE virtual void stopCalibration(int calType) = 0;

    /**
     * @brief 设置参数
     * @param name 参数名称
     * @param value 参数值
     */
    Q_INVOKABLE virtual void setParam(QString name, double value) = 0;

    /**
     * @brief 清除航点
     */
    Q_INVOKABLE virtual void clearMission() = 0;

    // /**
    //  * @brief 添加航点
    //  * @param name 参数名称
    //  * @param value 参数值
    //  */
    // Q_INVOKABLE virtual void addWaypoint(double lat, double lon, double alt, int turnType = 0) = 0;

    // /**
    //  * @brief 设置参数
    //  * @param name 参数名称
    //  * @param value 参数值
    //  */
    // Q_INVOKABLE virtual void addLandWaypoint(double lat, double lon, double alt, float speed = NAN) = 0;
    // Q_INVOKABLE virtual void addPhotoWaypoint(double lat, double lon, double alt) = 0;

    // /**
    //  * @brief 设置参数
    //  * @param name 参数名称
    //  * @param value 参数值
    //  */
    // Q_INVOKABLE virtual void updateWaypoint(int idx) = 0;

    /**
     * @brief 开始执行飞行任务
     * @param wpid 起始航点序号,0-UINT16_MAX. NAN表示忽略该参数，飞控根据执行方式从0或最后一点开始
     * @param execMode 任务执行模式：
     *     - 0: 顺序执行, 正常执行航点动作
     *     - 1: 顺序执行, 略过航点动作
     *     - 2: 逆序执行, 正常航点动作
     *     - 3: 逆序执行, 忽略航点动作
     * @param doneAct 任务完成动作：
     *     - 0: 悬停
     *     - 1: 返航回 home
     *     - 2: 原地降落
     *     - 3: 返回回备降点
     *     - 4: 返航回 home, 按顺序航线执行
     *     - 5: 返航回 home, 按逆序航线执行
     *     - 6: 重新执行循环航线
     */
    Q_INVOKABLE virtual void startMission(int wpid, int execMode, int doneAct) = 0;

    // Q_INVOKABLE virtual void uploadMission() = 0;

    /**
     * @brief 上传指定任务模型
     * @param mission 任务模型指针，包含完整航点信息
     *
     * @warning 调用方需保证mission对象生命周期
     */
    Q_INVOKABLE virtual void uploadMissionModel(MissionModel *mission) = 0;

    /**
     * @brief 从飞行器下载任务到本地模型
     * @param mission 目标任务模型指针（用于接收下载数据）
     *
     * @note 下载完成后将触发mission模型的missionChanged信号
     */
    Q_INVOKABLE virtual void downloadMission(MissionModel *mission) = 0;

    /**
     * @brief 执行返航任务
     * @param wpid wpid 起始航点序号,0-UINT16_MAX. NAN表示忽略该参数，飞控根据执行方式从0或最后一点开始
     * @param execMode 返航执行模式：
     *     - 0: 直线返航
     *     - 1: 沿航线正序返航
     *     - 2: 沿航线逆序返航
     */
    Q_INVOKABLE virtual void returnMission(int wpid, int execMode) = 0;

    /**
     * @brief 进入Offboard外部控制模式
     * 切换至外部控制模式，需配合MAVLink消息持续发送控制指令
     */
    Q_INVOKABLE virtual void offboard() = 0;

    /**
     * @brief 取消当前执行的指令
     * 中断正在执行的任务/动作，包括：下载日志/升级固件/下载航点/上传航点
     */
    Q_INVOKABLE virtual void cancelCurrentCommand() = 0;

    /**
     * @brief 获取日志列表
     */
    Q_INVOKABLE virtual void getLogList() = 0;

    /**
     * @brief 擦除所有日志
     */
    Q_INVOKABLE virtual void eraseLogs() = 0;

    /**
     * @brief 下载日志
     * @param logDir 存放日志文件的目录
     * @param logid 日志id，从VkLogEntry中获取
     */
    Q_INVOKABLE virtual void downloadLog(const QString &logFilePath, int logid) = 0;

    /**
     * @brief 升级固件
     * @param filePath 固件文件名
     */
    Q_INVOKABLE virtual void upgradeFirmware(const QString &filePath) = 0;

    /**
     * @brief 指点飞行看向该点
     * @param lon 目标点经度
     * @param lat 目标点纬度
     */
    Q_INVOKABLE virtual void lookAtCurrentPoint(double lon, double lat) = 0;

    /**
     * @brief 指点飞行飞行该点
     * @param lon 目标点经度
     * @param lat 目标点纬度
     * @param alt 目标飞行高度（米）
     * @param yaw 目标偏航角（度）
     * @param speed 飞行速度（米/秒）
     */
    Q_INVOKABLE virtual void flyCurrentPoint(double lon, double lat, float alt, float yaw, float speed) = 0;

    /**
     * @brief 指点飞行取消看向该点
     */
    Q_INVOKABLE virtual void cancelLookAtCurrentPoint() = 0;

    /**
     * @brief 指点飞行取消飞行该点
     */
    Q_INVOKABLE virtual void cancelFlyCurrentPoint() = 0;

    /**
     * @brief 获取载荷设备控制接口
     */
    virtual QQmlPropertyMap *getPayload() = 0;

    /**
     * @brief 将参数保存到JSON文件中
     * @param filePath 要保存的JSON文件路径
     * @note 该方法用于将当前参数存储中的参数序列化为JSON格式并保存到指定文件，
     *       支持参数的持久化存储与备份，保存内容包含参数名称、类型及对应值
     */
    Q_INVOKABLE virtual bool saveParamMapToJSON(const QString &filePath) = 0;

    /**
     * @brief 从JSON文件加载参数
     * @param filePath 要加载的JSON文件路径
     * @note 该方法用于从JSON文件中解析参数数据并更新到当前参数存储，
     *       支持参数的批量导入与恢复。加载完成后会自动触发参数更新通知
     */
    Q_INVOKABLE virtual bool loadParamMapFromJSON(const QString &filePath) = 0;

    /***** PWM related *****/

    /**
     * @brief 配置PWM通道
     * @param index PWM通道号
     * @param pwn_num 对应到飞控上的PWM编号（1-16）
     * @param rcch 对应到飞控上的SBUS通道号，设置后可以通过遥控器控制对应PWM
     * @param on PWM对应开的值
     * @param off PWM对应关的值
     */
    Q_INVOKABLE virtual void pwmConfigurate(int index, int pwn_num, int rcch, int on, int off) = 0;

    /**
     * @brief 控制所有PWM通道输出，最多10个
     * @param pwm PWM值，范围-1.0~1.0，-1.0表示关闭，1.0表示打开，NAN表示不变
     * @param len 数组长度，最大是10
     */
    Q_INVOKABLE virtual void pwmControlAll(const QList<float>& pwm, int len) = 0;

    /**
     * @brief 控制单个PWM通道输出
     * @param index PWM通道号
     * @param pwm PWM值，范围-1.0~1.0，-1.0表示关闭，1.0表示打开，NAN表示不变
     */
    Q_INVOKABLE virtual void pwmControl(int index, float pwm) = 0;

    /**
     * @brief 飞行过程中改变飞行速度
     * @param speed 飞行速度 m/s
     */
    Q_INVOKABLE virtual void changeSpeed(float speed) = 0;

protected:
    virtual int getSysId() = 0;
    virtual double homeDis() const = 0;
    virtual Vk_Heartbeat *heartBeat() = 0;
    virtual Vk_QingxieBms *qingxieBms() = 0;
    virtual Vk_BmsStatus *bmsStatus() = 0;
    virtual QGeoCoordinate getCoordinate() = 0;
    virtual VkSystemStatus *sysStatus() = 0;

    virtual QGeoCoordinate getHome() = 0;
    virtual QList<VkLogEntry *> getLogEntries() = 0;
    virtual VkGnss *gpsInput1() = 0;
    virtual VkGnss *gpsInput2() = 0;
    virtual VkRtkMsg *rtkMsg() = 0;
    virtual Vk_Attitude *attitude() = 0;
    virtual Vk_ServoOutputRaw *servoOutputRaw() = 0;
    virtual Vk_MissionCurrent *missionCurrent() = 0;
    virtual Vk_RcChannels *rcChannels() = 0;

    virtual Vk_ComponentVersion *componentVersion() = 0;
    virtual Vk_ComponentVersion *flightController() = 0;
    virtual Vk_ComponentVersion *gpsA() = 0;
    virtual Vk_ComponentVersion *gpsB() = 0;
    virtual Vk_ComponentVersion *rfdFront() = 0;
    virtual Vk_ComponentVersion *rfdRear() = 0;
    virtual Vk_ComponentVersion *rfdDown() = 0;
    virtual Vk_ComponentVersion *rfd360() = 0;
    virtual QList<Vk_ComponentVersion *> batteries() = 0;
    virtual QList<Vk_ComponentVersion *> ecus() = 0;
    virtual Vk_ComponentVersion *weigher() = 0;

    virtual Vk_FmuStatus *fmuStatus() = 0;
    virtual Vk_insStatus *insStatus() = 0;
    virtual Vk_VfrHud *vfrHud() = 0;
    virtual Vk_ObstacleDistance *obstacleDistance() = 0;
    virtual Vk_HighLatency *highLatency() = 0;
    virtual Vk_EscStatus *escStatus() = 0;
    virtual Vk_ImuStatus *scaledImuStatus() = 0;
    virtual Vk_ImuStatus *scaledImu2Status() = 0;
    virtual Vk_GlobalPositionInt *globalPositionInt() = 0;
    virtual MissionModel *getMission() = 0;

    virtual QMap<QString, QVariant> getParams() = 0;
    virtual Vk_DistanceSensor *distanceSensor() = 0;
    virtual Vk_WeigherState *weigherState() = 0;
    virtual Vk_FormationLeader *formationLeader() = 0;
    virtual Vk_ParachuteStatus *parachuteStatus() = 0;
    virtual int getDownloadLogProgress() = 0;
    virtual int getUpgradeProgress() = 0;
    virtual bool getIsConnected() = 0;

signals:

    void heartBeat(const Vk_Heartbeat *msg);
    void coordinateChanged(const QGeoCoordinate &coord);
    void homePositionChanged(const QGeoCoordinate &coord);
    void homeDisChanged();
    void headToHomeChanged();
    void sysStatusChanged(const VkSystemStatus *msg);
    void qingxieBmsChanged(const VkQingxieBms *msg);
    void bmsStatusChanged(const VkBmsStatus *msg);
    void gnssChanged(const VkGnss *msg);
    void rtkMsgChanged(const VkRtkMsg *msg);
    void attitudeChanged(const Vk_Attitude *msg);
    void servoOutputRaweChanged(const Vk_ServoOutputRaw *msg);
    void missionCurrentChanged(const Vk_MissionCurrent *msg);
    void rcChannelsChanged(const Vk_RcChannels *msg);
    void componentVersionChanged(const Vk_ComponentVersion *msg);
    void fmuStatusChanged(const Vk_FmuStatus *msg);
    void insStatusChanged(const Vk_insStatus *msg);
    void vfrHudStatusChanged(const Vk_VfrHud *msg);
    void obstacleDistanceChanged(const Vk_ObstacleDistance *msg);
    void highLatencyChanged(const Vk_HighLatency *msg);
    void highLatencyChanged(const Vk_EscStatus *msg);
    void imuStatusChanged(const Vk_ImuStatus *msg);
    void imu2StatusChanged(const Vk_ImuStatus *msg);
    void otherglobalPositionChanged(const Vk_GlobalPositionInt *msg);
    void distanceSensoChanged(const Vk_DistanceSensor *msg);
    void weigherStateChanged(const Vk_WeigherState *msg);
    void formationLeaderChanged(const Vk_FormationLeader *msg);
    void logChanged();
    void missionChanged();
    void paramChanged();
    void downloadLogProgressChanged();
    void upgradeProgressChanged();
    void isConnectedChanged();
};
