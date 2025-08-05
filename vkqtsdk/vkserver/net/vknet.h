#ifndef SGNET_H
#define SGNET_H

#include <QObject>
#include "httpclient.h"
#include <vkqtsdktypes.h>
#include "../../vkdata.h"

class VkNet : public QObject {
    Q_OBJECT
public:
    explicit VkNet(QObject *parent = nullptr);
    void login(const QString& userName, const QString& password);
    void logout();
    void registerUser(const QString& userName, const QString& password, const QString& phone);
    void changePassword(const QString& userId, const QString& oldPassword, const QString& newPassword);
    void requestKmlList();
    void downloadKml(const QString& kmlUrl);
    void uploadmissionInfo(const QString& userId, const MissonInfo& info);
    void requestRtmpPushUrl(const QString& droneId);
    void requestShareCode(const QString& droneId);
    
signals:
    void loginSuccess(const UserInfo &userInfo);
    void loginFailed(const QString& message);
    void registerSuccess(const UserInfo &userInfo);
    void registerFailed(const QString& message);
    void changePasswordSuccess();
    void changePasswordFailed(const QString& message);
    void requestKmlListSuccess(const QList<KmlInfo>& kmls);
    void requestKmlListFailed(const QString& message);
    void downloadKmlSuccess(const QString& message);
    void downloadKmlFailed(const QString& message);
    void requestRtmpPushUrlSuccess(const QString& rtmpUrl);
    void requestRtmpPushUrlFailed(const QString& message);
    void requestShareCodeSuccess(const QString& shareCode);
    void requestShareCodeFailed(const QString& message);

private:
    QSharedPointer<HttpClient> httpClient;
    QString token = "";
    void setToken(const QString& token);
    QString handleErrorMessage(const QString& errorMsg);
};

#endif // SGNET_H
