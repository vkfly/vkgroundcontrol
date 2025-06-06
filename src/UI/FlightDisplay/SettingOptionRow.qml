import QtQuick
import QtQuick.Controls
import ScreenTools

Item {
    id: settingOptionRoot

    // Public properties
    property string labelText: ""
    property string leftButtonText: ""
    property string rightButtonText: ""
    property int selectedIndex: 0
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5 / 6
    property color backgroundColor: ScreenTools.titleColor
    property color fontColor: "white"
    property real singleButtonWidth: 135 * ScreenTools.scaleWidth

    // Signal for selection changes
    signal selectionChanged(int index)

    height: 60 * ScreenTools.scaleWidth

    // Label section
    Text {
        id: optionLabel
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        text: labelText
        font.pixelSize: buttonFontSize
        font.bold: false
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: fontColor
    }

    // Button row
    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 1 * ScreenTools.scaleWidth

        Button {
            id: leftButton
            width: singleButtonWidth
            height: 50 * ScreenTools.scaleWidth

            background: Rectangle {
                radius: 5
                color: leftButton.pressed ? "gray" : (selectedIndex
                                                      === 0 ? backgroundColor : "white")
            }

            Text {
                anchors.fill: parent
                text: leftButtonText
                font.pixelSize: buttonFontSize * 0.75
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: selectedIndex === 0 ? "white" : "black"
            }

            onClicked: {
                selectedIndex = 0
                selectionChanged(0)
            }
        }

        Button {
            id: rightButton
            width: singleButtonWidth
            height: 50 * ScreenTools.scaleWidth

            background: Rectangle {
                radius: 5
                color: rightButton.pressed ? "gray" : (selectedIndex
                                                       === 1 ? backgroundColor : "white")
            }

            Text {
                anchors.fill: parent
                text: rightButtonText
                font.pixelSize: buttonFontSize * 0.75
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: selectedIndex === 1 ? "white" : "black"
            }

            onClicked: {
                selectedIndex = 1
                selectionChanged(1)
            }
        }
    }
}
