import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window
import QtQml.Models

import VKGroundControl
import ScreenTools

Item {
    id: mathKeyboard
    
    width: 270
    height: 300
    
    // Properties with camelCase naming
    property string keyboardNumber: "0"
    property bool isValid: true
    
    // Signals
    signal numberClicked()
    
    // Constants for better maintainability
    readonly property real baseWidth: 270
    readonly property real baseHeight: 300
    readonly property real scaleFactor: ScreenTools.scaleWidth * 1.3
    readonly property real buttonSize: 60 * scaleFactor
    readonly property real buttonSpacing: 5 * scaleFactor
    readonly property real fontSize: 25 * scaleFactor
    readonly property real leftMargin: 7 * scaleFactor
    
    Column {

        width: mathKeyboard.baseWidth * mathKeyboard.scaleFactor
        height: mathKeyboard.baseHeight * mathKeyboard.scaleFactor
        spacing: mathKeyboard.buttonSpacing
        
        // First row: 1, 2, 3, CLE
        Row {
            width: parent.width
            height: mathKeyboard.buttonSize
            spacing: mathKeyboard.buttonSpacing
            anchors.left: parent.left
            anchors.leftMargin: mathKeyboard.leftMargin
            
            TextButton {
                buttonText: "1"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "2"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "3"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "CLE"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
        }
        
        // Second row: 4, 5, 6, DEL
        Row {
            width: parent.width
            height: mathKeyboard.buttonSize
            spacing: mathKeyboard.buttonSpacing
            anchors.left: parent.left
            anchors.leftMargin: mathKeyboard.leftMargin
            
            TextButton {
                buttonText: "4"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "5"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "6"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "DEL"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
        }
        
        // Third row: 7, 8, 9, Ext
        Row {
            width: parent.width
            height: mathKeyboard.buttonSize
            spacing: mathKeyboard.buttonSpacing
            anchors.left: parent.left
            anchors.leftMargin: mathKeyboard.leftMargin
            
            TextButton {
                buttonText: "7"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "8"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "9"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "Ext"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
        }
        
        // Fourth row: -, 0, ., OK
        Row {
            width: parent.width
            height: mathKeyboard.buttonSize
            spacing: mathKeyboard.buttonSpacing
            anchors.left: parent.left
            anchors.leftMargin: mathKeyboard.leftMargin
            
            TextButton {
                buttonText: "-"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "0"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "."
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
            
            TextButton {
                buttonText: "OK"
                width: mathKeyboard.buttonSize
                height: mathKeyboard.buttonSize
                fontSize: mathKeyboard.fontSize
                enabled: mathKeyboard.isValid
                onClicked: {
                    mathKeyboard.keyboardNumber = buttonText
                    mathKeyboard.numberClicked()
                }
            }
        }
    }
}


