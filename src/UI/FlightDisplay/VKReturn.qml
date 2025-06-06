import QtQuick 2.15
import QtQuick.Controls 2.15

import Controls
import ScreenTools
import VkSdkInstance

Popup {
    id: root
    width: popupWidth
    height: mainColumn.height
    focus: true
    closePolicy: Popup.NoAutoClose
    
    // Properties with camelCase naming
    property string textMessage: ""
    property string textJixing: ""
    property string imageSource: ""
    property real buttonFontSize: 30 * ScreenTools.scaleWidth
    property int popupWidth: 600
    property int popupHeight: 720
    property int type: 1
    property int textAlignment: 0 // 0: 居中对齐, 1: 靠左对齐
    property int leftDistance: 15
    property int textFontSize: 25
    property int buttonFont: 14
    property color buttonFontColor: "white"
    property color backgroundColor: ScreenTools.titleColor
    
    // Flight parameters
    property bool sendAll: false
    property var waypointId: 0
    property var waypointLon: 116
    property var waypointLat: 40
    property var waypointAlt: 100
    property var waypointSpeed: 5
    property var paotouType: 0
    property var paotouHeight: 0
    property bool paotou1: true
    property bool paotou2: false
    property bool paotou3: false
    property bool paotou4: false
    property bool paotou5: false
    property bool paotou6: false
    property bool paotou7: false
    property bool paotou8: false
    property int selectedId: 1

    // Popup entrance animation
    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
        }
    }

    // Background styling
    background: Rectangle {
        anchors.fill: parent
        radius: 15
        color: "transparent"
        
        Rectangle {
            anchors.fill: parent
            radius: 15
            color: "#80000000"
        }
    }

    // Main content
    Column {
        id: mainColumn
        width: parent.width
        spacing: 30 * ScreenTools.scaleWidth

        // Top spacing
        Item {
            width: parent.width
            height: 30 * ScreenTools.scaleWidth
        }

        // Return mode selection section
        ReturnModeSelection {
            width: parent.width
            height: parent.width * 0.32 + 60 * ScreenTools.scaleWidth
            selectedIndex: selectedId
            onModeSelected: function(index) {
                selectedId = index
            }
        }

        // Description text
        Item {
            width: parent.width
            height: 30 * ScreenTools.scaleWidth
            
            Text {
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 20 * ScreenTools.scaleWidth
                text: getDescriptionText()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Execute slider
        Item {
            width: parent.width
            height: 80 * ScreenTools.scaleWidth
            SliderSwitch {
                id: executeSlider
                width: 600 * ScreenTools.scaleWidth
                height: parent.height
                fontsize: 30 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                labeltext: qsTr("执行")
                
                onAccept: {
                    executeReturnMission()
                    root.close()
                }
                
                onCancel: {
                    root.close()
                }
            }
        }

        // Top spacing
        Item {
            width: parent.width
            height: 30 * ScreenTools.scaleWidth
        }
    }

    // Helper functions
    function getDescriptionText() {
        switch(selectedId) {
            case 1:
                return qsTr("飞机直线返航到home点上方，然后垂直降落")
            case 2:
                return qsTr("飞机按照航线原路返航到home点上方，然后垂直降落")
            case 3:
                return qsTr("飞机按照航线返航到A点上方，然后垂直降落到A点位置")
            default:
                return ""
        }
    }

    function executeReturnMission() {
        if (sendAll === false) {
            if (selectedId === 1) {
                VkSdkInstance.vehicleManager.activeVehicle.returnMission(NaN, 0) // 直线返航
            }
            if (selectedId === 2) {
                VkSdkInstance.vehicleManager.activeVehicle.returnMission(NaN, 2) // 沿着航线逆序返航
            }
        }
    }

    // Reusable Return Mode Selection Component
    component ReturnModeSelection: Item {
        property int selectedIndex: 1
        signal modeSelected(int index)

        Row {
            width: parent.width * 0.7
            height: parent.height
            spacing: parent.width * 0.7 * 0.2
            anchors.centerIn: parent

            VerticalIconTextButton {
                width: parent.width * 0.4
                height: parent.height
                text: qsTr("直线返航")
                fontSize: buttonFontSize * 0.9
                isSelected: selectedIndex === 1
                iconSource: "/qmlimages/icon/zhixian_b.png"
                selectedIconSource: "/qmlimages/icon/zhixian_a.png"
                selectedBackgroundColor: "transparent"
                unSelectedBackgroundColor: "transparent"
                selectedTextColor: buttonFontColor
                unSelectedTextColor: buttonFontColor
                iconWidth: width
                iconHeight: width
                textHeight: 80 * ScreenTools.scaleWidth
                
                onClicked: {
                    parent.parent.modeSelected(1)
                }
            }

            VerticalIconTextButton {
                width: parent.width * 0.4
                height: parent.height
                text: qsTr("原路返航")
                fontSize: buttonFontSize * 0.9
                isSelected: selectedIndex === 2
                iconSource: "/qmlimages/icon/fanhang_b.png"
                selectedIconSource: "/qmlimages/icon/fanhang_a.png"
                selectedBackgroundColor: "transparent"
                unSelectedBackgroundColor: "transparent"
                selectedTextColor: buttonFontColor
                unSelectedTextColor: buttonFontColor
                iconWidth: width
                iconHeight: width
                textHeight: 80 * ScreenTools.scaleWidth
                
                onClicked: {
                    parent.parent.modeSelected(2)
                }
            }
        }
    }
}
