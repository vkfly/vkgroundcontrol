

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
import VKGroundControl.Palette
import VKGroundControl.Controls
import VKGroundControl.Controllers
import VKGroundControl.ScreenTools

Item {
    id: _root
    height: parent.height
    width: parent.width
    // contentHeight: column11.implicitHeight
    VKPalette {
        id: palette
        colorGroupEnabled: enabled
    }

    LogDownloadController {
        id: logController
    }

    property real _margin: 20 * sw
    property real _butttonWidth: 180 * sw
    Column {
        width: parent.width
        id: column11

        Item {
            width: parent.width

            // height: parent.height
            //  Component {
            //   id: pageComponent
            Row {
                id: column
                width: parent.width
                height: _root.height
                spacing: _margin
                Connections {
                    target: logController
                    onSelectionChanged: {
                        tableView.selection.clear()
                        for (var i = 0; i < logController.model.count; i++) {
                            var o = logController.model.get(i)
                            if (o && o.selected) {
                                tableView.selection.select(i, i)
                            }
                        }
                    }
                }

                Column {
                    width: parent.width - 300 * sw - 2
                    height: _root.height - 45 * sw
                    Item {
                        width: parent.width
                        height: 40 * sw
                        Row {
                            width: parent.width
                            height: 40 * sw
                            Text {
                                width: 100 * sw
                                height: 40 * sw
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 50 * sh
                                //anchors.centerIn : parent
                                text: qsTr("序号")
                                color: "black"
                                //font.pixelSize: parent.height*0.5
                            }
                            Text {
                                width: 200 * sw
                                height: 40 * sw
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 50 * sh
                                //anchors.centerIn : parent
                                text: qsTr("日期")
                                color: "black"
                                //font.pixelSize: parent.height*0.5
                            }
                            Text {
                                id: text3
                                width: parent.width - 530 * sw
                                height: 40 * sw
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 50 * sh
                                text: qsTr("大小")
                                color: "black"
                            }
                            Text {
                                width: 230 * sw
                                height: 40 * sw
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 50 * sh
                                color: "black"
                                text: qsTr("状态")
                            }
                        }
                    }

                    TableView {
                        id: tableView
                        width: parent.width
                        height: 400 * sw - 60 * sw
                        clip: true
                        model: logController.model

                        TableViewColumn {
                            //title: qsTr("序号")
                            width: 100 * sw
                            horizontalAlignment: Text.AlignHCenter

                            delegate: Text {
                                font.pixelSize: 45 * sh
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: styleData.textColor
                                text: {
                                    var o = logController.model.get(
                                                styleData.row)
                                    return o ? o.id : ""
                                }
                            }
                        }
                        TableViewColumn {
                            //title: qsTr("日期")
                            width: 200 * sw
                            horizontalAlignment: Text.AlignHCenter
                            delegate: Text {
                                font.pixelSize: 35 * sh
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                height: 10 * sw
                                color: styleData.textColor
                                text: {
                                    var o = logController.model.get(
                                                styleData.row)
                                    if (o) {
                                        if (logController.model.get(
                                                    styleData.row).received) {
                                            var d = logController.model.get(
                                                        styleData.row).time
                                            if (d.getUTCFullYear() < 2010)
                                                return qsTr("Date Unknown")
                                            else
                                                return d.toLocaleString(
                                                            undefined, "short")
                                        }
                                    }
                                    return ""
                                }
                            }
                        }
                        TableViewColumn {
                            // title: qsTr("大小")
                            width: text3.width
                            horizontalAlignment: Text.AlignHCenter
                            delegate: Text {

                                font.pixelSize: 35 * sh
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: styleData.textColor

                                text: {
                                    var o = logController.model.get(
                                                styleData.row)
                                    return o ? o.sizeStr : ""
                                }
                            }
                        }
                        TableViewColumn {
                            //  title: qsTr("状态")
                            width: 230 * sw

                            horizontalAlignment: Text.AlignHCenter
                            delegate: Text {
                                height: 40 * sw
                                color: styleData.textColor
                                font.pixelSize: 35 * sh
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: {
                                    var o = logController.model.get(
                                                styleData.row)
                                    return o ? o.status : ""
                                }
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
                    width: 300 * sw
                    height: 400 * sw

                    //anchors.horizontalCenter: parent.horizontalCenter
                    Column {
                        id: but
                        width: 260 * sw
                        height: 300 * sw
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: _margin
                        Button {
                            id: button1
                            enabled: !logController.requestingList
                                     && !logController.downloadingLogs
                            width: _butttonWidth
                            height: 50 * sw
                            background: Rectangle {
                                anchors.fill: parent
                                radius: 30 * sw
                                Rectangle {

                                    anchors.fill: parent
                                    radius: 30 * sw
                                    //anchors.right: parent.right;
                                    // width: 10;
                                    height: parent.height
                                    //(color.hovered || control.pressed)
                                    color: button1.pressed ? "gray" : mainWindow.titlecolor
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("刷新")
                                    font.pixelSize: button_fontsize * 5 / 6
                                    color: "white"
                                    font.bold: false
                                }
                                color: "#00000000"
                            }

                            onClicked: {
                                if (!VKGroundControl.multiVehicleManager.activeVehicle1
                                        || VKGroundControl.multiVehicleManager.activeVehicle1.isOfflineEditingVehicle) {

                                    // mainWindow.showMessageDialog(qsTr("Log Refresh"), qsTr("You must be connected to a vehicle in order to download logs."))
                                } else {
                                    logController.refresh()
                                }
                            }
                        }
                        Button {
                            id: button2
                            enabled: !logController.requestingList
                                     && !logController.downloadingLogs

                            width: _butttonWidth
                            height: 50 * sw
                            font.pixelSize: 60 * sh
                            background: Rectangle {
                                anchors.fill: parent
                                radius: 30 * sw
                                Rectangle {

                                    anchors.fill: parent
                                    radius: 30 * sw
                                    //anchors.right: parent.right;
                                    // width: 10;
                                    height: parent.height
                                    //(color.hovered || control.pressed)
                                    color: button2.pressed ? "gray" : button2.enabled === false ? "gray" : mainWindow.titlecolor
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("下载")
                                    font.pixelSize: button_fontsize * 5 / 6
                                    color: "white"
                                    font.bold: false
                                }
                                color: "#00000000"
                            }

                            onClicked: {
                                //-- Clear selection
                                for (var i = 0; i < logController.model.count; i++) {
                                    var o = logController.model.get(i)
                                    if (o)
                                        o.selected = false
                                }
                                //-- Flag selected log files
                                tableView.selection.forEach(
                                            function (rowIndex) {
                                                var o = logController.model.get(
                                                            rowIndex)
                                                if (o)
                                                    o.selected = true
                                            })
                                if (ScreenTools.isMobile) {
                                    // You can't pick folders in mobile, only default location is used
                                    logController.download()
                                } else {
                                    fileDialog.title = qsTr(
                                                "Select save directory")
                                    fileDialog.selectExisting = true
                                    fileDialog.folder = VKGroundControl.settingsManager.appSettings.logSavePath
                                    fileDialog.selectFolder = true
                                    fileDialog.openForLoad()
                                }
                            }
                            QGCFileDialog {
                                id: fileDialog
                                onAcceptedForLoad: {
                                    logController.download(file)
                                    close()
                                }
                            }
                        }
                        Button {
                            id: button3
                            enabled: !logController.requestingList
                                     && !logController.downloadingLogs
                                     && logController.model.count > 0

                            width: _butttonWidth
                            height: 50 * sw
                            font.pixelSize: 60 * sh
                            background: Rectangle {
                                anchors.fill: parent
                                radius: 30 * sw
                                Rectangle {

                                    anchors.fill: parent
                                    radius: 30 * sw
                                    //anchors.right: parent.right;
                                    // width: 10;
                                    height: parent.height
                                    //(color.hovered || control.pressed)
                                    color: button3.pressed ? "gray" : button3.enabled
                                                             === false ? "gray" : button_main
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("擦除全部")
                                    font.pixelSize: button_fontsize * 5 / 6
                                    color: "white"
                                    font.bold: false
                                }
                                color: "#00000000"
                            }

                            onClicked: {
                                messageboxs.text_msg = qsTr(
                                            "All log files will be erased permanently. Is this really what you want?")
                                messageboxs.send_id = "clearall"
                                messageboxs.canshu_y = 0
                                messageboxs.logController = logController

                                messageboxs.open()
                                //logController.eraseAll()
                            } /// mainWindow.showMessageDialog(qsTr("Delete All Log Files"),
                            //,
                            //StandardButton.Yes | StandardButton.No,
                            //function() { logController.eraseAll() })
                        }
                        Button {
                            id: button4
                            width: _butttonWidth
                            font.pixelSize: 60 * sh

                            height: 50 * sw
                            enabled: logController.requestingList
                                     || logController.downloadingLogs

                            background: Rectangle {
                                anchors.fill: parent
                                radius: 30 * sw
                                Rectangle {

                                    anchors.fill: parent
                                    radius: 30 * sw
                                    //anchors.right: parent.right;
                                    // width: 10;
                                    height: parent.height
                                    //(color.hovered || control.pressed)
                                    color: button4.pressed ? "gray" : button4.enabled
                                                             === false ? "gray" : button_main
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: qsTr("取消")
                                    font.pixelSize: button_fontsize * 5 / 6
                                    color: "white"
                                    font.bold: false
                                }
                                color: "#00000000"
                            }

                            onClicked: logController.cancel()
                        }
                    }
                    Text {
                        width: 180 * sw
                        height: 400 * sw
                    }
                }
                //  }
            }
        }
    }
    Text {
        width: 50 * sw
        height: 120 * sw
    }
}
