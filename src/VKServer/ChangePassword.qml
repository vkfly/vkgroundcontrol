import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Controls
import VkSdkInstance
import ScreenTools

Rectangle {

    id: _root
    property bool isShowOldPassword: false
    property bool isShowNewPassword: false
    property bool changePasswordSuccess: VkSdkInstance.vkServerController.changePasswordSuccess
    property real fontSize: 20 * ScreenTools.scaleWidth
    color: "#f5f5f5"
    onChangePasswordSuccessChanged: {
        if (changePasswordSuccess) {
            clickLogin()
        }
    }

    signal clickLogin()

    Grid {
        rows: 4
        rowSpacing: 36 * ScreenTools.scaleWidth
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 160 * ScreenTools.scaleWidth
        anchors.right: parent.right
        anchors.rightMargin: 160 * ScreenTools.scaleWidth

        RowLayout {
            width: parent.width
            spacing: 8
            Label {
                Layout.minimumWidth: 80 * ScreenTools.scaleWidth
                font.pixelSize: fontSize
                text: qsTr("旧密码")
            }

            CustomTextEdit {
                id: oldPassword
                Layout.fillWidth: true
                height: 48 * ScreenTools.scaleWidth
                placeholderText: qsTr("请输入新密码")
                fontSize: _root.fontSize
                echoMode: isShowOldPassword ? TextInput.Normal : TextInput.Password
                rightIcon: isShowOldPassword ? "/qmlimages/icon/eye_open.png" : "/qmlimages/icon/eye_close.png"
                reg: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$/
                onRightIconClick: {
                    isShowOldPassword = !isShowOldPassword
                }
            }
        }

        RowLayout {
            width: parent.width
            spacing: 8 * ScreenTools.scaleWidth
            Label {
                Layout.minimumWidth: 80 * ScreenTools.scaleWidth
                font.pixelSize: fontSize
                text: qsTr("新密码")
            }

            CustomTextEdit {
                id: newPassword
                Layout.fillWidth: true
                height: 48 * ScreenTools.scaleWidth
                placeholderText: qsTr("请输入新密码")
                fontSize: _root.fontSize
                echoMode: isShowNewPassword ? TextInput.Normal : TextInput.Password
                rightIcon: isShowNewPassword ? "/qmlimages/icon/eye_open.png" : "/qmlimages/icon/eye_close.png"
                reg: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$/
                onRightIconClick: {
                    isShowNewPassword = !isShowNewPassword
                }
            }
        }

        RowLayout {
            width: parent.width

            TextButton {
                Layout.alignment: Qt.AlignRight
                backgroundColor: "transparent"
                buttonText: qsTr("登录")
                pressedColor: "transparent"
                pressedTextColor: "orange"
                fontSize: _root.fontSize
                textColor: ScreenTools.titleColor
                onClicked: {
                    clickLogin()
                }
            }
        }

        Button {
            id:loginBtn
            enabled: oldPassword.isValid && newPassword.isValid
            width: parent.width    
            implicitHeight: 48 * ScreenTools.scaleWidth
            font.pixelSize: fontSize
            background: Rectangle {
                color: loginBtn.enabled ? ScreenTools.titleColor : "lightGray"
                radius: 8 * ScreenTools.scaleWidth
                Text {
                    id: txt
                    text: qsTr("确认")
                    anchors.centerIn: parent
                    color: loginBtn.enabled ? "white" : "black"
                    font.pixelSize: fontSize
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    VkSdkInstance.vkServerController.changePassword(oldPassword.text,newPassword.text)
                }
            }
        }
    }

}
