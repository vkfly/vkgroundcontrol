﻿import QtQuick
import QtQuick.Controls

import VKGroundControl
import ScreenTools
import Controls
import VkSdkInstance
// import VKGroundControl.MultiVehicleManager

import "../Common"

VKInstallBase {
    id: _root

    property var paramvalue : VkSdkInstance.vehicleManager.vehicles[0].parameters["IMU_ATT_YOFF0"]


    onParamvalueChanged: {
        if(paramvalue===0){
            _install_bt.selectedIndex=0
        }
        else  if(paramvalue===90){
            _install_bt.selectedIndex=1
        }
        else if(paramvalue===180){
            _install_bt.selectedIndex=2
        }
        else if(paramvalue===-90){
            _install_bt.selectedIndex=3
        }
    }
    // 监听参数变化



    Row {
        width: parent.width
        height: parent.height
        Item {
            width: parent.width * 3 / 4 - 2
            height: parent.height
            Column {
                width: parent.width - 20
                height: parent.height
                Item {
                    width: parent.width
                    height: 50 * ScreenTools.scaleWidth
                    Text {
                        width: parent.width
                        height: 50 * ScreenTools.scaleWidth
                        font.pixelSize: buttonFontsize
                        text: qsTr("安装方向:")
                        font.bold: false
                        verticalAlignment: Text.AlignVCenter
                        color: "gray"
                    }
                }
                Item {
                    width: parent.width
                    height: 50 * ScreenTools.scaleWidth
                    GroupButton {
                        id:_install_bt
                        width: parent.width
                        height: parent.height
                        fontSize: buttonFontsize
                        selectedIndex:-1
                        names: [qsTr("水平向前"), qsTr("水平向右"), qsTr("水平向后"), qsTr("水平向左")]
                        onClicked:{
                            if(index===0)
                            VkSdkInstance.vehicleManager.vehicles[0].setParam("IMU_ATT_YOFF0",0)
                            if(index===1)
                            VkSdkInstance.vehicleManager.vehicles[0].setParam("IMU_ATT_YOFF0",90)
                            if(index===2)
                            VkSdkInstance.vehicleManager.vehicles[0].setParam("IMU_ATT_YOFF0",180)
                            if(index===3)
                            VkSdkInstance.vehicleManager.vehicles[0].setParam("IMU_ATT_YOFF0",-90)
                        }
                    }
                }
                Item {
                    width: parent.width
                    height: 50 * ScreenTools.scaleWidth
                    Text {
                        width: parent.width
                        height: 50 * ScreenTools.scaleWidth
                        font.pixelSize: buttonFontsize
                        text: qsTr("偏差设置:")
                        font.bold: false
                        verticalAlignment: Text.AlignVCenter
                        color: "gray"
                    }
                }
                Item {
                    width: parent.width
                    height: 350 * ScreenTools.scaleWidth
                    Row {
                        width: parent.width
                        height: 350 * ScreenTools.scaleWidth
                        spacing: 20 * ScreenTools.scaleWidth
                        Item {
                            width: 350 * ScreenTools.scaleWidth
                            height: 350 * ScreenTools.scaleWidth
                            Rectangle {
                                id: item1
                                width: 300 * ScreenTools.scaleWidth
                                height: 300 * ScreenTools.scaleWidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                color: "white"
                                radius: 15 * ScreenTools.scaleWidth
                                Image {
                                    width: 300 * ScreenTools.scaleWidth
                                    height: 300 * ScreenTools.scaleWidth
                                    source: "/qmlimages/icon/imu_install_bias.png"
                                    anchors.centerIn: item1
                                }
                            }
                        }
                        Column {
                            width: parent.width - 350 * ScreenTools.scaleWidth - 20 * ScreenTools.scaleWidth
                            Item {
                                width: parent.width
                                height: 30 * ScreenTools.scaleWidth
                            }
                            InstallParameterInputField {
                                width: parent.width
                                height: 60 * ScreenTools.scaleWidth
                                labelName: qsTr("X偏差:")
                                paramKey: "IMU_PXOFF"
                                paramValue: VkSdkInstance.vehicleManager.activeVehicle.parameters["IMU_PXOFF"] || 0
                                valueType: 5
                                minValue: -50
                                maxValue: 50
                                unit: "cm"
                                textWidth: 120 * ScreenTools.scaleWidth
                                fixNum: 1
                                onValueClicked: {

                                }
                            }

                            Item {
                                width: parent.width
                                height: 40 * ScreenTools.scaleWidth
                            }
                            InstallParameterInputField {
                                width: parent.width
                                height: 60 * ScreenTools.scaleWidth
                                labelName: qsTr("Y偏差:")
                                paramKey: "IMU_PYOFF"
                                paramValue: VkSdkInstance.vehicleManager.activeVehicle.parameters["IMU_PYOFF"] || 0
                                valueType: 5
                                minValue: -50
                                maxValue: 50
                                unit: "cm"
                                textWidth: 120 * ScreenTools.scaleWidth
                                fixNum: 1
                                onValueClicked: {

                                }
                            }

                            Item {
                                width: parent.width
                                height: 40 * ScreenTools.scaleWidth
                            }
                            InstallParameterInputField {
                                width: parent.width
                                height: 60 * ScreenTools.scaleWidth
                                labelName: qsTr("Z偏差:")
                                paramKey: "IMU_PZOFF"
                                paramValue: VkSdkInstance.vehicleManager.activeVehicle.parameters["IMU_PZOFF"] || 0
                                valueType: 5
                                minValue: -50
                                maxValue: 50
                                unit: "cm"
                                textWidth: 120 * ScreenTools.scaleWidth
                                fixNum: 1
                                onValueClicked: {

                                }
                            }

                            Item {
                                width: parent.width
                                height: 40 * ScreenTools.scaleWidth
                            }
                        }
                    }
                }
            }
        }
        Item {
            width: 1
            height: parent.height
            Rectangle {
                width: parent.width
                height: parent.height
                color: "gray"
            }
        }
        Item {
            width: parent.width * 1 / 4
            height: parent.height
            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.95
                height: 100 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("设置飞控到机体中心的偏差\n\nX:左负右正\n\nY:后负前正\n\nZ:下负上正")
                font.pixelSize: buttonFontsize
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                color: "red"
            }
        }
    }
}
