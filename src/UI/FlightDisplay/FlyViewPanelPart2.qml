import QtQuick 2.15
import VkSdkInstance
import ScreenTools
import VKGroundControl

Item {
    width: parent.width
    height: parent.height
    property double dis_to_wpt: _vehicles ? _vehicles.fmuStatus.distToTar : 0
    property double dis_to_home: _vehicles ? _vehicles.homeDis : 0
    property double throttle: _vehicles ? _vehicles.vfrHud.throttle : 0
    property double v_speed: _vehicles ? (_vehicles.globalPositionInt.verticalSpeed).toFixed(
                                             1) : 0
    property double h_speed: _vehicles ? (_vehicles.globalPositionInt.horizontalSpeed).toFixed(
                                             1) : 0
    property double height_value: _vehicles ? _vehicles.globalPositionInt.relativeAlt.toFixed(
                                                  1) : 0

    property var _vehicles: VkSdkInstance.vehicleManager.vehicles[0]

    Column {
        width: parent.width
        height: parent.height
        Item {
            width: parent.width
            height: parent.height * 0.5
            Row {
                width: parent.width
                height: parent.height

                spacing: 20
                SixTuText {
                    width: parent.width / 3
                    height: parent.height
                    text_name1: qsTr("速度(m/s)")
                    text_name2: h_speed.toFixed(1)
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            keyBoardNumView.sendId = 1
                            keyBoardNumView.setInputParameters(
                                        1, 20, qsTr("设置速度"), "m/s", 1,
                                        _activeVehicle ? h_speed.toFixed(0) : 5)
                            keyBoardNumView.visible = true
                        }
                    }
                    // anchors.bottom: parent.Bottom
                }
                SixTuText {
                    width: parent.width / 3
                    height: parent.height
                    text_name1: qsTr("高度(m)")
                    text_name2: height_value.toFixed(1)
                    MouseArea {
                        width: parent.width / 3
                        height: parent.height
                        onClicked: {

                            // popupWindow.minvalue=1
                            // popupWindow.maxvalue=2000
                            // popupWindow.texttitle=qsTr("设置高度")
                            // popupWindow.danwei="m"
                            // popupWindow.fixednum=1
                            // popupWindow.str_text=5
                            // popupWindow.issend=true
                            // popupWindow.send_id=2 //0 是没 1 是速度 2 是高度
                            // popupWindow.setvalue(popupWindow.minvalue,popupWindow.maxvalue,popupWindow.texttitle,popupWindow.danwei,popupWindow.fixednum,  popupWindow.str_text)
                            // popupWindow.visible=true
                        }
                    }
                    // anchors.bottom: parent.Bottom
                }
                SixTuText {
                    width: parent.width / 3
                    height: parent.height
                    text_name1: dis_to_home > 1000 ? qsTr("距离(km)") : qsTr(
                                                         "距离(m)")
                    text_name2: get_dis_home()
                }
            }
        }
        Item {
            width: parent.width
            height: parent.height * 0.5
            Row {
                width: parent.width
                height: parent.height * 0.6
                anchors.top: parent.top
                spacing: 20
                SixTuText {
                    width: parent.width / 3
                    height: parent.height
                    text_name1: qsTr("垂速(m/s)")
                    text_name2: v_speed.toFixed(1)
                }
                SixTuText {
                    width: parent.width / 3
                    height: parent.height
                    text_name1: qsTr("对地雷达(m)")
                    text_name2: _vehicles ? _vehicles.distanceSensor.currentDistance.toFixed(
                                                1) : "0"
                    //text_name2: get_dis()
                }
                SixTuText {
                    width: parent.width / 3
                    height: parent.height
                    text_name1: _vehicles.fmuStatus.flightDist < 1000 ? qsTr("里程(m)") : qsTr(
                                                                            "里程(km)")
                    text_name2: _vehicles ? _vehicles.fmuStatus.flightDist
                                            < 1000 ? _vehicles.fmuStatus.flightDist : (_vehicles.fmuStatus.flightDist * 0.001).toFixed(
                                                         2) : "0"
                }
            }
        }
    }

    function get_dis() {
        if (dis_to_wpt > 1000) {
            return (VkSdkInstance.vehicleManager.vehicles[0].fmuStatus.distToTar / 1000.0).toFixed(
                        1)
        } else {
            return (VkSdkInstance.vehicleManager.vehicles[0].fmuStatus.distToTar).toFixed(
                        0)
        }
    }

    function get_dis_home() {
        if (dis_to_home > 1000) {
            return (dis_to_home / 1000.0).toFixed(1)
        } else {
            return (dis_to_home).toFixed(0)
        }
    }
}
