import QtQuick
import QtQuick.Controls
import VKGroundControl
import ScreenTools
import VkSdkInstance

Item {
    id: parameterDisplay
    width: parent.width
    height: parent.height

    // 基础显示属性
    property real fontSize: 30 * sw * 5 / 6
    property double textWidth: 120 * sw

    // 参数相关属性
    property string paramKey: ""
    property real paramValue: 0
    property int fixNum: 0
    property string labelName: "Parameter"
    property string msLabelName: ""
    property string unit: "m/s"

    // 键盘输入相关属性
    property real minValue: 0
    property real maxValue: 100
    property int valueType: 3
    property int sendId: 99

    // 信号定义
    signal valueClicked()

    // 主布局
    Row {
        width: parent.width
        height: ScreenTools.defaultFontPixelWidth * 7.2

        // 标签列
        Column {
            width: textWidth
            height: 60 * sw
            anchors.verticalCenter: parent.verticalCenter

            Text {
                height: parent.height
                width: textWidth
                text: labelName
                font.pixelSize: fontSize
                font.bold: false
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "gray"
            }

            Text {
                height: 20 * sw
                width: textWidth
                text: msLabelName
                font.pixelSize: 30 * sh
                font.bold: false
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.Top
                color: "gray"
                visible: msLabelName !== ""
            }
        }

        // 数值显示区域
        Item {
            width: calculateDisplayWidth()
            height: 50 * sw
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                width: parent.width
                height: 50 * sw
                border.width: 1
                border.color: "black"
                color: "white"
                radius: 3

                Text {
                    anchors.centerIn: parent
                    width: parent.width - 10 * sw
                    height: 50 * sw
                    font.pixelSize: fontSize
                    font.bold: false
                    text: paramValue.toFixed(fixNum) + unit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        valueClicked()
                        // 可选：触发键盘输入
                        if (typeof keyBoardNumView !== 'undefined') {
                            keyBoardNumView.parameterName = paramKey
                            keyBoardNumView.valueType = valueType
                            keyBoardNumView.sendId = sendId
                            keyBoardNumView.setInputParameters(minValue, maxValue, labelName, unit, fixNum, paramValue)
                            keyBoardNumView.visible = true
                        }
                    }
                }
            }
        }
    }

    // 辅助函数
    function calculateDisplayWidth() {
        var baseWidth = parent.width - textWidth - 20 * sw
        return baseWidth < 100 ? 100 : (baseWidth > 300 ? 300 : baseWidth)
    }

    // 参数值更新函数
    function updateValue(newValue) {
        if (newValue >= minValue && newValue <= maxValue) {
            paramValue = newValue
        }
    }
}
