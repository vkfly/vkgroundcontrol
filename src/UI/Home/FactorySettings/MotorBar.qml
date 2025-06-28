import QtQuick
import QtQuick.Controls

import VKGroundControl.Palette
import VKGroundControl 1.0
import VkSdkInstance 1.0
import ScreenTools

// import VKGroundControl.MultiVehicleManager
Item {

  id: motorBar
  width: parent.width
  height: parent.height

  property string labelName: qsTr("M1")
  property int barId: 1
  property string motorValue: "0"
  property real currentEsc: 0
  property real voltageEsc: 0
  property real rpmEsc: 0
  property real temperatureEsc: 0
  property real statusEsc: 0
  property real fontSize: 30 * ScreenTools.scaleWidth * 5 / 6
  property var mainColor: qgcPal.titleColor

  //property var _activeVehicle: VKGroundControl.multiVehicleManager.activeVehicle1 || null
  property var _activeVehicle: VkSdkInstance.vehicleManager.activeVehicle
  signal sendClickId

  VKPalette {
    id: qgcPal
  }

  Row {
    width: parent.width
    height: parent.height
    spacing: 30 * ScreenTools.scaleWidth

    Item {
      width: parent.height
      height: parent.height * 0.65
      anchors.verticalCenter: parent.verticalCenter
      Item {
        width: parent.height
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        Button {
          width: parent.height
          height: parent.height
          onClicked: {
            sendClickId()
          }
          background: Rectangle {
            color: "#00000000"
          }
          Rectangle {
            anchors.fill: parent
            radius: parent.width / 2
            color: mainColor
            MouseArea {}
          }
        }
      }
      Text {
        width: parent.width
        height: parent.height
        text: labelName
        font.pixelSize: fontSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "white"
      }
    }
    Column {
      width: motorBar.width - 200 * ScreenTools.scaleWidth - 200 * ScreenTools.scaleWidth - 40 * ScreenTools.scaleWidth
      anchors.verticalCenter: parent.verticalCenter
      // height: parent.height*0.15
      ProgressBar {
        id: control
        width: parent.width
        height: parent.height * 0.5
        value: ((motorValue - 1000) / 1000.0).toFixed(1)
        background: Rectangle {
          //背景项
          implicitWidth: control.width
          implicitHeight: control.height
          color: "lightgray"
          radius: 6 * ScreenTools.scaleWidth //圆滑度
        }
        contentItem: Item {
          //内容项
          Rectangle {
            width: ((motorValue - 1000) / 1000.0) * control.width
            height: control.height
            radius: 6 * ScreenTools.scaleWidth //圆滑度
            color: control.value >= 0.8 ? "red" : mainColor
          }
        }
      }
      Row {
        width: parent.width
        height: 10 * ScreenTools.scaleWidth
        Text {
          visible: voltageEsc !== 0 && voltageEsc !== 0.0
          width: 80 * ScreenTools.scaleWidth
          height: 30 * ScreenTools.scaleWidth
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          font.pixelSize: 40 * ScreenTools.scaleHeight
          color: "#0bff05"
          text: voltageEsc.toFixed(0) + "V"
        }
        Text {
          visible: currentEsc !== 0 && currentEsc !== 0.0
          width: 80 * ScreenTools.scaleWidth
          height: 30 * ScreenTools.scaleWidth
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          font.pixelSize: 40 * ScreenTools.scaleHeight
          color: "#0bff05"
          text: currentEsc.toFixed(0) + "A"
        }
        Text {
          visible: rpmEsc !== 0 && rpmEsc !== 0.0
          width: 120 * ScreenTools.scaleWidth
          height: 30 * ScreenTools.scaleWidth
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          font.pixelSize: 40 * ScreenTools.scaleHeight
          color: "#0bff05"
          text: rpmEsc + "rpm"
        }

        Text {
          visible: temperatureEsc !== 0 && temperatureEsc !== 0.0
          width: 120 * ScreenTools.scaleWidth
          height: 30 * ScreenTools.scaleWidth
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          font.pixelSize: 40 * ScreenTools.scaleHeight
          color: "#0bff05"
          text: temperatureEsc + "℃"
        }

        Text {
          visible: statusEsc !== 0 && statusEsc !== 0.0
          width: 120 * ScreenTools.scaleWidth
          height: 30 * ScreenTools.scaleWidth
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          font.pixelSize: 40 * ScreenTools.scaleHeight
          color: "#0bff05"
          text: statusEsc
        }
      }
    }
    Text {
      width: 80 * ScreenTools.scaleWidth
      height: parent.height
      //font.pixelSize: 40*ScreenTools.scaleHeight
      text: motorValue
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      color: "gray"
      font.pixelSize: fontSize
      // color: "white"
    }
    Button {
      id: bt_check
      width: 160 * ScreenTools.scaleWidth
      height: parent.height * 0.60
      anchors.verticalCenter: parent.verticalCenter
      background: Rectangle {
        anchors.fill: parent
        color: bt_check.pressed ? "lightgray" : mainColor
        radius: 10

        Text {
          anchors.fill: parent
          font.pixelSize: fontSize
          text: qsTr("检测")
          color: bt_check.pressed ? "black" : "white"
          font.bold: false
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
        }
      }
      onClicked: {
        _activeVehicle.motorTest(barId)
      }
    }
  }
}
