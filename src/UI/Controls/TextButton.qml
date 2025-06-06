import QtQuick 2.15
import QtQuick.Controls 2.15

import ScreenTools

Button {
    id: textButton
    property string buttonText: ""
    property real fontSize: 25 * ScreenTools.scaleWidth
    property color backgroundColor: "white"
    property color disabledBackgroundColor: "#f0f0f0"
    property color textColor: "black"
    property color disabledTextColor: "#888888"
    property color borderColor: "#e0e0e0"
    property real borderWidth: 0
    property real cornerRadius: 10

    property color pressedColor: ScreenTools.titleColor
    property color pressedTextColor: "white"

    // Custom background
    background: Rectangle {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: textButton.enabled ? textButton.pressed ? pressedColor : textButton.backgroundColor : textButton.disabledBackgroundColor
        radius: textButton.cornerRadius
        border.color: textButton.borderColor
        border.width: textButton.borderWidth
    }

    // 自定义内容
    contentItem: Text {
        anchors.fill: parent
        text: textButton.buttonText
        font.pixelSize: textButton.fontSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: textButton.enabled ? textButton.pressed ? textButton.pressedTextColor : textButton.textColor : textButton.disabledTextColor
    }

    // 移除默认内边距
    padding: 0
}
