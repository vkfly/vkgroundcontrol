import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs

import VKGroundControl
import VKGroundControl.Palette
import Controls
import ScreenTools
import Home
import VkSdkInstance

CustomPopup {
    id: progressDialog

    property var activeVehicle: VkSdkInstance.vehicleManager.activeVehicle
    property real progress: activeVehicle.progress
    property real _progress: 0
    contentHeight: contentColumn.height
    contentWidth: 600 * ScreenTools.scaleWidth
    modal: true
    focus: true

    onProgressChanged: {
        _progress = progress
        if (progress >= 1) {
            close()
        }
    }

    onVisibleChanged: {
        if (visible) {
            _progress = 0
        }
    }

    Column {
        id: contentColumn
        width: parent.width - 72 * ScreenTools.scaleWidth
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0

        Item {
            width: 1
            height: 18 * ScreenTools.scaleWidth
        }

        VTitle {
            vt_title: qsTr("日志下载")
            font.pixelSize: 25 * ScreenTools.scaleWidth
            color: "black"
        }

        Item {
            width: 1
            height: 72 * ScreenTools.scaleWidth
        }

        ProgressBar {
            width: parent.width
            value: _progress
        }

        Item {
            width: 1
            height: 72 * ScreenTools.scaleWidth
        }

        TextButton {
            height: 50 * ScreenTools.scaleWidth
            width: 100 * ScreenTools.scaleWidth
            anchors.horizontalCenter: parent.horizontalCenter
            buttonText: "取消"
            backgroundColor: ScreenTools.titleColor
            textColor: "white"
            onClicked: {
                activeVehicle.cancelCurrentCommand()
                close()
            }
        }

        Item {
            width: 1
            height: 36 * ScreenTools.scaleWidth
        }
    }
}
