import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs

import VKGroundControl
import QGroundControl 1.0
import VKGroundControl.Palette
import Controls
import ScreenTools
import Home
import VkSdkInstance

Item {
    id: _root
    width: parent.width
    height: parent.height

    // 样式属性
    property var activeVehicle: VkSdkInstance.vehicleManager.activeVehicle
    property real _margin: 20 * ScreenTools.scaleWidth
    property real _buttonWidth: 180 * ScreenTools.scaleWidth
    property color button_main: mainWindow.titlecolor// 按钮主色
    property real button_radius: 30 * ScreenTools.scaleWidth // 按钮圆角半径

    property var logList: activeVehicle.logs

    Column {
        width: parent.width
        spacing: 10 * ScreenTools.scaleWidth

        Row {
            width: parent.width
            height: _root.height - 45 * ScreenTools.scaleWidth
            spacing: _margin

            // 左侧日志列表区域
            Column {
                width: parent.width - 300 * ScreenTools.scaleWidth - 2
                height: parent.height

                // 表头
                Item {
                    width: parent.width
                    height: 40 * ScreenTools.scaleWidth
                    Row {
                        width: parent.width
                        height: parent.height

                        Text {
                            width: 100 * ScreenTools.scaleWidth
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("序号")
                            font.pixelSize: 50 * ScreenTools.scaleHeight
                            color: "black"
                        }
                        Text {
                            width: 200 * ScreenTools.scaleWidth
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("日期")
                            font.pixelSize: 50 * ScreenTools.scaleHeight
                            color: "black"
                        }
                        Text {
                            id: sizeHeader
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            width: parent.width - 530 * ScreenTools.scaleWidth
                            text: qsTr("大小")
                            font.pixelSize: 50 * ScreenTools.scaleHeight
                            color: "black"
                        }
                        Text {
                            width: 230 * ScreenTools.scaleWidth
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("状态")
                            font.pixelSize: 50 * ScreenTools.scaleHeight
                            color: "black"
                        }
                    }
                }

                // 带边框的列表容器
                Rectangle {
                    id: listViewContainer
                    width: parent.width
                    height: 400 * ScreenTools.scaleWidth - 60 * ScreenTools.scaleWidth
                    color: "transparent" // 背景透明
                    border.color: "gray" // 边框颜色
                    border.width: 1      // 边框宽度
                    radius: 4 * ScreenTools.scaleWidth // 圆角边框

                    // 日志列表
                    ListView {
                        id: logListView
                        anchors.fill: parent
                        anchors.margins: 2 * ScreenTools.scaleWidth
                        clip: true
                        model: logList
                        currentIndex: -1

                        delegate: Rectangle {
                            id: rowDelegate
                            width: logListView.width
                            height: 40 * ScreenTools.scaleWidth
                            color: index % 2 === 0 ? "#f0f0f0" : "#ffffff"

                            Component.onCompleted: {
                                if (logList) {
                                    console.log("Log Entry Created:",
                                                "Index:", index,
                                                "ID:", modelData.logid,
                                                "Time:", formatDate(modelData.timestamp),
                                                "Size:", modelData.size,
                                                "Status:", "可用") // 根据实际状态更新
                                } else {
                                    console.warn("No log entry at index", index)
                                }
                            }

                            // 选择指示器
                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                border.color: rowDelegate.ListView.isCurrentItem ? "blue" : "transparent"
                                border.width: 2
                            }

                            // 行内容
                            Row {
                                width: parent.width
                                height: parent.height

                                // 序号列
                                Text {
                                    width: 100 * ScreenTools.scaleWidth
                                    height: parent.height
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 45 * ScreenTools.scaleHeight
                                    text: modelData.logid
                                    color: "black"
                                }

                                // 日期列
                                Text {
                                    width: 200 * ScreenTools.scaleWidth
                                    height: parent.height
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 35 * ScreenTools.scaleHeight
                                    text: formatDate(modelData.timestamp)
                                    color: "black"
                                }

                                // 大小列
                                Text {
                                    width: sizeHeader.width
                                    height: parent.height
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 35 * ScreenTools.scaleHeight
                                    text: formatFileSize(modelData.size)
                                    color: "black"
                                }

                                // 状态列
                                Text {
                                    width: 230 * ScreenTools.scaleWidth
                                    height: parent.height
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 40 * ScreenTools.scaleHeight
                                    text: "可用"
                                    color: "black"
                                }
                            }

                            // 点击选择
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    logListView.currentIndex = index
                                    // 实际应用中添加选择逻辑
                                }
                            }
                        }

                        // 滚动条
                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                            width: 10 * ScreenTools.scaleWidth
                        }
                    }
                }
            }

            // 右侧按钮区域
            Item {
                width: 300 * ScreenTools.scaleWidth
                height: 400 * ScreenTools.scaleWidth

                Column {
                    width: 260 * ScreenTools.scaleWidth
                    height: 300 * ScreenTools.scaleWidth
                    anchors.centerIn: parent
                    spacing: _margin

                    TextButton {
                        buttonText: qsTr("刷新")
                        width: _buttonWidth
                        height: 50 * ScreenTools.scaleWidth
                        cornerRadius: button_radius
                        backgroundColor: button_main
                        fontSize: 45 * ScreenTools.scaleHeight
                        textColor: "white"
                        pressedColor: "gray"
                        onClicked: getLogList()
                    }

                    // 下载按钮
                    TextButton {
                        buttonText: qsTr("下载")
                        enabled: logListView.currentIndex !== -1
                        width: _buttonWidth
                        height: 50 * ScreenTools.scaleWidth
                        cornerRadius: button_radius
                        backgroundColor: button_main
                        fontSize: 45 * ScreenTools.scaleHeight
                        textColor: "white"
                        pressedColor: "gray"
                        onClicked: {
                            var fileName = _root.fileName(_root.logList[logListView.currentIndex].timestamp)
                            fileDialog.title =          qsTr("日志下载")
                            fileDialog.folder =         VKGroundControl.settingsManager.appSettings.logSavePath
                            fileDialog.selectFolder =   true
                            fileDialog.saveFileName = fileName
                            fileDialog.openForSave()
                        }

                        VKFileDialog {
                            id: fileDialog
                            onAcceptedForSave: {
                                activeVehicle.downloadLog(file, logListView.currentIndex)
                                close()
                                progressDialog.open()
                            }
                        }
                    }

                    TextButton {
                        buttonText: qsTr("擦除全部")
                        width: _buttonWidth
                        height: 50 * ScreenTools.scaleWidth
                        cornerRadius: button_radius
                        backgroundColor: button_main
                        fontSize: 45 * ScreenTools.scaleHeight
                        textColor: "white"
                        pressedColor: "gray"
                        onClicked: {
                            messageboxs.messageText = qsTr("所有日志文件将被永久删除。您确定这是您想要的操作吗？")
                            messageboxs.sendId = "clearall"
                            messageboxs.parameterY = 0
                            messageboxs.open();
                        }
                    }

                }
            }
        }
    }

    LogDownloadProgressDialog {
        id: progressDialog
    }

    function getLogList() {
        if (activeVehicle) {
            activeVehicle.getLogList()
        }
    }

    function formatDate(timestamp) {
        if (!timestamp) return ""
        var date = new Date(timestamp * 1000); // 转换为毫秒
        return Qt.formatDateTime(date, "yyyy-MM-dd hh:mm:ss")
    }

    function fileName(timestamp) {
        if (!timestamp) return ""
        var date = new Date(timestamp * 1000); // 转换为毫秒
        return Qt.formatDateTime(date, "yyyy-MM-dd_hh-mm-ss")+".dat"
    }

    function formatFileSize(bytes) {
        if (bytes < 1024) return bytes + " B"
        if (bytes < 1048576) return (bytes/1024).toFixed(1) + " KB"
        return (bytes/1048576).toFixed(1) + " MB"
    }
}
