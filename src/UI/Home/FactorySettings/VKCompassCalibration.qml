import QtQuick 2.15
import QtQuick.Controls 2.15
import QGroundControl

import VKGroundControl
import VKGroundControl.Palette
import VkSdkInstance
import Controls
import ScreenTools

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
    property string button_font_color: "white"  //按钮字体颜色
    property var backgroundcolor: mainWindow.titlecolor

    property ListModel customModel: ListModel {
        ListElement { text: qsTr("不抛投") }
        ListElement { text: qsTr("高空抛投") }
        ListElement { text: qsTr("降落抛投") }
        ListElement { text: qsTr("近地抛投") }

    }
    background:Rectangle {
        width: parent.width
        height:column.height
        color: "#00000000"
        Rectangle{
            width: parent.width
            height:parent.height
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
            Row{
                width:parent.width
                height:parent.width*0.35+40*ScreenTools.scaleWidth
                spacing: parent.width/12
                Text{
                    width:1
                    height:parent.height
                }
                Button{
                    width:parent.width*0.35
                    height:parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    background:Rectangle{
                        width: parent.width
                        height:parent.height
                        color: "#00000000"
                        Column{
                            width:parent.width
                            height:parent.height
                            Item{
                                width: parent.width
                                height:parent.width
                                Image{
                                    anchors.fill: parent
                                    source: (_activeVehicle.insStatus.magCalibStage===0||_activeVehicle.insStatus.magCalibStage===3||_activeVehicle.insStatus.magCalibStage===4)?"/qmlimages/icon/uav1.png":_activeVehicle.insStatus.magCalibStage===1?"/qmlimages/icon/shuipingjiaozhun.png":_activeVehicle.insStatus.magCalibStage===2?"/qmlimages/icon/chuizhi.png":"/qmlimages/icon/uav1.png"
                                }
                            }
                            Item{
                                width: parent.width
                                height:40*ScreenTools.scaleWidth
                                Text{
                                    width:parent.width
                                    height:40*ScreenTools.scaleWidth
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter

                                    text:_activeVehicle.insStatus.magCalibStage===0?qsTr("准备校准"):_activeVehicle.insStatus.magCalibStage===1?qsTr("水平校准"):_activeVehicle.insStatus.magCalibStage===2?qsTr("垂直校准"):_activeVehicle.insStatus.magCalibStage===3?qsTr("校准成功"):_activeVehicle.insStatus.magCalibStage===4?qsTr("校准失败"):qsTr("准备校准")
                                    color: _activeVehicle.insStatus.magCalibStage===4?"red":"black"
                                    font.pixelSize: button_fontsize*0.8
                                }
                            }

                        }
                    }
                }
                Text{
                    width:parent.width*0.4
                    height:parent.height-60*ScreenTools.scaleWidth
                    color: _activeVehicle.insStatus.magCalibStage===4?"red":"black"

                    text:_activeVehicle.insStatus.magCalibStage===1?qsTr("飞机如图进行水平面校准"):_activeVehicle.insStatus.magCalibStage===2?qsTr("飞机如图进行垂直面校准"):_activeVehicle.insStatus.magCalibStage===3?qsTr("校准成功"):_activeVehicle.insStatus.magCalibStage===4?qsTr("校准失败"):qsTr("准备校准")
                    font.pixelSize: button_fontsize*0.8
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
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
                            _activeVehicle.startCalibration(2)
                        }
                        background: Rectangle {
                            color: bt.pressed?"lightgray":mainWindow.titlecolor
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
