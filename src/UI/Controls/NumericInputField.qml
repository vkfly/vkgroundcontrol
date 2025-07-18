import QtQuick 2.15
import QtQuick.Layouts 1.15

import ScreenTools

Item {
    id: textMathPartRoot
    
    // Public properties with camelCase naming
    property string content: "0"
    property string textColor: isValueValid ? "black" : "red"
    property real baseFontSize: 45
    property real minValue: 0
    property real maxValue: 0
    property string title: "title"
    property string unitText: ""

    // 计算属性：值是否有效
    readonly property bool isValueValid: {
        return (parseFloat(valueTextInput.text) <= parseFloat(maxValue) &&
               parseFloat(valueTextInput.text) >= parseFloat(minValue)) || valueTextInput.text === "-"
    }

    function reset() {
        valueTextInput.text = ""
    }

    function currentValue() {
        return valueTextInput.text
    }

    // Component dimensions
    width: 270 * mainWindow.sw * 1.3
    height: 85 * sw * 1.3

    // Text synchronization between Item and internal TextInput
    onContentChanged: {
        valueTextInput.text = processNumber(content)
        adjustTextSize()
    }

    // Automatically adjust text size based on content width
    function adjustTextSize() {
        var textWidth = valueTextInput.contentWidth
        
        // Reduce font size if text is too wide
        if (textWidth > valueTextInput.width) {
            while (textWidth > valueTextInput.width && baseFontSize > 10) {
                baseFontSize -= 1
                valueTextInput.font.pixelSize = baseFontSize
                textWidth = valueTextInput.contentWidth
            }
        } 
        // Increase font size if there's space available
        else {
            while (textWidth < valueTextInput.width && baseFontSize < 45) {
                baseFontSize += 1
                valueTextInput.font.pixelSize = baseFontSize
                textWidth = valueTextInput.contentWidth
            }
        }
    }

    // Remove leading zeros from numbers (except decimals)
    function processNumber(number) {
        if (number.length > 1) {
            if (number.charAt(0) === '0' && !number.includes('.')) {
                console.log("processNumber",number.substring(1))
                return number.substring(1)
            }
        }
        return number
    }

    // Main content layout
    Column {
        anchors.fill: parent
        anchors.leftMargin: 15 * sw * 1.3
        anchors.rightMargin: 15 * sw * 1.3
        spacing: 0

        // Top spacing
        Item {
            width: parent.width
            height: 5 * sw * 1.3
        }

        // Title text
        Text {
            id: titleText
            text: title
            color: "white"
            width: parent.width
            height: 30 * sw * 1.3
            font.pixelSize: 20 * sw * 1.3
            font.bold: false
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        // Range description text
        Text {
            id: rangeText
            text: qsTr("数值的范围是：%1到%2").arg(minValue).arg(maxValue)
            color: "white"
            width: parent.width
            height: 30 * sw
            font.pixelSize: 15 * sw
            font.bold: false
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        // Input field container
        Item {
            id: inputContainer
            width: parent.width
            height: 45 * sw * 1.3 * 1.3

            // Background rectangle
            Rectangle {
                id: inputBackground
                anchors.fill: parent
                color: "white"
                radius: 5
            }

            // Input row layout
            Row {
                id: inputRow
                width: parent.width - 30 * sw * 1.3
                height: parent.height
                anchors.centerIn: parent

                // Text input field
                TextInput {
                    id: valueTextInput
                    width: parent.width - unitLabel.contentWidth - 20
                    height: parent.height
                    color: textColor
                    font.pixelSize: baseFontSize * sw * 1.3
                    font.bold: false
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                    onTextChanged: {
                        valueTextInput.text = processNumber(text)
                    }
                }

                // Unit label
                Text {
                    id: unitLabel
                    text: unitText
                    color: "black"
                    height: parent.height * 0.9
                    font.pixelSize: 35 * sw
                    font.bold: false
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                }
            }
        }
    }
}
