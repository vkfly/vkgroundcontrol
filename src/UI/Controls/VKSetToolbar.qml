import QtQuick
import QtQuick.Controls
import VKGroundControl

import ScreenTools

Item {
    id: _root
    property string titleName: qsTr("设置")
    property var _activeVehicle: VKGroundControl.multiVehicleManager.activeVehicle1 ? VKGroundControl.multiVehicleManager.activeVehicle1 : ""
    property var selectevehicle
    property double batteryVoltage: _activeVehicle ? _activeVehicle.batteryVoltage.toFixed(
                                                         1) : 0
    property double satellites_num: _activeVehicle ? _activeVehicle.satellites_num : 0
    property double bili_width: sw
    property double bili_height: sh
    property var parsedErrors: ""
    property var bms_cell: _activeVehicle.bms_cell
    signal returnLast

    width: parent.width
    height: sw * 65
    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Row {
        width: parent.width
        height: parent.height
        Button {
            width: parent.height * 1.5
            height: parent.height
            onClicked: returnLast()
            background: Rectangle {
                anchors.fill: parent
                color: "#00000000"
                Image {
                    width: parent.height * 0.9
                    height: parent.height * 0.9
                    anchors.centerIn: parent
                    source: "/qmlimages/icon/left.png"
                }
            }
        }
    }

    Text {
        width: parent.width * 0.3
        height: parent.height
        text: _root.titleName
        font.pointSize: 20
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
