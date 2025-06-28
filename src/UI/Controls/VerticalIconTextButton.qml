import QtQuick
import QtQuick.Controls
import VKGroundControl.Palette

import ScreenTools
// 按钮集合组件
Item {
    id: root

    // 属性定义
    property real fontSize: 25 * ScreenTools.scaleWidth
    property string text: qsTr("机型设置")
    property color unSelectedBackgroundColor: "lightgray"
    property color selectedBackgroundColor: "#00000000"
    property color selectedTextColor: qgcPal.titleColor
    property color unSelectedTextColor: "black"
    property bool isSelected: false
    property string iconSource: "/qmlimages/icon/left_arrow.png"
    property string selectedIconSource: "/qmlimages/icon/left_arrow.png"

    property real iconWidth: height * 0.6
    property real iconHeight: height * 0.6
    property real textWidth: width
    property real textHeight: height * 0.4
    property real spacing: 0

    width: parent.width
    height: parent.height

    // 信号定义
    signal clicked
    VKPalette { id: qgcPal; colorGroupEnabled: enabled }
    // 按钮实现
    Button {
        id: button
        width: parent.width
        height: parent.height

        background: Rectangle {
            anchors.fill: parent
            color: isSelected ? selectedBackgroundColor : unSelectedBackgroundColor

            Column {
                anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter
                spacing: root.spacing

                // 图标
                Image {
                    width: iconWidth
                    height: iconHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: isSelected ? selectedIconSource : iconSource
                }

                // 文本
                Text {
                    width: textWidth
                    height: textHeight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: fontSize
                    font.bold: false
                    text: root.text
                    color: isSelected ? selectedTextColor : unSelectedTextColor
                }
            }
        }

        onClicked: {
            root.clicked()
        }
    }
}
