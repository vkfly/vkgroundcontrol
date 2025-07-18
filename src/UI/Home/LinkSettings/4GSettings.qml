

/****************************************************************************
 *
 * (c) 2009-2020 VKGroundControl PROJECT <http://www.VKGroundControl.org>
 *
 * VKGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VKGroundControl
import Controls
import ScreenTools
import VKGroundControl.Palette

Column {
    spacing: 10 * sw

    Row {
        Label {
            width: 120 * sw
            height: 45 * sw
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 45 * sh
            color: "white"
            text: qsTr("IP地址")
        }
        TextField {
            id: hostField
            width: 400 * sw
            height: 45 * sw
            font.pixelSize: 45 * sh
            text: subEditConfig.ip
            background: Rectangle {
                color: "white"
                radius: 4 // 可设置圆角
            }
            onTextChanged: {
                subEditConfig.ip = hostField.text
            }
        }
    }
    Row {

        Label {
            width: 120 * sw
            height: 45 * sw
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 45 * sh
            color: "white"
            text: qsTr("端口")
        }

        TextField {
            id: portField
            width: 400 * sw
            height: 45 * sw
            font.pixelSize: 45 * sh
            text: subEditConfig.port
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            background: Rectangle {
                color: "white"
                radius: 4 // 可设置圆角
            }
            onTextChanged: {
                subEditConfig.port = portField.text
            }
        }
    }

    Row {

        Label {
            width: 120 * sw
            height: 45 * sw
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 45 * sh
            color: "white"
            text: qsTr("许可证")
        }

        TextField {
            id: licenseField
            width: 400 * sw
            height: 45 * sw
            font.pixelSize: 45 * sh
            text: subEditConfig.license
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            background: Rectangle {
                color: "white"
                radius: 4 // 可设置圆角
            }
            onTextChanged: {
                subEditConfig.license = licenseField.text
            }
        }
    }
}
