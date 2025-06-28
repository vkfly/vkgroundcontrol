import QtQuick

import VKGroundControl
import ScreenTools
Item {

    id: remoterView
    width: parent.width
    height: parent.height

    property var mainColor: ScreenTools.titleColor
    property int remoterXValue: 1500 //1000-2000
    property int remoterYValue: 1500
    property int itemWidth: remoterView.width
    property int itemHeight: remoterView.height
    property real fontSize: 25 * sw
    property int sensorRadius: 15 * sw
    property bool showLeft: true
    property bool showJapan: true

    Item {
        width: itemWidth / 4
        height: 40 * sw
        anchors.verticalCenter: parent.verticalCenter
        Text {
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: fontSize
            text: (showLeft) ? (showJapan ? qsTr("左转") : qsTr(
                                                "左转")) : (showJapan ? qsTr("左移") : qsTr(
                                                                          "左移"))
            color: "gray"
        }
    }

    Item {
        width: itemWidth / 4
        height: 40 * sw
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        Text {
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: fontSize
            text: (showLeft) ? (showJapan ? qsTr("右转") : qsTr(
                                                "右转")) : (showJapan ? qsTr("右移") : qsTr(
                                                                          "右移"))
            color: "gray"
        }
    }
    Item {
        width: itemWidth / 4
        height: itemWidth / 4
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: fontSize
            //text:"上"
            text: (showLeft) ? (showJapan ? qsTr("上升") : qsTr(
                                                "前进")) : (showJapan ? qsTr("前进") : qsTr(
                                                                          "上升"))

            color: "gray"
        }
    }
    Item {
        width: itemWidth / 4
        height: itemWidth / 4
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: fontSize
            text: (showLeft) ? (showJapan ? qsTr("下降") : qsTr(
                                                "后退")) : (showJapan ? qsTr("后退") : qsTr(
                                                                          "下降"))

            color: "gray"
        }
    }

    Rectangle {
        x: remoterView.x + 0 // 位于父窗体的x位置，以左上角为起点，缺省为0
        y: remoterView.y + 0 // 位于父窗体的y位置，以左上角为起点，缺省为0
        width: itemWidth // 宽度，此时Rectangle控件在Window控件内，属于Window的孩子，可以使用parent继承
        height: itemWidth // 高度，此时Rectangle控件在Window控件内，属于Window的孩子，可以使用parent
        color: (remoterXValue < 1000 || remoterXValue > 2000
                || remoterYValue < 1000
                || remoterYValue > 2000) ? "#00000000" : "#00000000" // 颜色，缺省为白色
        opacity: 0.95 // 透明度，缺省为1
        radius: itemWidth / 2 // 圆角，通过圆角来画出一个圆形窗体出来
        border.width: 2 * sw
        border.color: "black"
        clip: true // 截断，在Rectangle控件内的子控件，超出他本身大小后会被截断
    }

    Rectangle {
        x: remoterView.x + itemWidth * 0.25 // 位于父窗体的x位置，以左上角为起点，缺省为0
        y: remoterView.y + itemWidth * 0.25 // 位于父窗体的y位置，以左上角为起点，缺省为0
        width: itemWidth * 0.5 // 宽度，此时Rectangle控件在Window控件内，属于Window的孩子，可以使用parent继承
        height: itemWidth * 0.5 // 高度，此时Rectangle控件在Window控件内，属于Window的孩子，可以使用parent
        color: "#00000000" // 颜色，缺省为白色
        // 透明度，缺省为1
        radius: 15 * sw // 圆角，通过圆角来画出一个圆形窗体出来
        clip: true // 截断，在Rectangle控件内的子控件，超出他本身大小后会被截断
        border.width: 0
        border.color: (remoterXValue < 1000 || remoterXValue > 2000
                       || remoterYValue < 1000
                       || remoterYValue > 2000) ? "#00000000" : "#00000000"
    }
    Rectangle {
        width: itemWidth * 0.5
        height: 4 * sw
        color: "black"
        x: remoterView.x + itemWidth * 0.25
        y: remoterView.y + itemWidth * 0.25 + itemWidth * 0.25

        border.color: "gray"
        border.width: 2 * sw
        //border.style: BorderStyle.DashLine
    }
    Rectangle {
        height: itemWidth * 0.5
        width: 4 * sw
        color: "black"
        x: remoterView.x + itemWidth * 0.25 + itemWidth * 0.25 - 2
        y: remoterView.y + itemWidth * 0.25

        border.color: "gray"
        border.width: 2 * sw
    }
    Rectangle {
        x: remoterView.x + itemWidth * 0.25 // 位于父窗体的x位置，以左上角为起点，缺省为0
        y: remoterView.y + itemWidth * 0.25
        // 位于父窗体的y位置，以左上角为起点，缺省为0
        width: itemWidth * 0.5 // 宽度，此时Rectangle控件在Window控件内，属于Window的孩子，可以使用parent继承
        height: itemWidth * 0.5 // 高度，此时Rectangle控件在Window控件内，属于Window的孩子，可以使用parent
        color: "transparent" // 颜色，缺省为白色
        // 透明度，缺省为1
        radius: 15 * sw // 圆角，通过圆角来画出一个圆形窗体出来
        clip: true // 截断，在Rectangle控件内的子控件，超出他本身大小后会被截断
        border.width: 4 * sw
        border.color: (remoterXValue < 1000 || remoterXValue > 2000
                       || remoterYValue < 1000
                       || remoterYValue > 2000) ? "#00000000" : "#00000000"
    }
    Rectangle {
        id: yg
        x: getx() // 位于父窗体的x位置，以左上角为起点，缺省为0
        y: gety() // 位于父窗体的y位置，以左上角为起点，缺省为0;                  // 位于父窗体的y位置，以左上角为起点，缺省为0
        width: sensorRadius * 2 // 宽度，此时Rectangle控件在Window控件内，属于Window的孩子，可以使用parent继承
        height: sensorRadius * 2 // 高度，此时Rectangle控件在Window控件内，属于Window的孩子，可以使用parent
        color: (remoterXValue < 1000 || remoterXValue > 2000
                || remoterYValue < 1000
                || remoterYValue > 2000) ? "red" : mainColor // 颜色，缺省为白色
        opacity: 0.95 // 透明度，缺省为1
        radius: sensorRadius // 圆角，通过圆角来画出一个圆形窗体出来
        clip: true // 截断，在Rectangle控件内的子控件，超出他本身大小后会被截断
    }
    function getx() {
        if (remoterXValue >= 1000 && remoterXValue <= 2000) {
            return remoterView.x + itemWidth * 0.25 + (remoterXValue - 1000)
                    / 10 * itemWidth * 0.5 / 200 * 2 - yg.radius
        } else if (remoterXValue < 1000) {
            return remoterView.x + itemWidth * 0.25 + (1000 - 1000) / 10
                    * itemWidth * 0.5 / 200 * 2 - yg.radius
        } else if (remoterXValue > 2000) {
            return remoterView.x + itemWidth * 0.25 + (2000 - 1000) / 10
                    * itemWidth * 0.5 / 200 * 2 - yg.radius
        }
    }
    function gety() {
        if (remoterYValue >= 1000 && remoterYValue <= 2000) {
            return remoterView.y + itemWidth * 0.25 + (remoterYValue - 1000)
                    / 10 * itemWidth * 0.5 / 200 * 2 - yg.radius
        } else if (remoterYValue < 1000) {
            return remoterView.y + itemWidth * 0.25 + (1000 - 1000) / 10
                    * itemWidth * 0.5 / 200 * 2 - yg.radius
        } else if (remoterYValue > 2000) {
            return remoterView.y + itemWidth * 0.25 + (2000 - 1000) / 10
                    * itemWidth * 0.5 / 200 * 2 - yg.radius
        }
    }
}
