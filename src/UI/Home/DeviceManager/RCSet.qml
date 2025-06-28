import QtQuick
import QtQuick.Controls
import Qt.labs.settings

import VKGroundControl
import ScreenTools
import VkSdkInstance 1.0

Flickable {
    // UI related properties
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5 / 6
    property real buttonWidth: 300 * ScreenTools.scaleWidth
    property real buttonHeight: 140 * ScreenTools.scaleWidth
    property real marginLeftRight: 60 * ScreenTools.scaleWidth
    property real spacingWidth: 60 * ScreenTools.scaleWidth
    //property var buttonMainColor: mainWindow.titlecolor
    property string buttonMainColor: ScreenTools.titleColor
    property string buttonTextColor: "white"
    property int attitudeMode: 0


    property var _rcSettings: VKGroundControl.settingsManager.appSettings.rcSetting
    property var activeVehicle:VkSdkInstance.vehicleManager.activeVehicle
    property var _rcChannels:VkSdkInstance.vehicleManager.activeVehicle.rcChannels

    height: parent.height
    width: parent.width
    clip: true
    contentHeight: mainColumn.implicitHeight

    RCAdjuster{
        width: 800 * ScreenTools.scaleWidth
        id:rcAdjuster
        anchors.centerIn: parent
    }

    Column {
        id: mainColumn
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter

        // Spacing item
        Item {
            width: parent.width
            height: 50 * ScreenTools.scaleWidth
        }

        // RC control panel
        Item {
            width: parent.width
            height: parent.width * 0.5 * 0.67
            Rectangle {
                width: parent.width
                height: parent.height
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: rcControlPanel
                width: parent.width
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    width: parent.width
                    height: parent.height
                    Item {
                        width: parent.width * 2 / 3 - 2
                        height: parent.height
                        RCModel {
                            height: parent.height
                            width: parent.width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Item {
                        width: 2
                        height: parent.height
                        Rectangle {
                            width: parent.width
                            height: rcControlPanel.height
                            color: "gray"
                        }
                    }
                    Item {
                        width: parent.width * 1 / 3
                        height: rcControlPanel.height

                        Column {
                            width: parent.width
                            height: 170 * ScreenTools.scaleWidth
                            anchors.verticalCenter: parent.verticalCenter

                            Row {
                                width: parent.width * 0.9
                                height: 60 * ScreenTools.scaleWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 2
                                Button {
                                    id: modeUsButton
                                    width: parent.width * 0.5 - 1
                                    height: parent.height
                                    onClicked: {
                                        _rcSettings.value = 0
                                    }
                                    background: Rectangle {
                                        anchors.fill: parent
                                        radius: 10
                                        Rectangle {
                                            id: rightRect
                                            anchors.fill: parent
                                            radius: 10
                                            height: parent.height
                                            color: modeUsButton.pressed ? "gray" : (_rcSettings.value === 0 ? buttonMainColor : "gray")
                                        }
                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            text: qsTr("美国手")
                                            font.pixelSize: buttonFontSize
                                            color: "white"
                                            font.bold: false
                                        }
                                        color: "#00000000"
                                    }
                                }
                                Button {
                                    id: modeJpButton
                                    width: parent.width * 0.5 - 1
                                    height: parent.height
                                    onClicked: {
                                        _rcSettings.value = 1
                                    }
                                    background: Rectangle {
                                        anchors.fill: parent
                                        radius: 10
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 10
                                            height: parent.height
                                            color: modeJpButton.pressed ? "gray" : (_rcSettings.value === 1 ? buttonMainColor : "gray")
                                        }
                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            text: qsTr("日本手")
                                            font.pixelSize: buttonFontSize
                                            color: "white"
                                            font.bold: false
                                        }
                                        color: "#00000000"
                                    }
                                }
                            }
                            Item {
                                width: parent.width
                                height: 50 * ScreenTools.scaleWidth
                            }
                            Row {
                                width: parent.width * 0.9
                                height: 60 * ScreenTools.scaleWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 2
                                Button {
                                    id: calibrateButton
                                    width: parent.width
                                    height: parent.height
                                    onClicked: {
                                        if (_rcSettings.value === 1) {
                                            rcAdjuster.controllerMode = 1
                                        }
                                        if (_rcSettings.value === 0) {
                                            rcAdjuster.controllerMode = 0
                                        }
                                        rcAdjuster.open()
                                    }
                                    background: Rectangle {
                                        anchors.fill: parent
                                        radius: 10
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 10
                                            height: parent.height
                                            color: calibrateButton.pressed ? "gray" : buttonMainColor
                                        }
                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            text: qsTr("遥控器校准")
                                            font.pixelSize: buttonFontSize
                                            color: "white"
                                            font.bold: false
                                        }
                                        color: "#00000000"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Spacing item
        Item {
            width: parent.width
            height: 50 * ScreenTools.scaleWidth
        }

        // Remote control channels display
        Item {
            width: parent.width
            height: 410 * ScreenTools.scaleWidth
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Row {
                width: parent.width
                height: parent.height
                Column {
                    width: parent.width / 2
                    Item {
                        width: parent.width
                        height: 20 * ScreenTools.scaleWidth
                    }

                    RemoteBar {
                        remoteBarName: "5"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ? _rcChannels.rcChannelsRaw[4] : ""
                        remoteBarLeftName: attitudeMode === 0 ? qsTr("") : qsTr("姿态")
                        remoteBarCenterName: mainWindow.dingweimode === "beidou" ? qsTr("北斗") : qsTr("GNSS")
                        remoteBarRightName: qsTr("自动悬停")
                    }
                    RemoteBar {
                        remoteBarName: "6"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ?  _rcChannels.rcChannelsRaw[5] : ""
                        remoteBarLeftName: qsTr("待命")
                        remoteBarRightName: qsTr("返航")
                    }
                    RemoteBar {
                        remoteBarName: "7"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ?  _rcChannels.rcChannelsRaw[6] : ""
                    }
                    RemoteBar {
                        remoteBarName: "8"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ?  _rcChannels.rcChannelsRaw[7] : ""
                    }
                    RemoteBar {
                        remoteBarName: "9"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ? _rcChannels.rcChannelsRaw[8] : ""
                    }
                    RemoteBar {
                        remoteBarName: "10"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ? _rcChannels.rcChannelsRaw[9] : ""
                    }
                }
                Column {
                    width: parent.width / 2
                    Item {
                        width: parent.width
                        height: 20 * ScreenTools.scaleWidth
                    }

                    RemoteBar {
                        remoteBarName: "11"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ? _rcChannels.rcChannelsRaw[10] : ""
                    }
                    RemoteBar {
                        remoteBarName: "12"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ? _rcChannels.rcChannelsRaw[11] : ""
                    }
                    RemoteBar {
                        remoteBarName: "13"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ? _rcChannels.rcChannelsRaw[12] : ""
                    }
                    RemoteBar {
                        remoteBarName: "14"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ? _rcChannels.rcChannelsRaw[13] : ""
                    }
                    RemoteBar {
                        remoteBarName: "15"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ? _rcChannels.rcChannelsRaw[14] : ""
                    }
                    RemoteBar {
                        remoteBarName: "16"
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoteValue: activeVehicle ? _rcChannels.rcChannelsRaw[15] : ""
                    }
                }
            }
            Item {
                width: parent.width
                height: parent.height - 20 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Bottom spacing
        Item {
            width: parent.width
            height: 30 * ScreenTools.scaleWidth
        }
    }
}
