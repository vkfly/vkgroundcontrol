import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Controls
import VkSdkInstance

Popup {
    id: _root
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    width: 600
    height: 500
    closePolicy: Popup.NoAutoClose
    background: Rectangle {
        color: "#f5f5f5"
        border.color: "#ddd"
        border.width: 1
        radius: 8
    }

    enum ModuleType {
        Login,
        Register
    }
    property int moduleType: LoginRegisterPopup.ModuleType.Login
    property bool isLogin: VkSdkInstance.vkServerController.isLogin
    onIsLoginChanged: {
        if(isLogin) {
            close()
        }
    }
    Connections {
        target: VkSdkInstance.vkServerController
        function onErrorMessageChanged() {
            var errorMsg = VkSdkInstance.vkServerController.errorMessage
            toastComponent.showError(errorMsg)
        }
    }
    

    function getTitleName() {
        var titleName = ""
        switch (moduleType) {
        case LoginRegisterPopup.ModuleType.Login:
            titleName = qsTr("登录")
            break
        case LoginRegisterPopup.ModuleType.Register:
            titleName = qsTr("注册")
            break
        }
        return titleName
    }
    
    VKSetToolbar {
        id: vk_toolbar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        titleName: _root.getTitleName()
        onReturnLast: {
            close()
        }
    }
    
    Item {
        anchors.top: vk_toolbar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20

        Login {
            anchors.fill: parent
            visible: moduleType === LoginRegisterPopup.ModuleType.Login
            onClickRegister: {
                moduleType = LoginRegisterPopup.ModuleType.Register
            }
        }

        Register {
            anchors.fill: parent
            visible: moduleType === LoginRegisterPopup.ModuleType.Register
            onClickLogin: {
                moduleType = LoginRegisterPopup.ModuleType.Login
            }
        }
    }
    

    VKToast {
        id: toastComponent
        anchors.fill: parent
    }
}
