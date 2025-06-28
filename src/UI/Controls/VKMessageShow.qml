import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VKGroundControl
import VKGroundControl.Palette
import VkSdkInstance

CustomPopup {
    id: messagePopup
    contentWidth: popupWidth
    contentHeight: contentColumn.height

    // === 配置属性 (驼峰命名风格) ===
    property int planeType: 0
    property int gyroFilterId: -1
    property int accelFilterId: -1
    property real throttleValue: 0.05
    property int installId: -1
    property int valueType: -1
    property int value: -1
    property int rtkInstallId: -1
    property int escId: -1
    property string parameter: ""
    property int parameterY: 0
    property int selectedImage: 0
    property string sendId: "AIRFRAME1"
    property int buttonOpenValue: 0
    property var logController

    property var _activeVehicle: VkSdkInstance.vehicleManager.activeVehicle //TODO暂时这么处理，可以用activevehicle

    // === 显示内容属性 ===
    property string messageText: ""
    property string imageText: ""
    property string imageSource: ""
    property string warningText: qsTr("请注意螺旋桨转动方向！")
    
    // === 样式属性 ===
    property int fontSize: 30 * sw
    property int popupWidth: 400
    property int popupHeight: 200
    property int messageType: 1 // 0: 纯文本, 1: 带按钮消息, 2: 图片消息
    property int textAlignment: 0 // 0: 居中, 1: 左对齐
    property int textLeftMargin: 15
    property string buttonFontColor: "white"
    property var mainColor: qgcPal.titleColor

    VKPalette { id: qgcPal }

    // === 主要内容区域 ===
    ColumnLayout {
        id: contentColumn
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0

        // 文本消息显示
        Text {
            visible: messageType === 0 || messageType === 1
            text: messageText
            Layout.fillWidth: true
            Layout.preferredHeight: 130 * sw
            Layout.leftMargin: textAlignment === 1 ? textLeftMargin : 0
            Layout.rightMargin: textAlignment === 1 ? textLeftMargin : 0
            
            horizontalAlignment: textAlignment === 0 ? Text.AlignHCenter : Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: fontSize
            wrapMode: Text.Wrap
        }

        // 图片显示区域
        Item {
            visible: messageType === 2
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: popupWidth / 2
            Layout.preferredHeight: popupWidth / 2
            
            Image {
                id: displayImage
                anchors.fill: parent
                source: imageSource
                fillMode: Image.PreserveAspectFit
            }
        }

        // 图片说明文本
        Text {
            visible: messageType === 2
            text: imageText
            Layout.fillWidth: true
            Layout.preferredHeight: 60 * sw
            
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: fontSize
        }

        // 警告提示文本
        Text {
            visible: messageType === 2
            text: warningText
            Layout.fillWidth: true
            Layout.preferredHeight: 60 * sw
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: fontSize
            color: "red"
            font.bold: true
        }

        // 按钮操作区域
        RowLayout {
            visible: messageType === 1 || messageType === 2
            Layout.fillWidth: true
            spacing: 0
            
            // 取消按钮
            TextButton {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredHeight: 60 * sw
                buttonText: qsTr("取消")
                fontSize: fontSize
                backgroundColor: "#808080"
                textColor: buttonFontColor
                pressedColor: "#808080"
                cornerRadius: 0
                borderWidth: 0
                onClicked: messagePopup.close()
            }

            // 确认按钮
            TextButton {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredHeight: 60 * sw
                buttonText: qsTr("确认")
                fontSize: fontSize
                backgroundColor: mainColor
                textColor: buttonFontColor
                cornerRadius: 0
                borderWidth: 0
                onClicked: handleConfirmAction()
            }
        }
    }

    // === 确认操作处理函数 ===
    function handleConfirmAction() {
        switch (sendId) {
            case "Enterab":
                handleEnterAbMode()
                break
            case "Enterduodian":
                handleEnterMultiPointMode()
                break
            case "close":
                mainWindow.finishCloseProcess()
                break
            case "VOLT_PROT_CH":
                handleVoltageProtection()
                break
            case "clearall":
                handleClearAllLogs()
                break
            case "AIRFRAME":
                handleAirframeParameter()
                break
        }

        // 处理通用参数设置
        if (parameterY === 1) {
            handleGenericParameter()
        }

        messagePopup.close()
    }

    // === 私有辅助函数 ===
    function handleEnterAbMode() {
        settings.applicationSetting = 0
        mainWindow.applicationSettingId = 11
        flyView.missionModel.clear()
        flyView.missionModel.setwptMode(111)
        settings.applicationSettingId = 11
    }

    function handleEnterMultiPointMode() {
        settings.applicationSetting = 0
        mainWindow.applicationSettingId = 12
        flyView.missionModel.clear()
        flyView.missionModel.setwptMode(121)
        settings.applicationSettingId = 12
    }

    function handleVoltageProtection() {
        if (_activeVehicle) {
            _activeVehicle.sendEscIndex(escId)
        }
    }

    function handleClearAllLogs() {
        if (_activeVehicle) {
            _activeVehicle.eraseAll()
        }
    }

    function handleAirframeParameter() {
        if (_activeVehicle) {
            _activeVehicle.setParam("AIRFRAME", planeType)
        }
    }

    function handleGenericParameter() {
        if (_activeVehicle) {
            _activeVehicle.setParam(parameter, value)
        }
    }
}
