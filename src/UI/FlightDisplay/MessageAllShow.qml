import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Controls
import ScreenTools

import VkSdkInstance 1.0

Flickable {
    height: parent.height
    width: parent.width
    contentHeight: column_msg.implicitHeight
    property var button_fontsize: 30 * ScreenTools.scaleWidth * 5 / 6
    property var button_fontsizes: 30 * ScreenTools.scaleWidth
    property var id_vol
    property double width_text: parent.width / 3 * 0.9 * 0.95
    property double height_text: 65 * ScreenTools.scaleWidth
    property double fontsize: button_fontsize
    property var fontcolor: "white"
    property var activeVehicle : VkSdkInstance.vehicleManager.activeVehicle
    property var qingxieBms: VkSdkInstance.vehicleManager.activeVehicle ?
                             VkSdkInstance.vehicleManager.activeVehicle.qingxieBms : null
    property var value: VkSdkInstance.vehicleManager.activeVehicle.attitude.attitudeRoll

    onValueChanged: {

    }

    onQingxieBmsChanged: {
        qxbms0.visible = false; qxbms1.visible = false; qxbms2.visible = false; qxbms3.visible = false;
        vt_qx_bms.visible = false; qx_msg.visible = false;

        if (!qingxieBms) return;
        console.log("qingxieBms 实际字段：", Object.keys(qingxieBms));
        console.log("batVoltage 值：", qingxieBms.batVoltage);
        console.log("servoCurrent 值：", qingxieBms.servoCurrent);
        const hasValidData = (qingxieBms.batVoltage !== undefined) &&
                            (qingxieBms.servoCurrent !== undefined);
        if (!hasValidData) return;

        switch(qingxieBms.id) {
            case 0:
                vt_qx_bms.visible = true; qx_msg.visible = true; qxbms0.visible = true;
                qxbms0.qxbmsmsg = qingxieBms;
                break;
            case 1:
                vt_qx_bms.visible = true; qx_msg.visible = true; qxbms1.visible = true;
                qxbms1.qxbmsmsg = qingxieBms;
                break;
            case 2:
                vt_qx_bms.visible = true; qx_msg.visible = true; qxbms2.visible = true;
                qxbms2.qxbmsmsg = qingxieBms;
                break;
            case 3:
                vt_qx_bms.visible = true; qx_msg.visible = true; qxbms3.visible = true;
                qxbms3.qxbmsmsg = qingxieBms;
                break;
            default:
                vt_qx_bms.visible = false; qx_msg.visible = false;
                break;
        }
    }

    Column {
        width: parent.width * 0.98
        anchors.horizontalCenter: parent.horizontalCenter
        id: column_msg

        // 基础信息区域
        Item {
            width: parent.width
            height: 60 * ScreenTools.scaleWidth
            Text {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent.Center
                text: qsTr("基础信息")
                font.pixelSize: button_fontsizes
                font.bold: false
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
            }
        }
        Item {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: column1.height
            Rectangle {
                width: parent.width
                height: parent.height
                color: "#00000000"
                border.color: "white"
                border.width: 2
                radius: 30
            }
            Item {
                width: parent.width * 0.9
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    width: parent.width
                    id: column1
                    Item {
                        width: parent.width
                        height: 10 * ScreenTools.scaleWidth
                    }
                    Row {
                        width: parent.width
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            font.bold: false
                            color: fontcolor
                            text: qsTr("目标距离:%1m").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.fmuStatus.distToTar)
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            font.bold: false
                            color: fontcolor
                            text: qsTr("UPS 电压:%1V").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.fmuStatus.upsVolt)
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            font.bold: false
                            color: fontcolor
                            text: qsTr("ADC 电压:%1V").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.fmuStatus.adcVolt)
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Item {
                        width: parent.width
                        height: 10 * ScreenTools.scaleWidth
                    }

                    Row {
                        width: parent.width
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: qsTr("温度:%1℃").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.insStatus.temperature)
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: qsTr("基础油门:%1%").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.vfrHud.throttle)
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Item {
                        width: parent.width
                        height: 10 * ScreenTools.scaleWidth
                    }

                    Row {
                        width: parent.width
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: qsTr("经度:%1").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.coordinate.longitude)
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: qsTr("纬度:%1").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.coordinate.latitude)
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: qsTr("锁状态:%1").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.heartbeat.lockStatus
                                      === 0 ? qsTr("落锁") : qsTr("解锁"))
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Item {
                        width: parent.width
                        height: 10 * ScreenTools.scaleWidth
                    }

                    Row {
                        width: parent.width
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: qsTr("横滚角:%1").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.attitude.attitudeRoll.toFixed(
                                          2))
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: qsTr("俯仰角:%1").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.attitude.attitudePitch.toFixed(
                                          2))
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: qsTr("航向角:%1").arg(
                                      VkSdkInstance.vehicleManager.activeVehicle.attitude.attitudeYaw
                                      < 0 ? (360 + VkSdkInstance.vehicleManager.activeVehicle.attitude.attitudeYaw).toFixed(
                                                2) : VkSdkInstance.vehicleManager.activeVehicle.attitude.attitudeYaw.toFixed(
                                                2))
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Item {
                        width: parent.width
                        height: 10 * ScreenTools.scaleWidth
                    }

                    Row {
                        width: parent.width
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: VkSdkInstance.vehicleManager.activeVehicle.obstacleDistance.distances[0]
                                  === 65535 ? qsTr("前避障距离:无") : qsTr(
                                                  "前避障距离:%1m").arg(
                                                  (VkSdkInstance.vehicleManager.activeVehicle.obstacleDistance.distances[0] * 0.01).toFixed(
                                                      1))
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: VkSdkInstance.vehicleManager.activeVehicle.obstacleDistance.distances[2]
                                  === 65535 ? qsTr("后避障距离:无") : qsTr(
                                                  "后避障距离:%1m").arg(
                                                  (VkSdkInstance.vehicleManager.activeVehicle.obstacleDistance.distances[2] * 0.01).toFixed(
                                                      1))
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Item {
                        width: parent.width
                        height: 10 * ScreenTools.scaleWidth
                    }

                    Row {
                        width: parent.width
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: VkSdkInstance.vehicleManager.activeVehicle.obstacleDistance.distances[3]
                                  === 65535 ? qsTr("左避障距离:无") : qsTr(
                                                  "左避障距离:%1m").arg(
                                                  (VkSdkInstance.vehicleManager.activeVehicle.obstacleDistance.distances[3] * 0.01).toFixed(
                                                      1))
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: VkSdkInstance.vehicleManager.activeVehicle.obstacleDistance.distances[1]
                                  === 65535 ? qsTr("右避障距离:无") : qsTr(
                                                  "右避障距离:%1m").arg(
                                                  (VkSdkInstance.vehicleManager.activeVehicle.obstacleDistance.distances[1] * 0.01).toFixed(
                                                      1))
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Text {
                        width: width_text * 3
                        height: 10 * ScreenTools.scaleWidth
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 30 * ScreenTools.scaleWidth
        }

        // 氢能电池信息区域
        Item {
            width: parent.width
            height: 60 * ScreenTools.scaleWidth
            id:vt_qx_bms
            Text {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent.Center
                text: qsTr("氢能电池信息")
                font.pixelSize: button_fontsizes
                font.bold: false
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
            }
        }
        Item {
            id:qx_msg
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: column_battery.height
            Rectangle {
                width: parent.width
                height: parent.height
                color: "#00000000"
                border.color: "white"
                border.width: 2
                radius: 30
            }

            Column {
                width: parent.width
                id: column_battery
                spacing: 0
                //QXBMSMsg组件
                QXBMSMsg{
                    id:qxbms0;
                    width: parent.width;
                    visible: false;
                    width_text: parent.width / 3 * 0.9 * 0.95;
                    height_text: 65 * ScreenTools.scaleWidth;
                    button_fontsize: 30 * ScreenTools.scaleWidth * 5 / 6;
                }
                QXBMSMsg{
                    id:qxbms1;
                    width: parent.width;
                    visible: false;
                    width_text: parent.width / 3 * 0.9 * 0.95;
                    height_text: 65 * ScreenTools.scaleWidth;
                    button_fontsize: 30 * ScreenTools.scaleWidth * 5 / 6;
                }
                QXBMSMsg{
                    id:qxbms2;
                    width: parent.width;
                    visible: false;
                    width_text: parent.width / 3 * 0.9 * 0.95;
                    height_text: 65 * ScreenTools.scaleWidth;
                    button_fontsize: 30 * ScreenTools.scaleWidth * 5 / 6;
                }
                QXBMSMsg{
                    id:qxbms3;
                    width: parent.width;
                    visible: false;
                    width_text: parent.width / 3 * 0.9 * 0.95;
                    height_text: 65 * ScreenTools.scaleWidth;
                    button_fontsize: 30 * ScreenTools.scaleWidth * 5 / 6;
                }
            }
        }
        Item {
            width: parent.width
            height: 30 * ScreenTools.scaleWidth
        }
    }
}
