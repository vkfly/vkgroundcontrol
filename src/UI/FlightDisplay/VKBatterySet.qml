import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VKGroundControl
import Controls
import ScreenTools
import VkSdkInstance

Flickable {
    id: root
    height: parent.height
    width: parent.width
    contentHeight: mainColumn.implicitHeight
    
    property bool isBattery: false
    property real buttonFontSize: 30 * ScreenTools.scaleWidth
    property real textWidth: 200 * ScreenTools.scaleWidth
    property real textHeight: 30 * ScreenTools.scaleWidth
    property real fontSize: 18 * ScreenTools.scaleWidth
    property color fontColor: "white"
    property real contentSpacing: 30 * ScreenTools.scaleWidth
    property real sectionSpacing: 30 * ScreenTools.scaleWidth
    property real borderRadius: 30
    property real borderWidth: 2
    property real sideMargin: 30 * ScreenTools.scaleWidth

    Column {
        id: mainColumn
        width: parent.width * 0.98
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: sectionSpacing

        // 标题
        Item {
            width: parent.width
            height: 60 * ScreenTools.scaleWidth
            
            Text {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                text: qsTr("电池管理")
                font.pixelSize: buttonFontSize
                font.bold: false
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: fontColor
            }
        }

        // 一级低电保护
        BatteryProtectionSection {
            id: firstLevelProtection
            width: parent.width
            sectionTitle: qsTr("一级低电保护")
            voltageParameterName: "VOLT1_LOW_VAL"
            capacityParameterName: "VCAP1_LOW_VAL"
            actionParameterName: "FS_CONF_A_1"
            isBatteryMode: root.isBattery
        }

        // 二级低电保护
        BatteryProtectionSection {
            id: secondLevelProtection
            width: parent.width
            sectionTitle: qsTr("二级低电保护")
            voltageParameterName: "VOLT2_LOW_VAL"
            capacityParameterName: "VCAP2_LOW_VAL"
            actionParameterName: "FS_CONF_A_2"
            isBatteryMode: root.isBattery
        }
    }

    // 电池保护组件
    component BatteryProtectionSection: Item {
        id: section
        height: protectionColumn.height
        
        property string sectionTitle: ""
        property string voltageParameterName: ""
        property string capacityParameterName: ""
        property string actionParameterName: ""
        property bool isBatteryMode: false

        Rectangle {
            width: parent.width
            height: parent.height
            color: "transparent"
            border.color: root.fontColor
            border.width: root.borderWidth
            radius: root.borderRadius
        }

        Column {
            id: protectionColumn
            width: parent.width
            spacing: root.contentSpacing

            // 顶部间距
            Item {
                width: parent.width
                height: root.contentSpacing
            }

            // 标题
            Item {
                width: parent.width
                height: 40 * ScreenTools.scaleWidth
                
                Text {
                    width: parent.width
                    height: parent.height
                    anchors.left: parent.left
                    anchors.leftMargin: root.sideMargin
                    text: section.sectionTitle
                    font.pixelSize: root.buttonFontSize * 5 / 6
                    font.bold: false
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: root.fontColor
                }
            }

            // 电压/电量控制
            NumericParameterControl {
                visible: !section.isBatteryMode
                width: parent.width - 60 * ScreenTools.scaleWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("低电压值")
                unit: "V"
                parameterName: section.voltageParameterName
                fixNum: 1
                maxValue: 120
                minValue: 12
                valueType: 9
                textWidth: 240 * ScreenTools.scaleWidth
                parameterValue: VkSdkInstance.vehicleManager.activeVehicle.parameters[parameterName] || 0
            }

            NumericParameterControl {
                visible: section.isBatteryMode
                width: parent.width - 60 * ScreenTools.scaleWidth
                height: 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labelName: qsTr("低电量值")
                unit: "%"
                fixNum: 0
                parameterName: section.capacityParameterName
                maxValue: 100
                minValue: 1
                valueType: 1
                textWidth: 240 * ScreenTools.scaleWidth
                parameterValue: VkSdkInstance.vehicleManager.activeVehicle.parameters[parameterName] || 0
            }

            // 触发动作选择
            ParameterComboBox {
                width: parent.width - 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                parameterName: section.actionParameterName
                currentValue: VkSdkInstance.vehicleManager.activeVehicle.parameters[section.actionParameterName]
                labelName: qsTr("触发动作")
                customModel: ListModel {
                    ListElement { text: qsTr("无动作") }
                    ListElement { text: qsTr("悬停") }
                    ListElement { text: qsTr("返航") }
                    ListElement { text: qsTr("去往备降点") }
                    ListElement { text: qsTr("原地降落") }
                }
            }

            // 底部间距
            Item {
                width: parent.width
                height: root.contentSpacing
            }
        }
    }
}
