import QtQuick 2.15
import VkSdkInstance
import ScreenTools
import VKGroundControl

Item {
    id: item
    width: 300
    height: 300

    property var _vehicles: VkSdkInstance.vehicleManager.activeVehicle

    property double throttle: _vehicles ? _vehicles.vfrHud.throttle : 0
    property double rollAngle: _vehicles ? _vehicles.attitude.attitudeRoll : 0
    property double pitchAngle: _vehicles ? _vehicles.attitude.attitudePitch : 0

    Rectangle {
        width: parent.width
        height: parent.width
        color: "#00000000"
        Image {
            anchors.fill: parent
            anchors.centerIn: parent
            source: "/qmlimages/icon/rosee.png"
        }
    }
    Rectangle {
        id: rect
        width: parent.width
        height: parent.width

        color: "#00000000"
        Image {
            anchors.fill: parent
            anchors.centerIn: parent
            source: "/qmlimages/icon/rosef.png"
        }
    }

    Item {
        width: parent.width / 3 * 1.1
        height: parent.width / 3 * 1.1
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            width: parent.width
            height: parent.width
            Text {
                width: parent.width
                height: parent.width / 2
                //anchors.top:parent.top
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 25 * ScreenTools.scaleWidth
                //font.family:"Arial"
                id: text1
                text: qsTr("油门\n%1%").arg(throttle)
                wrapMode: Text.wrapMode
                font.bold: false
                color: throttle > 0 ? mainWindow.titlecolor : "white"
            }
        }
    }
}
