import QtQuick
import QtQuick.Controls
import QtQuick.Window

import VKGroundControl
import ScreenTools

/**
 * 数字键盘输入组件
 * 提供数字输入、范围验证和确认功能
 */
Item {
    id: root

    // 公共属性
    property bool shouldSend: false                 // 是否发送
    property int decimalPlaces: 0                   // 小数位数
    property int valueType: 3                       // 值类型
    property int sendId: 0                          // 发送ID: 0-不发送, 1-速度, 2-高度
    property string valueOk: "0"                    // 确认后的值
    property string currentText: "0"                // 当前显示的文本
    property real minValue: 0                        // 最小值
    property real maxValue: 100                      // 最大值
    property string titleText: "title"              // 标题文本
    property string unitText: ""                    // 单位文本
    property string parameterName: ""               // 参数名称
    property bool isInit: false

    // 信号
    signal keyboardConfirmed()                      // 键盘确认信号
    signal keyboardCancelled()                      // 键盘取消信号

    // 组件属性
    visible: false
    width: 270 * sw * 1.3
    height: 390 * sw * 1.3

    onVisibleChanged: {
        if(visible) {
            isInit = true
        }
    }
    // 主容器
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        radius: 15 * sw * 1.3
        border.width: 30
        
        Column {
            id: mainColumn
            anchors.fill: parent
            spacing: 50 * sw

            // 文本显示部分
            NumericInputField {
                id: textDisplay
                content: root.currentText
                title: titleText
                minValue: root.minValue
                maxValue: root.maxValue
                unitText: root.unitText
            }

            // 数学键盘部分
            MathKeyboard {
                id: mathKeyboard
                isValid: textDisplay.isValueValid
                onNumberClicked: handleKeyboardInput(keyboardNumber)
            }
        }
    }
    
    /**
     * 处理键盘输入
     * @param keyValue 键盘输入的值
     */
    function handleKeyboardInput(keyValue) {
        if(isInit) {
            currentText = ""
            isInit = false
        }
        switch (keyValue) {
            case "OK":
                if (textDisplay.isValueValid) {
                    currentText = textDisplay.currentValue()
                    keyboardConfirmed()
                }
                break

            case "Ext":
                keyboardCancelled()
                break

            case "CLE":
                reset()
                break

            default:
                // textDisplay.text = processKeyboardInput(textDisplay.text, keyValue)
                root.currentText = processKeyboardInput(root.currentText, keyValue)
                break
        }
    }
    
    /**
     * 处理键盘输入逻辑
     * @param currentText 当前文本
     * @param keyValue 按键值
     * @return 处理后的文本
     */
    function processKeyboardInput(currentText, keyValue) {
        var result = currentText
        
        switch (keyValue) {
            case "DEL":
                result = result.slice(0, result.length - 1)
                break

            case "-":
                result = toggleNegativeSign(result)
                break

            default:
                // 数字输入
                result += keyValue
                break
        }
        return result
    }
    
    /**
     * 切换负号
     * @param text 当前文本
     * @return 切换负号后的文本
     */
    function toggleNegativeSign(text) {
        if (text === "") {
            return "-"
        } else if (text === "-") {
            return ""
        } else if (text.charAt(0) === "-") {
            return text.slice(1)  // 移除负号
        } else {
            return "-" + text     // 添加负号
        }
    }
    
    /**
     * 设置输入参数
     * @param min 最小值
     * @param max 最大值
     * @param title 标题
     * @param unit 单位
     * @param decimals 小数位数
     * @param initialText 初始文本
     */
    function setInputParameters(min, max, title, unit, decimals, initialText) {
        minValue = min
        maxValue = max
        titleText = title
        unitText = unit
        decimalPlaces = decimals
        currentText = initialText
    }

    /**
     * 重置组件状态
     */
    function reset() {
        currentText = ""
        textDisplay.reset()
    }

    /**
     * 获取当前输入值（数字类型）
     */
    function getCurrentValue() {
        return parseFloat(currentText) || 0
    }

    /**
     * 验证当前值是否在有效范围内
     */
    function isCurrentValueValid() {
        var value = getCurrentValue()
        var min = parseFloat(minValue)
        var max = parseFloat(maxValue)
        return value >= min && value <= max
    }
}
