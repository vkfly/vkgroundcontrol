import QtQuick 2.15

import QtQuick 2.3
import QtQuick.Controls 2.15
import ScreenTools

/// The SliderSwitch control implements a sliding switch control similar to the power off
/// control on an iPhone.
Item {
    id: _root
    width: parent.width
    height: parent.height
    property string confirmText
    ///< Text for slider
    property alias fontPointSize: label.font.pointSize ///< Point size for text
    property real _border: 4
    property real _diameter: height - (_border * 2)
    property real fontsize: 30 * ScreenTools.scaleWidth
    property var labeltext: qsTr("开始航线")
    signal accept
    ///< Action confirmed
    signal cancel

    Row {
        width: parent.width - cancelbt.width
        height: parent.height
        Item {
            width: parent.width
            height: parent.height
            Rectangle {
                width: parent.width
                height: parent.height
                radius: height / 2
                color: "black"
                border.width: _border / 2
                border.color: "white"

                Text {
                    id: label
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: fontsize * 0.9
                    text: labeltext
                    color: "white"
                }
                Rectangle {
                    id: slider
                    x: _border
                    y: _border
                    height: _diameter
                    width: _diameter
                    radius: _diameter / 2
                    border.color: "white"
                    border.width: _border / 2
                    color: "#00000000"

                    Image {
                        anchors.centerIn: parent
                        width: parent.width * 0.9
                        height: parent.height * 0.9
                        sourceSize.height: height
                        fillMode: Image.PreserveAspectFit
                        smooth: false
                        cache: false
                        source: "/qmlimages/icon/slider_swith.png"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    id: sliderDragArea
                    drag.target: slider
                    drag.axis: Drag.XAxis
                    drag.minimumX: _border
                    drag.maximumX: _maxXDrag
                    preventStealing: true
                    onDragActiveChanged: {
                        if (slider.x > _maxXDrag - _border) {
                            slider.x = _border
                            _root.accept()
                        }
                        slider.x = _border
                    }
                    property real _maxXDrag: _root.width - cancelbt.width - (_diameter + _border)
                    property bool dragActive: drag.active
                    property real _dragOffset: 1
                }
            }
        }
        Item {
            id: cancelbt
            width: parent.height - 2 * _border
            height: parent.height - 2 * _border
            anchors.verticalCenter: parent.verticalCenter
            Button {
                height: parent.height
                width: parent.height

                background: Rectangle {
                    width: parent.height
                    height: parent.height
                    radius: parent.height / 2
                    border.color: "white"
                    border.width: _border / 2

                    color: "#00000000"
                    Image {
                        anchors.centerIn: parent
                        width: parent.width * 0.9
                        height: parent.height * 0.9
                        sourceSize.height: height
                        fillMode: Image.PreserveAspectFit
                        smooth: false
                        cache: false
                        source: "/qmlimages/icon/slider_cancel.png"
                    }
                }

                onClicked: {
                    _root.cancel()
                }
            }
        }
    }
}
