import QtQuick

Item {
    id: _root
    width: parent.width
    height: parent.width * 0.5

    property int fontSize: 30 * sw

    //文本高度
    property int textHeight: 60 * sw

    Row {

        width: parent.width
        height: parent.width * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Item {

            width: parent.width * 0.1
            height: parent.width * 0.1
        }
        Item {
            width: parent.width * 0.35
            height: parent.width * 0.35
            anchors.verticalCenter: parent.verticalCenter
            Column {
                width: parent.width
                height: parent.height
                Item {
                    width: parent.height - 60 * sw
                    height: parent.height - 60 * sw
                    CanvasDrawing {
                        width: parent.width
                        height: parent.height
                        id: canvasDrawing
                        showLeft: true
                        showJapan: _rcSettings.value === 0
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoterXValue: activeVehicle ? _rcChannels.rcChannelsRaw[3] : ""
                        remoterYValue: activeVehicle ? (_rcSettings.value === 0 ? 3000 - _rcChannels.rcChannelsRaw[2] : _rcChannels.rcChannelsRaw[1]) : ""
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: "L"
                    width: parent.width
                    height: textHeight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: fontSize
                    font.bold: false
                    color: "gray"
                }
            }
        }

        Item {

            width: parent.width * 0.1
            height: parent.width * 0.1
        }
        Item {

            width: parent.width * 0.35
            height: parent.width * 0.35
            anchors.verticalCenter: parent.verticalCenter
            Column {
                width: parent.height
                height: parent.height
                Item {
                    width: parent.height - 60 * sw
                    height: parent.height - 60 * sw
                    CanvasDrawing {
                        width: parent.width
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        remoterXValue: activeVehicle ?_rcChannels.rcChannelsRaw[0] : ""
                        remoterYValue: activeVehicle ? (_rcSettings.value === 0 ? _rcChannels.rcChannelsRaw[1] : 3000 - _rcChannels.rcChannelsRaw[2]) : ""
                        showLeft: false
                        showJapan: _rcSettings.value === 0
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: "R"
                    width: parent.width
                    height: textHeight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: fontSize
                    font.bold: false
                    color: "gray"
                }
            }
        }
        Item {
            width: parent.width * 0.1
            height: parent.width * 0.1
        }
    }
}
