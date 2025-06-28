import QtQuick
import QtQuick.Controls

import ScreenTools

Item {
    id: remoteSensingControl

    // Public properties with camelCase naming
    property real barWidth: 20
    property int valueBarX: 0
    property int valueBarY: 0

    width: parent.width
    height: parent.height

    // Horizontal bar component
    Item {
        id: horizontalBar
        width: parent.width
        height: barWidth
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        // Background bar
        Rectangle {
            id: horizontalBarBackground
            width: parent.width
            height: parent.height
            color: "gray"
            radius: barWidth / 2
        }

        // Percentage text for horizontal bar
        Text {
            id: horizontalPercentageText
            text: (valueBarX / 10).toFixed(0) + "%"
            anchors.left: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            color: "black"
            font.pixelSize: 12
        }
    }

    // Vertical bar component
    Item {
        id: verticalBar
        width: barWidth
        height: parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        // Background bar
        Rectangle {
            id: verticalBarBackground
            width: parent.width
            height: parent.height
            color: "gray"
            radius: barWidth / 2
        }

        // Percentage text for vertical bar
        Text {
            id: verticalPercentageText
            text: (valueBarY / 10).toFixed(0) + "%"
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10
            color: "black"
            font.pixelSize: 12
        }
    }

    // Horizontal position indicator
    Item {
        id: horizontalIndicator
        width: barWidth
        height: barWidth
        x: (parent.width - barWidth) * valueBarX / 1000
        y: parent.width / 2 - barWidth / 2

        Rectangle {
            id: horizontalIndicatorCircle
            width: barWidth
            height: barWidth
            color: mainWindow.titlecolor
            radius: width / 2
        }
    }

    // Vertical position indicator
    Item {
        id: verticalIndicator
        width: barWidth
        height: barWidth
        x: parent.width / 2 - barWidth / 2
        y: (parent.width - barWidth) * valueBarY / 1000

        Rectangle {
            id: verticalIndicatorCircle
            width: barWidth
            height: barWidth
            color: mainWindow.titlecolor
            radius: width / 2
        }
    }
}

