// OpacityMask.qml
import QtQuick
import QtQuick.Effects

Item {
    id: root

    property alias source: effect.source
    property alias maskSource: effect.maskSource
    property bool cached: false
    property bool invert: false

    MultiEffect {
        id: effect
        anchors.fill: parent
        maskEnabled: true
        maskInverted: root.invert

        // 如果需要缓存
        layer.enabled: root.cached
        layer.smooth: true
    }
}
