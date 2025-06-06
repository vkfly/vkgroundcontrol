

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

import VkSdkInstance 1.0

Column {
    spacing: 10 * sw

    Row {
        Label {
            width: 120 * sw
            height: 45 * sw
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 45 * sh
            color: "white"
            text: qsTr("端口")
        }
        ComboBox {
            id: commPortCombo
            width: 400 * sw
            height: 45 * sw
            font.pixelSize: 45 * sh
            enabled: VkSdkInstance.availableSerialPorts().length > 0

            onActivated: {
                if (index != -1) {
                    var list = VkSdkInstance.availableSerialPorts()
                    if (index >= list.length) {
                        // This item was adding at the end, must use added text as name
                        subEditConfig.portName = commPortCombo.textAt(index)
                    } else {
                        subEditConfig.portName = list[index]
                    }
                }
            }

            Component.onCompleted: {
                var index = -1
                var serialPorts = []
                var list = VkSdkInstance.availableSerialPorts()
                if (list.length !== 0) {
                    for (var i = 0; i < list.length; i++) {
                        serialPorts.push(list[i])
                    }
                    if (subEditConfig.portName === "" && list.length > 0) {
                        subEditConfig.portName = list[0]
                    }
                    index = serialPorts.indexOf(subEditConfig.portName)
                    if (index === -1) {
                        serialPorts.push(subEditConfig.portName)
                        index = serialPorts.indexOf(subEditConfig.portName)
                    }
                }
                if (serialPorts.length === 0) {
                    serialPorts = [qsTr("无有效端口")]
                    index = 0
                }
                commPortCombo.model = serialPorts
                commPortCombo.currentIndex = index
            }
        }
    }
    Row {
        Label {
            width: 120 * sw
            height: 45 * sw
            //anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 45 * sh
            color: "white"
            text: qsTr("波特率")
        }
        ComboBox {
            width: 400 * sw
            height: 45 * sw
            font.pixelSize: 45 * sh
            id: baudCombo
            model: [57600, 115200, 230400, 460800]
            onActivated: {
                if (index != -1) {
                    subEditConfig.baudrate = baudCombo.currentValue
                }
            }

            Component.onCompleted: {
                var baud = 57600
                if (subEditConfig != null) {
                    baud = subEditConfig.baudrate
                }
                var index = baudCombo.find(baud)
                if (index === -1) {
                    console.warn(qsTr("Baud rate name not in combo box"), baud)
                } else {
                    baudCombo.currentIndex = index
                }
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
            text: qsTr("奇偶校验")
        }
        ComboBox {
            width: 400 * sw
            height: 45 * sw
            font.pixelSize: 45 * sh
            model: [qsTr("None"), qsTr("Even"), qsTr("Odd")]
            onActivated: {
                // Hard coded values from qserialport.h
                switch (index) {
                case 0:
                    subEditConfig.parity = 0
                    break
                case 1:
                    subEditConfig.parity = 1
                    break
                case 2:
                    subEditConfig.parity = 2
                    break
                }
            }

            Component.onCompleted: {
                switch (subEditConfig.parity) {
                case 0:
                    currentIndex = 0
                    break
                case 2:
                    currentIndex = 1
                    break
                case 3:
                    currentIndex = 2
                    break
                default:
                    console.warn("Unknown parity", subEditConfig.parity)
                    break
                }
            }
        }
    }
    Row {
        Label {
            width: 120 * sw
            height: 45 * sw
            //anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 45 * sh
            color: "white"
            text: qsTr("数据位")
        }
        ComboBox {
            width: 400 * sw
            height: 45 * sw
            font.pixelSize: 45 * sh
            model: [6, 7, 8]
            currentIndex: subEditConfig.dataBits - 6
            onActivated: subEditConfig.dataBits = index + 6
        }
    }
    Row {
        Label {
            width: 120 * sw
            height: 45 * sw
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 45 * sh
            color: "white"
            text: qsTr("停止位")
        }
        ComboBox {
            width: 400 * sw
            height: 45 * sw
            font.pixelSize: 45 * sh
            model: [1, 2]
            currentIndex: subEditConfig.stopBits - 1
            onActivated: subEditConfig.stopBits = index + 1
        }
    }
}
