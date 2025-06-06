import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VKGroundControl
import Controls
import ScreenTools

Flickable {
    id: root
    contentHeight: mainColumn.implicitHeight
    boundsBehavior: Flickable.StopAtBounds
    clip: true

    property color backgroundColor: ScreenTools.titleColor
    property bool isDianchi: false
    property real shuipingsudu: 10
    property real textWidth: 240 * ScreenTools.scaleWidth
    property real buttonFontSize: 30 * ScreenTools.scaleWidth
    property string fcuModelVersions: "V10Pro"
    property real widthText: 200 * ScreenTools.scaleWidth
    property real heightText: 30 * ScreenTools.scaleWidth
    property real fontSize: 18 * ScreenTools.bili_height
    property color fontColor: "white"

    property var appSettings: VKGroundControl.settingsManager.appSettings
    property int isUdp: 0

    Component.onCompleted: {
        isUdp = udpSettingsManager.getValue("udp/isopen", "0")
    }

    // === 可复用组件定义 ===
    component SettingSection: Item {
        property string title: ""
        property alias content: contentLoader.sourceComponent

        width: parent.width
        height: Math.max(60, contentColumn.implicitHeight)

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "white"
            border.width: 2
            radius: 30
        }

        Column {
            id: contentColumn
            width: parent.width
            spacing: 0
            // 标题区域
            Item {
                width: parent.width
                height: title ? 60 * ScreenTools.scaleWidth : 30 * ScreenTools.scaleWidth

                Text {
                    visible: title
                    anchors.centerIn: parent
                    text: title
                    font.pixelSize: buttonFontSize
                    color: fontColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // 内容区域
            Loader {
                id: contentLoader
                width: parent.width
            }

            // 底部间距
            Item {
                width: parent.width
                height: 30 * ScreenTools.scaleWidth
            }
        }
    }

    component SettingRow: Item {
        property string labelText: ""
        property alias content: contentLoader1.sourceComponent

        width: parent.width - 60 * ScreenTools.scaleWidth
        height: 60 * ScreenTools.scaleWidth
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: textWidth
            height: 60 * ScreenTools.scaleWidth
            text: labelText
            font.pixelSize: buttonFontSize * 5 / 6
            color: fontColor
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 320 * ScreenTools.scaleWidth
            height: 60 * ScreenTools.scaleWidth

            Loader {
                id: contentLoader1
                anchors.fill: parent
            }
        }
    }

    component CustomTextField: TextField {
        height: 50 * ScreenTools.scaleWidth
        font.pixelSize: buttonFontSize
        color: "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        background: Rectangle {
            color: "white"
            border.width: 1
            border.color: "black"
        }
    }

    // === 滚动内容区域 ===
    Column {
        id: mainColumn
        width: root.width * 0.98
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 30 * ScreenTools.scaleWidth

        // 页面标题
        Item {
            width: parent.width
            height: 60 * ScreenTools.scaleWidth

            Text {
                anchors.centerIn: parent
                text: qsTr("通用设置")
                font.pixelSize: buttonFontSize
                color: fontColor
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // 应用模式设置
        SettingSection {
            width: parent.width

            content: Column {
                width: parent.width
                SettingRow {
                    labelText: qsTr("应用模式")
                    content: GroupButton {
                        width: 320 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        names: fcuModelVersions === "V10Pro" ? [qsTr(
                                                                    "物流"), qsTr(
                                                                    "巡查"), qsTr(
                                                                    "集群")] : [qsTr(
                                                                                  "物流"), qsTr("巡查")]
                        selectedIndex: appSettings.applicationSetting.value
                        mainColor: root.backgroundColor
                        fontSize: buttonFontSize * 5 / 6
                        spacing: 3 * ScreenTools.scaleWidth
                        backgroundColor: "black"

                        onClicked: function (index) {
                            appSettings.applicationSetting.value = index
                        }
                    }
                }
            }
        }

        // 飞行设置
        SettingSection {
            width: parent.width
            content: Column {
                width: parent.width
                spacing: 30 * ScreenTools.scaleWidth

                SettingRow {
                    labelText: qsTr("飞行轨迹")

                    content: CustomComboBox {
                        width: 320 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        fontSize: buttonFontSize * 5 / 6
                        model: [qsTr("开启"), qsTr("关闭")]
                        currentIndex: mainWindow.isguiji === false ? 1 : 0
                        onActivated: {

                            // 处理飞行轨迹设置
                        }
                    }
                }

                SettingRow {
                    labelText: qsTr("定位模式")

                    content: CustomComboBox {
                        width: 320 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        fontSize: buttonFontSize * 5 / 6
                        model: [qsTr("普通GPS"), qsTr("北斗")]
                        currentIndex: mainWindow.isbeidou === true ? 1 : 0
                        onActivated: {

                            // 处理定位模式设置
                        }
                    }
                }
            }
        }

        // 系统设置
        SettingSection {
            width: parent.width
            content: Column {
                width: parent.width
                spacing: 30 * ScreenTools.scaleWidth

                SettingRow {
                    labelText: qsTr("语言设置")

                    content: CustomComboBox {
                        id: languageCombo
                        width: 320 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        fontSize: buttonFontSize * 5 / 6
                        onActivated: {
                            VKGroundControl.settingsManager.appSettings.qLocaleLanguage.value
                                    = VKGroundControl.settingsManager.appSettings.qLocaleLanguage.enumValues[index]
                        }
                    }
                }

                SettingRow {
                    labelText: qsTr("语音设置")

                    content: CustomComboBox {
                        width: 320 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        fontSize: buttonFontSize * 5 / 6
                        model: [qsTr("开启"), qsTr("关闭")]
                        onActivated: {

                            // 处理语音设置
                        }
                    }
                }

                SettingRow {
                    labelText: qsTr("地图提供商")

                    content: CustomComboBox {
                        id: mapProviderCombo
                        width: 320 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        fontSize: buttonFontSize * 5 / 6
                        onActivated: {
                            VKGroundControl.settingsManager.flightMapSettings.mapProvider.value
                                    = textAt(index)
                            VKGroundControl.settingsManager.flightMapSettings.mapType.value
                                    = VKGroundControl.mapEngineManager.mapTypeList(
                                        textAt(index))[0]
                        }
                        Component.onCompleted: {
                            var index = find(_mapProvider)
                            if (index < 0)
                                index = 0
                            currentIndex = index
                        }
                    }
                }

                SettingRow {
                    labelText: qsTr("地图类型")

                    content: CustomComboBox {
                        id: mapTypeCombo
                        width: 320 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        fontSize: buttonFontSize * 5 / 6
                        onActivated: {
                            VKGroundControl.settingsManager.flightMapSettings.mapType.value
                                    = textAt(index)
                        }
                        Component.onCompleted: {
                            var index = find(_mapType)
                            if (index < 0)
                                index = 0
                            currentIndex = index
                        }
                    }
                }
            }
        }

        // UDP设置
        SettingSection {
            width: parent.width

            content: Column {
                width: parent.width
                spacing: 30 * ScreenTools.scaleWidth

                SettingRow {
                    labelText: qsTr("UDP数据转发")

                    content: CustomComboBox {
                        id: udpCombo
                        width: 320 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        fontSize: buttonFontSize * 5 / 6
                        model: [qsTr("开启"), qsTr("关闭"), qsTr("气象")]
                        onActivated: {
                            udpSettingsManager.setValue("udp/isopen", index)
                            isUdp = index
                        }
                    }
                }

                SettingRow {
                    visible: isUdp !== 1
                    labelText: qsTr("转发IP")

                    content: CustomTextField {
                        id: forwardIpField
                        onEditingFinished: {

                            // 处理IP设置
                        }
                    }
                }

                SettingRow {
                    visible: isUdp !== 1
                    labelText: qsTr("转发端口")

                    content: CustomTextField {
                        id: forwardPortField
                        onTextChanged: {
                            udpSettingsManager.setValue("udp/port",
                                                        text.toString())
                        }
                        onEditingFinished: {
                            udpSettingsManager.setValue("udp/port",
                                                        text.toString())
                        }
                    }
                }

                SettingRow {
                    visible: isUdp !== 1
                    labelText: qsTr("接收IP")

                    content: CustomTextField {
                        id: receiveIpField
                        onEditingFinished: {

                            // 处理接收IP设置
                        }
                    }
                }

                // 气象控制
                SettingRow {
                    visible: isUdp === 2
                    labelText: qsTr("气象控制")

                    content: Row {
                        spacing: 1 * ScreenTools.scaleWidth

                        TextButton {
                            width: 106 * ScreenTools.scaleWidth
                            height: 50 * ScreenTools.scaleWidth
                            buttonText: qsTr("开启")
                            onClicked: {
                                ctlmsg.text_slider = qsTr("仪器开启")
                                ctlmsg.ctl_id = 18
                                ctlmsg.open()
                            }
                        }

                        TextButton {
                            width: 106 * ScreenTools.scaleWidth
                            height: 50 * ScreenTools.scaleWidth
                            buttonText: qsTr("关闭")
                            onClicked: {
                                ctlmsg.text_slider = qsTr("仪器关闭")
                                ctlmsg.ctl_id = 19
                                ctlmsg.open()
                            }
                        }

                        TextButton {
                            width: 106 * ScreenTools.scaleWidth
                            height: 50 * ScreenTools.scaleWidth
                            buttonText: qsTr("采样")
                            onClicked: {
                                ctlmsg.text_slider = qsTr("仪器采样")
                                ctlmsg.ctl_id = 20
                                ctlmsg.open()
                            }
                        }
                    }
                }
            }
        }
    }
}
