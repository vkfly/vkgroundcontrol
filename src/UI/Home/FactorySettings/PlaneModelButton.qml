import QtQuick
import QtQuick.Controls

import ScreenTools
import Controls

/**
 * 飞机模型按钮组件
 * 用于显示和选择不同类型的多旋翼飞机模型按钮
 */
Item {
    id: modelButtonItem
    property int planeTypeValue: 0
    property string iconSource: ""
    property string rotationInfo: ""
    property int currentPlaneType: 0

    // 信号：当按钮被点击时发出
    signal buttonClicked(int planeType, string rotationInfo, string iconSource)

    Button {
        width: parent.width
        height: parent.width
        background: Rectangle {

        }
        onClicked: {
            //buttonClicked(planeTypeValue, rotationInfo, iconSource)
            messageboxs.imageSource = iconSource
            messageboxs.planeType = planeTypeValue
            messageboxs.sendId = "AIRFRAME"
            messageboxs.messageType = 2
            messageboxs.parameterY = 0
            messageboxs.open()
        }
        Image {
            width: parent.width
            height: parent.width
            source: iconSource
        }
    }

    Rectangle {
        width: parent.width
        height: parent.width
        color: "transparent"
        border.color: currentPlaneType === planeTypeValue ? "#0bff05" : "transparent"
        radius: 8
        border.width: 1
    }
}
