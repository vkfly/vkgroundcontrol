#pragma once

#include "vehicle.h"
#include <QObject>

Q_MOC_INCLUDE("vehicle.h")

/**
 * @brief 飞行器对象管理器类
 *
 * 继承自 QObject，用于管理多个飞行器对象的连接、断开和状态管理
 * 提供活跃飞行器的选择和飞行器列表的维护功能
 *
 */
class VkObjManager : public QObject {
    Q_OBJECT

    /**
     * @brief 获取当前活跃飞行器
     */
    Q_PROPERTY(VkVehicle *activeVehicle READ getActive NOTIFY activeVehicleChanged)
    /**
     * @brief 获取所有飞行器列表
     */
    Q_PROPERTY(QList<VkVehicle *> vehicles READ getVehicles NOTIFY vehicleChanged)

public:
    VkObjManager(QObject *parent = nullptr) : QObject(parent) {}

    virtual ~VkObjManager() = default;

    /**
     * @brief 根据系统ID获取飞行器对象
     * @param sysid 系统ID
     * @return 对应的飞行器对象指针，如果不存在则返回nullptr
     */
    virtual VkVehicle *getVehicle(int sysid) = 0;

signals:

    void vehicleAdded(int sysid);

    void vehicleRemoved(int sysid);

    void activeVehicleChanged(int sysid);

    void vehicleChanged();

protected:
    /**
     * @brief 设置活跃飞行器
     * @param sysid 要设置为活跃状态的飞行器系统ID
     */
    virtual void setActive(int sysid) = 0;

    virtual VkVehicle *getActive() = 0;

    virtual QList<VkVehicle *> getVehicles() = 0;
};
