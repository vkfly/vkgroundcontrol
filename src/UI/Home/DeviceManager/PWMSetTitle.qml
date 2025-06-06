import QtQuick
import QtQuick.Controls

import VKGroundControl
import VKGroundControl.Palette
import VKGroundControl.Controllers
import ScreenTools

// import VKGroundControl.Vehicle
// import VKGroundControl.MultiVehicleManager
Item {
    // UI Properties
    property var columnTitles: [
        qsTr("通道名称"),
        qsTr("通道名称"),
        qsTr("通道名称"),
        qsTr("通道名称"),
        qsTr("通道名称")
    ]
    property color mainColor: qgcPal.titleColor
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5/6
    
    // Vehicle Properties
    property var parameterManager: VKGroundControl.multiVehicleManager.activeVehicle1 ? VKGroundControl.multiVehicleManager.activeVehicle1.parameterManager : ""
    property string paramName: parameterManager ? parameterManager.paramName : ""
    property string paramValue: parameterManager ? parameterManager.paramValue : ""
    
    // Value Properties
    property int valueType: 3
    property real barValue: 0
    property real minValue: 0
    property real maxValue: 100
    property int toFix: 0
    property double curValue: 0
    property double addValue: 1
    property string unit: ""
    property string param: ""
    property var oldText: 0
    // name: value
    width: parent.width
    height: parent.height
    id: root

    VKPalette {
        id: qgcPal
    }

    Item {
        width: parent.width
        height: parent.height

        Row {
            width: parent.width * 0.95
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.horizontalCenter: parent.horizontalCenter
            spacing: parent.width / 6 * 0.25
            Text {
                width: parent.width / 8
                height: 60 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                text: columnTitles[0]
                font.pixelSize: buttonFontSize
                font.bold: false
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                width: parent.width / 8
                height: 60 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                text: columnTitles[1]
                font.pixelSize: buttonFontSize
                font.bold: false
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                width: parent.width / 8
                height: 60 * ScreenTools.scaleWidth
                text: columnTitles[2]
                anchors.verticalCenter: parent.verticalCenter
                // text:titil_name
                font.pixelSize: buttonFontSize
                font.bold: false
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                width: parent.width * 0.2
                height: 60 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                text: columnTitles[3]
                font.pixelSize: buttonFontSize
                font.bold: false
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                width: parent.width * 0.2
                height: 60 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                text: columnTitles[4]
                font.pixelSize: buttonFontSize
                font.bold: false
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
