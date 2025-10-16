import QtQuick
import QtQuick.Controls
import ScreenTools

Button {
    id: iconButton

    // 公开属性
    property string imageSource: ""
    property real imageSize: 45 * ScreenTools.scaleWidth
    property bool imageVisible: true
    property color backgroundColor: "transparent"
    property real backgroundOpacity: 0.0
    property bool autoSize: true

    // 自动设置尺寸
    width: autoSize ? imageSize : implicitWidth
    height: autoSize ? imageSize : implicitHeight

    // 透明背景
    background: Rectangle {
        width: iconButton.width
        height: iconButton.height
        color: backgroundColor
        radius: 0
        Image {
            id: iconImage
            visible: iconButton.imageVisible && iconButton.imageSource !== ""
            source: iconButton.imageSource
            width: iconButton.imageSize
            height: iconButton.imageSize
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
        }
    }

    // 工具提示支持
    property string toolTipText: ""
    ToolTip.visible: toolTipText !== "" && hovered
    ToolTip.text: toolTipText
    ToolTip.delay: 1000
}
