import QtQuick 2.15
import VKGroundControl.Palette

Item {
    property real fontSize: 30 * sw * 5/6
    property string values: "---V"
    property var mainColor: qgcPal.titleColor

    width: 80 * sw
    height: 200 * sw

    VKPalette {
        id: qgcPal
    }

    Column {
        width: parent.width
        height: parent.height
        
        Item {
            width: parent.width * 0.7
            height: parent.height - 40 * sw
            anchors.horizontalCenter: parent.horizontalCenter
            
            Rectangle {
                width: parent.width
                height: 40 * sw
                color: mainColor
                radius: 15 * sw
                anchors.bottom: parent.bottom
            }
            
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                radius: 15 * sw
                border.width: 4
                border.color: "black"
            }
        }
        
        Text {
            width: parent.width
            height: 40 * sw
            text: values
            font.pixelSize: fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
