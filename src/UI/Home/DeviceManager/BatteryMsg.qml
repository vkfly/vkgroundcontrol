import QtQuick

Column {

    property var batteryCells: new Array(40)

    id: column1
    width: parent.width * 0.95
    anchors.horizontalCenter: parent.horizontalCenter

    Item {
        width: parent.width
        height: 50 * sw
    }
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: 40 * sw
        Text {
            width: parent.width
            height: 40 * sw
            anchors.right: parent.right
            anchors.rightMargin: parent.width / 19
            text: qsTr("电池ID：%1").arg(batteryCells[30])
            color: "black"
            font.pixelSize: buttonFontSize
            horizontalAlignment: Text.AlignRight
        }
    }

    Item {
        width: parent.width
        height: batteryColumn2.height
        Rectangle {
            anchors.fill: parent
            color: "#00000000"
            border.color: "gray"
            border.width: 2
            radius: 30
        }
        Row {
            width: parent.width
            height: batteryColumn2.height
            Column {
                id: batteryColumn2
                width: parent.width
                spacing: 10 * sw

                Item {
                    width: 1
                    height: 3
                }

                Row {
                    width: parent.width * 0.9
                    height: parent.width * 0.09
                    anchors.horizontalCenter: parent.horizontalCenter
                    BatteryParam {
                        width: parent.width * 0.2
                        height: parent.width * 0.2
                        imgSource: "/qmlimages/icon/dianya.png"
                        nameTitle: qsTr("总电压")
                        values: qsTr("%1V").arg((batteryCells[36] * 0.001).toFixed(1))
                    }
                    BatteryParam {
                        width: parent.width * 0.2
                        height: parent.height
                        imgSource: "/qmlimages/icon/dianliu.png"
                        nameTitle: qsTr("总电流")
                        values: qsTr("%1A").arg((parseFloat(batteryCells[33]) * 0.01).toFixed(1))
                    }
                    BatteryParam {
                        width: parent.width * 0.2
                        height: parent.height
                        imgSource: "/qmlimages/icon/wendu.png"
                        nameTitle: qsTr("温度")
                        values: qsTr("%1℃").arg(batteryCells[35])
                    }
                    BatteryParam {
                        width: parent.width * 0.2
                        height: parent.height
                        imgSource: "/qmlimages/icon/xunhuan.png"
                        nameTitle: qsTr("循环次数")
                        values: qsTr("%1").arg(batteryCells[38])
                    }
                    BatteryParam {
                        width: parent.width * 0.2
                        height: parent.height
                        imgSource: "/qmlimages/icon/dianliang.png"
                        nameTitle: qsTr("电量")
                        values: qsTr("%1%").arg(batteryCells[31])
                    }
                }
                Item {
                    width: 1
                    height: 3
                }
                Row {
                    width: parent.width
                    spacing: parent.width / 19
                    height: parent.width / 9.5 * 0.7 + 40 * sw
                    Text {
                        width: 1
                        height: parent.width / 6.5 + 40 * sw
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[0] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[1] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[2] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[3] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[4] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[5] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[6] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[7] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[8] * 0.001).toFixed(1) + "V"
                    }
                }
                Row {
                    width: parent.width
                    spacing: parent.width / 19
                    height: parent.width / 9.5 * 0.7 + 40 * sw
                    Text {
                        width: 1
                        height: parent.width / 6.5 + 40 * sw
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[9] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[10] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[11] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 12
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[12] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 13
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[13] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 14
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[14] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 15
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[15] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 15
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[16] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 17
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[17] * 0.001).toFixed(1) + "V"
                    }
                }
                Row {
                    visible: parseInt(bmsCells[32]) > 18
                    width: parent.width
                    spacing: parent.width / 19
                    height: parent.width / 9.5 * 0.7 + 40 * sw
                    Text {
                        width: 1
                        height: parent.width / 6.5 + 40 * sw
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 18
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[18] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 19
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[19] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 20
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[20] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 21
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[21] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 22
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[22] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 23
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[23] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 24
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[24] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 25
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[25] * 0.001).toFixed(1) + "V"
                    }
                    BatteryParamValue {
                        visible: parseInt(bmsCells[32]) > 26
                        width: parent.width / 19
                        height: parent.height
                        values: (batteryCells[25] * 0.001).toFixed(1) + "V"
                    }
                }

                Item {
                    width: 1
                    height: 2
                }
            }
        }
    }

    Item {
        width: parent.width
        height: 30 * sw
    }
}
