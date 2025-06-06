import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import VKGroundControl
import ScreenTools
import Controls

VKFlickable {
    id: missionPointPanel

    // 驼峰命名的属性
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5 / 6
    property color backgroundColor: ScreenTools.titleColor
    property bool isBattery: false
    property real horizontalSpeed: 10
    property real mainButtonFontSize: 30 * ScreenTools.scaleWidth
    property var volumeId
    property real textWidth: 200 * ScreenTools.scaleWidth
    property real textHeight: 30 * ScreenTools.scaleWidth
    property real fontSize: 18 * ScreenTools.scaleWidth
    property color fontColor: "white"

    // 可复用组件：航点列表项
    component WaypointListItem: Item {
        property variant waypointModel: model

        width: waypointListView.width
        height: contentColumn.implicitHeight + 50 * ScreenTools.scaleWidth

        Rectangle {
            anchors.fill: parent
            color: "transparent"

            Column {
                id: contentColumn
                width: parent.width
                height: contentRow.implicitHeight + 20 * ScreenTools.scaleWidth

                Row {
                    id: contentRow
                    width: parent.width
                    anchors.margins: 10 * ScreenTools.scaleWidth
                    spacing: 10 * ScreenTools.scaleWidth

                    // 航点编号显示
                    Column {
                        width: 60 * ScreenTools.scaleWidth
                        spacing: 5 * ScreenTools.scaleWidth

                        Rectangle {
                            width: 40 * ScreenTools.scaleWidth
                            height: 40 * ScreenTools.scaleWidth
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: model.index === waypointListView.currentIndex ? ScreenTools.titleColor : "white"
                            radius: 20 * ScreenTools.scaleWidth

                            VKLabel {
                                anchors.fill: parent
                                text: model.wpt_type === 1 ? qsTr(
                                                                 "抛") : (model.index + 1).toString()
                                color: model.index
                                       === waypointListView.currentIndex ? "white" : "black"
                                fontSize: 25 * ScreenTools.scaleWidth
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        VKLabel {
                            width: 60 * ScreenTools.scaleWidth
                            height: 30 * ScreenTools.scaleWidth
                            visible: model.wpt_type === 1
                            text: model.index.toString()
                            color: "white"
                            fontSize: 25 * ScreenTools.scaleWidth
                        }
                    }

                    // 航点信息显示
                    Column {
                        id: infoColumn
                        width: waypointListView.width - 135 * ScreenTools.scaleWidth
                        spacing: 5 * ScreenTools.scaleWidth

                        // 高度和速度信息
                        Row {
                            width: parent.width
                            height: 40 * ScreenTools.scaleWidth
                            spacing: 10 * ScreenTools.scaleWidth

                            VKLabel {
                                width: parent.width / 2
                                height: 40 * ScreenTools.scaleWidth
                                text: qsTr("高度   %1m").arg(model.altitude)
                                color: "white"
                                fontSize: 20 * ScreenTools.scaleWidth
                            }

                            VKLabel {
                                width: parent.width / 2
                                height: 40 * ScreenTools.scaleWidth
                                text: qsTr("速度   %1m/s").arg(model.speed)
                                color: "white"
                                fontSize: 20 * ScreenTools.scaleWidth
                            }
                        }

                        // 位置信息
                        VKLabel {
                            width: parent.width
                            height: 40 * ScreenTools.scaleWidth
                            text: qsTr("位置   %1   %2").arg(
                                      model.longitude.toFixed(7)).arg(
                                      model.latitude.toFixed(7))
                            color: "white"
                            fontSize: 20 * ScreenTools.scaleWidth
                        }

                        // 任务模式信息
                        VKLabel {
                            width: parent.width
                            height: 40 * ScreenTools.scaleWidth
                            text: qsTr("%1     %2").arg(model.hover_time === 0 ? qsTr("自动转弯") : qsTr("定点悬停 %1s").arg(model.hover_time)).arg(
                                      model.take_photo_mode === 1 ? qsTr("无任务") : model.take_photo_mode === 2 ? qsTr("定时拍照 %1s").arg(model.take_photo_value) : model.take_photo_mode === 3 ? qsTr("定距拍照 %1m").arg(model.take_photo_value) : "")
                            color: "white"
                            fontSize: 20 * ScreenTools.scaleWidth
                        }
                    }

                    // 删除按钮
                    IconButton {
                        imageSource: "/qmlimages/icon/clean.png"
                        imageSize: 45 * ScreenTools.scaleWidth
                        imageVisible: model.index === waypointListView.currentIndex
                        anchors.verticalCenter: parent.verticalCenter
                        toolTipText: qsTr("删除航点")
                        onClicked: {
                            missionModel.removeAt(waypointListView.currentIndex)
                        }
                    }
                }

                // 分隔线
                Rectangle {
                    width: parent.width
                    height: 2
                    color: "white"
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: model.index !== waypointListView.currentIndex
            onClicked: {
                waypointListView.currentIndex = index
            }
        }
    }

    // 主要内容区域
    Rectangle {
        width: parent.width
        height: mainWindow.height
        color: "transparent"

        Column {
            id: mainColumn
            width: parent.width
            height: parent.height
            spacing: 30 * ScreenTools.scaleWidth

            // 标题栏
            VTitle {
                text: qsTr("航点参数")
                width: parent.width
                height: 60 * ScreenTools.scaleWidth
                color: "white"
                font.pixelSize: buttonFontSize
            }

            // 航点列表
            ListView {
                id: waypointListView
                width: parent.width - 60 * ScreenTools.scaleWidth
                height: mainWindow.height - 270 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                model: missionModel
                clip: true
                spacing: 10 * ScreenTools.scaleWidth

                delegate: WaypointListItem {}
            }

            // 操作按钮组
            Row {
                width: parent.width - 60 * ScreenTools.scaleWidth
                height: 50 * ScreenTools.scaleWidth
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10 * ScreenTools.scaleWidth

                TextButton {
                    id: batchSettingsButton
                    width: (parent.width - 30 * ScreenTools.scaleWidth) / 4
                    height: 50 * ScreenTools.scaleWidth
                    buttonText: qsTr("全部")
                    backgroundColor: "white"
                    textColor: "black"
                    fontSize: mainButtonFontSize * 4.5 / 6
                    cornerRadius: 10 * ScreenTools.scaleWidth
                    pressedColor: backgroundColor
                    pressedTextColor: "white"

                    onClicked: {
                        if (waypointListView.currentItem) {
                            xunchapoint.isAllMode = false
                            xunchapoint.waypointAltitude
                                    = waypointListView.currentItem.waypointModel.altitude
                            xunchapoint.waypointSpeed
                                    = waypointListView.currentItem.waypointModel.speed
                            xunchapoint.waypointHoverTime
                                    = waypointListView.currentItem.waypointModel.hover_time
                            xunchapoint.waypointPhotoMode
                                    = waypointListView.currentItem.waypointModel.take_photo_mode
                            xunchapoint.waypointPhotoValue
                                    = waypointListView.currentItem.waypointModel.take_photo_value
                            xunchapoint.open()
                        }
                    }
                }

                TextButton {
                    id: singleSettingsButton
                    width: (parent.width - 30 * ScreenTools.scaleWidth) / 4
                    height: 50 * ScreenTools.scaleWidth
                    buttonText: qsTr("单个")
                    backgroundColor: "white"
                    textColor: "black"
                    fontSize: mainButtonFontSize * 4.5 / 6
                    cornerRadius: 10 * ScreenTools.scaleWidth
                    pressedColor: backgroundColor
                    pressedTextColor: "white"

                    onClicked: {
                        if (waypointListView.currentItem) {
                            xunchapoint.isAllMode = true
                            xunchapoint.waypointId
                                    = waypointListView.currentItem.waypointModel.index
                            xunchapoint.waypointLongitude
                                    = waypointListView.currentItem.waypointModel.longitude
                            xunchapoint.waypointLatitude
                                    = waypointListView.currentItem.waypointModel.latitude
                            xunchapoint.waypointAltitude
                                    = waypointListView.currentItem.waypointModel.altitude
                            xunchapoint.waypointSpeed
                                    = waypointListView.currentItem.waypointModel.speed
                            xunchapoint.waypointHoverTime
                                    = waypointListView.currentItem.waypointModel.hover_time
                            xunchapoint.waypointPhotoMode
                                    = waypointListView.currentItem.waypointModel.take_photo_mode
                            xunchapoint.waypointPhotoValue
                                    = waypointListView.currentItem.waypointModel.take_photo_value
                            xunchapoint.open()
                        }
                    }
                }

                TextButton {
                    id: saveFileButton
                    width: (parent.width - 30 * ScreenTools.scaleWidth) / 4
                    height: 50 * ScreenTools.scaleWidth
                    buttonText: qsTr("保存")
                    backgroundColor: "white"
                    textColor: "black"
                    fontSize: mainButtonFontSize * 4.5 / 6
                    cornerRadius: 10 * ScreenTools.scaleWidth
                    pressedColor: backgroundColor
                    pressedTextColor: "white"

                    onClicked: {

                        // TODO: 实现文件保存功能
                        // fileDialog.open()
                    }
                }

                TextButton {
                    id: openFileButton
                    width: (parent.width - 30 * ScreenTools.scaleWidth) / 4
                    height: 50 * ScreenTools.scaleWidth
                    buttonText: qsTr("打开")
                    backgroundColor: "white"
                    textColor: "black"
                    fontSize: mainButtonFontSize * 4.5 / 6
                    cornerRadius: 10 * ScreenTools.scaleWidth
                    pressedColor: backgroundColor
                    pressedTextColor: "white"

                    onClicked: {

                        // TODO: 实现文件打开功能
                        // openFileDialog.open()
                    }
                }
            }
        }
    }

    // TODO: 添加文件对话框组件

    /*
    FileDialog {
        id: fileDialog
        title: qsTr("保存文件")
        nameFilters: ["KML files (*.kml)"]
        selectExisting: false
        onAccepted: {
            var fileUrl = fileDialog.fileUrl
            if (fileUrl !== "") {
                var filePath = fileUrl.toString().replace("file:///", "")
                // customListModel.savekmlfile(filePath)
            }
        }
    }

    FileDialog {
        id: openFileDialog
        title: qsTr("打开航线文件")
        selectMultiple: false
        selectFolder: false
        nameFilters: ["KML files (*.kml)"]
        onAccepted: {
            var fileUrl = openFileDialog.fileUrl
            if (fileUrl !== "") {
                var filePath = fileUrl.toString().replace("file:///", "")
                // customListModel.parseKML(filePath)
            }
        }
    }
    */
}
