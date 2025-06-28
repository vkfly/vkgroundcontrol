import QtQuick

Item {
    property var bmsmsg: new Array(50)
    property bool isbackground: false
    id: _root
    height: 65 * sw
    width: 160 * sw
    Rectangle {
        anchors.fill: parent
        color: isbackground ? "#80000000" : "#00000000"
    }
    Row {
        //id:bms0
        width: 160 * sw
        height: 65 * sw
        spacing: 10 * sw
        // id:row1
        Item {
            width: 40 * sw
            height: 50 * sw
            anchors.centerIn: parent.Center
            anchors.verticalCenter: parent.verticalCenter
            Image {
                width: 40 * sw
                height: 50 * sw

                //anchors.verticalCenter: parent.Center

                //anchors.verticalCenter: parent.Center
                //mipmap:true

                //anchors.verticalCenter:parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                source: "/qmlimages/icon/battrey.png"
            }
        }

        Column {
            width: 100 * sw
            height: 50 * sw
            anchors.verticalCenter: parent.verticalCenter
            //height: 60*bili_width
            spacing: 0
            Text {
                width: 100 * sw
                height: 25 * sw
                //anchors.verticalCenter: parent.verticalCenter // 垂直居中
                text: (parseFloat(bmsmsg[36]) * 0.001).toFixed(1) + "V"
                //horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#FFFFFF"
                font.pixelSize: 40 * sh
                font.bold: false
            }
            Text {
                width: 100 * sw
                height: 25 * sw
                //visible:_activeVehicle? _activeVehicle.prc_vol!==-1:false
                //anchors.verticalCenter: parent.verticalCenter // 垂直居中
                text: bmsmsg[31] + "% " + (parseFloat(
                                               bmsmsg[33]) * 0.01).toFixed(
                          1) + "A"
                //   text: _activeVehicle?(_activeVehicle.prc_vol+"%"):"N/A"
                // horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#FFFFFF"
                font.pixelSize: 40 * sh
                //font.bold: false
            }
        }
    }
}
