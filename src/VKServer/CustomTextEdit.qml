import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {

    property string rightIcon: ""
    property double iconWidth: 30
    property double iconHeight: 30
    property alias placeholderText: txt.placeholderText
    property alias text: txt.text
    property alias echoMode: txt.echoMode
    property bool isValid: false
    property var reg: /+/
    property alias fontSize: txt.font.pixelSize

    function isShowRightIcon() {
        return rightIcon && rightIcon !== ""
    }

    signal rightIconClick

    id: rec
    color: "white"
    radius: 8
    height: 40
    TextField {
        id: txt
        text: ""
        placeholderText: ""
        anchors.left: parent.left
        anchors.right: isShowRightIcon() ? icon.left : parent.right
        anchors.rightMargin: 16
        echoMode: TextInput.Normal
        implicitHeight: parent.height
        height: parent.height
        background: Item {}
        onTextChanged: {
            isValid = text.match(reg)
        }
    }

    Image {
        id: icon
        visible: isShowRightIcon()
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        height: iconHeight
        width: iconWidth
        source: rightIcon
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                rightIconClick()
            }
        }
    }
}
