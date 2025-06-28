import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import VKGroundControl
import VKGroundControl.Palette
import VkSdkInstance
import Controls
import ScreenTools
import Home

Popup {
    id: popup
    width: popupWidth
    height: column.height
    modal: true
    focus: true
    closePolicy:Popup.NoAutoClose
    property var button_fontsize:30*ScreenTools.scaleWidth
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

    property int selseid:0
    signal clicksend(var msg,var id)

    background:Rectangle {
        width: parent.width
        height:column.height
        color: "#00000000"
        Rectangle{
            width: parent.width
            height:column.height
            anchors.fill: parent
            radius: 15
            color: "#50000000"
            // border.width: 3
            //border.color: "black"
        }

        Column {
            id:column
            width: parent.width
            // height:parent.height
            // height:parent.height-60*ScreenTools.scaleWidth
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            Item{
                width:parent.width
                height: 40*ScreenTools.scaleWidth
            }
            Text{
                id:text1
                width: parent.width
                color: "white"
                //width: parent.width*0.5
                height: 60*ScreenTools.scaleWidth
                font.pixelSize: 35*ScreenTools.scaleWidth
                text: qsTr("工厂模式")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Item{
                width:parent.width
                height: 40*ScreenTools.scaleWidth
            }
            Item{
                width:parent.width
                height:70*ScreenTools.scaleWidth
                TextField{
                    id:text_field
                    width: parent.width*0.7
                    height: 70*ScreenTools.scaleWidth
                    font.pixelSize: 25*ScreenTools.scaleWidth
                    text: ""
                    color: "white"
                    placeholderText: qsTr("请输入密码")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    background: Item {
                        width: parent.width
                        height: parent.height
                        Rectangle {
                            id: borderRect
                            anchors.fill: parent
                            color: "#70000000"
                            radius:20
                        }
                        Image {
                            source: "/qmlimages/icon/suo.png"  // 替换为实际的图标路径
                            width: 30 * ScreenTools.scaleWidth
                            height: 30 * ScreenTools.scaleWidth
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 30 * ScreenTools.scaleWidth
                        }
                    }
                }
            }
            Text{
                width:1
                height:60*ScreenTools.scaleWidth
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
                        color:bt.pressed?"lightgray": "gray"
                    }
                    Rectangle{
                        width: parent.width / 2
                        height: parent.height
                        color:bt.pressed?"lightgray": "gray"
                        anchors.right: parent.right
                    }
                    Button {
                        id:bt
                        width: parent.width
                        height: parent.height
                        text: qsTr("关闭")
                        onClicked: {
                            popup.close()
                            //_activeVehicle.sendweigherconfig(0.0,NaN);//去皮
                        }
                        background: Rectangle {

                            color:bt.pressed?"lightgray": "gray"
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
                        color: bt11.pressed?"lightgray": mainWindow.titlecolor
                    }
                    Rectangle{
                        width: parent.width / 2
                        height: parent.height
                        color:bt11.pressed?"lightgray": mainWindow.titlecolor
                        anchors.left: parent.left
                    }
                    Button {
                        id:bt11
                        text: qsTr("确定")
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            if(text_field.text==="88888"){
                                //mainWindow.showidwindow=11
                                //mainsetting.maintitlename=qsTr("工厂模式")
                                // mainsetting.show_id=10
                                //clicksend(qsTr("工厂模式"),10)
                                moduleType = HomePage.ModuleType.FactorySettings
                                if(_activeVehicle)
                                    _activeVehicle.requestlist()
                                popup.close()
                                text_field.text=""
                                mainWindow.isgongchang=true
                            }
                            // _activeVehicle.parameterManager._sendParamToVehicle("BAT_V_OFF0",9,piancha.toString());
                            //_activeVehicle.sendweigherconfig(text_field.text,NaN);
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

