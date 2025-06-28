import QtQuick 2.15
import QtQuick.Controls 2.15
import QGroundControl               1.0

import ScreenTools
import VkSdkInstance 1.0

Popup {
    id: popup
    width: popupWidth
    height: column.height
    modal: true
    focus: true
    closePolicy:Popup.NoAutoClose
    property  var button_fontsize:30*ScreenTools.scaleWidth
    property int popupWidth: 600*ScreenTools.scaleWidth
    property int popupHeight: 720
    property int type: 1
    property int text_alignment: 0    // 0: 居中对齐, 1: 靠左对齐
    property int left_juli: 15  //离左边的距离
    property int leftm_argin: 10
    property int text_font_size1: 25   //文本字体大小
    property int button_font_size: 14  //按钮字体大小
    property string button_font_color: "white"  //按钮字体颜色
    property var backgroundcolor: mainWindow.titlecolor

    property var _activeVehicle: VkSdkInstance.vehicleManager.activeVehicle
    property var voltageDeviation : 0

    onOpened: {
         if(_activeVehicle) {
             voltageDeviation = _activeVehicle.parameters["BAT_V_OFF0"] || 0
         }
     }

    background:Rectangle {
        width: parent.width
        height:column.height
        color: "#00000000"
        Rectangle{
            width: parent.width
            height:column.height
            anchors.fill: parent
            radius: 15
            color: "white"
            // border.width: 3
            //border.color: "black"
        }

        Column {
            id:column
            width: parent.width
            Item{
                width:parent.width
                height: 30*ScreenTools.scaleWidth
            }

            Item{
                width:parent.width*0.8
                height:120*ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter

                Row{
                    width:text2.width+text1.width+100*ScreenTools.scaleWidth
                    height: 60*ScreenTools.scaleWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    Text{
                        id:text1
                          color: "black"
                        //width: parent.width*0.5
                        height: 60*ScreenTools.scaleWidth
                        font.pixelSize: 30*ScreenTools.scaleWidth
                        text: qsTr("当前电压值为%1V,准确电压值为").arg(_activeVehicle? _activeVehicle.sysStatus.batteryVoltage.toFixed(1):"")
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField{
                        id:text_field
                        width: 80*ScreenTools.scaleWidth
                        height: 40*ScreenTools.scaleWidth
                        font.pixelSize: 25*ScreenTools.scaleWidth
                        text: "0"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text{
                        id:text2
                        color: "black"
                        //width: parent.width*0.5
                        height: 60*ScreenTools.scaleWidth
                        font.pixelSize: 30*ScreenTools.scaleWidth
                        text: qsTr("V")
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            Text{
                width:1
                height:20*ScreenTools.scaleWidth
            }

            Row{
                width: parent.width
                height: 80*ScreenTools.scaleWidth

                Item{
                    width: parent.width / 2
                    height: parent.height
                    Rectangle{
                        width: parent.width / 2
                        height: parent.height/2
                        color: "gray"
                    }
                    Rectangle{
                        width: parent.width / 2
                        height: parent.height
                        color: "gray"
                        anchors.right: parent.right
                    }
                    Button {
                        id: button1
                        width: parent.width
                        height: parent.height
                        text: qsTr("关闭")
                        onClicked: {
                            popup.close()
                        }
                        background: Rectangle {
                            color: "gray"
                            radius: 15
                        }
                        contentItem: Item {
                            width: parent.width
                            height: parent.height

                            Text {
                                text: parent.parent.text
                                color: "white"
                                font.pixelSize: button_fontsize
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
                Item{
                    width: parent.width / 2
                    height: parent.height
                    Rectangle{
                        width: parent.width
                        height: parent.height/2
                        color: mainWindow.titlecolor
                    }
                    Rectangle{
                        width: parent.width / 2
                        height: parent.height
                        color: mainWindow.titlecolor
                        anchors.left: parent.left
                    }
                    Button {
                        id:bt
                        text: qsTr("开始校准")
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            if(!_activeVehicle) return

                            // 重新获取当前参数值，确保使用最新值
                            const currentDeviation = _activeVehicle.parameters["BAT_V_OFF0"] || 0

                            // 正确计算公式：
                            const measuredVoltage = _activeVehicle.sysStatus.batteryVoltage
                            const actualVoltage = parseFloat(text_field.text) || 0

                            // 新参数值 = 实际电压值 - (测量电压值 - 当前参数值)
                            const newDeviation = actualVoltage - (measuredVoltage - currentDeviation)

                            console.log("电压校准参数计算:",
                                        "\n测量电压:", measuredVoltage.toFixed(2), "V",
                                        "\n实际电压:", actualVoltage.toFixed(2), "V",
                                        "\n当前参数:", currentDeviation.toFixed(2),
                                        "\n计算新参数:", newDeviation.toFixed(2))

                            // 设置新参数值
                            _activeVehicle.setParam("BAT_V_OFF0", newDeviation)

                        }
                        background: Rectangle {
                            color:bt.pressed?"lightgray": mainWindow.titlecolor
                            radius: 15
                        }
                        contentItem: Item {
                            width: parent.width
                            height: parent.height

                            Text {
                                text: parent.parent.text
                                color: button_font_color
                                font.pixelSize: button_fontsize
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }
        }
    }
}

