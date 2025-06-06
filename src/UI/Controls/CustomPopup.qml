import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import ScreenTools

Popup {
    id: popup
    modal: true
    focus: true
    closePolicy: Popup.NoAutoClose
    default property alias content: contentArea.data
    property real radius: 15 * ScreenTools.scaleWidth
    property color backgroundColor: "#00000000"
    property color contentBackgroundColor: "white"

    Rectangle {
        id: contentArea
        width: popup.width
        height: popup.height
        radius: popup.radius
        color: contentBackgroundColor
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: popup.width
                height: popup.height
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
