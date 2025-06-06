import QtQuick 2.15
import ScreenTools

Item {
    id: _root
    width: parent.width
    height: parent.height
    property bool isonclicked: false
    // height: 200
    Rectangle {
        width: parent.width
        height: parent.height
        color: "#00000000"
        Image {
            anchors.fill: parent
            source: "/qmlimages/icon/rosea.png"
        }
        FlyViewPanelPart1 {
            anchors.left: parent.left
            width: parent.height
            height: parent.height
        }

        FlyViewPanelPart2 {
            id: part3b
            visible: true
            width: _root.width - 2 * _root.height - 40 * ScreenTools.scaleWidth
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
        }

        FlyViewPanelPart3 {
            id: part2
            anchors.right: parent.right
            width: parent.height
            height: parent.height
        }
    }
}
