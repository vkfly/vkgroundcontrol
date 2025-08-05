import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Controls
import VkSdkInstance
import ScreenTools

Rectangle {

    id: _root
    property bool isShowPassword: false
    property real fontSize: 20 * ScreenTools.scaleWidth
    property var userInfo: VkSdkInstance.vkServerController.userInfo
    color: "#f5f5f5"

    signal clickRegister()
    signal clickChangePassword()

    Grid {
        rows: 4
        rowSpacing: 36 * ScreenTools.scaleWidth
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 16 * ScreenTools.scaleWidth
        anchors.right: parent.right
        anchors.rightMargin: 16 * ScreenTools.scaleWidth

        RowLayout {
            width: parent.width
            spacing: 8
            Label {
                Layout.minimumWidth: 120 * ScreenTools.scaleWidth
                font.pixelSize: fontSize
                text: qsTr("用户名")
            }

            CustomTextEdit {
                id: userName
                Layout.fillWidth: true
                height: 48 * ScreenTools.scaleWidth
                fontSize: _root.fontSize
                placeholderText: qsTr("请输入手机号")
                text: userInfo.phone ? userInfo.phone : ""
                reg: /[1-9][0-9]+/
            }
        }

        RowLayout {
            width: parent.width
            spacing: 8 * ScreenTools.scaleWidth
            Label {
                Layout.minimumWidth: 120 * ScreenTools.scaleWidth
                font.pixelSize: fontSize
                text: qsTr("密码")
            }

            CustomTextEdit {
                id: password
                Layout.fillWidth: true
                height: 48 * ScreenTools.scaleWidth
                placeholderText: qsTr("请输入密码")
                fontSize: _root.fontSize
                echoMode: isShowPassword ? TextInput.Normal : TextInput.Password
                rightIcon: isShowPassword ? "/qmlimages/icon/eye_open.png" : "/qmlimages/icon/eye_close.png"
                reg: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$/
                onRightIconClick: {
                    isShowPassword = !isShowPassword
                }
            }
        }

        RowLayout {
            width: parent.width

            TextButton {
                Layout.alignment: Qt.AlignRight
                backgroundColor: "transparent"
                buttonText: qsTr("注册")
                pressedColor: "transparent"
                pressedTextColor: "orange"
                fontSize: _root.fontSize
                textColor: ScreenTools.titleColor
                onClicked: {
                    clickRegister()
                }
            }
        }

        Button {
            id:loginBtn
            enabled: userName.isValid
            width: parent.width    
            implicitHeight: 48 * ScreenTools.scaleWidth
            font.pixelSize: fontSize
            background: Rectangle {
                color: loginBtn.enabled ? ScreenTools.titleColor : "lightGray"
                radius: 8 * ScreenTools.scaleWidth
                Text {
                    id: txt
                    text: qsTr("登录")
                    anchors.centerIn: parent
                    color: loginBtn.enabled ? "white" : "black"
                    font.pixelSize: fontSize
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    VkSdkInstance.vkServerController.login(userName.text,password.text)
                }
            }
        }
    }

}
