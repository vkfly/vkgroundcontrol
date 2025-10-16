#pragma once

#include <QObject>
#include <QString>
#include <QList>
#include "vkqtsdktypes.h"

class VkServerController : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool isLogin READ getIsLogin NOTIFY isLoginChanged)
    Q_PROPERTY(bool registerSuccess READ getRegisterSuccess NOTIFY registerSuccessChanged)
    Q_PROPERTY(bool changePasswordSuccess READ getChangePasswordSuccess NOTIFY changePasswordSuccessChanged)
    Q_PROPERTY(QList<KmlInfo> kmlList READ getKmlList NOTIFY kmlListChanged)
    Q_PROPERTY(UserInfo userInfo READ getUserInfo NOTIFY userInfoChanged)
    Q_PROPERTY(QString errorMessage READ getErrorMessage NOTIFY errorMessageChanged)
    Q_PROPERTY(QString rtmpServerUrl READ getRtmpServerUrl NOTIFY rtmpServerUrlChanged)
    Q_PROPERTY(QString shareCode READ getShareCode NOTIFY shareCodeChanged)
    Q_PROPERTY(bool isStreamingActive READ getIsStreamingActive NOTIFY streamingStatusChanged)

public:
    VkServerController(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~VkServerController() = default;
    Q_INVOKABLE virtual void login(const QString& userName, const QString& password) = 0;
    Q_INVOKABLE virtual void logout() = 0;
    Q_INVOKABLE virtual void registerUser(const QString& userName, const QString& password, const QString& phone) = 0;
    Q_INVOKABLE virtual void changePassword(const QString& oldPassword, const QString& newPassword) = 0;
    Q_INVOKABLE virtual void requestKmlList() = 0;
    Q_INVOKABLE virtual void downloadKml(const QString& kmlUrl) = 0;
    Q_INVOKABLE virtual void requestRtmpPushUrl(const QString& droneId) = 0;
    Q_INVOKABLE virtual void requestPullStreamShareCode(const QString& droneId) = 0;
    Q_INVOKABLE virtual void updateDronePushStreamStatus(const QString& droneId) = 0;
    Q_INVOKABLE virtual void startPushStreamStatusSync(const QString& sn) = 0;
    Q_INVOKABLE virtual void stopPushStreamStatusSync() = 0;

protected:
    virtual bool getIsLogin() = 0;
    virtual bool getChangePasswordSuccess() = 0;
    virtual QList<KmlInfo> getKmlList() = 0;
    virtual bool getRegisterSuccess() = 0;
    virtual UserInfo getUserInfo() = 0;
    virtual QString getErrorMessage() = 0;
    virtual QString getRtmpServerUrl() = 0;
    virtual QString getShareCode() = 0;
    virtual bool getIsStreamingActive() = 0;

signals:
    void isLoginChanged(bool isLogin);
    void registerSuccessChanged();
    void changePasswordSuccessChanged();
    void kmlListChanged();
    void userInfoChanged();
    void errorMessageChanged();
    void rtmpServerUrlChanged();
    void shareCodeChanged();
    void streamingStatusChanged(bool isStreaming);
};
