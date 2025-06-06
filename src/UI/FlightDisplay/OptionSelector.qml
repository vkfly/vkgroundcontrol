import QtQuick
import QtQuick.Controls

import Controls
import ScreenTools

Item {
    id: optionSelectorRoot

    // Public properties
    property string title: ""
    property string leftButtonText: ""
    property string rightButtonText: ""
    property int selectedIndex: 0
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5 / 6
    property color backgroundColor: ScreenTools.titleColor

    // Public signals
    signal selectionChanged(int index)

    height: 60 * ScreenTools.scaleWidth

    // Title section
    Column {
        height: 50 * ScreenTools.scaleWidth

        Text {
            height: parent.height
            text: title
            font.pixelSize: buttonFontSize * 5 / 6
            font.bold: false
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }

        Text {
            height: 20 * ScreenTools.scaleWidth
            font.pixelSize: 30 * mainWindow.bili_height
            font.bold: false
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.Top
            color: "white"
        }
    }

    // Button row
    Row {
        width: 270 * ScreenTools.scaleWidth
        height: 60 * ScreenTools.scaleWidth
        anchors.right: parent.right
        spacing: 1 * ScreenTools.scaleWidth

        // Left option button
        TextButton {
            id: leftButton
            width: 135 * ScreenTools.scaleWidth
            height: 50 * ScreenTools.scaleWidth
            anchors.verticalCenter: parent.verticalCenter

            buttonText: leftButtonText
            fontSize: buttonFontSize * 4.5 / 6
            backgroundColor: selectedIndex === 0 ? optionSelectorRoot.backgroundColor : "white"
            textColor: selectedIndex === 0 ? "white" : "black"
            cornerRadius: 5

            onClicked: {
                optionSelectorRoot.selectionChanged(0)
            }
        }

        // Right option button
        TextButton {
            id: rightButton
            width: 135 * ScreenTools.scaleWidth
            height: 50 * ScreenTools.scaleWidth
            anchors.verticalCenter: parent.verticalCenter

            buttonText: rightButtonText
            fontSize: buttonFontSize * 4.5 / 6
            backgroundColor: selectedIndex === 1 ? optionSelectorRoot.backgroundColor : "white"
            textColor: selectedIndex === 1 ? "white" : "black"
            cornerRadius: 5

            onClicked: {
                optionSelectorRoot.selectionChanged(1)
            }
        }
    }
}
