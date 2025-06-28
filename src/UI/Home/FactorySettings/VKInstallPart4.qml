import QtQuick
import QtQuick.Controls

import VKGroundControl
// import VKGroundControl.Vehicle
// import VKGroundControl.MultiVehicleManager
import Controls
import ScreenTools

import "../Common"
VKInstallBase {
    id: _root

    Row {
        width: parent.width
        height: parent.width
        Item {
            width: parent.width * 3 / 4 - 2
            height: parent.height
            Row {
                width: 530 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 140 * ScreenTools.scaleWidth
                height: 120 * ScreenTools.scaleWidth
                GroupButton {
                    width: parent.width
                    height: 50 * ScreenTools.scaleWidth
                    fontSize: buttonFontsize
                    names: [qsTr("水平校准"), qsTr("磁罗盘校准")]
                    onClicked: function(index) {
                        if (index === 0) {
                            levelCalibrationPopup.open()
                        } else if (index === 1) {
                            compassCalibrationPopup.open()
                        }
                    }
                }
            }
        }

        Item {
            width: 1
            height: parent.height
            Rectangle {
                width: parent.width
                height: parent.height
                color: "gray"
            }
        }

        Item {
            width: parent.width * 1 / 4
            height: parent.height
            Text {
                width: parent.width
                height: 100
                font.pixelSize: buttonFontsize
                color: "red"
                font.bold: false
                wrapMode: Text.Wrap
            }
        }
    }

}
