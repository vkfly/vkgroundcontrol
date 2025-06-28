import QtQuick
import QtQuick.Controls

import VKGroundControl
import Controls
import VkSdkInstance
import ScreenTools
// import VKGroundControl.Vehicle
// import VKGroundControl.MultiVehicleManager

import "../Common"

VKInstallBase {
    id: _root
    property var paramvalue11 : VkSdkInstance.vehicleManager.activeVehicle.parameters["COM_SBUSO_AF"]

    property var installid:-1
    // 监听参数变化
    onParamvalue11Changed: {
        installid = parseInt(paramvalue11)
    }

    Row {
        width: parent.width
        height: 50 * ScreenTools.scaleWidth
        anchors.verticalCenter: parent.verticalCenter
        Item {
            width: parent.width * 3 / 4 - 2
            height: parent.height
            Column {
                width: parent.width - 20
                height: parent.height
                Item {
                    width: parent.width
                    height: 50 * ScreenTools.scaleWidth
                    Row {
                        width: parent.width
                        height: parent.height
                        spacing: 2
                        Text {
                            width: (parent.width - 6) / 4
                            height: parent.height
                            font.pixelSize: buttonFontsize
                            text: qsTr("Sbus复用:")
                            font.bold: false
                            verticalAlignment: Text.AlignVCenter
                            color: "gray"
                        }

                        GroupButton {
                            width: (parent.width - 6) / 2
                            height: parent.height
                            fontSize: buttonFontsize
                            spacing: 2 * ScreenTools.scaleWidth
                            names: [qsTr("透传SBUS"),qsTr("抛投复用")]
                            selectedIndex: installid
                            onClicked: {
                                VkSdkInstance.vehicleManager.activeVehicle.setParam("COM_SBUSO_AF",index)
                            }
                        }

                        // TextButton {
                        //     id: bt_install_1
                        //     width: (parent.width - 6) / 4
                        //     height: parent.height
                        //     backgroundColor: installid === 0 ? buttonMain : "#EDEDED"
                        //     textColor: installid === 0 ? buttonMain : "black"
                        //     fontSize: buttonFontsize
                        //     text: qsTr("透传SBUS")
                        //     onClicked: {
                        //         VkSdkInstance.vehicleManager.activeVehicle.setParam("COM_SBUSO_AF",0)
                        //         // messagebox.text_msg = qsTr("SBUS O设置为透传SBUS")
                        //         // messagebox.canshu = "COM_SBUSO_AF"
                        //         // messagebox.canshu_y = 1
                        //         // messagebox.send_id = ""
                        //         // messagebox.value_type = 1
                        //         // messagebox.value = 0
                        //         // messagebox.type = 1
                        //         // // slider.value=curvalue.toFixed(tofix)
                        //         // messagebox.open()
                        //     }
                        // }

                        // TextButton {
                        //     id: bt_install_2
                        //     width: (parent.width - 6) / 4
                        //     height: parent.height
                        //     backgroundColor: installid === 1 ? buttonMain : "#EDEDED"
                        //     textColor: installid === 1 ? buttonMain : "black"
                        //     fontSize: buttonFontsize
                        //     text: qsTr("抛投复用")
                        //     onClicked: {
                        //         VkSdkInstance.vehicleManager.activeVehicle.setParam("COM_SBUSO_AF",1)
                        //     }
                        // }
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
        }
    }
}
