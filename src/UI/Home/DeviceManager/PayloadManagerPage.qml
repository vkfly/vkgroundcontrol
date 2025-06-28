import QtQuick
import QtQuick.Controls

import VKGroundControl
import Controls
import ScreenTools
import VkSdkInstance 1.0
// import VKGroundControl.Vehicle
// import VKGroundControl.MultiVehicleManager

import "../Common"

Flickable {
    // UI Properties
    property double textWidth: parent.width / 6 * 0.9 * 0.95
    property double textHeight: 65 * ScreenTools.scaleWidth
    property color backgroundColor: mainWindow.titlecolor
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5/6
    property color mainColor: mainWindow.titlecolor
    
    // Vehicle Properties
    property var activeVehicle: VkSdkInstance.vehicleManager.activeVehicle //TODO暂时这么处理，可以用activevehicle
    property int escIndex: activeVehicle ? activeVehicle.esc_index : ""
    property var escCurrent: activeVehicle ? activeVehicle.esc_current : ""
    property var escVoltage: activeVehicle ? activeVehicle.esc_vol : ""
    property var escRpm: activeVehicle ? activeVehicle.esc_rpm : ""
    
    // Advanced Settings
    property bool isAdvanced: false
    property string advancedIconDown: "/qmlimages/icon/down_arrow.png"
    property string advancedIconUp: "/qmlimages/icon/up_arrow.png"
    
    // Parameter Properties
    property var parameterManager: VKGroundControl.multiVehicleManager.activeVehicle1 ? VKGroundControl.multiVehicleManager.activeVehicle1.parameterManager : ""
    property var parachuteCell: activeVehicle ? activeVehicle.parachute_cell : new Array(6)
    property var paramName: activeVehicle ? parameterManager.paramName : ""
    property var paramValue: activeVehicle ? parameterManager.paramValue : ""
    
    // Filter Properties
    property int gyroFilterId: -1
    property int accelFilterId: -1
    property real speedValue: 0.05
    property int throwChannelCount: 1

    property var fcumodel_versions : activeVehicle.FlightController.deviceModel

    height: parent.height
    width: parent.width
    clip: true
    contentHeight: mainColumn.implicitHeight

    property var throwParamNames: ["THROW_CH1", "THROW_CH2", "THROW_CH3", "THROW_CH4",
                                  "THROW_CH5", "THROW_CH6", "THROW_CH7", "THROW_CH8"]

    Component.onCompleted: {
        if (activeVehicle) {
            // 初始化加载所有参数
            for (var i = 0; i < throwParamNames.length; i++) {
                updateThrowChannelCount(throwParamNames[i]);
            }
        }
    }

    function updateThrowChannelCount(name) {
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

        // 根据参数名更新通道计数
        if (name === "THROW_CH1" && intValue !== 0 && throwChannelCount <= 1) {
            throwChannelCount = 1;
        }
        else if (name === "THROW_CH2" && intValue !== 0 && throwChannelCount <= 2) {
            throwChannelCount = 2;
        }
        else if (name === "THROW_CH3" && intValue !== 0 && throwChannelCount <= 3) {
            throwChannelCount = 3;
        }
        else if (name === "THROW_CH4" && intValue !== 0 && throwChannelCount <= 4) {
            throwChannelCount = 4;
        }
        else if (name === "THROW_CH5" && intValue !== 0 && throwChannelCount <= 5) {
            throwChannelCount = 5;
        }
        else if (name === "THROW_CH6" && intValue !== 0 && throwChannelCount <= 6) {
            throwChannelCount = 6;
        }
        else if (name === "THROW_CH7" && fcumodel_versions === "V10Pro" && intValue !== 0 && throwChannelCount <= 7) {
            throwChannelCount = 7;
        }
        else if (name === "THROW_CH8" && fcumodel_versions === "V10Pro" && intValue !== 0 && throwChannelCount <= 8) {
            throwChannelCount = 8;
        }
    }

    Connections {
        target: activeVehicle
        ignoreUnknownSignals: true

        function onParameterUpdated(name, value) {
            if (throwParamNames.includes(name)) {
                updateThrowChannelCount(name);
            }
        }
    }

    Column {
        id: mainColumn
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            width: parent.width
            height: 40 * ScreenTools.scaleWidth
        }

        ToolTitle {
            textTitle: qsTr("抛投器")
        }

        Item {
            width: parent.width
            height: throwSection.height
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }

            Column {
                id: throwSection
                width: parent.width
                Item {
                    width: parent.width
                    height: 20 * ScreenTools.scaleWidth
                }
                PWMSetTitle {
                    width: parent.width
                    height: 50 * ScreenTools.scaleWidth
                    columnTitles: [
                        "",
                        qsTr("遥控器映射通道"),
                        qsTr("飞控映射通道"),
                        qsTr("抛投器打开值"),
                        qsTr("抛投器关闭值")
                    ]
                }

                PWMSet {
                    width: parent.width
                    height: 80 * ScreenTools.scaleWidth
                    paramNames: ["THROW_RCCH1", "THROW_CH1", "THROW_CH1_ON", "THROW_CH1_OFF"]
                    titleName: qsTr("抛投通道1")
                }
                PWMSet {
                    visible: throwChannelCount >= 2
                    width: parent.width
                    height: 80 * ScreenTools.scaleWidth
                    titleName: qsTr("抛投通道2")
                    paramNames: ["THROW_RCCH2", "THROW_CH2", "THROW_CH2_ON", "THROW_CH2_OFF"]
                }
                PWMSet {
                    visible: throwChannelCount >= 3
                    width: parent.width
                    height: 80 * ScreenTools.scaleWidth
                    titleName: qsTr("抛投通道3")
                    paramNames: ["THROW_RCCH3", "THROW_CH3", "THROW_CH3_ON", "THROW_CH3_OFF"]
                }
                PWMSet {
                    visible: throwChannelCount >= 4
                    width: parent.width
                    height: 80 * ScreenTools.scaleWidth
                    titleName: qsTr("抛投通道4")
                    paramNames: ["THROW_RCCH4", "THROW_CH4", "THROW_CH4_ON", "THROW_CH4_OFF"]
                }
                PWMSet {
                    visible: throwChannelCount >= 5
                    width: parent.width
                    height: 80 * ScreenTools.scaleWidth
                    titleName: qsTr("抛投通道5")
                    paramNames: ["THROW_RCCH5", "THROW_CH5", "THROW_CH5_ON", "THROW_CH5_OFF"]
                }
                PWMSet {
                    visible: throwChannelCount >= 6
                    width: parent.width
                    height: 80 * ScreenTools.scaleWidth
                    titleName: qsTr("抛投通道6")
                    paramNames: ["THROW_RCCH6", "THROW_CH6", "THROW_CH6_ON", "THROW_CH6_OFF"]
                }
                PWMSet {
                    visible: throwChannelCount >= 7
                    width: parent.width
                    height: 80 * ScreenTools.scaleWidth
                    titleName: qsTr("抛投通道7")
                    paramNames: ["THROW_RCCH7", "THROW_CH7", "THROW_CH7_ON", "THROW_CH7_OFF"]
                }
                PWMSet {
                    visible: throwChannelCount == 8
                    width: parent.width
                    height: 80 * ScreenTools.scaleWidth
                    titleName: qsTr("抛投通道8")
                    paramNames: ["THROW_RCCH8", "THROW_CH8", "THROW_CH8_ON", "THROW_CH8_OFF"]
                }
                Item {
                    width: parent.width
                    height: 80 * ScreenTools.scaleWidth
                    Row {
                        width: 240 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        anchors.right: parent.right
                        anchors.rightMargin: 140 * ScreenTools.scaleWidth
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 20 * ScreenTools.scaleWidth
                        Button {
                            id: deleteButton
                            width: 120 * ScreenTools.scaleWidth
                            height: 50 * ScreenTools.scaleWidth
                            enabled: throwChannelCount > 1
                            anchors.verticalCenter: parent.verticalCenter
                            background: Rectangle {
                                anchors.fill: parent
                                radius: 5
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 5
                                    height: parent.height
                                    color: deleteButton.pressed ? "gray" : throwChannelCount > 1 ? backgroundColor : "gray"
                                    Text {
                                        anchors.fill: parent
                                        text: qsTr("删除")
                                        font.pixelSize: buttonFontSize * 5/6
                                        font.bold: false
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        color: "white"
                                    }
                                }
                                color: "#00000000"
                            }
                            onClicked: {
                                if (throwChannelCount > 1) {
                                    throwChannelCount = throwChannelCount - 1
                                }
                            }
                        }
                        Button {
                            id: addButton
                            enabled: activeVehicle.FlightController.deviceModel === "V10Pro" ? throwChannelCount < 8 : throwChannelCount < 6
                            width: 120 * ScreenTools.scaleWidth
                            height: 50 * ScreenTools.scaleWidth
                            anchors.verticalCenter: parent.verticalCenter
                            background: Rectangle {
                                anchors.fill: parent
                                radius: 5
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 5
                                    height: parent.height
                                    color: addButton.pressed ? "gray" : fcumodel_versions === "V10Pro" ? (throwChannelCount < 8 ? backgroundColor : "gray") : (throwChannelCount < 6 ? backgroundColor : "gray")
                                    Text {
                                        anchors.fill: parent
                                        text: qsTr("增加")
                                        font.pixelSize: buttonFontSize * 5/6
                                        font.bold: false
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        color: "white"
                                    }
                                }
                                color: "#00000000"
                            }
                            onClicked: {
                                if (fcumodel_versions === "V10Pro") {
                                    if (throwChannelCount < 8) {
                                        throwChannelCount = throwChannelCount + 1
                                    }
                                } else {
                                    if (throwChannelCount < 6) {
                                        throwChannelCount = throwChannelCount + 1
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 40 * ScreenTools.scaleWidth
        }

        ToolTitle {
            textTitle: qsTr("照明灯")
        }

        Item {
            width: parent.width
            height: 260 * ScreenTools.scaleWidth
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: lightSection
                width: parent.width
                height: parent.height - 20 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                
                Item {
                    width: parent.width
                    height: parent.height
                    Column {
                        width: parent.width
                        height: parent.width
                        Item {
                            width: parent.width
                            height: 20 * ScreenTools.scaleWidth
                        }
                        PWMSetTitle {
                            width: parent.width
                            height: 50 * ScreenTools.scaleWidth
                            columnTitles: [
                                "",
                                qsTr("遥控器映射通道"),
                                qsTr("飞控映射通道"),
                                qsTr("照明灯打开值"),
                                qsTr("照明灯关闭值")
                            ]
                        }

                        PWMSet {
                            width: parent.width
                            height: 80 * ScreenTools.scaleWidth
                            titleName: qsTr("照明灯1")
                            paramNames: ["THROW_RCCH9", "THROW_CH9", "THROW_CH9_ON", "THROW_CH9_OFF"]
                        }
                        PWMSet {
                            width: parent.width
                            height: 80 * ScreenTools.scaleWidth
                            titleName: qsTr("照明灯2")
                            paramNames: ["THROW_RCCH10", "THROW_CH10", "THROW_CH10_ON", "THROW_CH10_OFF"]
                        }
                    }
                }
            }
        }
        
        Item {
            width: parent.width
            height: 40 * ScreenTools.scaleWidth
        }

        ToolTitle {
            textTitle: qsTr("降落伞")
        }

        Item {
            width: parent.width
            height: 180 * ScreenTools.scaleWidth
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: parachuteSection
                width: parent.width
                height: parent.height - 20 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter

                Item {
                    width: parent.width
                    height: parent.height
                    Column {
                        width: parent.width
                        height: parent.width
                        Item {
                            width: parent.width
                            height: 20 * ScreenTools.scaleWidth
                        }
                        PWMSetTitle {
                            width: parent.width
                            height: 50 * ScreenTools.scaleWidth
                            columnTitles: [
                                "",
                                qsTr("遥控器映射通道"),
                                qsTr("飞控映射通道"),
                                qsTr("降落伞打开值"),
                                qsTr("降落伞关闭值")
                            ]
                        }

                        PWMSet {
                            width: parent.width
                            height: 80 * ScreenTools.scaleWidth
                            titleName: qsTr("降落伞")
                            paramNames: ["PARACHUTE_RCCH", "PARACHUTE_CH", "PARACHUTE_ON", "PARACHUTE_OFF"]
                            value1 : VkSdkInstance.vehicleManager.activeVehicle.parameters["PARACHUTE_RCCH"]
                        }
                    }
                }
            }
        }
        
        Item {
            width: parent.width
            height: 40 * ScreenTools.scaleWidth
        }

        Item {
            width: parent.width
            height: 80 * ScreenTools.scaleWidth
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                width: parent.width * 0.9
                height: parachuteDataSection.height
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    width: parent.width
                    id: parachuteDataSection
                    
                    Item {
                        width: parent.width
                        height: 10 * ScreenTools.scaleWidth
                    }
                    Row {
                        height: textHeight
                        width: parent.width
                        Text {
                            width: textWidth
                            height: textHeight
                            font.pixelSize: buttonFontSize
                            font.bold: false
                            color: "black"
                            text: qsTr("降落伞数据")
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: textWidth
                            height: textHeight
                            font.pixelSize: buttonFontSize
                            font.bold: false
                            color: "black"
                            text: qsTr("状态:%1").arg(
                                      activeVehicle ? (parachuteCell[1] === "0" ? qsTr("未就绪") : parachuteCell[1] === "1" ? qsTr("就绪") : parachuteCell[1] === "2" ? qsTr("已开伞") : parachuteCell[1] === "3" ? qsTr("故障") : "---") : "---")
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: textWidth
                            height: textHeight
                            font.pixelSize: buttonFontSize
                            font.bold: false
                            color: "black"
                            text: qsTr("触发方式:%1").arg(
                                      activeVehicle ? (parachuteCell[2] === "0" ? qsTr("不启动") : parachuteCell[2] === "1" ? qsTr("启动") : "---") : "---")
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: textWidth
                            height: textHeight
                            font.pixelSize: buttonFontSize
                            font.bold: false
                            color: "black"
                            text: qsTr("伞给飞控命令:%1").arg(
                                      activeVehicle ? (parachuteCell[3] === "0" ? qsTr("无") : parachuteCell[3] === "1" ? qsTr("停桨") : "---") : "---")
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: textWidth
                            height: textHeight
                            font.pixelSize: buttonFontSize
                            font.bold: false
                            color: "black"
                            text: qsTr("降落伞故障码:%1").arg(
                                      activeVehicle ? (parachuteCell[4]) : "---")
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: textWidth
                            height: textHeight
                            font.pixelSize: buttonFontSize
                            font.bold: false
                            color: "black"
                            text: qsTr("备用供电电压:%1V").arg(
                                      activeVehicle ? (parachuteCell[5]) : "---")
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Text {
                        width: textWidth * 3
                        height: 10 * ScreenTools.scaleWidth
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 40 * ScreenTools.scaleWidth
        }

        ToolTitle {
            textTitle: qsTr("拍照设置")
        }
        
        Item {
            width: parent.width
            height: 320 * ScreenTools.scaleWidth
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: cameraSection
                width: parent.width
                height: parent.height - 20 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                
                Item {
                    width: parent.width
                    height: parent.height
                    Column {
                        width: parent.width
                        height: parent.width
                        Item {
                            width: parent.width
                            height: 20 * ScreenTools.scaleWidth
                        }
                        PWMSetTitle {
                            width: parent.width
                            height: 50 * ScreenTools.scaleWidth
                            columnTitles: [
                                "",
                                qsTr("拍照信号类型"),
                                qsTr("飞控映射通道"),
                                qsTr("拍照触发值"),
                                qsTr("拍照常规值")
                            ]
                        }
                        PWMSet {
                            width: parent.width
                            height: 80 * ScreenTools.scaleWidth
                            titleName: qsTr("拍照")
                            takePhotoType: true
                            paramNames: ["PHO_SIG_TYPE", "PHO_SIG_CH", "PHO_PWM_ON", "PHO_PWM_OFF"]
                            maxValue: 10000
                        }

                        Item {
                            width: parent.width
                            height: 20 * ScreenTools.scaleWidth
                        }
                        PWMSetTitle {
                            width: parent.width
                            height: 50 * ScreenTools.scaleWidth
                            columnTitles: [
                                "",
                                "",
                                "",
                                "",
                                qsTr("持续时间")
                            ]
                        }

                        PWMSet {
                            width: parent.width
                            height: 80 * ScreenTools.scaleWidth
                            titleName: qsTr("")
                            takePhotoType: true
                            paramVisibility: [false, false, false, true]
                            paramNames: ["", "", "", "PHO_SIG_TIME"]
                            maxValue: 20000
                        }
                    }
                }
            }
        }
        
        Item {
            width: parent.width
            height: 40 * ScreenTools.scaleWidth
        }
        
        ToolTitle {
            textTitle: qsTr("称重校准")
        }
        
        Item {
            width: parent.width
            height: 180 * ScreenTools.scaleWidth
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: weightCalibrationSection
                width: parent.width
                height: parent.height - 20 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                
                Item {
                    width: parent.width
                    height: parent.height

                    Button {
                        id: calibrateButton
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: 300 * ScreenTools.scaleWidth
                        height: 50 * ScreenTools.scaleWidth
                        onClicked: {
                            vkweighercal.open()
                        }
                        background: Rectangle {
                            anchors.fill: parent
                            radius: 30

                            Rectangle {
                                anchors.fill: parent
                                radius: 10
                                height: parent.height
                                color: calibrateButton.pressed ? "#EDEDED" : mainColor
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: qsTr("校准")
                                font.pixelSize: buttonFontSize
                                color: calibrateButton.pressed ? "black" : "white"
                                font.bold: false
                            }
                            color: "#00000000"
                        }
                    }
                }
            }
        }
        
        Item {
            width: parent.width
            height: 40 * ScreenTools.scaleWidth
        }
    }

    VKMessageShow {
        id: messageBox
        anchors.centerIn: parent
        popupWidth: parent.width * 0.5
        messageType: 1
        popupHeight: 240 * ScreenTools.scaleWidth
    }

    WeightCalculator{
        width:800 * ScreenTools.scaleWidth
        id:vkweighercal
        //id:vkbiandui
        anchors.centerIn: parent
    }
}
