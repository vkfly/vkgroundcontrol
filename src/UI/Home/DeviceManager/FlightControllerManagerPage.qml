import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import VKGroundControl
import Controls
import VKGroundControl.FileDownloader
import VkSdkInstance 1.0
import Home


import "../Common"

Flickable {

    property double textWidth: parent.width / 4 * 0.9 * 0.95
    property double textHeight: 65 * sw
    property real buttonFontSize: 30 * sw * 5/6
    property real fontSize: buttonFontSize
    property color mainColor: mainWindow.titlecolor
    property color fontColor: "black"

    property bool isUpdating: false
    property bool isApkUpdating: false
    property bool isLocalFmuUpdating: false
    property bool isAdvanced: false
    property string advancedIconDown: "/qmlimages/icon/down_arrow.png"
    property string advancedIconUp: "/qmlimages/icon/up_arrow.png"


    property real apkUpdateProgress: 0

    property int gyroFilterId: -1
    property int accelFilterId: -1
    property real speedValue: 0.05


    property var _Vehicle : VkSdkInstance.vehicleManager.activeVehicle
    property var getCurrentData : _Vehicle.getCurrentData

    //property var _Vehicle : VkSdkInstance.vehicleManager.vehicles[0]
    property var getCurrentProgress : _Vehicle.getCurrentProgress


    height: parent.height
    width: parent.width
    clip: true
    contentHeight: mainColumn.implicitHeight


    function fetchDataFromServer(type) {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var serverUrl = xhr.responseText.trim()
                    var jsonData = JSON.parse(serverUrl)
                    var urlPath = jsonData.urlPath
                    var versionName = jsonData.versonName

                    if (!urlPath.endsWith("/")) {
                        urlPath += "/"
                    }
                    fileDownloader.downloadFile(urlPath + versionName, "/path/to/save")
                    isUpdating = true
                } else {
                    console.error("Failed to fetch server URL:", xhr.status, xhr.statusText)
                }
            }
        }

        if (type === "V10Pro") {
            xhr.open("GET", "http://www.vk-fly.com:8081/v10_3rbl_update_folder/updata.txt")
        }
        if (type === "V12") {
            xhr.open("GET", "http://www.vk-fly.com:8081/v12_rbl_update_folder/updata.txt")
        }
        xhr.send()
    }

    function fetchDataFromServerApk() {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var serverUrl = xhr.responseText.trim()
                    var jsonData = JSON.parse(serverUrl)
                    var urlPath = jsonData.urlPath
                    var versionName = jsonData.versonName

                    if (!urlPath.endsWith("/")) {
                        urlPath += "/"
                    }
                    isApkUpdating = true
                    fileDownloader.downloadFileapk(urlPath + versionName, "/path/to/save")
                } else {
                    console.error("Failed to fetch server URL:", xhr.status, xhr.statusText)
                }
            }
        }
        xhr.open("GET", "http://www.vk-fly.com:8081/v10_apk_update_folder/updata.txt")
        xhr.send()
    }

    Column {
        id: mainColumn
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            width: parent.width
            height: 40 * sw
        }
        ToolTitle {
            textTitle: qsTr("版本信息")
        }
        Item {

            width: parent.width
            height: 540 * sw
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: _item4
                width: parent.width
                height: parent.height - 20 * sw
                anchors.verticalCenter: parent.verticalCenter
                Row {
                    width: parent.width
                    height: column1.height
                    Item {
                        width: parent.width * 2 / 3 - 2
                        height: column1.height

                        Column {
                            id: column1
                            width: parent.width
                            spacing: 10 * sw
                            Text {
                                width: 200 * sw
                                height: 15 * sw
                            }
                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: qsTr("飞控序列号")
                                    width: 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                Text {
                                    id: fmuSn
                                    text: _Vehicle.FlightController.serialNumber
                                    width: parent.width - 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                            }

                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: qsTr("飞控固件版本")
                                    width: 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                Text {
                                    id: fmuVersion
                                    text: _Vehicle.FlightController.firmwareVersion
                                    width: parent.width - 200 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                            }

                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: qsTr("飞控型号")
                                    width: 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                Text {

                                    id: fkVersion
                                    text: _Vehicle.FlightController.deviceModel
                                    width: parent.width - 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                            }

                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: qsTr("RTK固件版本")
                                    width: 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                Text {

                                    id: rtkVersion
                                    text: "--------"
                                    width: parent.width - 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                            }
                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: mainWindow.dingweimode
                                          === "beidou" ? qsTr("北斗 SN") : qsTr(
                                                             "GNSS SN")
                                    width: 200 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                Text {
                                    id: gpsSnVersion
                                    text: Vehicle.GPSA.serialNumber
                                    width: parent.width - 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                            }

                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: mainWindow.dingweimode
                                          === "beidou" ? qsTr("北斗固件版本") : qsTr(
                                                             "GNSS固件版本")
                                    width: 200 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                Text {
                                    id: gpsVersion
                                    text: Vehicle.GPSA.firmwareVersion
                                    width: parent.width - 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                            }
                            Row {
                                visible: false
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: qsTr("仿地雷达固件号")
                                    width: 200 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                Text {

                                    text: "--------"
                                    width: parent.width - 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                            }
                            Row {
                                visible: false
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: qsTr("前避障雷达固件号")
                                    width: 200 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                Text {

                                    text: "--------"
                                    width: parent.width - 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                            }
                            Row {
                                visible: false
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: qsTr("后避障雷达固件号")
                                    width: 200 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                Text {
                                    text: "--------"
                                    width: parent.width - 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                            }

                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text: qsTr("APP版本号")
                                    width: 200 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                                Text {
                                    text: mainWindow.appversion
                                    width: parent.width - 200 * sw
                                    height: 60 * sw
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: buttonFontSize
                                    font.bold: false
                                    color: "gray"
                                }
                            }
                        }
                    }
                    Item {

                        width: 2
                        height: parent.height

                        Rectangle {
                            width: parent.width
                            height: _item4.height
                            color: "#00000000"
                        }
                    }
                    Item {
                        width: parent.width * 1 / 3
                        height: column1.height
                        Column {
                            width: parent.width
                            spacing: 10 * sw
                            Text {
                                width: 200 * sw
                                height: 15 * sw
                            }
                            Text {
                                text: ""
                                width: 200 * sw
                                height: 60 * sw
                            }

                            Row {
                                width: 380 * sw
                                height: 60 * sw
                                spacing: 20 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                // Button {
                                //     anchors.verticalCenter: parent.verticalCenter
                                //     id: button1
                                //     visible: have_fcu_update
                                //     width: 180 * sw
                                //     height: 50 * sw
                                //     font.pixelSize: 20 * mainWindow.bili_height
                                //     onClicked: {
                                //         var url = fetchDataFromServer(fkVersion.text.toString())
                                //     }

                                //     background: Rectangle {
                                //         anchors.fill: parent
                                //         radius: 30 * sw
                                //         Rectangle {
                                //             anchors.fill: parent
                                //             radius: 30 * sw
                                //             height: parent.height
                                //             color: button1.pressed ? "gray" : mainColor
                                //         }
                                //         Text {
                                //             id: text_1
                                //             anchors.verticalCenter: parent.verticalCenter
                                //             anchors.horizontalCenter: parent.horizontalCenter
                                //             horizontalAlignment: Text.AlignHCenter
                                //             verticalAlignment: Text.AlignVCenter
                                //             text: isUpdating
                                //                   ? qsTr("传输%1%").arg(getCurrentData) : qsTr(
                                //                                  "在线升级")
                                //             font.pixelSize: buttonFontSize * 5 / 6
                                //             color: "white"
                                //             font.bold: false
                                //         }
                                //         color: "#00000000"
                                //     }
                                // }
                                Button {
                                    id: button2
                                    width: 180 * sw
                                    height: 50 * sw
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.pixelSize: 40 * mainWindow.bili_height
                                    onClicked: {
                                        fileDialog.openForLoad()
                                    }
                                    background: Rectangle {
                                        anchors.fill: parent
                                        radius: 30 * sw
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 30 * sw
                                            height: parent.height
                                            color: button2.pressed ? "gray" : mainColor
                                        }
                                        Text {
                                            id: bd
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            text: isLocalFmuUpdating
                                                  ? qsTr("传输%1%").arg(getCurrentProgress) : qsTr(
                                                                 "本地升级")
                                            font.pixelSize: buttonFontSize * 5 / 6
                                            color: "white"
                                            font.bold: false
                                        }
                                        color: "#00000000"
                                    }
                                }
                            }
                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Row {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: ""
                                width: 200 * sw
                                height: 60 * sw
                            }

                            Row {
                                width: 380 * sw
                                height: 60 * sw
                                spacing: 20 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                // Button {
                                //     anchors.verticalCenter: parent.verticalCenter
                                //     id: button3
                                //     visible: Qt.platform.os === "android"
                                //              && have_apk_update
                                //              && factory_ver_manager === ""
                                //     width: 180 * sw
                                //     height: 50 * sw
                                //     font.pixelSize: 20 * mainWindow.bili_height
                                //     onClicked: {
                                //         apkUpdateProgress = 0
                                //         var url = fetchDataFromServerApk()
                                //     }

                                //     background: Rectangle {
                                //         anchors.fill: parent
                                //         radius: 30 * sw
                                //         Rectangle {
                                //             anchors.fill: parent
                                //             radius: 30 * sw
                                //             height: parent.height
                                //             color: button3.pressed ? "gray" : mainColor
                                //         }
                                //         Text {
                                //             anchors.verticalCenter: parent.verticalCenter
                                //             anchors.horizontalCenter: parent.horizontalCenter
                                //             horizontalAlignment: Text.AlignHCenter
                                //             verticalAlignment: Text.AlignVCenter
                                //             text: isApkUpdating
                                //                   ? qsTr("在线升级") : qsTr(
                                //                                   "正在下载%1%").arg(
                                //                                   apkUpdateProgress)
                                //             font.pixelSize: buttonFontSize * 5 / 6
                                //             color: "white"
                                //             font.bold: false
                                //         }
                                //         color: "#00000000"
                                //     }
                                // }
                                Text {
                                    id: button4
                                    width: 180 * sw
                                    height: 50 * sw
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }
            }
        }
        Item {
            width: parent.width
            height: 40 * sw
        }
        ToolTitle {
            visible: false
            textTitle: qsTr("固件升级")
        }
        Item {
            visible: false
            width: parent.width
            height: 130 * sw
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: _item5
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
                            height: 250 * sw
                            spacing: 10 * sw
                            Text {
                                width: 200 * sw
                                height: 15 * sw
                            }
                            FirmwareUpgrade {
                                width: parent.width * 0.95
                                height: 60 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                barName: qsTr("升级飞控固件")
                                barColor: "blue"
                            }
                        }
                    }
                }
            }
        }
        Item {
            width: parent.width
            height: 40 * sw
        }

        ToolTitle {
            textTitle: qsTr("日志信息")
        }

        Item {
            width: parent.width
            height: 430 * sw
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: _item6
                width: parent.width - 30
                height: parent.height - 20 * sw
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                Row {
                    width: parent.width
                    height: parent.width
                    Item {
                        width: parent.width
                        height: parent.height
                        LogDownloadPage{
                            width: parent.width
                            height: parent.height
                        }
                    }
                }
            }
        }
        Item {
            width: parent.width
            height: 40 * sw
        }

        ToolTitle {
            textTitle: qsTr("传感器1")
        }
        Item {

            width: parent.width
            height: column3.height + 20 * sw
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {

                width: parent.width - 10 * sw
                height: column3.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Item {
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: column3.height
                    Rectangle {
                        width: parent.width
                        height: column3.height
                        color: "#00000000"
                        border.color: "white"
                        border.width: 2
                        radius: 30
                    }
                    Item {
                        width: parent.width * 0.9
                        height: column3.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        Column {
                            width: parent.width
                            id: column3
                            Item {
                                width: parent.width
                                height: 10 * sw
                            }
                            Row {
                                height: textHeight
                                width: parent.width
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("磁力计(Gauss):")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("X:%1").arg(_Vehicle? _Vehicle.imuStatus.xmag.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("Y:%1").arg(_Vehicle? _Vehicle.imuStatus.ymag.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("Z:%1").arg(_Vehicle? _Vehicle.imuStatus.zmag.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Row {
                                height: textHeight
                                width: parent.width
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("加计(m/s²):")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("X:%1").arg(_Vehicle? _Vehicle.imuStatus.xacc.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("Y:%1").arg(_Vehicle? _Vehicle.imuStatus.yacc.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("Z:%1").arg(_Vehicle? _Vehicle.imuStatus.zacc.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Row {
                                width: parent.width
                                height: textHeight
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("陀螺(deg/s):")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("X:%1").arg(_Vehicle? _Vehicle.imuStatus.xgyro.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("Y:%1").arg(_Vehicle? _Vehicle.imuStatus.ygyro.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("Z:%1").arg(_Vehicle? _Vehicle.imuStatus.zgyro.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            Text {
                                width: textWidth * 3
                                height: 10 * sw
                            }
                        }
                    }
                }
            }
        }
        Item {
            width: parent.width
            height: 40 * sw
        }
        ToolTitle {
            textTitle: qsTr("传感器2")
        }
        Item {

            width: parent.width
            height: column4.height + 20 * sw
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {

                width: parent.width - 10 * sw
                height: column4.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Item {
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: column4.height
                    Rectangle {
                        width: parent.width
                        height: column4.height
                        color: "#00000000"
                        border.color: "white"
                        border.width: 2
                        radius: 30
                    }
                    Item {
                        width: parent.width * 0.9
                        height: column4.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        Column {
                            width: parent.width
                            id: column4
                            Item {
                                width: parent.width
                                height: 10 * sw
                            }
                            Row {
                                height: textHeight
                                width: parent.width

                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("加计(m/s²)")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("X:%1").arg(_Vehicle? _Vehicle.imu2Status.xacc.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("Y:%1").arg(_Vehicle? _Vehicle.imu2Status.yacc.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("Z:%1").arg(_Vehicle? _Vehicle.imu2Status.zacc.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Row {
                                width: parent.width
                                height: textHeight
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("陀螺(deg/s):")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("X:%1").arg(_Vehicle? _Vehicle.imu2Status.xgyro.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("Y:%1").arg(_Vehicle? _Vehicle.imu2Status.ygyro.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                                Text {
                                    width: textWidth
                                    height: textHeight
                                    font.pixelSize: fontSize
                                    font.bold: false
                                    color: fontColor
                                    text: qsTr("Z:%1").arg(_Vehicle? _Vehicle.imu2Status.zgyro.toFixed(1) : "---")
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Text {
                                width: textWidth * 3
                                height: 10 * sw
                            }
                        }
                    }
                }
            }
        }
        Item {
            width: parent.width
            height: 40 * sw
        }
    }

    VKMessageShow {
        id: messageBox
        anchors.centerIn: parent
        popupWidth: parent.width * 0.5
        messageType: 1
        popupHeight: 240 * sw
    }

    FileDownloader {
        id: fileDownloader
    }

    Connections {
        property var fullPath
        target: fileDownloader
        onDownloadProgressChanged: {
            if (bytesTotal > 1000) {
                if (isApkUpdating) {
                    apkUpdateProgress = (bytesReceived * 100 / bytesTotal).toFixed(1)
                }
            }
        }
        onFullpathchanged: {
            fullPath = fullpath
        }
        onFileend: {
            if (isUpdating) {
                _Vehicle.upgradeFirmware(fullPath.toString().replace("file:///", ""))
            }
            if (isApkUpdating) {
                isApkUpdating = false
            }
        }
    }

    VKFileDialog {
        id: fileDialog
        nameFilters: ["Update files (*.rbl)"]
        title: qsTr("选择文件")
        onAcceptedForLoad: function(filePath){
            _Vehicle.upgradeFirmware(filePath)
            isLocalFmuUpdating = true
        }
    }

    // FileDialog {
    //     id: fileDialog
    //     title: qsTr("选择文件")
    //     nameFilters: ["Update files (*.rbl)"]
    //     fileMode: FileDialog.OpenFile

    //     onAccepted: {
    //         // 获取第一个选择的文件（单个文件模式）
    //         var fileUrl = fileDialog.selectedFile

    //         var filePath = fileUrl.toString();
    //         if (Qt.platform.os === "windows") {
    //             filePath = filePath.replace("file:///", "");
    //         } else {
    //             filePath = filePath.replace("file://", "");
    //         }

    //         if (filePath && filePath !== "") {
    //             console.log("Selected file path:", filePath); // 添加调试输出

    //             _Vehicle.upgradeFirmware(filePath)
    //             isLocalFmuUpdating = true
    //         } else {
    //             console.error("未选择有效的文件")
    //         }
    //     }
    // }
}
