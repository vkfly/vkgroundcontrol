#include "vkservercontrollerimpl.h"

VkServerControllerImpl::VkServerControllerImpl(QObject *parent)
{
    net = QSharedPointer<VkNet>::create(this);
    connect(net.data(), &VkNet::loginSuccess, this, [this](const UserInfo& userInfo) {
        this->userInfo = userInfo;
        isLogin = true;
        sgSender.start();
        emit userInfoChanged();
        emit isLoginChanged();
    });
    
    connect(net.data(), &VkNet::requestRtmpPushUrlSuccess, this, [this](const QString& rtmpUrl) {
        updateRtmpServerUrl(rtmpUrl);
    });
    
    connect(net.data(), &VkNet::requestShareCodeSuccess, this, [this](const QString& shareCode) {
        updateShareCode(shareCode);
    });
    
    connect(net.data(), &VkNet::requestRtmpPushUrlFailed, this, [this](const QString& message) {
        qDebug() << "Failed to get RTMP push URL:" << message;
    });
    
    connect(net.data(), &VkNet::requestShareCodeFailed, this, [this](const QString& message) {
        qDebug() << "Failed to get share code:" << message;
    });
    
    connect(net.data(), &VkNet::loginFailed, this, [this](const QString& message) {
        isLogin = false;
        errorMessage = message;
        emit errorMessageChanged();
        emit isLoginChanged();
    });
    connect(net.data(), &VkNet::registerSuccess, this, [this](const UserInfo& userInfo) {
        this->userInfo = userInfo;
        qDebug() << "registerSuccess" << userInfo.getPhone();
        registerSuccess = true;
        emit registerSuccessChanged();
        emit userInfoChanged();
    });

    connect(net.data(), &VkNet::registerFailed, this, [this](const QString& message) {
        registerSuccess = false;
        errorMessage = message;
        emit errorMessageChanged();
        emit registerSuccessChanged();
    });
    
    connect(net.data(), &VkNet::changePasswordSuccess, this, [this]() {
        changePasswordSuccess = true;
        emit changePasswordSuccessChanged();
    });

    connect(net.data(), &VkNet::changePasswordFailed, this, [this](const QString& message) {
        changePasswordSuccess = false;
        errorMessage = message;
        emit errorMessageChanged();
        emit changePasswordSuccessChanged();
    });

    connect(net.data(), &VkNet::requestKmlListSuccess, this, [this](const QList<KmlInfo>& kmlList) {
        this->kmlList = kmlList;
        emit kmlListChanged();
    });
    connect(net.data(), &VkNet::requestKmlListFailed, this, [this](const QString& message) {
        errorMessage = message;
        emit errorMessageChanged();
        emit kmlListChanged();
    });
}

VkServerControllerImpl::~VkServerControllerImpl()
{

}

void VkServerControllerImpl::updateRtmpServerUrl(const QString& rtmpUrl)
{
    this->rtmpServerUrl = rtmpUrl;
    emit rtmpServerUrlChanged();
}

void VkServerControllerImpl::updateShareCode(const QString& shareCode)
{
    this->shareCode = shareCode;
    emit shareCodeChanged();
}

void VkServerControllerImpl::login(const QString& userName, const QString& password)  
{
    isLogin = false;
    emit isLoginChanged();
    net->login(userName, password);
}

void VkServerControllerImpl::logout()
{
    isLogin = false;
    emit isLoginChanged();
    net->logout();
    sgSender.stop();
}

void VkServerControllerImpl::registerUser(const QString& userName, const QString& password, const QString& phone)
{
    registerSuccess = false;
    emit registerSuccessChanged();
    net->registerUser(userName, password, phone);
}

void VkServerControllerImpl::changePassword(const QString& oldPassword, const QString& newPassword)
{
    changePasswordSuccess = false;
    emit changePasswordSuccessChanged();
    net->changePassword(userInfo.getUserId(), oldPassword, newPassword);
}

void VkServerControllerImpl::requestKmlList()
{
    net->requestKmlList();
}

void VkServerControllerImpl::downloadKml(const QString& kmlUrl)
{
    net->downloadKml(kmlUrl);
}

void VkServerControllerImpl::requestRtmpPushUrl(const QString& droneId) {
    net->requestRtmpPushUrl(droneId);
}

void VkServerControllerImpl::requestPullStreamShareCode(const QString& droneId) {
    net->requestShareCode(droneId);
}

void VkServerControllerImpl::sendImu(const VehicleTelemetryData& info)
{
    sgSender.sendImu(info);
}

void VkServerControllerImpl::uploadMissionInfo(const MissonInfo& info)
{
    if(isLogin) {
        qDebug() << "uploadMissionInfo";
        net->uploadmissionInfo(userInfo.getUserId(),info);
    }
}

