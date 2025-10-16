import QtQuick
import QtQuick.Controls
import Qt.labs.settings

import VKGroundControl
import VKGroundControl.Palette
import VkSdkInstance

// import VKGroundControl.Vehicle
// import VKGroundControl.MultiVehicleManager

Flickable {
    // UI Properties
    property real buttonFontSize: 30 * sw * 5/6
    property var mainColor: qgcPal.titleColor

    // Vehicle Management Properties


    // Advanced Settings Properties
    property bool isAdvanced: false
    property string advancedIconDown: "/qmlimages/icon/down_arrow.png"
    property string advancedIconUp: "/qmlimages/icon/up_arrow.png"

    // Parameter Properties
    // Video Settings Properties
    property var videoSettings: VKGroundControl.settingsManager.videoSettings
    property string videoSource: videoSettings.videoSource.rawValue
    property bool isGStreamer: VKGroundControl.videoManager.isGStreamer
    property bool isUdp264: isGStreamer && videoSource === videoSettings.udp264VideoSource
    property bool isUdp265: isGStreamer && videoSource === videoSettings.udp265VideoSource
    property bool isRtsp: isGStreamer && videoSource === videoSettings.rtspVideoSource
    property bool isTcp: isGStreamer && videoSource === videoSettings.tcpVideoSource
    property bool isMpegts: isGStreamer && videoSource === videoSettings.mpegtsVideoSource
    property var shareCode: VkSdkInstance.vkServerController.shareCode

    // Filter Properties
    property int gyroFilterId: -1
    property int accelFilterId: -1
    property real speedValue: 0.05

    property ListModel cameraModelList: ListModel {
        ListElement { text: qsTr("SIYI ZR10") }
        ListElement { text: qsTr("SIYI ZT30") }
        ListElement { text: qsTr("云卓 C12") }
        ListElement { text: qsTr("云卓 C20") }
        ListElement { text: qsTr("先飞D80-Pro") }
        ListElement { text: qsTr("先飞Z1-mini") }
        ListElement { text: qsTr("翔拓") }
        ListElement { text: qsTr("拓扑") }
        ListElement { text: qsTr("品灵-A40TRPRO") }
        ListElement { text: qsTr("上博智像DYT") }
        ListElement { text: qsTr("其他型号") }
    }

    Settings {
        id: settings
        property var cameraModel: settings.value("camera_model", "其他型号")
        property var cameraOtherModelAddr: settings.value("camera_other_model_addr", "rtsp://192.168.144.108:554")
    }

    height: parent.height
    width: parent.width
    clip: true

    Connections {
        target: VkSdkInstance.vkServerController
        function onStreamingStatusChanged(isStreaming) { 
            streamingSwitch.checked = isStreaming
        }
    }

    onShareCodeChanged: {
        if(shareCode && shareCode != "") {
            console.log("shareCode",shareCode)
            const key = shareCode.split('/').pop();
            shareCodeText.text = `http://sgcloud-test.jiagutech.com/share?type=drones&id=${_activeVehicle.FlightController.serialNumber}&key=${key}`;
        }
    }
    VKPalette {
        id: qgcPal
    }

    Item {
        width: parent.width * 0.95
        height: parent.height * 0.95
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Rectangle {
            anchors.fill: parent
            color: "#00000000"
            border.color: "gray"
            border.width: 2
            radius: 30
        }
        Item {
            id: mainContent
            width: parent.width
            height: parent.height - 20 * sw
            anchors.verticalCenter: parent.verticalCenter
            Row {
                width: parent.width
                height: parent.width
                Item {
                    width: parent.width
                    height: parent.height
                    Column {
                        width: parent.width
                        height: parent.width
                        Item {
                            width: parent.width
                            height: 20 * sw
                        }
                        Item {
                            width: parent.width
                            height: 80 * sw
                            Item {
                                width: parent.width * 0.95
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                //spacing: parent.width/6*0.25
                                Text {
                                    width: parent.width / 2
                                    height: 60 * sw
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("吊舱型号")
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                }
                                ComboBox {
                                    id: cameraModelCombo
                                    width: parent.width / 4
                                    height: 60 * sw
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    model: cameraModelList
                                    background: Rectangle {
                                        anchors.fill: parent
                                        radius: 10
                                        color: "lightgray"
                                    }
                                    contentItem: Text {
                                        text: cameraModelCombo.currentText
                                        font.pixelSize: buttonFontSize
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    delegate: ItemDelegate {
                                        width: cameraModelCombo.width
                                        height: 50 * sw
                                        background: Rectangle {
                                            anchors.fill: parent
                                            color: "lightgray"
                                        }
                                        Text {
                                            width: parent.width
                                            height: 50 * sw
                                            font.pixelSize: buttonFontSize
                                            text: model.text
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }
                                    //currentIndex: 0
                                    onCurrentTextChanged: {
                                        settings.cameraModel = currentText
                                        if (currentText === qsTr("SIYI ZR10")) {
                                            videoSettings.rtspUrl.value = "rtsp://192.168.144.25:8554/main.264"
                                        } else if (currentText === qsTr("SIYI ZT30")) {
                                            videoSettings.rtspUrl.value = "rtsp://192.168.144.25:8554/video1"
                                        } else if (currentText === qsTr("云卓 C12")) {
                                            videoSettings.rtspUrl.value = "rtsp://192.168.144.108:554/stream=1"
                                        } else if (currentText === qsTr("云卓 C20")) {
                                            videoSettings.rtspUrl.value = "rtsp://192.168.144.108:554/main"
                                        } else if (currentText === qsTr("先飞D80-Pro")) {
                                            videoSettings.rtspUrl.value = "rtsp://user:0000@192.168.144.108:554/cam/realmonitor?channel=1&subtype=0"
                                        } else if (currentText === qsTr("先飞Z1-mini")) {
                                            videoSettings.rtspUrl.value = "rtsp://192.168.144.108"
                                        } else if (currentText === qsTr("翔拓")) {
                                            videoSettings.rtspUrl.value = "rtsp://192.168.144.119/554"
                                        } else if (currentText === qsTr("拓扑")) {
                                            videoSettings.rtspUrl.value = "rtsp://192.168.144.108:554/stream=0"
                                        } else if (currentText === qsTr("品灵-A40TRPRO")) {
                                            videoSettings.rtspUrl.value = "rtsp://192.168.144.119:554"
                                        } else if (currentText === qsTr("上博智像DYT")) {
                                            videoSettings.rtspUrl.value = "rtsp://192.168.2.119/554"
                                        }

                                        if (currentText === qsTr("其他型号")) {
                                            videoSettings.rtspUrl.value = settings.cameraOtherModelAddr
                                        }

                                        videoSettings.gimbalType.value = currentIndex

                                        if (cameractl)
                                            cameractl.setcamera_model(
                                                        currentText)
                                        mainWindow.camera_model = cameraModelCombo.currentText
                                    }
                                }
                            }
                        }
                        Item {
                            visible: cameraModelCombo.currentText === qsTr("其他型号")
                            width: parent.width
                            height: 80 * sw
                            Item {
                                width: parent.width * 0.95
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                //anchors.horizontalCenter: parent.horizontalCenter
                                //spacing: parent.width/6*0.25
                                Text {
                                    width: parent.width / 2
                                    height: 60 * sw
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("视频流地址")
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                }
                                TextField {
                                    id: rtspUrlField
                                    width: parent.width / 4
                                    height: 60 * sw
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "rtsp://192.168.144.64:558/live/single"
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    background: Rectangle {
                                        radius: 10
                                        color: "lightgray"
                                    }
                                    verticalAlignment: Text.AlignVCenter
                                    onEditingFinished: {

                                    }
                                    onTextChanged: {
                                        if (cameraModelCombo.currentText === qsTr(
                                                    "其他型号")) {
                                            videoSettings.rtspUrl.value = rtspUrlField.text
                                            settings.cameraOtherModelAddr = rtspUrlField.text
                                        }
                                    }
                                    //horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }

                        Item {
                            width: parent.width
                            height: 30 * sw
                        }

                        Item {
                            width: parent.width
                            height:tipsText.height
                            Text {
                                id: tipsText
                                width: parent.width * 0.95
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("*以下操作需登录并连上无人机")
                                font.pixelSize: buttonFontSize
                                font.bold: false
                                color: "orange"
                            }
                        }

                        Item {
                            width: parent.width
                            height: 80 * sw
                            Item {
                                width: parent.width * 0.95
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    width: parent.width / 2
                                    height: 60 * sw
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("推流地址")
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                }

                                Button {
                                    width: parent.width / 6
                                    height: 60 * sw
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("获取")
                                    font.pixelSize: buttonFontSize
                                    onClicked: {
                                        if(_activeVehicle) {
                                            VkSdkInstance.vkServerController.requestRtmpPushUrl(_activeVehicle.FlightController.serialNumber)
                                        }
                                    }
                                }
                            }
                        }

                        // Streaming toggle switch
                        Item {
                            width: parent.width
                            height: 80 * sw
                            Item {
                                width: parent.width * 0.95
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    width: parent.width / 3
                                    height: 60 * sw
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("推流到服务器")
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                }


                                Switch {
                                    id: streamingSwitch
                                    height: 60 * sw
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    enabled: VkSdkInstance.vkServerController.isLogin && VkSdkInstance.vkServerController.rtmpServerUrl !== ""   
                                    onCheckedChanged: {
                                        toggleStreamingToServer(checked)
                                    }
                                }
                            }
                        }

                        // Share code display and button
                        Item {
                            width: parent.width
                            height: 80 * sw
                            Item {
                                width: parent.width * 0.95
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    id: shareLinkLabel
                                    width: parent.width / 2
                                    height: 60 * sw
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("分享直播链接")
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                }

                                Text {
                                    id: shareCodeText
                                    height: 60 * sw
                                    anchors.right: shareCodeButton.left
                                    anchors.rightMargin: 10 * sw
                                    anchors.left: shareLinkLabel.left
                                    anchors.leftMargin: 10 * sw
                                    anchors.verticalCenter: parent.verticalCenter 
                                    font.pixelSize: buttonFontSize - 5
                                    font.bold: false
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignRight
                                    elide: Text.ElideRight

                                }

                                Button {
                                    id: shareCodeButton
                                    width: 120 * sw
                                    height: 60 * sw
                                    anchors.right: copyButton.left
                                    anchors.rightMargin: 10 * sw
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("刷新")
                                    font.pixelSize: buttonFontSize
                                    onClicked: {
                                        if(_activeVehicle && streamingSwitch.checked) {
                                            VkSdkInstance.vkServerController.requestPullStreamShareCode(_activeVehicle.FlightController.serialNumber)
                                        }
                                    }
                                }

                                Button {
                                    id: copyButton
                                    width: 120 * sw
                                    height: 60 * sw
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("拷贝")
                                    font.pixelSize: buttonFontSize
                                    onClicked: {
                                        if (shareCodeText.text !== "") {
                                            VKGroundControl.copyToClipboard(shareCodeText.text)
                                        } else {
                                            console.log("分享链接为空")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        var cameraId = settings.cameraModel
        cameraModelCombo.currentIndex = cameraModelCombo.find(cameraId)
        if (cameraModelCombo.currentText === qsTr("SIYI ZR10")) {
            videoSettings.rtspUrl.value = "rtsp://192.168.144.25:8554/main.264"
        }
        if (cameraModelCombo.currentText === qsTr("SIYI ZT30")) {
            videoSettings.rtspUrl.value = "rtsp://192.168.144.25:8554/video1"
        }
        if (cameraModelCombo.currentText === qsTr("云卓 C12")) {
            videoSettings.rtspUrl.value = "rtsp://192.168.144.108:554/stream=1"
        }
        if (cameraModelCombo.currentText === qsTr("云卓 C20")) {
            videoSettings.rtspUrl.value = "rtsp://192.168.144.108:554/main"
        }
        if (cameraModelCombo.currentText === qsTr("先飞D80-Pro")) {
            videoSettings.rtspUrl.value = "rtsp://user:0000@192.168.144.108:554/cam/realmonitor?channel=1&subtype=0"
        }
        if (cameraModelCombo.currentText === qsTr("翔拓")) {
            videoSettings.rtspUrl.value = "rtsp://192.168.144.119/554"
        }
        if (cameraModelCombo.currentText === qsTr("拓扑")) {
            videoSettings.rtspUrl.value = "rtsp://192.168.144.108:554/stream=0"
        }
        if (cameraModelCombo.currentText === qsTr("品灵-A40TRPRO")) {
            videoSettings.rtspUrl.value = "rtsp://192.168.144.119:554"
        }
        if (cameraModelCombo.currentText === qsTr("上博智像DYT")) {
            videoSettings.rtspUrl.value = "rtsp://192.168.2.119/554"
        }
        if (cameraModelCombo.currentText === qsTr("其他型号")) {
            rtspUrlField.text = settings.cameraOtherModelAddr
            videoSettings.rtspUrl.value = settings.cameraOtherModelAddr
        }
        if (VkSdkInstance.vkServerController.isStreamingActive) {
            streamingSwitch.checked = true
        }
        mainWindow.camera_model = cameraModelCombo.currentText
    }


    // Function to toggle streaming to server
    function toggleStreamingToServer(checked) {
        if (checked) {
            // Start streaming with the server URL from settings
            VKGroundControl.videoManager.startStreamingToServer(VkSdkInstance.vkServerController.rtmpServerUrl)
            VkSdkInstance.vkServerController.startPushStreamStatusSync(_activeVehicle.FlightController.serialNumber)
            VkSdkInstance.vkServerController.requestPullStreamShareCode(_activeVehicle.FlightController.serialNumber)
        } else {
            // Stop streaming
            VKGroundControl.videoManager.stopStreamingToServer()
            VkSdkInstance.vkServerController.stopPushStreamStatusSync()
        }
    }

}
