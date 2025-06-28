import QtQuick
import QtQuick.Controls

import VKGroundControl
import VKGroundControl.Palette
import ScreenTools

Flickable {
    // UI Properties
    property real buttonFontSize: 30 * sw * 5/6
    property var mainColor: qgcPal.titleColor
    
    height: parent.height
    width: parent.width
    clip: true
    contentHeight: mainItem.height

    VKPalette {
        id: qgcPal
    }


    Item {
        id: mainItem
        width: parent.width
        height: mainColumn.height + 80 * sw
        
        Item {
            width: parent.width * 0.95
            height: mainColumn.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            
            Rectangle {
                width: parent.width
                height: mainColumn.height
                color: "#00000000"
                border.width: 2
                border.color: "gray"
                radius: 30
            }
            
            Row {
                width: parent.width
                height: mainColumn.height
                
                Item {
                    width: parent.width * 0.7
                    height: mainColumn.height
                    
                    Column {
                        id: mainColumn
                        width: parent.width * 0.95
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        BatteryMsg {
                            id: battery0
                            width: parent.width
                            visible: false
                        }
                        BatteryMsg {
                            id: battery1
                            width: parent.width
                            visible: false
                        }
                        BatteryMsg {
                            id: battery2
                            width: parent.width
                            visible: false
                        }
                        BatteryMsg {
                            id: battery3
                            width: parent.width
                            visible: false
                        }
                        BatteryMsg {
                            id: battery4
                            width: parent.width
                            visible: false
                        }
                        BatteryMsg {
                            id: battery5
                            width: parent.width
                            visible: false
                        }
                    }
                }
                
                Item {
                    width: 2
                    height: mainColumn.height
                    Rectangle {
                        width: 2
                        height: mainColumn.height
                        color: "gray"
                    }
                }
                
                Item {
                    width: parent.width * 0.3 - 2
                    height: mainColumn.height

                    Column {
                        width: parent.width
                        
                        Item {
                            width: parent.width
                            height: 80 * sw
                        }
                        
                        Button {
                            id: calibrateButton
                            width: 180 * sw
                            height: 50 * sw
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 40 * mainWindow.bili_height
                            
                            onClicked: {
                                vk_battery_cal.open()
                            }
                            
                            background: Rectangle {
                                anchors.fill: parent
                                radius: 30 * sw
                                
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 30 * sw
                                    height: parent.height
                                    color: calibrateButton.pressed ? "gray" : mainColor
                                }
                                
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("电压校准")
                                    font.pixelSize: buttonFontSize * 5/6
                                    color: "white"
                                    font.bold: false
                                }
                                
                                color: "#00000000"
                            }
                        }
                    }
                }
            }
        }
    }

    BatteryCalibration{
        width:800*ScreenTools.scaleWidth
        id:vk_battery_cal
        //id:vkbiandui
        anchors.centerIn: parent
    }
}
