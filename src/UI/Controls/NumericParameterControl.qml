import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import ScreenTools
import VkSdkInstance
import Controls

Item {
    id: parameterVolumeControl
    width: parent.width
    height: parent.height

    // 驼峰命名的属性
    property color backgroundColor: ScreenTools.titleColor
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5 / 6
    property color textColor: "white"
    
    // 参数相关属性
    property int fixNum: 0
    property string parameterName: ""
    property var oldText: 0
    property int valueType: 3
    property real parameterValue: 0
    property real _parameterValue: 0
    property int sendId: 99
    
    // 滑块范围属性
    property real minValue: 0
    property real maxValue: 100
    property string labelName: "Volume"
    property string msLabelName: ""
    property string unit: "m/s"
    
    // 尺寸属性
    property double textWidth: 240 * ScreenTools.scaleWidth
    property double text2Width: 300 * ScreenTools.scaleWidth
        
    // 信号定义
    signal textClicked()

    onParameterValueChanged: {
        _parameterValue = parameterValue
    }

    property var handleTextClicked: function() {
        showKeyboardNumView()
    }

    property var handleTextChanged: function(param, value) {
        if (VkSdkInstance.vehicleManager.activeVehicle) {
            VkSdkInstance.vehicleManager.activeVehicle.setParam(param, value)
        }
    }

    function showKeyboardNumView() {
        // 触发键盘输入
        if (typeof keyBoardNumView !== 'undefined') {
            keyBoardNumView.parameterName = parameterName
            keyBoardNumView.sendId = sendId
            keyBoardNumView.setInputParameters(
                minValue,
                maxValue,
                labelName,
                unit,
                fixNum,
                parameterValue.toFixed(fixNum)
            )
            keyBoardNumView.keyboardConfirmed.connect(onKeyboardConfirmed)
            keyBoardNumView.visible = true
        }
    }

    function onKeyboardConfirmed() {
        keyBoardNumView.keyboardConfirmed.disconnect(onKeyboardConfirmed)
        handleTextChanged(keyBoardNumView.parameterName,keyBoardNumView.getCurrentValue())
    }

    // 主要内容区域
    Item {
        width: parent.width
        height: 60 * ScreenTools.scaleWidth
        
        // 标签区域
        Column {
            id: labelColumn
            width: textWidth
            height: 60 * ScreenTools.scaleWidth
            
            VKLabel {
                height: parent.height
                width: textWidth
                text: labelName
                fontSize: buttonFontSize
                color: textColor
                horizontalAlignment: Text.AlignLeft
            }
            
            VKLabel {
                height: 20 * ScreenTools.scaleWidth
                width: textWidth
                text: msLabelName
                fontSize: 30 * mainWindow.bili_height
                color: textColor
                horizontalAlignment: Text.AlignLeft
                visible: msLabelName !== ""
            }
        }
        
        Rectangle {
            id: _content
            width: 320 * ScreenTools.scaleWidth
            height: 50 * ScreenTools.scaleWidth
            anchors.right: parent.right
            radius: 8 * ScreenTools.scaleWidth
            color: "transparent"
            layer.enabled: true
            layer.effect: OpacityMask{
                maskSource: Rectangle{
                    width: _content.width
                    height: _content.height
                    radius: _content.radius
                }
            }
            // 控制按钮和数值显示区域
            Row {
                anchors.fill: parent
                spacing: 2 * ScreenTools.scaleWidth

                // 减少按钮
                IconButton {
                    id: decreaseButton
                    imageSource: "/qmlimages/icon/del.png"
                    imageSize: parent.height * 0.7
                    autoSize: false
                    width: 80 * ScreenTools.scaleWidth
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    backgroundColor: parameterVolumeControl.backgroundColor
                    backgroundOpacity: 1.0
                    enabled: _parameterValue > minValue

                    onClicked: {
                        var step = 1 / Math.pow(10, fixNum)
                        var newValue = _parameterValue - step
                        newValue = Math.max(newValue, minValue)
                        _parameterValue = parseFloat(newValue.toFixed(fixNum))
                        handleTextChanged(parameterName,_parameterValue)
                    }
                }

                // 数值显示区域
                Item {
                    width: 160 * ScreenTools.scaleWidth
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        border.width: 1
                        border.color: "black"
                        Text {
                            anchors.centerIn: parent
                            width: parent.width - 4 * ScreenTools.scaleWidth
                            height: parent.height
                            font.pixelSize: buttonFontSize
                            font.bold: false
                            text: _parameterValue.toFixed(fixNum) + unit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                textClicked()
                                // 触发键盘输入
                                if (typeof keyBoardNumView !== 'undefined') {
                                    keyBoardNumView.parameterName = parameterName
                                    keyBoardNumView.sendId = sendId
                                    keyBoardNumView.setInputParameters(
                                        minValue,
                                        maxValue,
                                        labelName,
                                        unit,
                                        fixNum,
                                        parameterValue.toFixed(fixNum)
                                    )
                                    keyBoardNumView.visible = true
                                }
                            }
                        }
                    }
                }

                // 增加按钮
                IconButton {
                    id: increaseButton
                    imageSource: "/qmlimages/icon/add.png"
                    imageSize: parent.height * 0.7
                    autoSize: false
                    width: 80 * ScreenTools.scaleWidth
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    backgroundColor: parameterVolumeControl.backgroundColor
                    backgroundOpacity: 1.0
                    enabled: _parameterValue < maxValue

                    onClicked: {
                        var step = 1 / Math.pow(10, fixNum)
                        var newValue = _parameterValue + step
                        newValue = Math.min(newValue, maxValue)
                        _parameterValue = parseFloat(newValue.toFixed(fixNum))
                        handleTextChanged(parameterName, _parameterValue)
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





