#pragma once

#include <vkservercontroller.h>
#include "net/vknet.h"
#include "telemetry/sgsender.h"
#include "../vkdata.h"

class VkServerControllerImpl final : public VkServerController {
public:
    VkServerControllerImpl(QObject *parent = nullptr);
    ~VkServerControllerImpl();

public:
    void login(const QString& userName, const QString& password) override;
    void logout() override;
    void registerUser(const QString& userName, const QString& password, const QString& phone) override;
    void changePassword(const QString& oldPassword, const QString& newPassword) override;
    void requestKmlList() override;
    void downloadKml(const QString& kmlUrl) override;
    void sendImu(const VehicleTelemetryData& info);
    void uploadMissionInfo(const MissonInfo& info);
    void requestRtmpPushUrl(const QString& droneId) override;
    void requestPullStreamShareCode(const QString& droneId) override;
    
protected:
    bool getIsLogin() override { return isLogin; }
    QList<KmlInfo> getKmlList() override { return kmlList; }
    bool getRegisterSuccess() override { return registerSuccess; }
    bool getChangePasswordSuccess() override { return changePasswordSuccess; }
    UserInfo getUserInfo() override { return userInfo; }
    QString getErrorMessage() override { return errorMessage; }
    QString getRtmpServerUrl() override { return rtmpServerUrl; }
    QString getShareCode() override { return shareCode; }
    
private:
    bool isLogin = false;
    QList<KmlInfo> kmlList;
    QSharedPointer<VkNet> net;
    UserInfo userInfo;
    bool registerSuccess = false;
    bool changePasswordSuccess = false;
    QString errorMessage;
    SgSender sgSender;
    
    // RTMP and share code properties
    QString rtmpServerUrl;
    QString shareCode;
    
    // Private methods for internal use
    void updateRtmpServerUrl(const QString& rtmpUrl);
    void updateShareCode(const QString& shareCode);
};
