import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import ScreenTools
import VKGroundControl.Palette
import Controls

Rectangle {
    id: _root

    property var names: []
    property int selectedIndex: -1
    property var mainColor: qgcPal.titleColor
    property int fontSize: 20 * ScreenTools.scaleWidth
    property color backgroundColor: "white"
    property real spacing: 2 * ScreenTools.scaleWidth
    radius: 8 * ScreenTools.scaleWidth
    color: backgroundColor
    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: _root.width
            height: _root.height
            radius: _root.radius
        }
    }
    signal clicked(var index)

    VKPalette {
        id: qgcPal
    }

    RowLayout {
        width: _root.width
        height: _root.height
        spacing: _root.spacing

        Repeater {
            model: names
            TextButton {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumWidth: _root.width / names.length - _root.spacing
                                     * (names.length - 1) / names.length
                Layout.maximumWidth: _root.width / names.length - _root.spacing
                                     * (names.length - 1) / names.length
                backgroundColor: pressed ? mainColor : selectedIndex
                                           === index ? mainColor : "#EDEDED"
                textColor: pressed ? "white" : selectedIndex === index ? "white" : "black"
                fontSize: _root.fontSize
                buttonText: modelData
                cornerRadius: 0
                borderWidth: 0
                onClicked: {
                    _root.clicked(index)
                }
            }
        }
    }
}
