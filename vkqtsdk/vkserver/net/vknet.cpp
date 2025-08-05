#include "vknet.h"
#include <QDebug>
#include "../nlohmann/json.hpp"

using json = nlohmann::json;
using namespace nlohmann::literals;

VkNet::VkNet(QObject *parent)
    : QObject{parent}, httpClient(new HttpClient("http://sgcloud-test.jiagutech.com/api/")) {
    httpClient->header("Terminal-Type", "app")
    .debug(true);
}

void VkNet::setToken(const QString& token) {
    this->token = token;
    httpClient->header("Authorization", QString("Bearer %1").arg(token));
}

QString VkNet::handleErrorMessage(const QString& errorMsg) {
    json jsonMsg = json::parse(errorMsg.toStdString());
    return QString::fromStdString(jsonMsg["message"]);
}

void VkNet::login(const QString& userName, const QString& password) {           
    json loginInfo = {{"phone", userName.toStdString()}, {"password", password.toStdString()}};
    QString jsonUsr = QString::fromStdString(loginInfo.dump());
    httpClient->path("userServ/v1/login")
    .json(jsonUsr)
    .success([ = ](const QString & value) {
        json user = json::parse(value.toStdString());
        std::string token = user["data"]["accessToken"];
        setToken(QString::fromStdString(token));
        UserInfo userInfo(QString::fromStdString(user["extra"]["username"]), QString::fromStdString(user["extra"]["phone"]), QString::fromStdString(user["extra"]["id"]));
        emit loginSuccess(userInfo);
    }).fail([ = ](const QString & messge, int code) {
        emit loginFailed(messge);
    }).post();
}

void VkNet::logout() {
    setToken("");
}

void VkNet::registerUser(const QString& userName, const QString& password, const QString& phone) {
    json registerInfo = {{"username", userName.toStdString()}, {"password", password.toStdString()}, {"phone", phone.toStdString()}};
    QString jsonUsr = QString::fromStdString(registerInfo.dump());
    httpClient->path("userServ/v1/pilots")
    .json(jsonUsr)
    .success([ = ](const QString & value) {
        UserInfo userInfo("", phone, "");
        emit registerSuccess(userInfo);
    }).fail([ = ](const QString & messge, int code) {
        emit registerFailed(handleErrorMessage(messge));
    }).post();
}

void VkNet::changePassword(const QString& userId, const QString& oldPassword, const QString& newPassword) {
    json changeInfo = {{"oldPassword", oldPassword.toStdString()}, {"newPassword", newPassword.toStdString()}};
    QString jsonUsr = QString::fromStdString(changeInfo.dump());
    QString path = QString("userServ/v1/users/%1").arg(userId);
    httpClient->path(path)
    .json(jsonUsr)
    .success([ = ](const QString & value) {
        emit changePasswordSuccess();
    }).fail([ = ](const QString & messge, int code) {
        emit changePasswordFailed(messge);
    }).put();
}


void VkNet::requestKmlList() {
    httpClient->path("mainServ/v1/kmls")
    .success([ = ](const QString & value) {
        json res = json::parse(value.toStdString());
        QList<KmlInfo> kmlList;
        // if(res["data"].is_array()) {
        //     for(const json &j : res["data"]) {
        //         kmlList.append(KmlInfo(j));
        //     }
        // }
        emit requestKmlListSuccess(kmlList);
    }).fail([ = ](const QString & messge, int code) {
        emit requestKmlListFailed(messge);
    }).get();
}

void VkNet::downloadKml(const QString& kmlUrl) {
    HttpClient(kmlUrl).debug(true).fail([ = ](const QString & messge, int code) {
        emit downloadKmlFailed(messge);
    }).download([ = ](const QByteArray & data) {
        qDebug() << "download kml" << QString::fromLocal8Bit(data);
        emit downloadKmlSuccess(QString::fromLocal8Bit(data));
    });
}

void VkNet::uploadmissionInfo(const QString& userId, const MissonInfo& info) {
    json missionInfo = {{"sn", info.sn.toStdString()}, {"location", info.locaction.toStdString()},{"startTime", info.startTime}, {"endTime", info.endTime}, {"pilotId", userId.toStdString()}, {"type", info.type},{"comment", info.comment.toStdString()}};
    QString missionJson = QString::fromStdString(missionInfo.dump());
    httpClient->path("flightServ/v1/sorties")
    .json(missionJson)
    .success([ = ](const QString & value) {
        qDebug() << "upload mission info" << value;
    }).fail([ = ](const QString & messge, int code) {
       qDebug() << "upload mission info error" << messge;
    }).post();
}

void VkNet::requestRtmpPushUrl(const QString& droneId) {
    QString path = QString("flightServ/v1/drones/%1/pushStreamUrl").arg(droneId);
    httpClient->path(path)
    .success([ = ](const QString & value) {
        json response = json::parse(value.toStdString());
        QString rtmpUrl = QString::fromStdString(response["data"]);
        emit requestRtmpPushUrlSuccess(rtmpUrl);
    }).fail([ = ](const QString & message, int code) {
        emit requestRtmpPushUrlFailed(message);
    }).get();
}

void VkNet::requestShareCode(const QString& droneId) {
    QString path = QString("flightServ/v1/drones/%1/pullStreamUrl").arg(droneId);
    httpClient->path(path)
    .success([ = ](const QString & value) {
        json response = json::parse(value.toStdString());
        QString shareCode = QString::fromStdString(response["data"]);
        emit requestShareCodeSuccess(shareCode);
    }).fail([ = ](const QString & message, int code) {
        emit requestShareCodeFailed(message);
    }).get();
}
