import QtQuick

Item {

    property string imgSource: "/qmlimages/icon/paotouqi.png"
    property string nameTitle: qsTr("总电压")
    property string values: "------"

    width: 200 * sw
    height: 100 * sw

    Row {
        width: 200 * sw
        height: 100 * sw
        Item {
            width: parent.width * 0.4
            height: parent.height
            Image {
                width: parent.width * 0.8
                height: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: imgSource
            }
        }
        Column {
            width: parent.width * 0.6
            height: parent.height * 0.8
            anchors.verticalCenter: parent.verticalCenter
            Item {
                width: parent.width * 0.8
                height: 30 * sw
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    width: parent.width
                    height: parent.height
                    font.pixelSize: 15 * sw
                    verticalAlignment: Text.AlignVCenter
                    text: nameTitle
                }
            }
            Item {
                width: parent.width * 0.8
                height: parent.height - 30 * sw
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    width: parent.width
                    height: parent.height
                    text: values
                    font.pixelSize: 30 * sw
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
