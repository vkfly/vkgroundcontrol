import QtQuick
import QtQuick.Controls

import ScreenTools

ComboBox {
    id: comboBox

    property real fontSize: 20 * ScreenTools.scaleWidth

    // Custom background
    background: Rectangle {
        anchors.fill: parent
        radius: 5 * sw
        color: "white"
    }

    // Custom content item
    contentItem: Text {
        text: comboBox.currentText
        font.bold: false
        font.pixelSize: comboBox.fontSize
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "black"
    }

    // Custom delegate
    delegate: ItemDelegate {
        width: comboBox.width
        height: comboBox.height
        background: Rectangle {
            color: "white"
        }
        Text {
            text: modelData ? modelData : model.text
            font.pixelSize: comboBox.fontSize
            font.bold: false
            anchors.centerIn: parent
        }
    }
}
