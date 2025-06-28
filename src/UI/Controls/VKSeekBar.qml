import QtQuick
import QtQuick.Controls

import VKGroundControl
import VKGroundControl.Controllers
import ScreenTools
import VKGroundControl.Palette
import VkSdkInstance
Item {
    id: seekBar
    
    // 基本属性
    width: parent.width
    height: parent.height
    signal released
    
    // UI相关属性
    property string titleBarName: qsTr("滑块名称")
    property var buttonMain: qgcPal.titleColor
    property var buttonFontSize: 30 * ScreenTools.scaleWidth * 5 / 6
    property string decrementButtonColor: slider.value > slider.minSliderValue ? "blue" : "lightgray"
    property string incrementButtonColor: slider.value < slider.maxSliderValue ? "blue" : "lightgray"
    
    // 滑块相关属性
    property var valueType: 3
    property var barValue: 0
    property var minValue: 0
    property var maxValue: 100
    property int toFix: 0
    property double curValue: 0
    property double curSetValue: 0
    property double addValue: 1
    property var unit: ""
    property string param: ""
    property var oldText: 0
    property var param_value:""// name: value
    VKPalette { id: qgcPal}

    signal valueChanged(var value)

    onParam_valueChanged: {
        slider.value = param_value
        valueText.text = param_value.toFixed(toFix)
        curValue=param_value
    }
    // 参数值变化处理

    
    // 主布局
    Column {
        width: parent.width
        height: parent.height
        
        // 标题和当前值显示区域
        Item {
            width: parent.width
            height: parent.height / 2
            
            Row {
                width: parent.width
                height: parent.height

                // 标题文本
                Text {
                    width: parent.width / 2
                    height: parent.height
                    anchors.centerIn: parent.Center
                    text: titleBarName
                    font.pixelSize: buttonFontSize
                    font.bold: false
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: "gray"
                }
                
                // 当前值文本
                Text {
                    id: valueText
                    width: parent.width / 2 - 2 * parent.height
                    height: parent.height
                    anchors.centerIn: parent.Center
                    text: curValue.toFixed(toFix)
                    font.pixelSize: buttonFontSize
                    font.bold: false
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    color: buttonMain
                }
                
                // 单位文本
                Text {
                    width: 2 * parent.height
                    height: parent.height
                    anchors.centerIn: parent.Center
                    text: " " + unit
                    font.pixelSize: buttonFontSize
                    font.bold: false
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: buttonMain
                }
            }
        }
        
        // 滑块控制区域
        Item {
            width: parent.width
            height: parent.height / 2

            Row {
                width: parent.width
                height: parent.height
                spacing: 10

                // 减小按钮
                Button {
                    width: 80 * ScreenTools.scaleWidth
                    height: 50 * ScreenTools.scaleWidth

                    onClicked: {
                        if (curValue > minValue) {
                            curSetValue = (curValue - addValue).toFixed(toFix)
                            //valueChanged(curSetValue)
                            if (activeVehicle) {
                                activeVehicle.setParam(param, curSetValue)
                            }
                        }
                    }
                    
                    background: Rectangle {
                        width: parent.width
                        height: parent.height
                        anchors.centerIn: parent
                        color: curValue > minValue ? buttonMain : "gray"
                        radius: 5 * ScreenTools.scaleWidth
                        
                        Image {
                            width: parent.height * 0.7
                            height: parent.height * 0.7
                            anchors.centerIn: parent
                            source: "/qmlimages/icon/del.png"
                        }
                    }
                }
                
                // 滑块控件
                Slider {
                    id: slider
                    height: 35 * ScreenTools.scaleWidth
                    value: curValue.toFixed(toFix)
                    from: minValue
                    to: maxValue
                    width: parent.width - 2 * parent.height * 1.2 - 90
                    anchors.verticalCenter: parent.verticalCenter
                    background: Rectangle {
                        x: slider.leftPadding
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitHeight: 8
                        width: slider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: "#bdbebf"

                        Rectangle {
                            width: slider.visualPosition * parent.width
                            height: parent.height
                            color: "#21be2b"
                            radius: 2
                        }
                    }
                    handle: Rectangle {
                        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 26 * ScreenTools.scaleWidth
                        implicitHeight: 26 * ScreenTools.scaleWidth
                        radius: 13 * ScreenTools.scaleWidth
                        color: "#21be2b"
                        border.color: "#21be2b"
                    }
                    
                    onValueChanged: {
                        curSetValue = value.toFixed(toFix)
                        valueText.text = curSetValue
                    }
                    
                    onPressedChanged: {
                                         if( pressed ) {
                            //hoverShowAnimation.start()
                        }
                        else {
                            messageboxs.messageText=qsTr("设置%1为%2%3").arg(titleBarName).arg(curSetValue).arg(unit)
                            messageboxs.value=curSetValue.toFixed(toFix)
                            messageboxs.parameter=param
                            messageboxs.sendId=""
                            messageboxs.parameterY=1
                            messageboxs.valueType=9
                            slider.value=curValue
                            valueText.text=curValue
                            messageboxs.open()
                        }

                    }
                }

                // 增加按钮
                Button {
                    width: 80 * ScreenTools.scaleWidth
                    height: 50 * ScreenTools.scaleWidth
                    
                    onClicked: {
                        if (curValue < maxValue) {
                            curSetValue = (curValue + addValue).toFixed(toFix)
                            if (VkSdkInstance.vehicleManager.activeVehicle) {
                                VkSdkInstance.vehicleManager.activeVehicle.setParam(param, curSetValue)
                            }
                        }
                    }
                    
                    background: Rectangle {
                        width: parent.width
                        height: parent.height
                        anchors.centerIn: parent
                        radius: 5 * ScreenTools.scaleWidth
                        color: curValue < maxValue ? buttonMain : "gray"
                        
                        Image {
                            width: parent.height * 0.7
                            height: parent.height * 0.7
                            anchors.centerIn: parent
                            source: "/qmlimages/icon/add.png"
                        }    
                    }
                }
            }
        }
    }
    
    // 打开消息框的辅助函数
    // function openMessageBox() {
    //     messagebox.text_msg = qsTr("设置%1为%2%3").arg(titleBarName).arg(curSetValue).arg(unit)
    //     messagebox.canshu = param
    //     messagebox.canshu_y = 1
    //     messagebox.send_id = ""
    //     messagebox.value_type = valueType
    //     messagebox.value = curSetValue.toFixed(toFix)
    //     slider.value = curValue.toFixed(toFix)
    //     messagebox.open()
    // }
    
    // 获取参数值的辅助函数
    function getParamValue(paramName, param) {
        if (paramName === param) {
            if (toFix != 0) {
                var floatValue = parseFloat(paramValue1)
                var doubleValue = floatValue.toFixed(toFix)
                oldText = doubleValue
                return doubleValue
            }

            oldText = parseInt(paramValue1)
            return parseInt(paramValue1)
        } else {
            return oldText
        }
    }
}
