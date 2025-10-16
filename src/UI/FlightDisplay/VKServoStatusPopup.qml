import QtQuick 2.15
import QtQuick.Controls 2.15

import VkSdkInstance 1.0
import ScreenTools
import Controls

/**
 * 舵机状态弹窗组件
 * 显示和控制最多8个舵机的开关状态
 */
Item {
    id: root

    component ServoControl: Item {
        id: servoControl

        // 公开属性
        property string title: "1"
        property bool isOpen: false
        property bool enabled: false
        property bool selected: false
        property color primaryColor: ScreenTools.titleColor

        // 信号
        signal clicked()

        width: 100 * ScreenTools.scaleWidth
        height: 50 * ScreenTools.scaleWidth

        Row {
            anchors.fill: parent
            spacing: 0

            // 选择按钮
            Button {
                id: selectButton
                width: 50 * ScreenTools.scaleWidth
                height: 50 * ScreenTools.scaleWidth
                enabled: servoControl.enabled

                onClicked: {
                    servoControl.clicked()
                }

                background: Rectangle {
                    width: parent.width * 0.8
                    height: parent.height * 0.8
                    anchors.centerIn: parent
                    radius: width / 2
                    color: servoControl.selected ? servoControl.primaryColor : "white"
                    opacity: selectButton.enabled ? 1.0 : 0.3

                    // 按钮文本
                    Text {
                        anchors.centerIn: parent
                        text: servoControl.title
                        font.pixelSize: 20 * ScreenTools.scaleWidth
                        color: servoControl.selected ? "white" : (selectButton.enabled ? "black" : "#808080")
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // 状态指示
            Text {
                width: 50 * ScreenTools.scaleWidth
                height: 50 * ScreenTools.scaleWidth
                text: {
                    if (!servoControl.enabled) return ""
                    return servoControl.isOpen ? qsTr("开") : qsTr("关")
                }
                font.pixelSize: 20 * ScreenTools.scaleWidth
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: servoControl.isOpen ? servoControl.primaryColor : "red"
            }
        }
    }

    property var activeVehicle: VkSdkInstance.vehicleManager.activeVehicle

    property int servoStatusMask: activeVehicle ? activeVehicle.fmuStatus.servoState : 0
    property bool isVisible: false
    property real scaleWidth: ScreenTools.scaleWidth
    property var servosEnabled: [false, false, false, false, false, false, false, false]

    readonly property int maxServos: 8
    readonly property int servosPerRow: 4
    readonly property real panelWidth: 100 * scaleWidth * 4 + 3 * 30 * scaleWidth + 60 * scaleWidth
    property var servoParamNames: ["THROW_CH1", "THROW_CH2", "THROW_CH3", "THROW_CH4",
                                  "THROW_CH5", "THROW_CH6", "THROW_CH7", "THROW_CH8"]

    width: panelWidth
    height: isVisible ? 200 * scaleWidth : 0

    Connections {
        target: activeVehicle
        ignoreUnknownSignals: true

        function onParamChanged() {
            for(var i  = 0; i < servoParamNames.length; i++ ) {
                var name = servoParamNames[i];
                updateServoState(name , activeVehicle.parameters[name])
            }
        }
    }

    // ============================================================================
    // 函数定义
    // ============================================================================

    /**
     * 更新舵机启用状态
     * @param paramName 参数名称 (THROW_CH1 ~ THROW_CH8)
     * @param paramValue 参数值
     */
    function updateServoState(paramName, paramValue) {
        if (!paramName || !paramValue) return

        // 匹配 THROW_CH1 到 THROW_CH8
        const match = paramName.match(/^THROW_CH(\d+)$/)
        if (!match) return

        const channelIndex = parseInt(match[1]) - 1
        if (channelIndex < 0 || channelIndex >= maxServos) return

        // 解析参数值
        // const valueStr = paramValue.split("--")[0]
        const value = parseInt(paramValue)

        // 检查是否是 V10Pro 特殊情况
        const isV10Pro = activeVehicle.FlightController.deviceModel === "V10Pro"

        // 更新启用状态
        let enabled = value !== 0

        // CH7 和 CH8 仅在 V10Pro 上可用
        if (channelIndex >= 6 && !isV10Pro) {
            enabled = false
        }

        servosEnabled[channelIndex] = enabled
        servosEnabledChanged() // 触发更新
    }

    /**
     * 执行舵机动作
     * @param action 1=打开, -1=关闭
     */
    function executeServoAction(action) {
        if (!activeVehicle) return

        const group = servosEnabled.map((enabled, index) => {
            const servoItem = servoRepeater.itemAt(index)
            console.log(`servoItem:${servoItem.selected}`)
            return (enabled && servoItem && servoItem.selected) ? action : NaN
        })

        console.log(`group1:${group}`)
        activeVehicle.pwmControlAll(
            group, 8
        )
    }

    /**
     * 获取舵机开关状态（通过位掩码）
     * @param servoIndex 舵机索引 (0-7)
     */
    function getServoStatus(servoIndex) {
        return servoStatusMask & (1 << servoIndex)
    }

    // ============================================================================
    // UI 布局
    // ============================================================================

    // 背景遮罩
    Rectangle {
        anchors.fill: parent
        color: isVisible ? "#90000000" : "#00000000"
    }

    Column {
        width: panelWidth
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0

        // 标题
        Text {
            visible: isVisible
            width: parent.width
            height: 40 * scaleWidth
            text: qsTr("舵机状态")
            font.pixelSize: 25 * scaleWidth
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }

        // 舵机网格（使用 Grid 代替两个 Row）
        Grid {
            visible: isVisible
            width: parent.width
            columns: servosPerRow
            rowSpacing: 10 * scaleWidth
            columnSpacing: 30 * scaleWidth

            Repeater {
                id: servoRepeater
                model: maxServos

                ServoControl {
                    required property int index

                    title: (index + 1).toString()
                    isOpen: getServoStatus(index)
                    enabled: servosEnabled[index] || false

                    onClicked: {
                        selected = !selected
                    }
                }
            }
        }

        // 控制按钮行
        Row {
            width: parent.width
            height: 60 * scaleWidth
            spacing: 10 * scaleWidth

            // 打开按钮
            TextButton {
                visible: isVisible
                anchors.left: parent.left
                anchors.leftMargin: 50 * scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                width: 100 * scaleWidth
                height: 40 * scaleWidth
                buttonText: qsTr("打开")
                textColor: "black"
                onClicked: {
                    executeServoAction(1)
                }
            }

            // 折叠/展开按钮
            Button {
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: 80 * scaleWidth
                height: 40 * scaleWidth

                onClicked: {
                    isVisible = !isVisible
                }

                background: Rectangle {
                    width: parent.width
                    height: parent.height
                    radius: 10 * scaleWidth
                    color: isVisible ? "#00000000" : "#90000000"

                    Image {
                        width: parent.width * 0.5
                        height: parent.height * 0.5
                        anchors.centerIn: parent
                        source: isVisible ? "/qmlimages/icon/up.png" : "/qmlimages/icon/down.png"
                    }
                }
            }

            // 关闭按钮
            TextButton {
                visible: isVisible
                anchors.right: parent.right
                anchors.rightMargin: 50 * scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                width: 100 * scaleWidth
                height: 40 * scaleWidth
                buttonText: qsTr("关闭")
                textColor: "black"
                onClicked: {
                    executeServoAction(-1)
                }
            }
        }
    }
}
