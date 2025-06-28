import QtQuick
import QtQuick.Controls

import ScreenTools

import "../Common"

// 设备按钮组件
Item {
    id: deviceButton
    property string buttonText: ""
    property string iconSource: ""
    property string selectedIconSource: ""
    property var deviceInfos: []
    property var deviceInfoComponent: null

    signal clicked

    Rectangle {
        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: 30 * ScreenTools.scaleWidth
        color: button.pressed ? "lightgray" : "white"
    }

    Button {
        id: button
        width: parent.width
        height: parent.height
        background: Rectangle {
            color: "#00000000"
            Column {
                width: parent.width
                height: parent.height
                IconTitle {
                    id: infoComponent
                    height: parent.height
                    width: parent.width
                    iconSource: deviceButton.iconSource
                    selectedIconSource: deviceButton.selectedIconSource
                    btText: deviceButton.buttonText
                    deviceInfos: deviceButton.deviceInfos
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
        onClicked: deviceButton.clicked()
    }

    Component.onCompleted: {
        if (deviceInfoComponent) {
            deviceInfoComponent = infoComponent
        }
    }
}
