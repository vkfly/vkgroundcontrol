import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VKGroundControl
import ScreenTools
import Controls

Flickable {
    id: stripLineSettingsRoot

    height: parent.height
    width: parent.width
    contentHeight: mainColumn.implicitHeight

    // Font and styling properties
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5 / 6
    property real largeFontSize: 30 * ScreenTools.scaleWidth
    property color backgroundColor: ScreenTools.titleColor
    property color fontColor: "white"

    // Vehicle connection
    property var activeVehicle: VKGroundControl.multiVehicleManager.activeVehicle1
                                || null

    // Vehicle status properties
    property real horizontalSpeed: activeVehicle ? (activeVehicle.horizontalSpeed * 0.01).toFixed(
                                                       1) : 0
    property real verticalSpeed: activeVehicle ? (activeVehicle.verticalSpeed * 0.01).toFixed(
                                                     1) : 0
    property real heightValue: activeVehicle ? (activeVehicle.relative_alt * 0.001).toFixed(
                                                   1) : 0
    property var bmsCell: activeVehicle ? activeVehicle.bms_cell : null
    property var qingxieBmsCell: activeVehicle ? activeVehicle.qingxiebms_cell : null

    // Strip line configuration
    property real stripWidth: 10
    property real lineInterval: 10
    property real waypointAltitude: 100
    property real waypointSpeed: 5
    property real photoModeValue: 5

    // Mission settings
    property int turnMethod: 0 // 0: auto turn, 1: fixed point turn
    property int hoverTime: 0 // hover time in seconds
    property int missionMode: 1 // 1: no mission, 2: photo mission
    property int photoMode: 2 // 2: time-based, 3: distance-based

    // Layout constants
    property real itemSpacing: 30 * ScreenTools.scaleWidth
    property real containerWidth: parent.width - 60 * ScreenTools.scaleWidth
    property real textWidth: 240 * ScreenTools.scaleWidth
    property real inputWidth: 270 * ScreenTools.scaleWidth
    property real buttonRowWidth: 270 * ScreenTools.scaleWidth
    property real singleButtonWidth: 135 * ScreenTools.scaleWidth

    Item {
        width: parent.width
        height: parent.height - 70 * ScreenTools.scaleWidth

        Column {
            id: mainColumn
            width: parent.width
            spacing: itemSpacing

            // Title section
            Item {
                width: parent.width
                height: 60 * ScreenTools.scaleWidth

                Text {
                    anchors.fill: parent
                    text: qsTr("带状航线")
                    font.pixelSize: largeFontSize
                    font.bold: false
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: fontColor
                }
            }

            // Strip width setting
            NumericParameterInputControl {
                id: stripWidthInput
                width: containerWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("带状宽度")
                textWidth: textWidth
                text1Width: inputWidth
                maxValue: 500
                minValue: 1
                value: stripWidth
                onTextChanged: {
                    stripWidth = value
                    scanListModel.setWidth(value)
                }
            }

            // Line interval setting
            NumericParameterInputControl {
                id: lineIntervalInput
                width: containerWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("航线间隔")
                textWidth: textWidth
                text1Width: inputWidth
                maxValue: 500
                minValue: 1
                value: lineInterval
                onTextChanged: {
                    if (isValidNumber(value) && value > 0) {
                        lineInterval = value
                        scanListModel.setJiange(value)
                    } else {

                    }
                }
            }

            // Altitude setting
            NumericParameterInputControl {
                id: altitudeInput
                width: containerWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("高度")
                textWidth: textWidth
                text1Width: inputWidth
                maxValue: 5000
                minValue: 1
                value: waypointAltitude
                onTextChanged: {
                    waypointAltitude = value
                }
            }

            // Speed setting
            NumericParameterInputControl {
                id: speedInput
                width: containerWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("速度")
                textWidth: textWidth
                text1Width: inputWidth
                maxValue: 40
                minValue: 1
                value: waypointSpeed
                onTextChanged: {
                    waypointSpeed = value
                }
            }

            // Turn method selection
            SettingOptionRow {
                id: turnMethodSelector
                width: containerWidth
                anchors.horizontalCenter: parent.horizontalCenter

                labelText: qsTr("转弯方式")
                leftButtonText: qsTr("自动转弯")
                rightButtonText: qsTr("定点转弯")
                selectedIndex: turnMethod
                buttonFontSize: stripLineSettingsRoot.buttonFontSize
                backgroundColor: stripLineSettingsRoot.backgroundColor
                fontColor: stripLineSettingsRoot.fontColor
                singleButtonWidth: stripLineSettingsRoot.singleButtonWidth

                onSelectionChanged: function (index) {
                    turnMethod = index
                    hoverTime = index === 0 ? 0 : 10
                }
            }

            // Hover time setting (visible when fixed point turn is selected)
            NumericParameterInputControl {
                id: hoverTimeInput
                visible: turnMethod !== 0
                width: containerWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("悬停时间")
                textWidth: textWidth
                text1Width: inputWidth
                maxValue: 500
                minValue: 1
                value: hoverTime
                onTextChanged: {
                    hoverTime = value
                }
            }

            // Mission mode selection
            SettingOptionRow {
                id: missionModeSelector
                width: containerWidth
                anchors.horizontalCenter: parent.horizontalCenter

                labelText: qsTr("任务方式")
                leftButtonText: qsTr("无任务")
                rightButtonText: qsTr("拍照")
                selectedIndex: missionMode === 1 ? 0 : 1
                buttonFontSize: stripLineSettingsRoot.buttonFontSize
                backgroundColor: stripLineSettingsRoot.backgroundColor
                fontColor: stripLineSettingsRoot.fontColor
                singleButtonWidth: stripLineSettingsRoot.singleButtonWidth

                onSelectionChanged: function (index) {
                    missionMode = index === 0 ? 1 : 2
                }
            }

            // Photo mode selection (visible when photo mission is selected)
            SettingOptionRow {
                id: photoModeSelector
                visible: missionMode !== 1
                width: containerWidth
                anchors.horizontalCenter: parent.horizontalCenter

                labelText: qsTr("拍照方式")
                leftButtonText: qsTr("按时拍照")
                rightButtonText: qsTr("按距拍照")
                selectedIndex: photoMode === 2 ? 0 : 1
                buttonFontSize: stripLineSettingsRoot.buttonFontSize
                backgroundColor: stripLineSettingsRoot.backgroundColor
                fontColor: stripLineSettingsRoot.fontColor
                singleButtonWidth: stripLineSettingsRoot.singleButtonWidth

                onSelectionChanged: function (index) {
                    photoMode = index === 0 ? 2 : 3
                }
            }

            // Photo interval setting (visible when photo mission is selected)
            NumericParameterInputControl {
                id: photoIntervalInput
                visible: missionMode !== 1
                width: containerWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: photoMode === 2 ? qsTr("时间间隔") : qsTr("距离间隔")
                textWidth: textWidth
                text1Width: inputWidth
                maxValue: 500
                minValue: 1
                value: photoModeValue
                onTextChanged: {
                    photoModeValue = value
                }
            }
        }
    }

    // Helper functions
    function isValidNumber(value) {
        return !isNaN(parseFloat(value)) && isFinite(value)
    }
}
