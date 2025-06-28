import QtQuick
import QtQuick.Controls

import VKGroundControl
import Controls
import VkSdkInstance 1.0

Flickable {

    property var _escStatus : VkSdkInstance.vehicleManager.activeVehicle.escStatus
    property int escIndex: activeVehicle ? _escStatus.index : -1
    property var escCurrent: activeVehicle ? _escStatus.current : new Array[16]
    property var escVoltage: activeVehicle ? _escStatus.voltage : new Array[16]
    property var escRpm: activeVehicle ? _escStatus.rpm : new Array[16]
    property var escTemperature: activeVehicle ? _escStatus.temperature : new Array[16]
    property var escStatus: activeVehicle ? _escStatus.status : new Array[16]

    property bool isAdvancedMode: false
    property string advancedModeUpIcon: "/qmlimages/icon/up_arrow.png"
    property string advancedModeDownIcon: "/qmlimages/icon/down_arrow.png"
    property var mainColor: mainWindow.titlecolor

    property var _servoOutputRaw : VkSdkInstance.vehicleManager.activeVehicle.servoOutputRaw
    property var activeVehicle:VkSdkInstance.vehicleManager.activeVehicle
    property var fcumodel_versions : activeVehicle.FlightController.deviceModel


    on_ServoOutputRawChanged: {
    }

    on_EscStatusChanged: {
    }
    height: parent.height
    width: parent.width
    clip: true
    contentHeight: mainColumn.implicitHeight

    Column {
        id: mainColumn
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            width: parent.width
            height: 40 * sw
        }

        MotorBar {
            width: parent.width
            height: 100 * sw
            labelName: qsTr("M1")
            barId: 1
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[0] : "0"
            currentEsc: escCurrent[0]
            voltageEsc: escVoltage[0]
            rpmEsc: escRpm[0]
            temperatureEsc: escTemperature[0]
            statusEsc: escStatus[0]
            onSendClickId: {
                messageBox.escId = 1
                messageBox.messageText = qsTr("配置%1号电机").arg(1)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            labelName: qsTr("M2")
            width: parent.width
            height: 100 * sw
            barId: 2
            motorValue: activeVehicle ?  _servoOutputRaw.servoOutputRaw[1] : "0"
            currentEsc: escCurrent[1]
            voltageEsc: escVoltage[1]
            rpmEsc: escRpm[1]
            temperatureEsc: escTemperature[1]
            statusEsc: escStatus[1]
            onSendClickId: {
                messageBox.escId = 2
                messageBox.messageText = qsTr("配置%1号电机").arg(2)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            labelName: qsTr("M3")
            width: parent.width
            height: 100 * sw
            barId: 3
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[2] : "0"
            currentEsc: escCurrent[2]
            voltageEsc: escVoltage[2]
            rpmEsc: escRpm[2]
            temperatureEsc: escTemperature[2]
            statusEsc: escStatus[2]
            onSendClickId: {
                messageBox.escId = 3
                messageBox.messageText = qsTr("配置%1号电机").arg(3)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            labelName: qsTr("M4")
            width: parent.width
            height: 100 * sw
            barId: 4
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[3] : "0"
            currentEsc: escCurrent[3]
            voltageEsc: escVoltage[3]
            rpmEsc: escRpm[3]
            temperatureEsc: escTemperature[3]
            statusEsc: escStatus[3]
            onSendClickId: {
                messageBox.escId = 4
                messageBox.messageText = qsTr("配置%1号电机").arg(4)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            labelName: qsTr("M5")
            width: parent.width
            height: 100 * sw
            barId: 5
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[4] : "0"
            currentEsc: escCurrent[4]
            voltageEsc: escVoltage[4]
            rpmEsc: escRpm[4]
            temperatureEsc: escTemperature[4]
            statusEsc: escStatus[4]
            onSendClickId: {
                messageBox.escId = 5
                messageBox.messageText = qsTr("配置%1号电机").arg(5)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            labelName: qsTr("M6")
            width: parent.width
            height: 100 * sw
            barId: 6
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[5] : "0"
            currentEsc: escCurrent[5]
            voltageEsc: escVoltage[5]
            rpmEsc: escRpm[5]
            temperatureEsc: escTemperature[5]
            statusEsc: escStatus[5]
            onSendClickId: {
                messageBox.escId = 6
                messageBox.messageText = qsTr("配置%1号电机").arg(6)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            labelName: qsTr("M7")
            width: parent.width
            height: 100 * sw
            barId: 7
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[6] : "0"
            currentEsc: escCurrent[6]
            voltageEsc: escVoltage[6]
            rpmEsc: escRpm[6]
            temperatureEsc: escTemperature[6]
            statusEsc: escStatus[6]
            onSendClickId: {
                messageBox.escId = 7
                messageBox.messageText = qsTr("配置%1号电机").arg(7)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            labelName: qsTr("M8")
            width: parent.width
            height: 100 * sw
            barId: 8
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[7] : "0"
            currentEsc: escCurrent[7]
            voltageEsc: escVoltage[7]
            rpmEsc: escRpm[7]
            temperatureEsc: escTemperature[7]
            statusEsc: escStatus[7]
            onSendClickId: {
                messageBox.escId = 8
                messageBox.messageText = qsTr("配置%1号电机").arg(8)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            visible: isAdvancedMode
            labelName: fcumodel_versions === "V10Pro" ? qsTr("M9") : qsTr("S1")
            width: parent.width
            height: 100 * sw
            barId: 9
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[8] : "0"
            currentEsc: escCurrent[8]
            voltageEsc: escVoltage[8]
            rpmEsc: escRpm[8]
            temperatureEsc: escTemperature[8]
            statusEsc: escStatus[8]
            onSendClickId: {
                if (fcumodel_versions === "V10Pro") {
                    messageBox.escId = 9
                    messageBox.messageText = qsTr("配置%1号电机").arg(9)
                    messageBox.sendId = "VOLT_PROT_CH"
                    messageBox.open()
                }
            }
        }

        MotorBar {
            visible: isAdvancedMode
            labelName:fcumodel_versions === "V10Pro" ? qsTr("M10") : qsTr("S2")
            width: parent.width
            height: 100 * sw
            barId: 10
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[9] : "0"
            currentEsc: escCurrent[9]
            voltageEsc: escVoltage[9]
            rpmEsc: escRpm[9]
            temperatureEsc: escTemperature[9]
            statusEsc: escStatus[9]
            onSendClickId: {
                if (mainWindow.fcumodel_versions === "V10Pro") {
                    messageBox.escId = 10
                    messageBox.messageText = qsTr("配置%1号电机").arg(10)
                    messageBox.sendId = "VOLT_PROT_CH"
                    messageBox.open()
                }
            }
        }

        MotorBar {
            visible: isAdvancedMode &&fcumodel_versions === "V10Pro"
            labelName: qsTr("M11")
            width: parent.width
            height: 100 * sw
            barId: 11
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[10] : "0"
            currentEsc: escCurrent[10]
            voltageEsc: escVoltage[10]
            rpmEsc: escRpm[10]
            temperatureEsc: escTemperature[10]
            statusEsc: escStatus[10]
            onSendClickId: {
                messageBox.escId = 11
                messageBox.messageText = qsTr("配置%1号电机").arg(11)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            visible: isAdvancedMode &&fcumodel_versions === "V10Pro"
            labelName: qsTr("M12")
            width: parent.width
            height: 100 * sw
            barId: 12
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[11] : "0"
            currentEsc: escCurrent[11]
            voltageEsc: escVoltage[11]
            rpmEsc: escRpm[11]
            temperatureEsc: escTemperature[11]
            statusEsc: escStatus[11]
            onSendClickId: {
                messageBox.escId = 12
                messageBox.messageText = qsTr("配置%1号电机").arg(12)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            visible: isAdvancedMode &&fcumodel_versions === "V10Pro"
            labelName: qsTr("M13")
            width: parent.width
            height: 100 * sw
            barId: 13
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[12] : "0"
            currentEsc: escCurrent[12]
            voltageEsc: escVoltage[12]
            rpmEsc: escRpm[12]
            temperatureEsc: escTemperature[12]
            statusEsc: escStatus[12]
            onSendClickId: {
                messageBox.escId = 13
                messageBox.messageText = qsTr("配置%1号电机").arg(13)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            visible: isAdvancedMode &&fcumodel_versions === "V10Pro"
            labelName: qsTr("M14")
            width: parent.width
            height: 100 * sw
            barId: 14
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[13] : "0"
            currentEsc: escCurrent[13]
            voltageEsc: escVoltage[13]
            rpmEsc: escRpm[13]
            temperatureEsc: escTemperature[13]
            statusEsc: escStatus[13]
            onSendClickId: {
                messageBox.escId = 14
                messageBox.messageText = qsTr("配置%1号电机").arg(14)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            visible: isAdvancedMode &&fcumodel_versions === "V10Pro"
            labelName: qsTr("M15")
            width: parent.width
            height: 100 * sw
            barId: 15
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[14] : "0"
            currentEsc: escCurrent[14]
            voltageEsc: escVoltage[14]
            rpmEsc: escRpm[14]
            temperatureEsc: escTemperature[14]
            statusEsc: escStatus[14]
            onSendClickId: {
                messageBox.escId = 15
                messageBox.messageText = qsTr("配置%1号电机").arg(15)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        MotorBar {
            visible: isAdvancedMode &&fcumodel_versions === "V10Pro"
            labelName: qsTr("M16")
            width: parent.width
            height: 100 * sw
            barId: 16
            motorValue: activeVehicle ? _servoOutputRaw.servoOutputRaw[15] : "0"
            currentEsc: escCurrent[15]
            voltageEsc: escVoltage[15]
            rpmEsc: escRpm[15]
            temperatureEsc: escTemperature[15]
            statusEsc: escStatus[15]
            onSendClickId: {
                messageBox.escId = 16
                messageBox.messageText = qsTr("配置%1号电机").arg(16)
                messageBox.sendId = "VOLT_PROT_CH"
                messageBox.open()
            }
        }

        // Advanced mode toggle button
        Button {
            anchors.right: parent.right
            width: 40 * sw
            height: 40 * sw
            onClicked: {
                isAdvancedMode = !isAdvancedMode
            }
            background: Rectangle {
                radius: 5
                color: mainColor
                Image {
                    width: 40 * sw
                    height: 40 * sw
                    source: isAdvancedMode ? advancedModeUpIcon : advancedModeDownIcon
                }
            }
        }

        // Bottom spacing
        Item {
            width: parent.width
            height: 40 * sw
        }
    }

    // Helper function to get ESC values
    function getEscValue(motorId, index, escArray) {
        const motorGroups = [
            { start: 1, end: 4, offset: 0 },
            { start: 5, end: 8, offset: 4 },
            { start: 9, end: 12, offset: 8 },
            { start: 13, end: 16, offset: 12 }
        ]

        for (const group of motorGroups) {
            if (motorId >= group.start && motorId <= group.end && index === group.offset) {
                const arrayIndex = motorId - group.start
                return parseFloat(escArray[arrayIndex])
            }
        }
        return 0
    }

    // Message box component
    VKMessageShow {
        id: messageBox
        anchors.centerIn: parent
        popupWidth: parent.width * 0.5
        messageType: 1
        popupHeight: 240 * sw
    }
}
