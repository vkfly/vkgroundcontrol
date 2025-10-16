import QtQuick
import QtQuick.Controls

import VKGroundControl
import VKGroundControl.Palette
import ScreenTools
import VKGroundControl.Controllers
import VkSdkInstance 1.0

Item {
    id: root

    // UI Properties
    property color backgroundColor: qgcPal.titleColor
    property string titleName: qsTr("通道名称")
    property color mainColor: qgcPal.titleColor
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5/6

    // Value Properties
    property int valueType: 3
    property real barValue: 0
    property real minValue: 0
    property real maxValue: 2500
    property int toFix: 0
    property double curValue: 0
    property double curValue1: 0
    property bool takePhotoType: false
    property double addValue: 1
    property string unit: ""
    property int oldText: 0

    // Optimized Parameter Properties
    property var paramNames: ["", "", "", ""]
    property var paramValues: [0, 0, 0, 0]
    property var paramVisibility: [true, true, true, true]

    // Original param property kept separate for compatibility
    property string param: ""

    property var value1 : ""
    property string paramName1: paramNames[0] || ""
    property string paramName2: paramNames[1] || ""
    property string paramName3: paramNames[2] || ""
    property string paramName4: paramNames[3] || ""

    Component.onCompleted: {
            // 初始化加载所有参数
            if (activeVehicle) {
                updateParamValue(paramName1);
                updateParamValue(paramName2);
                updateParamValue(paramName3);
                updateParamValue(paramName4);
            }
        }

    function updateParamValue(name) {
        if (!name || !activeVehicle) return;

        var rawValue = activeVehicle.parameters[name];
        if (rawValue === undefined) {
            console.warn("Parameter not found:", name);
            return;
        }

        var intValue = parseInt(rawValue);
        if (isNaN(intValue)) {
            console.warn("Invalid parameter value:", name, rawValue);
            return;
        }

        if (name === paramName1) {
            if (paramName1 === "PHO_SIG_TYPE") {
                comboBox1.currentIndex = intValue;
            } else {
                if (intValue === 0) {
                    comboBox1.currentIndex = 0;
                } else {
                    comboBox1.currentIndex = intValue - 6;
                }
            }
        }
        else if (name === paramName2) {
            if (intValue === 0) {
                comboBox2.currentIndex = 0;
            } else {
                comboBox2.currentIndex = intValue - 4;
            }
        }
        else if (name === paramName3) {
            textField1.text = intValue;
        }
        else if (name === paramName4) {
            textField2.text = intValue;
        }
    }

    // 监听参数变化
    Connections {
        target: activeVehicle
        ignoreUnknownSignals: true
        function onParamChanged() {
            console.log("onParametersChanged")
            if (activeVehicle) {
                updateParamValue(paramName1);
                updateParamValue(paramName2);
                updateParamValue(paramName3);
                updateParamValue(paramName4);
            }
        }
    }

    // Models
    property ListModel channelModel: ListModel {
        ListElement { text: qsTr("不启用") }
        ListElement { text: qsTr("通道 7") }
        ListElement { text: qsTr("通道 8") }
        ListElement { text: qsTr("通道 9") }
        ListElement { text: qsTr("通道 10") }
        ListElement { text: qsTr("通道 11") }
        ListElement { text: qsTr("通道 12") }
        ListElement { text: qsTr("通道 13") }
        ListElement { text: qsTr("通道 14") }
        ListElement { text: qsTr("通道 15") }
        ListElement { text: qsTr("通道 16") }
    }

    property ListModel pwmModelV10: ListModel {
        ListElement { text: qsTr("不启用") }
        ListElement { text: qsTr("M 5") }
        ListElement { text: qsTr("M 6") }
        ListElement { text: qsTr("M 7") }
        ListElement { text: qsTr("M 8") }
        ListElement { text: qsTr("M 9") }
        ListElement { text: qsTr("M 10") }
        ListElement { text: qsTr("M 11") }
        ListElement { text: qsTr("M 12") }
        ListElement { text: qsTr("M 13") }
        ListElement { text: qsTr("M 14") }
        ListElement { text: qsTr("M 15") }
        ListElement { text: qsTr("M 16") }
    }

    property ListModel pwmModelV12: ListModel {
        ListElement { text: qsTr("不启用") }
        ListElement { text: qsTr("M 5") }
        ListElement { text: qsTr("M 6") }
        ListElement { text: qsTr("M 7") }
        ListElement { text: qsTr("M 8") }
        ListElement { text: qsTr("S 1") }
        ListElement { text: qsTr("S 2") }
    }

    property ListModel photoTypeModel: ListModel {
        ListElement { text: qsTr("低电平") }
        ListElement { text: qsTr("高电平") }
        ListElement { text: qsTr("PWM") }
    }


    VKPalette {
        id: qgcPal
    }

    // name: value
    width: parent.width
    height: parent.height

    Item {
        width: parent.width
        height: parent.height

        Row {
            width: parent.width * 0.95
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: parent.width / 6 * 0.25
            Text {
                width: parent.width / 8
                height: 60 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                text: titleName
                font.pixelSize: buttonFontSize
                font.bold: false
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Item {
                width: parent.width / 8
                height: 60 * ScreenTools.scaleWidth
                ComboBox {
                    visible: paramVisibility[0]
                    id: comboBox1
                    width: parent.width
                    height: 60 * ScreenTools.scaleWidth

                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: buttonFontSize
                    font.bold: false
                    model: takePhotoType ? photoTypeModel : channelModel
                    background: Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: "white"
                        border.width: 1
                        border.color: "black"
                    }
                    contentItem: Text {
                        text: comboBox1.currentText
                        font.pixelSize: buttonFontSize
                        color: "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    delegate: ItemDelegate {
                        width: comboBox1.width
                        height: 60 * ScreenTools.scaleWidth
                        background: Rectangle {
                            anchors.fill: parent
                            color: "white"
                        }
                        Text {
                            width: comboBox1.width
                            height: 60 * ScreenTools.scaleWidth
                            font.pixelSize: buttonFontSize
                            text: model.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            font.bold: false
                        }
                    }
                    currentIndex: 0
                    onActivated: {
                        if (activeVehicle) {

                            if ("PHO_SIG_TYPE" === paramName1) {
                                activeVehicle.setParam(
                                            paramName1, comboBox1.currentIndex)
                            } else {
                                if (currentIndex > 0)
                                    activeVehicle.setParam(
                                                paramName1,
                                                comboBox1.currentIndex + 6)
                                else {
                                    activeVehicle.setParam(
                                                paramName1,  0)
                                }
                            }
                        }
                    }
                }
            }
            Item {
                width: parent.width / 8
                height: 60 * ScreenTools.scaleWidth
                ComboBox {
                    id: comboBox2
                    visible: paramVisibility[1]
                    width: parent.width
                    //height:  parent.height
                    height: 60 * ScreenTools.scaleWidth
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: buttonFontSize
                    font.bold: false

                    model: fcumodel_versions === "V10Pro" ? pwmModelV10 : pwmModelV12
                    background: Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: "white"
                        border.width: 1
                        border.color: "black"
                    }
                    contentItem: Text {
                        text: comboBox2.currentText
                        font.pixelSize: buttonFontSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    delegate: ItemDelegate {
                        width: comboBox2.width
                        height: 60 * ScreenTools.scaleWidth
                        background: Rectangle {
                            anchors.fill: parent
                            color: "white"
                        }
                        Text {
                            width: comboBox1.width
                            height: 60 * ScreenTools.scaleWidth
                            font.pixelSize: buttonFontSize
                            text: model.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            font.bold: false
                        }
                    }

                    onActivated: {
                        if (activeVehicle) {

                            if ("PHO_SIG_CH" === paramName2) {
                                if (currentIndex > 0)
                                    activeVehicle.setParam(
                                                paramName2,
                                                comboBox2.currentIndex + 4)
                                else {
                                    activeVehicle.setParam(
                                                paramName2, 0)
                                }
                            } else {
                                if (currentIndex > 0)
                                    activeVehicle.setParam(
                                                paramName2,
                                                comboBox2.currentIndex + 4)
                                else {
                                    activeVehicle.setParam(
                                                paramName2, 0)
                                }
                            }
                        }
                    }
                    currentIndex: 0
                }
            }
            Item {
                width: parent.width / 5
                height: 60 * ScreenTools.scaleWidth
                Row {
                    visible: paramVisibility[2]
                    width: parent.width
                    //height:  parent.height
                    height: 60 * ScreenTools.scaleWidth
                    anchors.verticalCenter: parent.verticalCenter
                    Button {
                        id: decreaseButton1
                        width: 60 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: buttonFontSize * 1.5
                        font.bold: false
                        //text: "-"
                        background: Rectangle {
                            anchors.fill: parent
                            radius: 10
                            Rectangle {
                                anchors.fill: parent
                                radius: 10
                                height: parent.height
                                color: decreaseButton1.pressed ? "gray" : backgroundColor
                            }
                            Image {
                                width: parent.height * 0.8
                                height: parent.height * 0.8
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "/qmlimages/icon/del.png"
                            }
                            color: "#00000000"
                        }

                        onClicked: {
                            textField1.text = parseInt(textField1.text) - 50
                            activeVehicle.setParam(
                                         paramName3, textField1.text)
                        }
                    }
                    Text {
                        width: 2 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                    }
                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 124 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        // anchors.verticalCenter: parent.verticalCenter
                        Rectangle {
                            anchors.fill: parent
                            color: "white"
                            border.width: 1
                            border.color: "black"
                        }
                        TextField {
                            id: textField1
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 50 * ScreenTools.scaleWidth
                            font.pixelSize: buttonFontSize
                            font.bold: false
                            //text: slider.value.toFixed(fixnum)+danwei
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            onTextChanged: {
                                // 将输入的文本转换为整数
                                var number = parseInt(textField1.text, 10)
                                // 如果输入的数字不在0-3000范围内，则重置为0
                                if (isNaN(number) || number <= 0) {
                                    number = 0
                                } else if (number > maxValue) {
                                    number = maxValue
                                }
                                // 更新textField显示的文本
                                textField1.text = number.toString()
                                //_activeVehicle.parameterManager._sendParamToVehicle(canshu,value_type,slider.value.toString());
                            }
                            //onEditingFinished:
                            onEditingFinished: {
                                activeVehicle.setParam(
                                             paramName3, textField1.text)
                            }
                        }
                    }
                    Text {
                        width: 2 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                    }
                    Button {
                        id: increaseButton1
                        width: 60 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: buttonFontSize * 1.5
                        font.bold: false

                        //text: "+"
                        background: Rectangle {
                            anchors.fill: parent
                            radius: 10
                            Rectangle {
                                anchors.fill: parent
                                radius: 10
                                height: parent.height
                                //(color.hovered || control.pressed)
                                color: increaseButton1.pressed ? "gray" : backgroundColor
                            }
                            Image {
                                width: parent.height * 0.8
                                height: parent.height * 0.8
                                source: "/qmlimages/icon/add.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            color: "#00000000"
                        }

                        onClicked: {
                            textField1.text = parseInt(textField1.text) + 50
                            activeVehicle.setParam(
                                         paramName3, textField1.text)
                        }
                    }
                }
            }
            Item {
                width: parent.width / 5
                height: 60 * ScreenTools.scaleWidth
                Row {
                    visible: paramVisibility[3]
                    width: parent.width
                    //height:  parent.height
                    height: 60 * ScreenTools.scaleWidth
                    anchors.verticalCenter: parent.verticalCenter
                    Button {
                        id: decreaseButton2
                        width: 60 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: buttonFontSize * 1.5
                        font.bold: false

                        background: Rectangle {
                            anchors.fill: parent
                            radius: 10
                            Rectangle {
                                anchors.fill: parent
                                radius: 10
                                height: parent.height
                                color: decreaseButton2.pressed ? "gray" : backgroundColor
                            }
                            Image {
                                width: parent.height * 0.8
                                height: parent.height * 0.8
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "/qmlimages/icon/del.png"
                            }
                            color: "#00000000"
                        }

                        onClicked: {
                            textField2.text = parseInt(textField2.text) - 50
                            activeVehicle.setParam(
                                         paramName4, textField2.text)
                        }
                    }
                    Text {
                        width: 2 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                    }
                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 124 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        Rectangle {
                            anchors.fill: parent
                            color: "white"
                            border.width: 1
                            border.color: "black"
                        }
                        TextField {
                            id: textField2
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 50 * ScreenTools.scaleWidth
                            font.pixelSize: buttonFontSize
                            font.bold: false
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"
                            onTextChanged: {
                                // 将输入的文本转换为整数
                                var number = parseInt(textField2.text, 10)
                                // 如果输入的数字不在0-3000范围内，则重置为0
                                if (isNaN(number) || number <= 0) {
                                    number = 0
                                } else if (number > maxValue) {
                                    number = maxValue
                                }
                                // 更新textField显示的文本
                                textField2.text = number.toString()
                            }
                            onEditingFinished: {
                                activeVehicle.setParam(
                                             paramName4, textField2.text)
                            }
                        }
                    }
                    Text {
                        width: 2 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                    }
                    Button {
                        id: increaseButton2
                        width: 60 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: buttonFontSize * 1.5
                        font.bold: false

                        //text: "+"
                        background: Rectangle {
                            anchors.fill: parent
                            radius: 10
                            Rectangle {
                                anchors.fill: parent
                                radius: 10
                                height: parent.height
                                color: increaseButton2.pressed ? "gray" : backgroundColor
                            }
                            Image {
                                width: parent.height * 0.8
                                height: parent.height * 0.8
                                source: "/qmlimages/icon/add.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            color: "#00000000"
                        }

                        onClicked: {
                            textField2.text = parseInt(textField2.text) + 50
                            activeVehicle.setParam(
                                         paramName4, textField2.text)
                        }
                    }
                }
            }
        }
    }
}
