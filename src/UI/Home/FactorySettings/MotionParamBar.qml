import QtQuick
import QtQuick.Controls
import QtQuick.Window

import VKGroundControl
import Controls
import VKGroundControl.Palette
// import VKGroundControl.Vehicle
// import VKGroundControl.MultiVehicleManager
import ScreenTools
import VkSdkInstance

Item {
    // UI Properties
    property var mainColor: qgcPal.titleColor
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5/6
    property string textColor: "white"
    property double textWidth: 240 * ScreenTools.scaleWidth
    property double text2Width: 300 * ScreenTools.scaleWidth
    property real parameterValue: 0

    // Parameter Control Properties
    property int decimalPlaces: 0
    property string parameter: ""
    property int oldValue: 0
    property int valueType: 3
    property real sliderMinValue: 0
    property real sliderMaxValue: 100
    property string labelName: "Volume"
    property string subLabelName: ""
    property string unit: "m/s"
    property real sliderValue: sliderMinValue
    property real paramValue1: 0
    property real sendId: 99

    // Icon Properties
    property string uploadIcon: "/qmlimages/icon/upload.png"
    property string uploadSuccessIcon: "/qmlimages/icon/upload.png"
    property string uploadFailIcon: "/qmlimages/icon/uploadfail.png"

    //TODO暂时处理
    property bool isConnected:  VkSdkInstance.vehicleManager.activeVehicle !== null

    id: parameterVolumeControl
    width: parent.width
    height: parent.height

    VKPalette {
        id: qgcPal
    }

    signal clickText()

    Item {
        width: parent.width
        height: 60 * ScreenTools.scaleWidth

        Column {
            width: textWidth
            height: 60 * ScreenTools.scaleWidth

            // 主标签
            VKLabel {
                id: mainLabel
                width: parent.width
                height: parent.height
                text: labelName
                fontSize: buttonFontSize
                color: textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            // 副标签
            VKLabel {
                id: subLabel
                width: parent.width
                height: 20 * ScreenTools.scaleWidth
                anchors.top: mainLabel.bottom
                text: subLabelName
                fontSize: 30 * ScreenTools.scaleHeight
                color: textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                visible: subLabelName !== ""
            }
        }

        Row {
            width: 320 * ScreenTools.scaleWidth
            height: 60 * ScreenTools.scaleWidth
            anchors.right: parent.right
            spacing: 2 * ScreenTools.scaleWidth

            Button {
                id: decreaseButton
                width: 80 * ScreenTools.scaleWidth
                height: 50 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: buttonFontSize * 1.5
                font.bold: false

                background: Rectangle {
                    anchors.fill: parent
                    radius: 5
                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        height: parent.height
                        color: decreaseButton.pressed ? "gray" : mainColor
                    }
                    Image {
                        width: parent.height * 0.7
                        height: parent.height * 0.7
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: "/qmlimages/icon/del.png"
                    }
                    color: "#00000000"
                }

                onClicked: {
                    if (!isConnected) return
                    let step = Math.pow(10, -decimalPlaces)
                    let newValue = parameterValue - step

                    newValue = Math.max(newValue, sliderMinValue)
                    //更新显示值
                    parameterValue = Number(newValue.toFixed(decimalPlaces))
                    if(VkSdkInstance.vehicleManager.activeVehicle){
                        VkSdkInstance.vehicleManager.activeVehicle.setParam(parameter,parameterValue);
                    }
                }
            }

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: 160 * ScreenTools.scaleWidth
                height: 50 * ScreenTools.scaleWidth

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    border.width: 1
                    border.color: "black"
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 160 * ScreenTools.scaleWidth
                    height: 50 * ScreenTools.scaleWidth
                    font.pixelSize: buttonFontSize
                    font.bold: false
                    text: parameterValue.toFixed(decimalPlaces) + unit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            keyBoardNumView.parameterName = parameter
                            keyBoardNumView.valueType = valueType
                            keyBoardNumView.sendId = sendId
                            keyBoardNumView.setInputParameters(sliderMinValue,sliderMaxValue,labelName,unit,decimalPlaces,parameterValue.toFixed(decimalPlaces))
                            keyBoardNumView.visible = true
                        }
                    }
                }
            }

            Button {
                id: increaseButton
                width: 80 * ScreenTools.scaleWidth
                height: 50 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: buttonFontSize * 1.5
                font.bold: false

                background: Rectangle {
                    anchors.fill: parent
                    radius: 5
                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        height: parent.height
                        color: increaseButton.pressed ? "gray" : mainColor
                    }
                    Image {
                        width: parent.height * 0.7
                        height: parent.height * 0.7
                        source: "/qmlimages/icon/add.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    color: "#00000000"
                }

                onClicked: {
                    if (!isConnected) return
                    let step = Math.pow(10, -decimalPlaces)
                    let newValue = parameterValue + step
                    newValue = Math.min(newValue, sliderMaxValue)
                    // 更新显示值
                    parameterValue = Number(newValue.toFixed(decimalPlaces))

                    // 发送参数到车辆
                    if(VkSdkInstance.vehicleManager.activeVehicle){
                        VkSdkInstance.vehicleManager.activeVehicle.setParam(parameter, parameterValue)
                    }
                }
            }
        }
    }

    // 参数值更新函数
    function updateParameterValue(newValue) {
        if (newValue >= minValue && newValue <= maxValue) {
            parameterValue = parseFloat(newValue.toFixed(fixNum))
        }
    }

    // 获取参数值函数
    function getParameterValue(paramName, currentParam) {
        if (paramName === currentParam) {
            if (fixNum !== 0) {
                var floatValue = parseFloat(parameterValue)
                var doubleValue = floatValue.toFixed(fixNum)
                oldText = doubleValue
                return doubleValue
            }
            oldText = parseInt(parameterValue)
            return parseInt(parameterValue)
        } else {
            return oldText
        }
    }
}
