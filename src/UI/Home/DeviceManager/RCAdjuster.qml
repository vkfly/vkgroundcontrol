import QtQuick
import QtQuick.Controls
import QGroundControl
import Qt5Compat.GraphicalEffects

import VKGroundControl
import VKGroundControl.Palette
import VkSdkInstance
import ScreenTools
import Controls

Popup {
    id: root
    width: popupWidth
    height: mainColumn.implicitHeight
    modal: true
    focus: true

    // Properties with camelCase naming
    property var activeVehicle: VkSdkInstance.vehicleManager.activeVehicle
    property var rcChannels: activeVehicle.rcChannels

    property int popupWidth: 900
    property string initialInstructionText: qsTr("请把所有摇杆、拨杆都置于中位，点击确定开始校准")
    property string calibrationInstructionText: qsTr("缓慢推动左右摇杆各方向到最大行程")
    property int buttonFontSize: 30 * ScreenTools.scaleWidth
    property color buttonFontColor: "white"
    property bool isCalibrating: false
    property real titleHeight: 80 * ScreenTools.scaleWidth
    property real instructionHeight: 60 * ScreenTools.scaleWidth
    property int controllerMode: 0 // 0: American mode, 1: Japanese mode

    // Constants for better maintainability
    readonly property real cornerRadius: 15
    readonly property real joystickAreaRatio: 0.8
    readonly property real buttonRowHeight: 60 * ScreenTools.scaleWidth
    readonly property color backgroundColor: "white"
    readonly property color cancelButtonColor: "gray"

    background: Item {}

    Rectangle {
        width: parent.width
        height: mainColumn.implicitHeight
        radius: cornerRadius
        color: "white"
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: mainColumn.width
                height: mainColumn.height
                radius: cornerRadius
            }
        }
        Column {
            id: mainColumn
            width: parent.width
            spacing: 0

            // Title section
            Item {
                width: parent.width
                height: titleHeight

                Text {
                    height: parent.width / 30
                    anchors.centerIn: parent
                    text: qsTr("摇杆校准")
                    color: "black"
                    font.pixelSize: 30 * ScreenTools.scaleWidth
                    font.bold: true
                }
            }

            // Instruction section
            Item {
                width: parent.width
                height: instructionHeight

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: isCalibrating ? calibrationInstructionText : initialInstructionText
                    color: "black"
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // Joystick visualization section
            Item {
                width: parent.width
                height: parent.width * joystickAreaRatio / 2

                Row {
                    width: parent.width * joystickAreaRatio
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: parent.width * (1 - joystickAreaRatio)

                    // Left joystick
                    RemoteSensing {
                        id: leftJoystick
                        width: parent.height * joystickAreaRatio
                        height: parent.height * joystickAreaRatio
                        anchors.left: parent.left

                        valueBarX: activeVehicle ? (rcChannels.rcChannelsRaw[3] - 1000) : 0
                        valueBarY: activeVehicle ? getLeftJoystickY() : 0
                    }

                    // Right joystick
                    RemoteSensing {
                        id: rightJoystick
                        width: parent.height * joystickAreaRatio
                        height: parent.height * joystickAreaRatio
                        anchors.right: parent.right

                        valueBarX: activeVehicle ? (rcChannels.rcChannelsRaw[0] - 1000) : 0
                        valueBarY: activeVehicle ? getRightJoystickY() : 0
                    }
                }
            }

            Item {
                width: parent.width
                height: buttonRowHeight

                // Initial state buttons (Cancel and Start Calibration)
                Row {
                    visible: !isCalibrating
                    anchors.fill: parent
                    spacing: 0

                    TextButton {
                        id: cancelButton
                        width: parent.width / 2
                        height: parent.height
                        buttonText: qsTr("取消")
                        backgroundColor: cancelButtonColor
                        pressedColor: cancelButtonColor
                        textColor: buttonFontColor
                        fontSize: buttonFontSize
                        cornerRadius: 0
                        borderWidth: 0
                        onClicked: root.close()
                    }

                    TextButton {
                        id: startCalibrationButton
                        width: parent.width / 2
                        height: parent.height
                        buttonText: qsTr("开始校准")
                        backgroundColor: mainWindow.titlecolor
                        textColor: buttonFontColor
                        fontSize: buttonFontSize
                        cornerRadius: 0
                        borderWidth: 0
                        onClicked: startCalibration()
                    }
                }

                // Calibration state button (End Calibration)
                TextButton {
                    id: endCalibrationButton
                    visible: isCalibrating
                    anchors.fill: parent
                    buttonText: qsTr("结束校准")
                    backgroundColor: mainWindow.titlecolor
                    textColor: buttonFontColor
                    fontSize: buttonFontSize
                    cornerRadius: 0
                    borderWidth: 0
                    onClicked: endCalibration()
                }
            }
        }
    }

    // Helper functions for joystick value calculation
    function getLeftJoystickY() {
        if (!activeVehicle || !rcChannels)
            return 0
        return controllerMode
                === 0 ? (2000 - rcChannels.rcChannelsRaw[2]) : (rcChannels.rcChannelsRaw[1] - 1000)
    }

    function getRightJoystickY() {
        if (!activeVehicle || !rcChannels)
            return 0
        return controllerMode === 0 ? (rcChannels.rcChannelsRaw[1]
                                       - 1000) : (2000 - rcChannels.rcChannelsRaw[2])
    }

    function startCalibration() {
        isCalibrating = true
        if (activeVehicle) {
            activeVehicle.startCalibration(3)
        }
    }

    function endCalibration() {
        isCalibrating = false
        if (activeVehicle) {
            activeVehicle.stopCalibration(4)
        }
        root.close()
    }
}
