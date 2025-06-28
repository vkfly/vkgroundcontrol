import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import VKGroundControl
import VKGroundControl.FileDownloader

Item {
    id: rowfly
    property string barName: qsTr("升级飞控固件")
    property var buttonMain: mainWindow.titlecolor
    property string barColor: "transparent" //透明
    property real bottommargin: 30 * sw
    property real buttonWidth: 300 * sw
    property real buttonHeight: 140 * sw
    property real buttonFontSize: 30 * sw * 5/6
    property real marginLeftRight: 60 * sw
    property real spacingWidth: 60 * sw
    width: parent.width
    height: parent.height
    Row {
        anchors.fill: parent
        Text {
            id: displayText
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            width: 200 * sw
            text: barName
            font.pixelSize: buttonFontSize
            font.bold: false
            color: "gray"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        ProgressBar {
            id: control
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 526 * sw // 设置 Item 的宽度，这里要与 ProgressBar 保持一致
            height: 30 * sw // 设置 Item 的高度，这里要与 ProgressBar 保持一致
            value: _activeVehicle ? (_activeVehicle.getCurrentData) : 0
            from: 0
            to: 100

            background: Rectangle {
                //背景项
                implicitWidth: control.width
                height: 30 * sw
                color: "lightgray"
                radius: 3 * sw //圆滑度
            }

            contentItem: Item {
                //内容项
                Rectangle {
                    width: control.visualPosition * control.width
                    height: 30 * sw
                    radius: 2 * sw
                    color: buttonMain
                }
            }
        }
        Text {
            width: 80 * sw
            height: 60 * sw
            anchors.verticalCenter: parent.verticalCenter
            text: _activeVehicle ? (_activeVehicle.getCurrentData + "%") : "0%"
            font.pixelSize: buttonFontSize
            font.bold: false
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "gray"
        }
        Row {
            width: 246 * sw
            height: 60 * sw
            spacing: 6 * sw
            anchors.verticalCenter: parent.verticalCenter
            Button {
                //anchors.verticalCenter: parent.verticalCenter
                id: button1
                width: 120 * sw
                height: 40 * sw
                font.pixelSize: 40 * mainWindow.bili_height
                anchors.verticalCenter: parent.verticalCenter
                // text: "在线升级"
                onClicked: {
                    displayText.text = "下载固件"
                    var url = fetchDataFromServer()
                }

                background: Rectangle {
                    anchors.fill: parent
                    radius: 10
                    Rectangle {

                        anchors.fill: parent
                        radius: 10
                        //anchors.right: parent.right;
                        // width: 10;
                        height: parent.height
                        //(color.hovered || control.pressed)
                        color: button1.pressed ? "gray" : buttonMain
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: "在线升级"
                        font.pixelSize: buttonFontSize
                        color: "white"
                        font.bold: false
                    }
                    color: "#00000000"
                }
            }
            Button {
                id: button2
                width: 120 * sw
                height: 40 * sw
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 40 * mainWindow.bili_height
                //text: "本地升级"
                onClicked: {
                    fileDialog.open()
                    //bt.text="下载固件"
                    //var url= fetchDataFromServer()
                }
                background: Rectangle {
                    anchors.fill: parent
                    radius: 10
                    Rectangle {

                        anchors.fill: parent
                        radius: 10
                        //anchors.right: parent.right;
                        // width: 10;
                        height: parent.height
                        //(color.hovered || control.pressed)
                        color: button2.pressed ? "gray" : buttonMain
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: "本地升级"
                        font.pixelSize: buttonFontSize
                        color: "white"
                        font.bold: false
                    }
                    color: "#00000000"
                }

                // background: Rectangle{
                //     anchors.fill: parent
                //     color:"white"
                //     border.width:3
                //     radius: 12
                //     border.color: "black"
                // }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr("选择文件")
        nameFilters: ["Update files (*.rbl)"]
        onAccepted: {
            var fileUrl = fileDialog.fileUrl
            if (fileUrl !== "") {
                // 将文件路径传递给C++
                displayText.text = "开始升级"
                _activeVehicle.upgradeFirmware(fileUrl.toString().replace("file:///", ""))
                // cppObject.loadFile(fileUrl.toString().replace("file://", ""))
            }
        }
    }
    function fetchDataFromServer() {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var serverUrl = xhr.responseText.trim()
                    var jsonData = JSON.parse(serverUrl)
                    var urlPath = jsonData.urlPath
                    var versonName = jsonData.versonName

                    // 确保 URL 后面有斜杠
                    if (!urlPath.endsWith("/")) {
                        urlPath += "/"
                    }
                    //fileDownloader.downloadFile(urlPath + versonName, "/path/to/save")
                    fileDownloader.downloadFile(urlPath + versonName,
                                                "/path/to/save")
                    // return urlPath + versonName;

                    // 这里可以进一步处理获取到的服务器网址，例如显示在界面上或者进行其他操作
                } else {
                    console.error("Failed to fetch server URL:", xhr.status,
                                  xhr.statusText)
                }
            }
        }

        xhr.open("GET",
                 "http://www.vk-fly.com:8081/v10_rbl_update_folder/updata.txt") // 替换为你的服务器地址和文件路径
        xhr.send()
    }
    FileDownloader {
        id: fileDownloader // 在 QML 中声明 FileDownloader 对象
    }
    Connections {
        property var fullPath
        target: fileDownloader // 指定信号来源为后端对象（backend）
        onDownloadProgressChanged: {
            displayText.text = "下载固件"
            if (bytesReceived === bytesTotal && bytesTotal > 1000) {
                displayText.text = "开始升级"
            }
        }
        onFullPathChanged: {
            fullPath = fullPath
        }
        onFileEnd: {
            _activeVehicle.upgradeFirmware(fullPath.toString().replace("file:///", ""))
        }
    }
}
