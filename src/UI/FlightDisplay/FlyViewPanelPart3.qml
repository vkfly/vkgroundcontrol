import QtQuick 2.15
import VkSdkInstance
import ScreenTools
Item {
    id: _root
    width: parent.width
    height: parent.width
    property real angle: 0
    signal clicked
    property var _vehicles: VkSdkInstance.vehicleManager.activeVehicle
    property double headingAngle: _vehicles ? _vehicles.attitude.attitudeYaw : 0
    property var head_to_home: _vehicles ? _vehicles.headToHome : 0

    // property double headingAngle: {
    //     let value = _vehicles?_vehicles.attitude.attitudeYaw : 0
    //     return value;
    // }

    // property double head_to_home: {
    //     let value = _vehicles?_vehicles.headToHome : 0
    //     return value;
    // }

    //property bool isbool_visible : false
    Rectangle {
        id: rect
        width: parent.width
        height: parent.width
        // 初始角度为0
        //radius: parent.width/2
        color: "#00000000"
        Image {
            anchors.fill: parent
            anchors.centerIn: parent
            source: "/qmlimages/icon/roseb.png"
        }
        transform: Rotation {
            origin.x: rect.width / 2
            origin.y: rect.height / 2
            angle: -headingAngle
        }
    }
    Rectangle {
        id: rect2
        width: parent.width
        height: parent.width
        // 初始角度为0
        //radius: parent.width/2
        color: "#00000000"
        Image {
            anchors.fill: parent
            anchors.centerIn: parent
            source: "/qmlimages/icon/rosec2.png"
        }
        transform: Rotation {
            origin.x: rect2.width / 2
            origin.y: rect2.height / 2
            angle: -(-head_to_home + headingAngle)
        }
    }

    Rectangle {
        width: parent.width
        height: parent.width
        color: "#00000000"
        Image {
            anchors.fill: parent
            anchors.centerIn: parent
            source: "/qmlimages/icon/rosec.png"
        }

        MouseArea {
            width: parent.width * 0.5
            height: parent.height * 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                _root.clicked()
            }
        }
    }
    Item {
        width: parent.width / 3 * 2
        height: parent.width / 3 * 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        // Rectangle{
        //     anchors.fill: parent
        //     color:"blue"
        // }
        Item {
            width: parent.width
            height: parent.width

            Text {
                width: parent.width
                height: parent.width / 2
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 35 * ScreenTools.scaleHeight
                font.family: "Arial"
                id: text1
                text: headingAngle.toFixed(
                          1) > 0 ? headingAngle.toFixed(
                                       1) : (headingAngle + 360).toFixed(1)
                font.bold: false
                color: "white"
            }
        }
    }
}
