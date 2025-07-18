import QtQuick
import QtQml.Models

import VKGroundControl
import VKGroundControl.Palette
import Controls
import ScreenTools
import FlightDisplay
import FlightMap

Item {

    signal goToMain
    id: _root
    width: 600 * sw
    height: parent.height
    VKSetToolbar {
        id: vk_toobar
        anchors.top: parent.top
        width: parent.width
        titleName: qsTr("连接方式选择")
        onReturnLast: {
            goToMain()
        }
    }

    Item {
        width: _root.width
        height: _root.height - vk_toobar.height
        Rectangle {
            anchors.fill: parent
            color: "black"
        }
        anchors.bottom: parent.bottom
        LinkSettings {
            width: 600 * sw
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
