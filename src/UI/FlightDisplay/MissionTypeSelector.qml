import QtQuick
import QtQuick.Controls
import VKGroundControl
import ScreenTools
import Controls
import Qt5Compat.GraphicalEffects

Popup {
    id: missionPlannerPopup

    width: popupWidth
    height: mainColumn.height
    modal: true
    focus: true

    // Text and message properties
    property string textMessage: ""
    property string aircraftTypeText: ""
    property string imageSource: ""

    // Styling properties
    property real buttonFontSize: 30 * ScreenTools.scaleWidth
    property color backgroundColor: ScreenTools.titleColor
    property color buttonFontColor: "white"

    // Layout properties
    property int popupWidth: 600 * ScreenTools.scaleWidth
    property int popupHeight: 720 * ScreenTools.scaleWidth
    property int textAlignment: 0 // 0: center, 1: left
    property int leftDistance: 15 * ScreenTools.scaleWidth  // distance from left edge
    property int textFontSize: 25 * ScreenTools.scaleWidth // text font size
    property int buttonFontSizeSmall: 14 * ScreenTools.scaleWidth // button font size

    // Mission properties
    property int waypointId: 0
    property real waypointLongitude: 116
    property real waypointLatitude: 40
    property real waypointAltitude: 100
    property real waypointSpeed: 5
    property int dropType: 0
    property real dropHeight: 0

    // Drop type flags (could be simplified to use selectedMissionType)
    property bool dropType1: true
    property bool dropType2: false
    property bool dropType3: false
    property bool dropType4: false
    property bool dropType5: false
    property bool dropType6: false
    property bool dropType7: false
    property bool dropType8: false

    // Current selection
    property int selectedMissionType: 1 // 1: single line, 2: strip line, 3: area

    // Signals
    signal missionTypeSelected(int missionType)

    // Drop type model (currently unused but kept for compatibility)
    property ListModel dropTypeModel: ListModel {
        ListElement {
            text: qsTr("不抛投")
        }
        ListElement {
            text: qsTr("高空抛投")
        }
        ListElement {
            text: qsTr("降落抛投")
        }
        ListElement {
            text: qsTr("近地抛投")
        }
    }

    // Background click handler
    MouseArea {
        anchors.fill: parent
        onClicked: {

        }
    }

    // Main content
    Rectangle {
        // anchors.fill: parent
        width: parent.width
        height: mainColumn.height
        radius: 15
        color: "#80000000"
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: mainColumn.width
                height: mainColumn.height
                radius: 15
            }
        }

        Column {
            id: mainColumn
            width: parent.width
            // Top spacing
            Item {
                width: parent.width
                height: 30 * ScreenTools.scaleWidth
            }

            // Mission type selection area
            Item {
                width: parent.width
                height: parent.width * 0.35

                Row {
                    width: parent.width
                    height: parent.width * 0.2 + 60 * ScreenTools.scaleWidth
                    spacing: parent.width / 10
                    anchors.verticalCenter: parent.verticalCenter

                    // Left spacing
                    Item {
                        width: 1
                        height: parent.height
                    }

                    // Single line mission button
                    VerticalIconTextButton {
                        id: singleLineMission
                        width: parent.width / 5
                        height: parent.height
                        iconWidth: parent.width / 5
                        iconHeight: parent.width / 5
                        textHeight: 80 * ScreenTools.scaleWidth
                        textWidth: parent.width / 5
                        text: qsTr("单条航线")
                        iconSource: "/qmlimages/icon/tiao_a.png"
                        selectedIconSource: "/qmlimages/icon/tiao_b.png"
                        isSelected: selectedMissionType === 1
                        fontSize: buttonFontSize * 0.9
                        selectedTextColor: buttonFontColor
                        unSelectedTextColor: buttonFontColor
                        selectedBackgroundColor: "#00000000"
                        unSelectedBackgroundColor: "#00000000"
                        onClicked: {
                            selectedMissionType = 1
                        }
                    }

                    // Strip line mission button
                    VerticalIconTextButton {
                        id: stripLineMission
                        width: parent.width / 5
                        height: parent.height
                        iconWidth: parent.width / 5
                        iconHeight: parent.width / 5
                        textHeight: 80 * ScreenTools.scaleWidth
                        textWidth: parent.width / 5
                        text: qsTr("带状航线")
                        iconSource: "/qmlimages/icon/dai_a.png"
                        selectedIconSource: "/qmlimages/icon/dai_b.png"
                        isSelected: selectedMissionType === 2
                        fontSize: buttonFontSize * 0.9
                        selectedTextColor: buttonFontColor
                        unSelectedTextColor: buttonFontColor
                        selectedBackgroundColor: "#00000000"
                        unSelectedBackgroundColor: "#00000000"
                        onClicked: {
                            selectedMissionType = 2
                        }
                    }

                    // Area mission button
                    VerticalIconTextButton {
                        id: areaMission
                        width: parent.width / 5
                        height: parent.height
                        iconWidth: parent.width / 5
                        iconHeight: parent.width / 5
                        textHeight: 80 * ScreenTools.scaleWidth
                        textWidth: parent.width / 5
                        text: qsTr("块状航线")
                        iconSource: "/qmlimages/icon/kuai_a.png"
                        selectedIconSource: "/qmlimages/icon/kuai_b.png"
                        isSelected: selectedMissionType === 3
                        fontSize: buttonFontSize * 0.9
                        selectedTextColor: buttonFontColor
                        unSelectedTextColor: buttonFontColor
                        selectedBackgroundColor: "#00000000"
                        unSelectedBackgroundColor: "#00000000"
                        onClicked: {
                            selectedMissionType = 3
                        }
                    }
                }
            }

            // Bottom spacing
            Item {
                width: parent.width
                height: 30 * ScreenTools.scaleWidth
            }

            // Action buttons row
            Item {
                width: parent.width
                height: 60 * ScreenTools.scaleWidth
                // 按钮内容
                Row {
                    id: buttonRow
                    anchors.fill: parent

                    // Cancel button
                    TextButton {
                        id: cancelButton
                        width: parent.width / 2
                        height: parent.height
                        layer.enabled: true
                        layer.smooth: true
                        buttonText: qsTr("取消")
                        backgroundColor: "gray"
                        textColor: buttonFontColor
                        fontSize: buttonFontSize
                        cornerRadius: 0
                        borderWidth: 0

                        onClicked: missionPlannerPopup.close()
                    }

                    // Confirm button
                    TextButton {
                        id: confirmButton
                        width: parent.width / 2
                        height: parent.height
                        layer.enabled: true
                        layer.smooth: true
                        buttonText: qsTr("确认")
                        backgroundColor: missionPlannerPopup.backgroundColor
                        textColor: buttonFontColor
                        fontSize: buttonFontSize
                        cornerRadius: 0
                        borderWidth: 0

                        onClicked: {
                            missionTypeSelected(selectedMissionType)
                            missionPlannerPopup.close()
                        }
                    }
                }
            }
        }
    }

    // Transparent background
    background: Rectangle {
        anchors.fill: parent
        radius: 15
        color: "#00000000"
    }
}
