import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import ScreenTools

Popup {
    id: popup
    modal: true
    focus: true
    width: mainWindow.width
    height: mainWindow.height
    closePolicy: Popup.NoAutoClose
    default property alias content: contentArea.data
    property real radius: 15 * ScreenTools.scaleWidth
    property color backgroundColor: "#00000000"
    property color contentBackgroundColor: "white"
    parent: Overlay.overlay

    Rectangle {
        id: contentArea
        width: popup.contentWidth
        height: popup.contentHeight
        anchors.centerIn: parent
        radius: popup.radius
        color: contentBackgroundColor
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: popup.contentWidth
                height: popup.contentHeight
                radius: popup.radius
            }
        }
    }

    background: Rectangle {
        width: popup.width
        height: popup.height
        color: backgroundColor
    }
}
