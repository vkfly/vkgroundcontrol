import QtQuick
import QtQuick.Controls

import ScreenTools

Item {

    property real buttonFontSize: 25 * ScreenTools.scaleWidth
    property string btText: "机型设置"
    property color btTextColor: vkPal.titleColor
    property bool isSelected: false

    // 图标属性
    property url iconSource: "/qmlimages/icon/left_arrow.png"
    property url selectedIconSource: "/qmlimages/icon/left_arrow.png"

    property var deviceInfos: []

    width: parent.width
    height: parent.height

    // 点击信号
    signal btclick

    // 主按钮
    Button {
        id: button1
        enabled: false
        width: parent.width
        height: parent.height

        background: Rectangle {
            anchors.fill: parent
            color: isSelected ? "lightgray" : "#00000000"

            Column {
                width: parent.width
                height: parent.height

                // 标题和图标区域
                Row {
                    width: parent.width * 0.5
                    height: parent.height * 0.5
                    anchors.horizontalCenter: parent.horizontalCenter

                    // 图标容器
                    Item {
                        width: parent.width * 0.5
                        height: parent.width * 0.5
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            width: parent.width * 0.8
                            height: parent.width * 0.8
                            anchors.centerIn: parent
                            source: selectedIconSource
                        }
                    }

                    // 标题文本
                    Text {
                        width: parent.width * 0.5
                        height: parent.height - parent.width * 0.5
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: buttonFontSize
                        font.bold: false
                        text: btText
                        color: button1.pressed ? btTextColor : "black"
                    }
                }

                // 信息显示区域
                Row {
                    width: parent.width * 0.75
                    height: parent.height * 0.5
                    anchors.horizontalCenter: parent.horizontalCenter

                    // 信息文本列
                    Column {
                        width: parent.width * 0.95
                        height: parent.height

                        // 使用函数创建重复的信息项
                        Repeater {
                            model: deviceInfos
                            delegate: InfoItem {
                                width: parent.width
                                height: 30 * ScreenTools.scaleWidth
                                labelText: modelData.name
                                valueText: modelData.value
                            }
                        }
                    }

                    // 指示器列
                    Column {
                        width: parent.width * 0.05
                        height: parent.height
                        spacing: 0
                        // 使用函数创建重复的指示器项
                        Repeater {
                            model: deviceInfos
                            delegate: Item {
                                width: parent.width
                                height: 30 * ScreenTools.scaleWidth
                                StatusIndicator {
                                    visible: modelData.hasUpdate
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // 信息项组件
    component InfoItem: Item {
        property string labelText: ""
        property string valueText: ""
        property real fontSize: 16 * ScreenTools.scaleWidth

        Text {
            text: labelText
            font.bold: false
            font.pixelSize: fontSize
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            text: valueText
            font.bold: false
            font.pixelSize: fontSize
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    // 状态指示器组件
    component StatusIndicator: Item {
        width: 12 * ScreenTools.scaleWidth
        height: 12 * ScreenTools.scaleWidth

        Rectangle {
            width: parent.width
            height: parent.height
            color: "red"
            radius: width
            anchors.centerIn: parent
        }
    }

    // 为了访问根项目的属性
    id: root
}
