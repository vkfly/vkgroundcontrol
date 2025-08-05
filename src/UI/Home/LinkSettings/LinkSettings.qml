

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
import QtQuick.Dialogs
import QtQuick.Layouts

import VKGroundControl
import Controls
import ScreenTools
import VKGroundControl.Palette

import VkSdkInstance 1.0

Flickable {
    clip: true
    width: parent.width
    height: parent.height

    property var _currentSelection: null
    property int _firstColumnWidth: ScreenTools.defaultFontPixelWidth * 12
    property int _secondColumnWidth: ScreenTools.defaultFontPixelWidth * 30
    property int _rowSpacing: ScreenTools.defaultFontPixelHeight / 2
    property int _colSpacing: ScreenTools.defaultFontPixelWidth / 2

    property bool isdelete: true

    QtObject {
        id: config
        property string settingsURL: "SerialSettings.qml"
        property int linkType: 0
        property string ip: ""
        property string port: ""
        property string license: ""

        property string portName: ""
        property string baudrate: "115200"
        property int parity: 0
        property int dataBits: 8
        property int stopBits: 1
    }

    Component.onCompleted: {
        if(ScreenTools.isAndroid) { //android 自动连接
            config.linkType = 2
            config.ip = "127.0.0.1"
            config.port = "9876"
            connect()
            connectRc()
            return
        }
        openCommSettings(null)
    }

    function openCommSettings(originalLinkConfig) {
        loadConfig()
        settingsLoader.editingConfig = config
        settingsLoader.sourceComponent = commSettings
    }

    function loadConfig() {
        var conf = VkSdkInstance.loadLinkConfig()
        var name = conf[0]
        if (name === "tcp") {
            config.linkType = 1
            config.ip = conf[1]
            config.port = conf[2]
        } else if (name === "udp") {
            config.linkType = 2
            config.ip = conf[1]
            config.port = conf[2]
        } else if (name === "serial") {
            config.linkType = 0
            config.portName = conf[1]
            config.baudrate = conf[2]
            config.dataBits = parseInt(conf[3])
            config.parity = conf[4] === "N" ? 0 : conf[4] === "E" ? 1 : 2
            config.stopBits = parseInt(conf[5])
        } else if (name === "4G") {
            config.linkType = 3
            config.ip = conf[1]
            config.port = conf[2]
            config.license = conf[3]
        }
        loadConfigPageWithLinkType(config.linkType)
    }

    function loadConfigPageWithLinkType(linkType) {
        switch (linkType) {
        case 0:
            config.settingsURL = "SerialSettings.qml"
            break
        case 1:
            config.settingsURL = "TcpSettings.qml"
            break
        case 2:
            config.settingsURL = "UdpSettings.qml"
            break
        case 3:
            config.settingsURL = "4GSettings.qml"
            break
        }
    }

    function changeConfigPage(index) {
        config.linkType = index
        loadConfigPageWithLinkType(config.linkType)
    }

    function saveSettings() {
        VkSdkInstance.saveLinkConfig(getSaveSettingsListStr())
    }

    function getSaveSettingsListStr() {
        var settingListStr = []
        var configName = getConfigName()
        if (config.linkType === 1 || config.linkType === 2) {
            settingListStr = [configName, config.ip, config.port]
        } else if (config.linkType === 0) {
            settingListStr
                    = [configName, config.portName, config.baudrate, config.dataBits, config.parity
                       === 0 ? "N" : config.parity === 1 ? "E" : "O", config.stopBits]
        } else if (config.linkType === 3) {
            settingListStr = [configName, config.ip, config.port, config.license]
        }
        return settingListStr
    }
    function getConfigName() {
        var configName = ""
        switch (config.linkType) {
        case 0:
            configName = "serial"
            break
        case 1:
            configName = "tcp"
            break
        case 2:
            configName = "udp"
            break
        case 3:
            configName = "4g"
            break;
        }
        return configName
    }
    function connect() {
        VkSdkInstance.startLink(getConnectStr())
    }

    function connectRc() {
        VkSdkInstance.startRcLink(`udp://127.0.0.1:9877`)
    }

    function getConnectStr() {
        var settingStr = ""
        var configName = getConfigName()
        if (config.linkType === 1 || config.linkType === 2) {
            settingStr = `${configName}://${config.ip}:${config.port}`
        } else if (config.linkType === 0) {
            settingStr = `${configName}://${config.portName}:${config.baudrate}:${config.dataBits}${config.parity
                    === 0 ? "N" : config.parity === 1 ? "E" : "O"}${config.stopBits}`
        } else if(config.linkType === 3) {
            settingStr = `${configName}://${config.ip}:${config.port}?${config.license}`
        }
        return settingStr
    }

    function disconnect() {
        VkSdkInstance.stopLink()
    }

    Component.onDestruction: {

    }

    RowLayout {
        id: buttonRow
        spacing: 16 * sw
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8 * sw
        width: parent.width

        Button {
            text: qsTr("保存")
            Layout.fillWidth: true
            Layout.fillHeight: true
            topPadding: 8 * sw
            bottomPadding: 8 * sw
            font.pixelSize: 60 * sh
            onClicked: {
                saveSettings()
            }
        }
        Button {
            text: qsTr("连接")
            Layout.fillWidth: true
            Layout.fillHeight: true
            topPadding: 8 * sw
            bottomPadding: 8 * sw
            font.pixelSize: 60 * sh
            enabled: true
            onClicked: {
                connect()
            }
        }
        Button {
            text: qsTr("断开")
            Layout.fillWidth: true
            Layout.fillHeight: true
            topPadding: 8 * sw
            bottomPadding: 8 * sw
            font.pixelSize: 60 * sh
            enabled: true
            onClicked: {
                disconnect()
            }
        }
    }

    Loader {
        id: settingsLoader
        width: parent.width
        height: parent.height - buttonRow.height - 8 * sw
        visible: sourceComponent ? true : false
        property var originalLinkConfig: null
        property var editingConfig: null
    }

    //---------------------------------------------
    Component {
        id: commSettings
        Rectangle {
            id: settingsRect
            width: 600 * sw
            anchors.fill: parent
            property real _panelWidth: width * 0.8
            color: "black"
            VKFlickable {
                width: 640 * sw
                id: settingsFlick
                clip: true
                anchors.fill: parent
                anchors.margins: ScreenTools.defaultFontPixelWidth
                contentHeight: mainLayout.height
                ColumnLayout {
                    id: mainLayout
                    spacing: _rowSpacing
                    GroupBox {
                        width: 640 * sw
                        Column {
                            Column {
                                spacing: 10 * sw
                                Row {
                                    Label {
                                        width: 120 * sw
                                        height: 45 * sw
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: 45 * sh
                                        text: qsTr("通讯类型")
                                        color: "white"
                                    }
                                    ComboBox {
                                        width: 400 * sw
                                        height: 45 * sw
                                        font.pixelSize: 45 * sh
                                        enabled: originalLinkConfig == null
                                        model: ["Serial", "TCP", "UDP", "4G"]
                                        currentIndex: editingConfig.linkType
                                        onActivated: {
                                            if (index !== editingConfig.linkType) {
                                                changeConfigPage(index)
                                            }
                                        }
                                    }
                                }

                                Loader {
                                    id: linksettingsLoader
                                    source: subEditConfig.settingsURL
                                    property var subEditConfig: editingConfig
                                }

                                Text {
                                    width: 60 * sw
                                    height: 10 * sw
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
