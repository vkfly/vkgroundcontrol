import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import VKGroundControl
import VKGroundControl.Palette
import VkSdkInstance
import Controls
import ScreenTools

Popup {
    id: calibrationPopup
    width: popupWidth
    height: mainColumn.height
    modal: true
    focus: true
    closePolicy:Popup.NoAutoClose

    // 尺寸属性
    property int popupWidth: 600 * ScreenTools.scaleWidth
    property int buttonFontSize:30 * ScreenTools.scaleWidth

    property int popupHeight: 720

    readonly property color buttonFontColor: "white"
    readonly property color cancelButtonColor: "gray"
    readonly property real cornerRadius: 15
    readonly property color backgroundColor: "white"
    property var rollAngle: _activeVehicle?_activeVehicle.attitude.attitudeRoll.toFixed(2) : 0
    property var pitchAngle: _activeVehicle?_activeVehicle.attitude.attitudePitch.toFixed(2) : 0

    property var _activeVehicle: VkSdkInstance.vehicleManager.activeVehicle

    background:Rectangle {
        width: parent.width
        height: mainColumn.height
        radius: cornerRadius

        color: "transparent"
        layer.enabled: true
        layer.effect: OpacityMask{
            maskSource: Rectangle{
                width: mainColumn.width
                height: mainColumn.height
                radius: cornerRadius
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: cornerRadius
            color: backgroundColor
        }

        Column {
            id: mainColumn
            width: parent.width
            spacing: 0

            Item{
                width:parent.width
                height: 30*ScreenTools.scaleWidth
            }

            Text{
                width:parent.width*0.8
                height:120*ScreenTools.scaleWidth
                color: "black"
                anchors.horizontalCenter: parent.horizontalCenter
                text:qsTr("横滚角 %1°  俯仰角 %2°").arg(rollAngle).arg(pitchAngle)
                font.pixelSize: buttonFontSize
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Item{
                width: parent.width
                height: 20*ScreenTools.scaleWidth
            }

            Item{
                width: parent.width
                height: 80*ScreenTools.scaleWidth
                Row{
                    width: parent.width
                    height: parent.height

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
                        onClicked: calibrationPopup.close()
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
                        onClicked: _activeVehicle.startCalibration(15) // 水平校准
                    }
                }
            }
        }
    }
}
