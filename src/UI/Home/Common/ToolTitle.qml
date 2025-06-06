import QtQuick 2.15

import ScreenTools

// 标题组件，用于各个安装设置部分的标题显示
Item {
    id: toolTitle
    
    // 属性定义
    property real fontsize: 18
    property real textWidth: ScreenTools.defaultFontPixelWidth * 19.2
    property var textTitle: qsTr("飞控安装")
    
    // 布局设置
    width: parent.width
    height: ScreenTools.defaultFontPixelWidth * 7.2

    // 背景
    Rectangle {
        anchors.fill: parent
        color: "#00000000"
    }
    
    // 水平线
    Item {
        width: parent.width
        height: ScreenTools.defaultFontPixelWidth
        anchors.verticalCenter: parent.verticalCenter
        
        Rectangle {
            anchors.fill: parent
            border.width: 2
            border.color: "gray"
        }
    }
    
    // 标题文本
    Item {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        
        Rectangle {
            width: textWidth
            height: parent.height
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            
            Text {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                text: textTitle
                font.pointSize: fontsize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "gray"
            }
        }
    }
}
