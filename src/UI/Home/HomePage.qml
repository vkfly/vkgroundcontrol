import QtQuick
import QtQuick.Controls

import VKGroundControl
import VKGroundControl.Palette
import Controls
import ScreenTools

import VkSdkInstance 1.0

import "DeviceManager"
import "FactorySettings"
import "LinkSettings"

Item {

    id: _root
    enum ModuleType {
        None,
        DataPlayback,    // 数据回放
        OfflineMap,      // 离线地图
        FactorySettings, // 工厂设置
        DeviceManagement, // 设备管理
        LinkSelect  // 连接选择
    }

    property var buttonMain: vkPal.titleColor
    property string buttonTextColor: "white"
    property string factoryVerManager: ""
    property bool linkSelect: false
    property int moduleType: HomePage.ModuleType.None
    property real fontSize: 30 * sw
    property var _activeVehicle: VkSdkInstance.vehicleManager.activeVehicle

    signal clickSend(var msg, var id)
    signal goToFlyPage

    VKPalette {
        id: vkPal
    }


    Item {
        id: mainView
        anchors.fill: parent

        Image {
            anchors.fill: parent
            source: "/qmlimages/icon/background.jpg"
        }

        TextButton {
            anchors.top: parent.top
            anchors.topMargin: 60 * sw
            anchors.right: parent.right
            anchors.rightMargin: 60 * sw
            backgroundColor: "red"
            textColor: "white"
            buttonText: qsTr("退出")
            fontSize: _root.fontSize
            leftPadding: 16 * ScreenTools.scaleWidth
            rightPadding: 16 * ScreenTools.scaleWidth
            topPadding: 8 * ScreenTools.scaleWidth
            bottomPadding: 8 * ScreenTools.scaleWidth
            cornerRadius: 8 * ScreenTools.scaleWidth
            onClicked: {
                mainWindow.close()
            }
        }

        IconTextButton {
            showBorder: false
            anchors.horizontalCenter: flyButton.horizontalCenter
            anchors.bottom: flyButton.top
            backgroundColor: "transparent"
            text: _activeVehicle && _activeVehicle.isConnected ? qsTr("已连接") : qsTr("未连接")
            pixelSize: fontSize * 0.8
            textColor: _activeVehicle && _activeVehicle.isConnected ? vkPal.titleColor : "red"
            showHighlight: false
            onClicked: {
                if(ScreenTools.isAndroid) {
                    return
                }
                if (!_activeVehicle) {
                    moduleType = HomePage.ModuleType.LinkSelect
                }
            }
        }

        Column {
            spacing: ScreenTools.scaleWidth * 30
            anchors.left: parent.left
            anchors.leftMargin: ScreenTools.scaleWidth * 60
            anchors.bottom: parent.bottom
            anchors.bottomMargin: ScreenTools.scaleWidth * 60
            Row {
                spacing: ScreenTools.scaleWidth * 60
                // IconTextButton {
                //     id: rePlayButton
                //     visible: Qt.platform.os !== "android"
                //     showBorder: false
                //     height: ScreenTools.defaultFontPixelWidth * 15
                //     backRadius: ScreenTools.defaultFontPixelWidth * 5
                //     backgroundColor: "#60000000"
                //     text: qsTr("数据回放")
                //     pixelSize: fontSize
                //     iconWidth: ScreenTools.defaultFontPixelWidth * 6
                //     leftPadding: ScreenTools.defaultFontPixelWidth * 6
                //     rightPadding: ScreenTools.defaultFontPixelWidth * 6
                //     textColor: "white"
                //     iconSource: "/qmlimages/icon/replay.png"
                //     onClicked: {

                //         // mainWindow.isreplay = !mainWindow.isreplay
                //     }
                // }

                // IconTextButton {
                //     id: offlineMapButton
                //     visible: Qt.platform.os !== "android"
                //     showBorder: false
                //     height: ScreenTools.defaultFontPixelWidth * 15
                //     backRadius: ScreenTools.defaultFontPixelWidth * 5
                //     backgroundColor: offlineMapButton.pressed ? "gray" : "#60000000"
                //     text: qsTr("离线地图")
                //     pixelSize: fontSize
                //     iconWidth: ScreenTools.defaultFontPixelWidth * 6
                //     leftPadding: ScreenTools.defaultFontPixelWidth * 6
                //     rightPadding: ScreenTools.defaultFontPixelWidth * 6
                //     textColor: "white"
                //     iconSource: "/qmlimages/icon/map_type.png"
                //     onClicked: {

                //         // mainWindow.isreplay = !mainWindow.isreplay
                //         // mainWindow.windowState = 20
                //         // clickSend(qsTr("离线地图"), 0)
                //     }
                // }
            }
            Row {
                spacing: 60 * ScreenTools.scaleWidth
                IconTextButton {
                    id: deviceManagerButton
                    // visible: Qt.platform.os !== "android"
                    showBorder: false
                    height: 120 * ScreenTools.scaleWidth
                    backRadius: 30 * ScreenTools.scaleWidth
                    backgroundColor: deviceManagerButton.pressed ? "gray" : "#60000000"
                    text: qsTr("设备管理")
                    pixelSize: fontSize
                    iconWidth: 36 * ScreenTools.scaleWidth
                    leftPadding: 36 * ScreenTools.scaleWidth
                    rightPadding: 36 * ScreenTools.scaleWidth
                    textColor: "white"
                    iconSource: "/qmlimages/icon/driveset.png"
                    onClicked: {
                        moduleType = HomePage.ModuleType.DeviceManagement
                        // if (_activeVehicle) {
                        //     _activeVehicle.sendversion()
                        //     _activeVehicle.getcompoidversion()
                        //     _activeVehicle.requestlist()
                        // }
                    }
                }

                IconTextButton {
                    id: factoryButton
                    // visible: Qt.platform.os !== "android"
                    showBorder: false
                    height: 120 * ScreenTools.scaleWidth
                    backRadius: 30 * ScreenTools.scaleWidth
                    backgroundColor: factoryButton.pressed ? "gray" : "#60000000"
                    text: qsTr("工厂模式")
                    pixelSize: fontSize
                    iconWidth: 36 * ScreenTools.scaleWidth
                    leftPadding: 36 * ScreenTools.scaleWidth
                    rightPadding: 36 * ScreenTools.scaleWidth
                    textColor: "white"
                    iconSource: "/qmlimages/icon/factory_set.png"
                    onClicked: {
                        if (mainWindow.isgongchang === false) //工厂模式密码
                        {
                            vkPasswordmsg.open()
                        } else {
                            moduleType = HomePage.ModuleType.FactorySettings
                            // clickSend(qsTr("工厂模式"), 10)
                            // if (_activeVehicle)
                            //     _activeVehicle.requestlist()
                        }
                    }
                }
            }
        }

        IconTextButton {
            id: flyButton
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 60 * sw
            showBorder: false
            anchors.right: parent.right
            anchors.rightMargin: 60 * sw
            height: 120 * sw
            leftPadding: 36 * sw
            rightPadding: 36 * sw
            backRadius: 30 * sw
            backgroundColor: flyButton.pressed ? "gray" : buttonMain
            text: qsTr("进入飞行页面")
            pixelSize: fontSize
            textColor: "white"
            onClicked: {
                //if (_activeVehicle)
                    //_activeVehicle.requestlist()
                goToFlyPage()
            }
        }
    }

    LinkSelect {
        width: 600 * sw
        height: parent.height
        id: linkSelect
        anchors.right: parent.right
        visible: moduleType == HomePage.ModuleType.LinkSelect
        onGoToMain: {
            moduleType = HomePage.ModuleType.None
        }
    }

    FactorySettings {
        anchors.fill: parent
        visible: moduleType == HomePage.ModuleType.FactorySettings
        onGoToMain: {
            moduleType = HomePage.ModuleType.None
        }
    }

    DeviceManager {
        anchors.fill: parent
        visible: moduleType == HomePage.ModuleType.DeviceManagement
        onGoToMain: {
            moduleType = HomePage.ModuleType.None
        }
    }

}
