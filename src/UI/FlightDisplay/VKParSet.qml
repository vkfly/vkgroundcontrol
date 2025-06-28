import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VKGroundControl
import Qt.labs.settings
import Controls
import ScreenTools
import VkSdkInstance

Flickable {
    id: root
    height: parent.height
    width: parent.width
    contentHeight: mainColumn.implicitHeight
    
    // Properties with camelCase naming
    property color backgroundColor: ScreenTools.titleColor
    property bool isDianchi: false
    property real buttonFontSize: 30 * ScreenTools.scaleWidth
    property real textWidth: 240 * ScreenTools.scaleWidth
    property real itemHeight: 60 * ScreenTools.scaleWidth
    property real itemSpacing: 30 * ScreenTools.scaleWidth
    property real fontSize: 18 * ScreenTools.scaleHeight
    property color fontColor: "white"
    
    // Flight parameters with meaningful English names
    property int altitudeLimit: 0
    property int returnAltitude: 0
    property int takeoffAltitude: 0
    property var horizontalSpeed: 10
    property var activeVehicle: VkSdkInstance.vehicleManager.activeVehicle
    property int climbMode: activeVehicle ? parseInt(activeVehicle.parameters["WP_FP_ALT_MODE"]) : 0
    property int returnHeadingMode: activeVehicle ? parseInt(activeVehicle.parameters["RTL_HEAD_MODE"]) : 0


    Column {
        id: mainColumn
        width: parent.width * 0.98
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: itemSpacing

        // Title
        Text {
            width: parent.width
            height: itemHeight
            text: qsTr("飞行设置")
            font.pixelSize: buttonFontSize
            font.bold: false
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: fontColor
        }

        // Aircraft ID Section
        ParameterSection {
            CustomNumericParameterControl {
                labelName: qsTr("飞行器编号")
                unit: ""
                parameterName: "MAV_SYS_ID"
                maxValue: 255
                minValue: 1
                valueType: 3
            }
        }

        // Flight Settings Section
        ParameterSection {
            CustomNumericParameterControl {
                labelName: qsTr("起飞高度")
                unit: "m"
                parameterName: "TOF_ALT_M"
                valueType: 9
                maxValue: 5000
                minValue: 1
            }

            CustomNumericParameterControl {
                labelName: qsTr("返航高度")
                unit: "m"
                parameterName: "RTL_ALT_M"
                valueType: 9
                maxValue: 5000
                minValue: 1
            }

            CustomNumericParameterControl {
                labelName: qsTr("限高")
                unit: "m"
                parameterName: "ALT_LIM_UP1"
                maxValue: 5000
                minValue: 10
                valueType: 3
            }

            CustomNumericParameterControl {
                labelName: qsTr("限距")
                unit: "m"
                parameterName: "MAX_HOR_DIST"
                maxValue: 50000
                minValue: 10
                valueType: 5
            }

            // Return head mode
            FlightModeRow {
                labelText: qsTr("返航机头")
                options: [qsTr("机头返航"), qsTr("机尾返航"), qsTr("保持航向")]
                selectedIndex: returnHeadingMode
                onClicked: function(index) {
                    if (activeVehicle) {
                        activeVehicle.setParam("RTL_HEAD_MODE", index)
                    }
                }
            }

            // Waypoint mode
            FlightModeRow {
                labelText: qsTr("去航点方式")
                options: [qsTr("垂直爬高"), qsTr("斜线爬高")]
                selectedIndex: climbMode
                onClicked: function(index) {
                    if (activeVehicle) {
                        activeVehicle.setParam("WP_FP_ALT_MODE", index)
                    }
                }
            }
        }

        // Speed Settings Section
        ParameterSection {
            CustomNumericParameterControl {
                labelName: qsTr("手动水平速度")
                unit: "m/s"
                parameterName: "MAN_VELH_MAX"
                maxValue: 25
                minValue: 1
                valueType: 9
            }

            CustomNumericParameterControl {
                labelName: qsTr("去航点/返航速度")
                unit: "m/s"
                parameterName: "MC_XY_CRUISE"
                maxValue: 25
                minValue: 2
                valueType: 9
            }
        }

        // Communication Link Settings Section
        ParameterSection {
            ParameterComboBox {
                id: gcsDisconnectComboBox
                width: parent.width - 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                currentValue: activeVehicle ? activeVehicle.parameters[parameterName] : 0
                parameterName: "GCS_DISCONT_DT"
                valueType: 3
                labelName: qsTr("链路失联返航开关")
                customModel: ListModel {
                    ListElement { text: qsTr("关闭") }
                    ListElement { text: qsTr("开启") }
                }
            }

            CustomNumericParameterControl {
                visible: gcsDisconnectComboBox.currentIndex === 1
                labelName: qsTr("链路失联时间")
                parameterName: "GCS_DISCONT_DT"
                valueType: 3
                maxValue: 1200
                minValue: 5
                unit: "s"
            }

            ParameterComboBox {
                visible: gcsDisconnectComboBox.currentIndex === 1
                width: parent.width - 60 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                currentValue: activeVehicle ? activeVehicle.parameters[parameterName] : 0
                parameterName: "GCS_DISC_CRUISE"
                valueType: 1
                labelName: qsTr("航线中是否触发")
                customModel: ListModel {
                    ListElement { text: qsTr("否") }
                    ListElement { text: qsTr("是") }
                }
            }
        }

        // Remote Control Settings Section
        ParameterSection {
            CustomNumericParameterControl {
                labelName: qsTr("遥控器失联悬停时间")
                unit: "s"
                parameterName: "RCFAIL_LOT_T"
                maxValue: 1200
                minValue: 0
                valueType: 3
            }
        }
    }

    // Reusable Parameter Section Component
    component ParameterSection: Item {
        default property alias children: contentColumn.children
        
        width: parent.width
        height: sectionBackground.height
        
        Rectangle {
            id: sectionBackground
            width: parent.width
            height: contentColumn.height + itemSpacing * 2
            color: "transparent"
            border.color: "white"
            border.width: 2
            radius: 30
        }
        
        Column {
            id: contentColumn
            width: parent.width
            y: itemSpacing
            spacing: itemSpacing
        }
    }

    // Reusable NumericParameterControl with default properties
    component CustomNumericParameterControl: NumericParameterControl {
        width: parent.width - 60 * ScreenTools.scaleWidth
        height: itemHeight
        textWidth: root.textWidth
        anchors.horizontalCenter: parent.horizontalCenter
        parameterValue: activeVehicle ? activeVehicle.parameters[parameterName] : 0
    }

    // Reusable Flight Mode Row Component
    component FlightModeRow: Item {
        property string labelText: ""
        property var options: []
        property int selectedIndex: 0
        signal clicked(int index)
        
        width: parent.width - 60 * ScreenTools.scaleWidth
        height: itemHeight
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            height: 50 * ScreenTools.scaleWidth
            Text {
                height: parent.height
                text: labelText
                font.pixelSize: buttonFontSize * 5 / 6
                font.bold: false
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: fontColor
            }
        }

        GroupButton {
            width: 320 * ScreenTools.scaleWidth
            height: itemHeight
            anchors.right: parent.right
            spacing: 2 * ScreenTools.scaleWidth
            names: options
            selectedIndex: parent.selectedIndex
            backgroundColor: "black"
            onClicked: function(index) {
                parent.clicked(index)
            }
        }
    }
}
