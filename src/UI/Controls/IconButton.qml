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
        opacity: backgroundOpacity
        radius: 0
        
        // 悬停效果
        states: [
            State {
                name: "hovered"
                when: iconButton.hovered
                PropertyChanges {
                    target: iconButton.background
                    opacity: Math.max(backgroundOpacity, 0.1)
                }
            },
            State {
                name: "pressed"
                when: iconButton.pressed
                PropertyChanges {
                    target: iconButton.background
                    opacity: Math.max(backgroundOpacity, 0.2)
                }
            }
        ]
        
        transitions: Transition {
            PropertyAnimation {
                properties: "opacity"
                duration: 150
                easing.type: Easing.OutQuad
            }
        }
    }
    
    // 图标内容
    contentItem: Image {
        id: iconImage
        visible: iconButton.imageVisible && iconButton.imageSource !== ""
        source: iconButton.imageSource
        width: iconButton.imageSize
        height: iconButton.imageSize
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        
        // 禁用状态的视觉效果
        opacity: iconButton.enabled ? 1.0 : 0.3
        
        Behavior on opacity {
            PropertyAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }
        }
    }
    
    // 工具提示支持
    property string toolTipText: ""
    ToolTip.visible: toolTipText !== "" && hovered
    ToolTip.text: toolTipText
    ToolTip.delay: 1000
} 