import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VKGroundControl
import ScreenTools
import Controls

Flickable {
    id: areaSetRoot

    height: parent.height
    width: parent.width
    contentHeight: mainColumn.implicitHeight

    // Public properties with camelCase naming
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5 / 6
    property color backgroundColor: ScreenTools.titleColor
    property bool isBattery: false
    property real horizontalSpeed: 10
    property real buttonFontSizeSmall: 30 * ScreenTools.scaleWidth

    property var idVol
    property real textWidth: 200 * ScreenTools.scaleWidth
    property real textHeight: 30 * ScreenTools.scaleWidth
    property real fontSize: 18 * ScreenTools.scaleWidth
    property color fontColor: "white"
    property int throwMethod: 0
    property int turnMethod: 1
    property int taskMethod: 0
    property int photoMethod: 0
    property real waypointAltitude: 10
    property real waypointSpeed: 5
    property real hoverTime: 0
    property int waypointPhotoMode: 1
    property real photoModeValue: 5

    // Main content container
    Item {
        width: parent.width
        height: mainWindow.height - 70 * ScreenTools.scaleWidth

        Rectangle {
            anchors.fill: parent
            color: "#00000000"
        }

        Column {
            id: mainColumn
            width: parent.width
            height: parent.height
            spacing: 30 * ScreenTools.scaleWidth

            // Title section
            Item {
                width: parent.width
                height: 60 * ScreenTools.scaleWidth

                Text {
                    anchors.centerIn: parent
                    text: qsTr("块状航线")
                    font.pixelSize: buttonFontSizeSmall
                    font.bold: false
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }
            }

            // Route angle setting
            NumericParameterInputControl {
                id: routeAngle
                width: parent.width - 60 * ScreenTools.scaleWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("航线角度")
                textWidth: 240 * ScreenTools.scaleWidth
                text1Width: 270 * ScreenTools.scaleWidth
                maxValue: 500
                minValue: 1
                value: 10
                onTextChanged: function(text) {
                    areaListModel.setAngle(text)
                }
            }

            // Route spacing setting
            NumericParameterInputControl {
                id: routeSpacing
                width: parent.width - 60 * ScreenTools.scaleWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("航线间隔")
                textWidth: 240 * ScreenTools.scaleWidth
                text1Width: 270 * ScreenTools.scaleWidth
                maxValue: 500
                minValue: 1
                value: 10
                onTextChanged: function(text) {
                    areaListModel.setSpacing(text)
                }
            }

            // Altitude setting
            NumericParameterInputControl {
                id: altitudeSetting
                width: parent.width - 60 * ScreenTools.scaleWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("高度")
                textWidth: 240 * ScreenTools.scaleWidth
                text1Width: 270 * ScreenTools.scaleWidth
                maxValue: 5000
                minValue: 1
                value: waypointAltitude
                onTextChanged: {
                    waypointAltitude = altitudeSetting.value
                }
            }

            // Speed setting
            NumericParameterInputControl {
                id: speedSetting
                width: parent.width - 60 * ScreenTools.scaleWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("速度")
                textWidth: 240 * ScreenTools.scaleWidth
                text1Width: 270 * ScreenTools.scaleWidth
                maxValue: 40
                minValue: 1
                value: waypointSpeed
                onTextChanged: {
                    waypointSpeed = speedSetting.value
                }
            }

            // Turn method selection
            OptionSelector {
                id: turnMethodSelector
                width: parent.width - 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                title: qsTr("转弯方式")
                leftButtonText: qsTr("自动转弯")
                rightButtonText: qsTr("定点转弯")
                selectedIndex: hoverTime === 0 ? 0 : 1
                buttonFontSize: areaSetRoot.buttonFontSize
                backgroundColor: areaSetRoot.backgroundColor
                onSelectionChanged: function (index) {
                    hoverTime = index === 0 ? 0 : 10
                }
            }

            // Hover time setting (visible when fixed-point turn is selected)
            NumericParameterInputControl {
                id: hoverTimeSetting
                visible: hoverTime !== 0
                width: parent.width - 60 * ScreenTools.scaleWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("悬停时间")
                textWidth: 240 * ScreenTools.scaleWidth
                text1Width: 270 * ScreenTools.scaleWidth
                maxValue: 500
                minValue: 1
                value: hoverTime
                onTextChanged: {
                    hoverTime = hoverTimeSetting.value
                }
            }

            // Task method selection
            OptionSelector {
                id: taskMethodSelector
                width: parent.width - 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                title: qsTr("任务方式")
                leftButtonText: qsTr("无任务")
                rightButtonText: qsTr("拍照")
                selectedIndex: waypointPhotoMode === 1 ? 0 : 1
                buttonFontSize: areaSetRoot.buttonFontSize
                backgroundColor: areaSetRoot.backgroundColor
                onSelectionChanged: function (index) {
                    waypointPhotoMode = index === 0 ? 1 : 2
                }
            }

            // Photo method selection (visible when photo task is selected)
            OptionSelector {
                id: photoMethodSelector
                visible: waypointPhotoMode !== 1
                width: parent.width - 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                title: qsTr("拍照方式")
                leftButtonText: qsTr("按时拍照")
                rightButtonText: qsTr("按距拍照")
                selectedIndex: waypointPhotoMode === 2 ? 0 : 1
                buttonFontSize: areaSetRoot.buttonFontSize
                backgroundColor: areaSetRoot.backgroundColor
                onSelectionChanged: function (index) {
                    waypointPhotoMode = index === 0 ? 2 : 3
                }
            }

            // Photo interval setting (visible when photo task is selected)
            NumericParameterInputControl {
                id: photoIntervalSetting
                visible: waypointPhotoMode !== 1
                width: parent.width - 60 * ScreenTools.scaleWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: waypointPhotoMode === 2 ? qsTr("时间间隔") : qsTr("距离间隔")
                textWidth: 240 * ScreenTools.scaleWidth
                text1Width: 270 * ScreenTools.scaleWidth
                maxValue: 500
                minValue: 1
                value: photoModeValue
                onTextChanged: {
                    photoModeValue = value
                }
            }
        }
    }
}
