#pragma once

#include <QObject>
#include "vehicle.h"

Q_MOC_INCLUDE("vehicle.h")

class VkObjManager : public QObject {
    Q_OBJECT

    Q_PROPERTY(VkVehicle* activeVehicle READ getActive NOTIFY activeVehicleChanged)
    Q_PROPERTY(QList<VkVehicle*> vehicles READ getVehicles NOTIFY vehicleChanged)

public:
    VkObjManager(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~VkObjManager() = default;

    virtual VkVehicle *getVehicle(int sysid) = 0;

signals:
    void vehicleAdded(int sysid);
    void vehicleRemoved(int sysid);
    void activeVehicleChanged(int sysid);
    void vehicleChanged();

protected:
    virtual void setActive(int sysid) = 0;
    virtual VkVehicle *getActive() = 0;
    virtual QList<VkVehicle*> getVehicles() = 0;
};