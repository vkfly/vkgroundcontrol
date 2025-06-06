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

    property var value: VkSdkInstance.vehicleManager.vehicles[0].attitude.attitudeRoll
    onValueChanged: {

    }

    Column {
        width: parent.width * 0.98
        anchors.horizontalCenter: parent.horizontalCenter
        id: column_msg
        VTitle {
            visible: false
            id: vt
            vt_title: qsTr("定位信息")
        }
        Item {
            visible: false
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: column.height
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
                // height: 100*ScreenTools.scaleWidth
                Column {
                    width: parent.width
                    id: column
                    // Text {
                    //     width:width_text
                    //     height:height_text
                    //     font.pixelSize: fontsize
                    //     color: fontcolor
                    //     text:"时间戳"+gettime()
                    // }
                    Item {
                        width: parent.width
                        height: 10 * ScreenTools.scaleWidth
                    }
                    Row {
                        width: parent.width
                        // height:30*ScreenTools.scaleWidth
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            font.bold: false
                            color: fontcolor
                            //text: qsTr("RTK航向:%1").arg(gethead())
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            font.bold: false
                            color: fontcolor
                            //text:"RTK定位星数:"+ get_rtk_star()
                            //text: qsTr("RTK定位星数:%1").arg(get_rtk_star())
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            // text:"RTK定向星数:"+ getheadstar()
                            //text: qsTr("RTK定向星数:%1").arg(getheadstar())
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Row {
                        width: parent.width
                        //height:30*ScreenTools.scaleWidth
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            font.bold: false
                            color: fontcolor
                            //text:"定位类型:"+getfixed()
                            //text: qsTr("定位类型:%1").arg(getfixed())
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text:"RTK海拔高度:"+getalt()+"m"
                            //text: qsTr("RTK海拔高度:%1m").arg(getalt())
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text:"GPS海拔高度:"+get_alt()+"m"
                            //text: qsTr("GPS海拔高度:%1m").arg(get_alt())
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
                    // GridLayout
                    // {
                    //     id:grid1
                    //     width:width_text*3
                    //     columns:3
                    //     rows: 3
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

                            //text: qsTr("目标距离:%1m").arg(_activeVehicle? getmubiao_dis():"0")
                            text: qsTr("目标距离:%1m").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].fmuStatus.distToTar)
                            //text: qsTr("目标距离:%1m").arg(VkSdkInstance.vehicleManager.vehicles[0].sysStatus.batteryVoltage.toFixed(1))
                            //text: VkSdkInstance.vehicleManager.vehicles[0].sysStatus.batteryVoltage.toFixed(1)+ "V"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            font.bold: false
                            color: fontcolor
                            //text: _activeVehicle?getups_v():"UPS 电压: 0V"
                            //text: qsTr("UPS 电压:%1V").arg(_activeVehicle? getups_v():"0")
                            text: qsTr("UPS 电压:%1V").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].fmuStatus.upsVolt)
                            //text: VkSdkInstance.vehicleManager.vehicles[0].sysStatus.batteryVoltage.toFixed(1)+ "V"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            font.bold: false
                            color: fontcolor
                            // text:_activeVehicle? getads_v():"ADC 电压: 0V"
                            //text: qsTr("ADC 电压:%1V").arg(_activeVehicle? getads_v():"0")
                            text: qsTr("ADC 电压:%1V").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].fmuStatus.adcVolt)
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Row {
                        width: parent.width

                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text:qsTr("温度:%1℃").arg(_activeVehicle? _activeVehicle.temperatures:"")
                            text: qsTr("温度:%1℃").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].insStatus.temperature)
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text:qsTr("基础油门:%1%").arg(_activeVehicle? _activeVehicle.throttle:"")
                            text: qsTr("基础油门:%1%").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].vfrHud.throttle)
                            verticalAlignment: Text.AlignVCenter
                        }

                        /* Text {
                            width:width_text
                            height:height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text:"航迹角:"
                            verticalAlignment: Text.AlignVCenter
                        }*/

                        /*
                        Text {
                            width:width_text
                            height:height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            text: _activeVehicle?("水平速度:"+h_speed+"m/s"):"水平速度: 0m/s"
                            verticalAlignment: Text.AlignVCenter
                        }*/
                    }
                    Row {
                        width: parent.width
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text:qsTr("经度:%1").arg(_activeVehicle? (_activeVehicle.longitude).toFixed(7):"")
                            text: qsTr("经度:%1").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].coordinate.longitude)
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false

                            //text:qsTr("纬度:%1").arg(_activeVehicle? (_activeVehicle.latitude).toFixed(7):"")
                            text: qsTr("纬度:%1").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].coordinate.latitude)
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text:qsTr("锁状态:%1").arg(_activeVehicle? _activeVehicle.lock_staus===0?qsTr("落锁"):qsTr("解锁"):"")
                            text: qsTr("锁状态:%1").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].heartbeat.lockStatus
                                      === 0 ? qsTr("落锁") : qsTr("解锁"))
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Row {
                        width: parent.width
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text:qsTr("横滚角:%1").arg(_activeVehicle?rollAngle.toFixed(2):"")
                            text: qsTr("横滚角:%1").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].attitude.attitudeRoll.toFixed(
                                          2))
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text:qsTr("俯仰角:%1").arg(_activeVehicle? pitchAngle.toFixed(2):"")
                            text: qsTr("俯仰角:%1").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].attitude.attitudePitch.toFixed(
                                          2))
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text:qsTr("航向角:%1").arg(_activeVehicle?(headingAngle<0?(360+headingAngle).toFixed(2):headingAngle.toFixed(2)):"")
                            //text: qsTr("航向角:%1%").arg(VkSdkInstance.vehicleManager.vehicles[0].attitude.attitudeYaw<0?(360+attitudeYaw).toFixed(2):attitudeYaw.toFixed(2))
                            //text: qsTr("航向角:%1").arg(VkSdkInstance.vehicleManager.vehicles[0].attitude.attitudeYaw.toFixed(2))
                            text: qsTr("航向角:%1").arg(
                                      VkSdkInstance.vehicleManager.vehicles[0].attitude.attitudeYaw
                                      < 0 ? (360 + VkSdkInstance.vehicleManager.vehicles[0].attitude.attitudeYaw).toFixed(
                                                2) : VkSdkInstance.vehicleManager.vehicles[0].attitude.attitudeYaw.toFixed(
                                                2))

                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Row {
                        width: parent.width

                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text: _activeVehicle?(_activeVehicle.bizhang_dis[0]===65535?qsTr("前避障距离:无"):qsTr("前避障距离:%1m").arg((_activeVehicle.bizhang_dis[0]*0.01).toFixed(1))):qsTr("右避障距离:无")
                            text: VkSdkInstance.vehicleManager.vehicles[0].obstacleDistance.distances[0]
                                  === 65535 ? qsTr("前避障距离:无") : qsTr(
                                                  "前避障距离:%1m").arg(
                                                  (VkSdkInstance.vehicleManager.vehicles[0].obstacleDistance.distances[0] * 0.01).toFixed(
                                                      1))

                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            //text:_activeVehicle?(_activeVehicle.bizhang_dis[2]===65535?qsTr("后避障距离:无"):qsTr("后避障距离:%1m").arg((_activeVehicle.bizhang_dis[2]*0.01).toFixed(1))):qsTr("后避障距离:无")
                            text: VkSdkInstance.vehicleManager.vehicles[0].obstacleDistance.distances[2]
                                  === 65535 ? qsTr("后避障距离:无") : qsTr(
                                                  "后避障距离:%1m").arg(
                                                  (VkSdkInstance.vehicleManager.vehicles[0].obstacleDistance.distances[2] * 0.01).toFixed(
                                                      1))
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Row {
                        width: parent.width

                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            // text:_activeVehicle?(_activeVehicle.bizhang_dis[3]===65535?qsTr("左避障距离:无"):qsTr("左避障距离:%1m").arg((_activeVehicle.bizhang_dis[3]*0.01).toFixed(1))):qsTr("左避障距离:无")
                            text: VkSdkInstance.vehicleManager.vehicles[0].obstacleDistance.distances[3]
                                  === 65535 ? qsTr("左避障距离:无") : qsTr(
                                                  "左避障距离:%1m").arg(
                                                  (VkSdkInstance.vehicleManager.vehicles[0].obstacleDistance.distances[3] * 0.01).toFixed(
                                                      1))
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            width: width_text
                            height: height_text
                            font.pixelSize: fontsize
                            color: fontcolor
                            font.bold: false
                            // text:_activeVehicle?(_activeVehicle.bizhang_dis[1]===65535?qsTr("右避障距离:无"):qsTr("右避障距离:%1m").arg((_activeVehicle.bizhang_dis[1]*0.01).toFixed(1))):qsTr("右避障距离:无")
                            text: VkSdkInstance.vehicleManager.vehicles[0].obstacleDistance.distances[1]
                                  === 65535 ? qsTr("右避障距离:无") : qsTr(
                                                  "右避障距离:%1m").arg(
                                                  (VkSdkInstance.vehicleManager.vehicles[0].obstacleDistance.distances[1] * 0.01).toFixed(
                                                      1))
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    // Row{
                    //     width: parent.width

                    //     Text{
                    //         width:width_text*3
                    //         height:30*ScreenTools.scaleWidth
                    //     }
                    // }
                    Text {
                        width: width_text * 3
                        height: 10 * ScreenTools.scaleWidth
                    }
                }
                // }
            }
        }
        Item {
            width: parent.width
            height: 30 * ScreenTools.scaleWidth
        }
    }
}
