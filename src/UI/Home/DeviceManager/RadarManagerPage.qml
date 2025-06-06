import QtQuick
import QtQuick.Controls

import VKGroundControl
import Controls
import VKGroundControl.Palette

// import VKGroundControl.Vehicle
// import VKGroundControl.MultiVehicleManager
import "../Common"

Flickable {
    // UI Properties
    property real buttonFontSize: 30 * sw * 5 / 6
    property color mainColor: qgcPal.titleColor
    

    // Advanced Settings
    property bool isAdvanced: false
    property string advancedIconDown: "/qmlimages/icon/down_arrow.png"
    property string advancedIconUp: "/qmlimages/icon/up_arrow.png"
    
    // Filter Properties
    property int gyroFilterId: -1
    property int accelFilterId: -1
    property real idleValue: 0.05
    
    // Radar Status Properties

    property bool isFrontRadar: false
    property bool isRearRadar: false
    property bool isTerrainRadar: false

    // Layout Properties
    height: parent.height
    width: parent.width
    clip: true
    contentHeight: mainColumn.implicitHeight
    
    VKPalette {
        id: qgcPal
    }


    
    Column {
        id: mainColumn
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter
        
        Item {
            width: parent.width
            height: 40 * sw
        }
        
        ToolTitle {
            textTitle: qsTr("单向雷达")
        }
        
        Item {
            width: parent.width
            height: singleRadarColumn.height
            
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            
            Item {
                id: singleRadarContainer
                width: parent.width
                height: singleRadarColumn.height
                
                Row {
                    width: parent.width
                    height: singleRadarColumn.height
                    
                    Item {
                        width: parent.width * 2 / 3 - 2
                        height: singleRadarColumn.height

                        Column {
                            id: singleRadarColumn
                            width: parent.width
                            spacing: 10 * sw
                            
                            Item {
                                width: 200 * sw
                                height: 40 * sw
                            }
                            
                            // Front Radar
                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                Text {
                                    text: qsTr("前避障雷达")
                                    width: parent.width / 3
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                
                                Text {
                                    id: frontVersionText
                                    text: "--------"
                                    width: parent.width / 3
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                
                                Item {
                                    width: parent.width / 3
                                    height: 60 * sw
                                    
                                    Button {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.verticalCenter: parent.verticalCenter
                                        visible: false
                                        id: frontUpgradeButton
                                        width: 180 * sw
                                        height: 50 * sw
                                        font.pixelSize: 20 * mainWindow.bili_height
                                        
                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 30 * sw
                                            
                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 30 * sw
                                                height: parent.height
                                                color: frontUpgradeButton.pressed ? "gray" : mainColor
                                            }
                                            
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                text: qsTr("在线升级")
                                                font.pixelSize: buttonFontSize * 5 / 6
                                                color: "white"
                                                font.bold: false
                                            }
                                            
                                            color: "#00000000"
                                        }
                                    }
                                }
                            }
                            
                            Item {
                                width: 200 * sw
                                height: 15 * sw
                            }
                            
                            // Rear Radar
                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                Text {
                                    text: qsTr("后避障雷达")
                                    width: parent.width / 3
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                
                                Text {
                                    id: rearVersionText
                                    text: "--------"
                                    width: parent.width / 3
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                
                                Item {
                                    width: parent.width / 3
                                    height: 60 * sw
                                    
                                    Button {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.verticalCenter: parent.verticalCenter
                                        id: rearUpgradeButton
                                        width: 180 * sw
                                        height: 50 * sw
                                        font.pixelSize: 20 * mainWindow.bili_height
                                        visible: false
                                        
                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 30 * sw
                                            
                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 30 * sw
                                                height: parent.height
                                                color: rearUpgradeButton.pressed ? "gray" : mainColor
                                            }
                                            
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                text: qsTr("在线升级")
                                                font.pixelSize: buttonFontSize * 5 / 6
                                                color: "white"
                                                font.bold: false
                                            }
                                            
                                            color: "#00000000"
                                        }
                                    }
                                }
                            }
                            
                            Item {
                                width: 200 * sw
                                height: 15 * sw
                            }
                            
                            // Terrain Radar
                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                Text {
                                    text: qsTr("仿地雷达")
                                    width: parent.width / 3
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                
                                Text {
                                    id: terrainVersionText
                                    text: "--------"
                                    width: parent.width / 3
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                
                                Item {
                                    width: parent.width / 3
                                    height: 60 * sw
                                    
                                    Button {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.verticalCenter: parent.verticalCenter
                                        id: terrainUpgradeButton
                                        width: 180 * sw
                                        height: 50 * sw
                                        font.pixelSize: 20 * mainWindow.bili_height
                                        visible: false
                                        
                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 30 * sw
                                            
                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 30 * sw
                                                height: parent.height
                                                color: terrainUpgradeButton.pressed ? "gray" : mainColor
                                            }
                                            
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                text: qsTr("在线升级")
                                                font.pixelSize: buttonFontSize * 5 / 6
                                                color: "white"
                                                font.bold: false
                                            }
                                            
                                            color: "#00000000"
                                        }
                                    }
                                }
                            }
                            
                            Item {
                                width: 200 * sw
                                height: 40 * sw
                            }
                        }
                    }
                    
                    // Divider
                    Item {
                        width: 2
                        height: parent.height
                        
                        Rectangle {
                            width: parent.width
                            height: singleRadarContainer.height
                            color: "gray"
                        }
                    }
                    
                    // Radar Distance Information
                    Item {
                        width: parent.width * 1 / 3
                        height: singleRadarColumn.height
                        
                        Column {
                            width: parent.width * 0.8
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 10 * sw
                            
                            Item {
                                width: parent.width
                                height: 40 * sw
                            }
                            
                            // Front Radar Distance
                            Row {
                                width: parent.width
                                height: 60 * sw
                                
                                Text {
                                    width: parent.width / 2
                                    height: 40 * sw
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("前避障距离")
                                    color: "gray"
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                
                                Text {
                                    width: parent.width / 2
                                    height: 40 * sw
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: activeVehicle ? (activeVehicle.bizhang_dis[0] === 65535 ? qsTr("无效") : (activeVehicle.bizhang_dis[0] * 0.01).toFixed(1) + "m") : ""
                                    color: "gray"
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                            
                            Item {
                                width: 200 * sw
                                height: 15 * sw
                            }
                            
                            // Rear Radar Distance
                            Row {
                                width: parent.width
                                height: 60 * sw
                                
                                Text {
                                    width: parent.width / 2
                                    height: 40 * sw
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("后避障距离")
                                    color: "gray"
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                
                                Text {
                                    width: parent.width / 2
                                    height: 40 * sw
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: activeVehicle ? (activeVehicle.bizhang_dis[2] === 65535 ? qsTr("无效") : (activeVehicle.bizhang_dis[2] * 0.01).toFixed(1) + "m") : ""
                                    color: "gray"
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                            
                            Item {
                                width: 200 * sw
                                height: 15 * sw
                            }
                            
                            // Terrain Distance
                            Row {
                                width: parent.width
                                height: 60 * sw
                                
                                Text {
                                    width: parent.width / 2
                                    height: 40 * sw
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("仿地距离")
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                
                                Text {
                                    width: parent.width / 2
                                    height: 40 * sw
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: activeVehicle ? (activeVehicle.current_dis.toFixed(1) + "m") : ""
                                    color: "gray"
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                            
                            Item {
                                width: 200 * sw
                                height: 15 * sw
                            }
                        }
                    }
                }
            }
        }
        
        Item {
            width: parent.width
            height: 40 * sw
        }
        
        ToolTitle {
            textTitle: qsTr("360雷达")
        }
        
        Item {
            width: parent.width
            height: panoramicRadarColumn.height
            
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            
            Item {
                id: panoramicRadarContainer
                width: parent.width
                height: panoramicRadarColumn.height
                
                Row {
                    width: parent.width
                    height: panoramicRadarColumn.height
                    
                    Item {
                        width: parent.width * 2 / 3 - 2
                        height: panoramicRadarColumn.height
                        
                        Column {
                            id: panoramicRadarColumn
                            width: parent.width
                            spacing: 10 * sw
                            
                            Item {
                                width: parent.width / 3
                                height: 40 * sw
                            }
                            
                            Item {
                                width: parent.width / 3
                                height: 60 * sw
                            }
                            
                            Item {
                                width: 200 * sw
                                height: 15 * sw
                            }
                            
                            // 360 Radar
                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                Text {
                                    text: qsTr("360雷达")
                                    width: parent.width / 3
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                
                                Text {
                                    text: "--------"
                                    width: parent.width / 3
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                
                                Item {
                                    width: parent.width / 3
                                    height: 60 * sw
                                    
                                    Button {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.verticalCenter: parent.verticalCenter
                                        id: panoramicUpgradeButton
                                        width: 180 * sw
                                        height: 50 * sw
                                        font.pixelSize: 20 * mainWindow.bili_height
                                        visible: false
                                        
                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 30 * sw
                                            
                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 30 * sw
                                                height: parent.height
                                                color: panoramicUpgradeButton.pressed ? "gray" : mainColor
                                            }
                                            
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                text: qsTr("在线升级")
                                                font.pixelSize: buttonFontSize * 5 / 6
                                                color: "white"
                                                font.bold: false
                                            }
                                            
                                            color: "#00000000"
                                        }
                                    }
                                }
                            }
                            
                            Item {
                                width: 200 * sw
                                height: 15 * sw
                            }
                            
                            Item {
                                width: parent.width / 3
                                height: 60 * sw
                            }
                            
                            Item {
                                width: 200 * sw
                                height: 40 * sw
                            }
                        }
                    }
                    
                    // Divider
                    Item {
                        width: 2
                        height: parent.height
                        
                        Rectangle {
                            width: parent.width
                            height: singleRadarContainer.height
                            color: "gray"
                        }
                    }
                    
                    // 360 Radar Display
                    Item {
                        width: parent.width * 1 / 3
                        height: singleRadarColumn.height
                        
                        Row {
                            width: parent.width * 0.8
                            height: singleRadarColumn.height
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            // Radar Gauge
                            Item {
                                width: parent.width * 0.5
                                height: parent.height
                                
                                RadarDashboard {
                                    width: parent.width
                                    height: parent.width
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    
                                    Text {
                                        width: parent.width
                                        height: parent.height / 2
                                        text: qsTr("前")
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    
                                    Text {
                                        width: parent.width
                                        height: parent.height / 2
                                        text: qsTr("后")
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.bottom: parent.bottom
                                    }
                                    
                                    Text {
                                        width: parent.width / 2
                                        height: parent.height
                                        text: qsTr("左")
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: parent.left
                                    }
                                    
                                    Text {
                                        width: parent.width / 2
                                        height: parent.height
                                        text: qsTr("右")
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.right: parent.right
                                    }
                                }
                            }
                            
                            // Radar Readings
                            Column {
                                width: parent.width * 0.5
                                spacing: 10 * sw
                                
                                Item {
                                    width: parent.width
                                    height: 25 * sw
                                }
                                
                                Text {
                                    width: parent.width
                                    height: 60 * sw
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("前  ---")
                                    color: "gray"
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                
                                Text {
                                    width: parent.width
                                    height: 60 * sw
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("后  ---")
                                    color: "gray"
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                
                                Text {
                                    width: parent.width
                                    height: 60 * sw
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("左  ---")
                                    color: "gray"
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                
                                Text {
                                    width: parent.width
                                    height: 60 * sw
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("右  ---")
                                    color: "gray"
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                
                                Item {
                                    width: 200 * sw
                                    height: 15 * sw
                                }
                            }
                        }
                    }
                }
            }
        }
        
        Item {
            width: parent.width
            height: 40 * sw
        }
    }
    
    VKMessageShow {
        id: messageBox
        anchors.centerIn: parent
        popupWidth: parent.width * 0.5
        messageType: 1
        popupHeight: 240 * sw
    }
}
