import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import VKGroundControl
import VKGroundControl.Palette
import VkSdkInstance 1.0
import ScreenTools
// import VKGroundControl.Vehicle
// import VKGroundControl.MultiVehicleManager

import "../Common"

Flickable {
    // UI Properties
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5/6
    property var mainColor: qgcPal.titleColor

    // Vehicle Management Properties
    property var activeVehicle: VkSdkInstance.vehicleManager.activeVehicle

    // ESC Properties
    property int escIndex: activeVehicle && activeVehicle.esc_index ? activeVehicle.esc_index : 0
    property var escCurrent: activeVehicle && activeVehicle.esc_current ? activeVehicle.esc_current : ""
    property var escVoltage: activeVehicle && activeVehicle.esc_vol ? activeVehicle.esc_vol : ""
    property var escRpm: activeVehicle && activeVehicle.esc_rpm ? activeVehicle.esc_rpm : ""

    // Advanced Settings Properties
    property bool isAdvanced: false
    property string advancedIconUp: "/qmlimages/icon/up_arrow.png"
    property string advancedIconDown: "/qmlimages/icon/down_arrow.png"

    // Parameter Properties

    property int gyroFilterId: -1
    property int accelFilterId: -1
    property int idleValue: 5
    property int attitudeMode: 0

    height: parent.height
    width: parent.width

    property real itemSpacing: 30 * ScreenTools.scaleWidth
    property real itemTextWidth: 240 * ScreenTools.scaleWidth
    property real itemHeight: 60 * ScreenTools.scaleWidth

    clip: true
    contentHeight: column.implicitHeight

    VKPalette {
        id: qgcPal
    }

    Column {
        id: column
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            width: parent.width
            height: 40 * sw
        }

        Item {
            width: parent.width
            height: 30 * sw
        }

        ToolTitle {
            textTitle: qsTr("机动设置")
        }

        Item {
            width: parent.width
            height: 870 * sw
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }

            Item {
                id: mainContent
                width: parent.width
                height: parent.height - 20 * sw
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    width: parent.width
                    height: parent.width

                    Item {
                        width: parent.width * 0.75
                        height: parent.height

                        Column {
                            width: parent.width
                            height: parent.width

                            ParameterSection {
                                CustomNumericParameterControl {
                                    labelName: qsTr("自动爬升速度")
                                    unit: "m/s"
                                    parameter: "AUTO_VELU_MAX"
                                    sliderMaxValue: 8
                                    sliderMinValue: 0.5
                                    valueType: 9
                                }

                                CustomNumericParameterControl {
                                    labelName: qsTr("自动下降速度")
                                    unit: "m/s"
                                    parameter: "AUTO_VELD_MAX"
                                    sliderMaxValue: 5
                                    sliderMinValue: 0.2
                                    valueType: 9
                                }

                                CustomNumericParameterControl {
                                    labelName: qsTr("去航点/返航速度")
                                    unit: "m/s"
                                    parameter: "MC_XY_CRUISE"
                                    sliderMaxValue: 25
                                    sliderMinValue: 2
                                    valueType: 9
                                }

                                CustomNumericParameterControl {
                                    labelName: qsTr("自动降落精度")
                                    unit: "m"
                                    parameter: "PREC_LAND_ERR"
                                    sliderMaxValue: 1
                                    sliderMinValue: 0.05
                                    decimalPlaces: 2
                                    valueType: 9
                                }

                                CustomNumericParameterControl {
                                    labelName: qsTr("着陆速度")
                                    unit: "m/s"
                                    parameter: "AUTO_VELV_LND"
                                    sliderMaxValue: 0.6
                                    sliderMinValue: 0.2
                                    decimalPlaces: 1
                                    valueType: 9
                                }

                                CustomNumericParameterControl {
                                    labelName: qsTr("手动爬升速度")
                                    unit: "m/s"
                                    parameter: "MAN_VELU_MAX"
                                    sliderMaxValue: 5
                                    sliderMinValue: 0.2
                                    valueType: 9
                                }

                                CustomNumericParameterControl {
                                    labelName: qsTr("手动下降速度")
                                    unit: "m/s"
                                    parameter: "MAN_VELD_MAX"
                                    sliderMaxValue: 5
                                    sliderMinValue: 0.2
                                    valueType: 9
                                }

                                CustomNumericParameterControl {
                                    labelName: qsTr("手动平飞速度")
                                    unit: "m/s"
                                    parameter: "MAN_VELH_MAX"
                                    sliderMaxValue: 25
                                    sliderMinValue: 1
                                    valueType: 9
                                }
                            }

                            Item {
                                width: parent.width - 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: 60 * sw

                                Column {
                                    height: 50 * sw

                                    Text {
                                        height: parent.height
                                        text: qsTr("遥控器姿态控制")
                                        font.pixelSize: 30 * sw * 5/6
                                        font.bold: false
                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter
                                        color: "gray"
                                    }

                                    Text {
                                        height: 20 * sw
                                        font.pixelSize: 30 * ScreenTools.scaleHeight
                                        font.bold: false
                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.Top
                                        color: "gray"
                                    }
                                }

                                Row {
                                    width: 320 * sw
                                    height: 60 * sw
                                    anchors.right: parent.right
                                    spacing: 1 * sw

                                    Button {
                                        id: disableButton
                                        width: 162 * sw
                                        height: 50 * sw
                                        anchors.verticalCenter: parent.verticalCenter

                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 5
                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 5
                                                height: parent.height
                                                color: disableButton.pressed ? "gray" : (attitudeMode === 0 ? mainColor : "lightgray")

                                                Text {
                                                    anchors.fill: parent
                                                    text: qsTr("不启用")
                                                    font.pixelSize: buttonFontSize * 7/8
                                                    font.bold: false
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: attitudeMode === 0 ? "white" : "black"
                                                }
                                            }
                                            color: "#00000000"
                                        }

                                        onClicked: {
                                            if(VkSdkInstance.vehicleManager.activeVehicle){
                                                VkSdkInstance.vehicleManager.activeVehicle.setParam("RC_ATT_EN",0);
                                            }
                                        }
                                    }

                                    Button {
                                        id: enableButton
                                        width: 162 * ScreenTools.scaleWidth
                                        height: 50 * ScreenTools.scaleWidth
                                        anchors.verticalCenter: parent.verticalCenter

                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 5
                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 5
                                                height: parent.height
                                                color: enableButton.pressed ? "gray" : (attitudeMode === 1 ? mainColor : "lightgray")

                                                Text {
                                                    anchors.fill: parent
                                                    text: qsTr("启用")
                                                    font.pixelSize: buttonFontSize * 7/8
                                                    font.bold: false
                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignVCenter
                                                    color: attitudeMode === 1 ? "white" : "black"
                                                }
                                            }
                                            color: "#00000000"
                                        }

                                        onClicked: {
                                            if(VkSdkInstance.vehicleManager.activeVehicle){
                                                VkSdkInstance.vehicleManager.activeVehicle.setParam("RC_ATT_EN",1);
                                            }
                                        }
                                    }
                                }
                            }

                            Item {
                                width: parent.width
                                height: 30 * sw
                            }
                        }
                    }

                    Item {
                        width: 2
                        height: parent.height
                        Rectangle {
                            width: parent.width
                            height: mainContent.height
                            color: "gray"
                        }
                    }

                    Item {
                        width: parent.width * 1/4
                        height: parent.height
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 30 * sw
        }
    }

    component ParameterSection: Item {
        default property alias children: contentColumn.children

        width: parent.width
        height: sectionBackground.height

        Rectangle {
            id: sectionBackground
            width: parent.width
            height: contentColumn.height + itemSpacing * 2
            color: "transparent"
            border.color: "transparent"
            border.width:2
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
    component CustomNumericParameterControl: MotionParamBar {
        width: parent.width - 100 * ScreenTools.scaleWidth
        height: itemHeight
        textWidth: itemTextWidth
        anchors.horizontalCenter: parent.horizontalCenter
        textColor: "gray"
        parameterValue: activeVehicle && activeVehicle.parameters[parameter] ? activeVehicle.parameters[parameter] : 0
    }
}
