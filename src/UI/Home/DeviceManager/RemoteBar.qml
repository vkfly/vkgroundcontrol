import QtQuick
import QtQuick.Controls

import VKGroundControl.Palette

Item {
    id: remoteView
    
    width: 510 * sw
    height: 60 * sw

    // Properties
    property int remoteXValue: 2200   // Range: 1000-2000
    property int remoteYValue: 1500
    property int itemWidth: remoteView.width
    property string remoteBarName: qsTr("通道1")
    property string remoteBarLeftName: ""
    property string remoteBarCenterName: ""
    property string remoteBarRightName: ""
    property real buttonFontSize: 30 * sw * 5 / 6
    property var mainColor: qgcPal.titleColor
    property int remoteValue: 0

    VKPalette { id: qgcPal}

    // Main container
    Item {
        width: parent.width
        height: 60 * sw
        Label {
            id: remoteNameLabel
            text: remoteBarName
            height: 40 * sw
            width: 90 * sw
            font.pixelSize: buttonFontSize
            font.bold: false
            anchors.left: parent.left
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "black"
            Rectangle {
                anchors.fill: parent
                border.width: 1
                border.color: "black"
                radius: 5
                color: "#00000000"
            }
        }

        Label {
            height: 40 * sw
            width: 80 * sw
            font.pixelSize: buttonFontSize
            font.bold: false
            horizontalAlignment: Text.AlignHCenter
            anchors.right: parent.right
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
            color: remoteValue >= 1000 && remoteValue <= 2000 ? "gray" : "red"
        }
    }

    // Background bar
    Rectangle {
        id: backgroundBar
        x: remoteNameLabel.width + 20 * sw
        width: 390 * sw
        height: 20 * sw
        color: "gray"
        radius: 5 * sw
        clip: true
        anchors.verticalCenter: parent.verticalCenter
    }

    // Value indicator bar
    Rectangle {
        x: remoteNameLabel.width + 20 * sw + updateRemoteValue(remoteValue)
        width: 130 * sw
        height: 20 * sw
        color: remoteValue >= 1000 && remoteValue <= 2000 ? mainColor : "red"
        radius: 5 * sw
        border.width: 2 * sw
        border.color: "#00000000"
        clip: true
        anchors.verticalCenter: parent.verticalCenter
    }

    // Value marker
    Rectangle {
        id: valueMarker
        x: getMarkerPosition()
        width: 5 * sw
        height: 20 * sw
        color: "red"
        radius: 2 * sw
        border.width: 0
        border.color: mainColor
        clip: true
        anchors.verticalCenter: parent.verticalCenter
    }

    // Center divider
    Rectangle {
        x: remoteNameLabel.width + 20 * sw + 130 * sw
        width: 1 * sw
        height: 20 * sw
        color: "white"
        radius: 2 * sw
        border.width: 0
        border.color: mainColor
        clip: true
        anchors.verticalCenter: parent.verticalCenter
    }

    // Right divider
    Rectangle {
        x: remoteNameLabel.width + 20 * sw + 260 * sw
        width: 1 * sw
        height: 20 * sw
        color: "white"
        radius: 2 * sw
        border.width: 0
        border.color: mainColor
        clip: true
        anchors.verticalCenter: parent.verticalCenter
    }

    // Labels container
    Rectangle {
        y: 40 * sw
        x: remoteNameLabel.width + 20 * sw
        width: 390 * sw
        height: 40 * sw
        color: "transparent"
        radius: 5 * sw
        clip: true

        Item {
            width: 390 * sw
            height: 40 * sw
            Label {
                text: remoteBarLeftName
                width: 130 * sw
                height: 40 * sw
                font.pixelSize: buttonFontSize * 5 / 6
                font.bold: false
                anchors.left: parent.left
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "gray"
            }
            Label {
                text: remoteBarCenterName
                width: 130 * sw
                height: 40 * sw
                font.pixelSize: buttonFontSize * 5 / 6
                font.bold: false
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "gray"
            }
            Label {
                text: remoteBarRightName
                width: 130 * sw
                height: 40 * sw
                font.pixelSize: buttonFontSize * 5 / 6
                font.bold: false
                anchors.right: parent.right
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "gray"
            }
        }
    }

    // Helper functions
    function updateRemoteValue(value) {
        if (value <= 1350)
            return 0
        else if (value > 1350 && value < 1650) {
            return 131 * sw
        } else {
            return 261 * sw
        }
    }

    function getMarkerPosition() {
        if (remoteValue >= 1000 && remoteValue <= 2000)
            return remoteNameLabel.width + 20 * sw + backgroundBar.width * (remoteValue - 1000) / 1000.0 - valueMarker.width / 2
        else if (remoteValue < 1000)
            return remoteNameLabel.width + 20 * sw + backgroundBar.width * (1000 - 1000) / 1000.0 - valueMarker.width / 2
        else if (remoteValue > 2000)
            return remoteNameLabel.width + 20 * sw + backgroundBar.width * (2000 - 1000) / 1000.0 - valueMarker.width / 2
    }
}
