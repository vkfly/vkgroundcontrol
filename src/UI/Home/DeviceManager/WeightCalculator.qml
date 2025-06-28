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
    //property  var text_jixing_msg:"请注意螺旋桨转动方向！"
    property  var buttonFontSize:30 * ScreenTools.scaleWidth
    property int popupWidth: 600 * ScreenTools.scaleWidth
    property int popupHeight: 720
    property int textFontSize: 25   //文本字体大小
    property int buttonFontSize2: 14  //按钮字体大小
    property string buttonFontColor: "white"  //按钮字体颜色
    property var backgroundcolor: mainWindow.titlecolor
    property int selseid:0


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
                        text: qsTr("当前重量为%1g,准确重量为").arg(_activeVehicle?_activeVehicle.weigherState.weight : "")
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
                        text: qsTr("g")
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
                    width: parent.width / 3
                    height: parent.height
                    Rectangle{
                        width: parent.width / 2
                        height: parent.height/2
                        color:bt.pressed?"lightgray": mainWindow.titlecolor
                    }
                    Rectangle{
                        width: parent.width / 2
                        height: parent.height
                        color:bt.pressed?"lightgray": mainWindow.titlecolor
                        anchors.right: parent.right
                    }
                    Button {
                        id:bt
                        width: parent.width
                        height: parent.height
                        text: qsTr("去皮")
                        onClicked: {
                            _activeVehicle.sendweigherconfig(0.0,NaN);//去皮
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
                                color: "white"
                                font.pixelSize: buttonFontSize
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
                Item{
                    width: parent.width / 3
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

                        text: qsTr("关闭")
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            popup.close()
                        }
                        background: Rectangle {
                            color: "gray"
                            //color:bt.pressed?"lightgray": mainWindow.titlecolor
                            //radius: 15
                        }
                        contentItem: Item {
                            width: parent.width
                            height: parent.height

                            Text {
                                text: parent.parent.text
                                color: buttonFontColor
                                font.pixelSize: buttonFontSize
                                anchors.centerIn: parent
                            }
                        }
                    }
                }

                Item{
                    width: parent.width / 3
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
                        id:bt11
                        text: qsTr("开始校准")
                        width: parent.width
                        height: parent.height
                        onClicked: {

                            // _activeVehicle.parameterManager._sendParamToVehicle("BAT_V_OFF0",9,piancha.toString());
                            _activeVehicle.sendweigherconfig(text_field.text,NaN);
                        }
                        background: Rectangle {
                            color:bt11.pressed?"lightgray": mainWindow.titlecolor
                            radius: 15
                        }
                        contentItem: Item {
                            width: parent.width
                            height: parent.height

                            Text {
                                text: parent.parent.text
                                color: buttonFontColor
                                font.pixelSize: buttonFontSize
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }
        }
    }
}
