import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import ScreenTools
import Controls

Item {
    id: parameterTextControl
    width: parent.width
    height: parent.height

    // 驼峰命名的属性
    property color backgroundColor: ScreenTools.titleColor
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5 / 6
    property color textColor: "white"
    
    // 尺寸属性
    property double textWidth: 240 * ScreenTools.scaleWidth
    property double text2Width: 300 * ScreenTools.scaleWidth
    property double text1Width: 320 * ScreenTools.scaleWidth
    
    // 参数相关属性
    property string labelName: ""
    property real maxValue: 100
    property real minValue: -100
    property real value: 0
    
    // 信号定义
    signal textChanged(var text)

    // 主要内容区域
    Item {
        width: parent.width
        height: 50 * ScreenTools.scaleWidth
        
        // 标签区域
        VKLabel {
            id: labelColumn
            width: textWidth
            height: 50 * ScreenTools.scaleWidth
            anchors.verticalCenter: parent.verticalCenter
            text: labelName
            fontSize: buttonFontSize
            color: textColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        
        Rectangle {
            id: _content
            width: text1Width
            height: 50 * ScreenTools.scaleWidth
            anchors.verticalCenter: parent.verticalCenter
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

            // 控制按钮和输入框区域
            Row {
                anchors.fill: parent
                spacing: 2 * sw

                // 减少按钮
                IconButton {
                    id: decreaseButton
                    imageSource: "/qmlimages/icon/del.png"
                    imageSize: 50 * ScreenTools.scaleWidth * 0.7
                    autoSize: false
                    width: 80 * ScreenTools.scaleWidth
                    height: 50 * ScreenTools.scaleWidth
                    anchors.verticalCenter: parent.verticalCenter
                    backgroundColor: parameterTextControl.backgroundColor
                    backgroundOpacity: 1.0
                    toolTipText: qsTr("减少")
                    enabled: value > minValue

                    onClicked: {
                        if (value > minValue) {
                            value = parseInt(value) - 1
                            textChanged(value)
                        }
                    }
                }

                // 输入框区域
                Item {
                    width: text1Width - 160 * ScreenTools.scaleWidth
                    height: 50 * ScreenTools.scaleWidth
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        border.width: 1
                        border.color: "black"
                    }

                    TextField {
                        id: inputField
                        anchors.fill: parent
                        font.pixelSize: buttonFontSize
                        font.bold: false
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        selectByMouse: true

                        background: Rectangle {
                            color: "transparent"
                        }

                        validator: DoubleValidator {
                            bottom: minValue
                            top: maxValue
                            decimals: 1
                        }

                        Connections {
                            target: parameterTextControl
                            function onValueChanged() {
                                inputField.text = parameterTextControl.value.toString()
                            }
                        }

                        Component.onCompleted: {
                            text = parameterTextControl.value.toString()
                        }

                        onTextChanged: {
                            let validText = text.trim()

                            // 允许 NaN 作为有效输入
                            if (validText.toLowerCase() === "nan") {
                                value = NaN
                                parameterTextControl.textChanged(value)
                                return
                            }

                            // 移除所有非数字、非小数点和非负号字符
                            validText = validText.replace(/[^0-9.-]/g, "")

                            // 只允许开头出现一个负号
                            if (validText.indexOf("-") !== validText.lastIndexOf("-")) {
                                validText = validText.replace(/[^0-9.-]/g, "")
                            }

                            // 确保只允许一个小数点
                            let parts = validText.split(".")
                            if (parts.length > 2) {
                                validText = parts[0] + "." + parts.slice(1).join("")
                            }

                            // 检查是否为有效数字并在有效范围内
                            let numericValue = parseFloat(validText)
                            if (!isNaN(numericValue) && numericValue >= minValue && numericValue <= maxValue) {
                                value = numericValue
                                parameterTextControl.textChanged(value)
                            } else if (validText === "") {
                                value = 0
                                parameterTextControl.textChanged(value)
                            }
                        }
                    }
                }

                // 增加按钮
                IconButton {
                    id: increaseButton
                    imageSource: "/qmlimages/icon/add.png"
                    imageSize: 50 * ScreenTools.scaleWidth * 0.7
                    autoSize: false
                    width: 80 * ScreenTools.scaleWidth
                    height: 50 * ScreenTools.scaleWidth
                    anchors.verticalCenter: parent.verticalCenter
                    backgroundColor: parameterTextControl.backgroundColor
                    backgroundOpacity: 1.0
                    toolTipText: qsTr("增加")
                    enabled: value < maxValue

                    onClicked: {
                        if (value < maxValue) {
                            value = parseInt(value) + 1
                            parameterTextControl.textChanged(value)
                        }
                    }
                }
            }
        }

    }
}
