import QtQuick 2.15
import ScreenTools

Item {
    width: parent.width
    height: parent.height
    property string text_name1: ""
    property string text_name2: ""
    property string color_name: "white"
    Column {
        width: parent.width
        height: parent.height

        Text {
            width: parent.width
            height: parent.height * 0.4
            text: text_name1
            color: color_name
            font.pixelSize: 20 * ScreenTools.scaleWidth
            font.bold: false
            verticalAlignment: Text.AlignBottom
        }

        Text {
            width: parent.width
            height: parent.height * 0.6
            text: text_name2
            color: color_name
            font.pixelSize: 35 * ScreenTools.scaleWidth
            font.bold: false
            verticalAlignment: Text.AlignTop
        }
    }
}
