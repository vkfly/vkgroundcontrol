import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import VKGroundControl
import ScreenTools
import FlightDisplay
import Controls

CustomPopup {

    id: popup
    width: popupWidth
    height: mainColumn.height

    // 基础配置属性
    property bool isAllMode: false
    property string textMessage: ""
    property string textModel: ""
    property string imageSource: ""
    property int popupWidth: 600
    property int popupHeight: 720
    property int itemType: 1
    property int textAlignment: 0 // 0: 居中对齐, 1: 靠左对齐

    // 样式配置
    property int leftDistance: 15
    property int textFontSize: 25
    property int buttonFontSize: 14
    property string buttonFontColor: "white"
    property var selectedBackgroundColor: mainWindow.titlecolor
    property real buttonFontSize30: 30 * sw
    property real itemHeight: 60 * sw
    property real fieldWidth: 260 * sw
    property real labelWidth: 160 * sw

    // 航点参数
    property int waypointId: 0
    property real waypointLongitude: 116
    property real waypointLatitude: 40
    property real waypointAltitude: 10
    property real waypointSpeed: 5
    property real waypointHoverTime: 0
    property int waypointPhotoMode: 1
    property real waypointPhotoValue: 10

    // 模式配置
    property int dropMode: 0
    property int turnMode: 1
    property int missionMode: 0
    property int photoMode: 0
    property int gimbalType: 0
    property real gimbalHeight: 0

    // 云台方向配置
    property bool gimbalDirection1: true
    property bool gimbalDirection2: false
    property bool gimbalDirection3: false
    property bool gimbalDirection4: false
    property bool gimbalDirection5: false
    property bool gimbalDirection6: false
    property bool gimbalDirection7: false
    property bool gimbalDirection8: false

    // 可复用组件：简单文本输入行
    component SimpleInputRow: Row {
        property string labelText
        property alias inputText: textField.text
        property alias validator: textField.validator
        property bool isVisible: true

        visible: isVisible
        width: 422 * sw
        height: itemHeight
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2 * sw

        VKLabel {
            width: labelWidth
            height: 50 * sw
            color: "black"
            text: labelText
            fontSize: 50 * sh
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: textField
            anchors.verticalCenter: parent.verticalCenter
            width: fieldWidth
            height: 50 * sw
            font.pixelSize: buttonFontSize30
            font.bold: false
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    // 可复用组件：选择按钮组（使用GroupButton）
    component SelectionGroup: Row {
        property string labelText
        property var buttonNames: []
        property int selectedIndex: 0
        property alias groupButton: groupBtn

        width: 422 * sw
        anchors.horizontalCenter: parent.horizontalCenter
        height: itemHeight

        VKLabel {
            width: labelWidth
            height: 50 * sw
            color: "black"
            text: labelText
            fontSize: 50 * sh
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        GroupButton {
            id: groupBtn
            anchors.verticalCenter: parent.verticalCenter
            width: 270 * sw
            height: 50 * sw
            names: buttonNames
            selectedIndex: parent.selectedIndex
            mainColor: selectedBackgroundColor
            fontSize: buttonFontSize30 * 4.5 / 6
            backgroundColor: "white"
        }
    }

    Column {
        id: mainColumn
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Item {
            width: parent.width
            height: 30 * sw
        }

        // 航点ID（仅在全模式下显示）
        Row {
            visible: isAllMode
            width: 422 * sw
            height: itemHeight
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2 * sw

            VKLabel {
                width: labelWidth
                height: 50 * sw
                color: "black"
                text: qsTr("航点ID")
                verticalAlignment: Text.AlignVCenter
                fontSize: 50 * sh
            }

            VKLabel {
                anchors.verticalCenter: parent.verticalCenter
                width: fieldWidth
                height: 50 * sw
                fontSize: buttonFontSize30
                text: (waypointId + 1).toString()
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        // 经度
        SimpleInputRow {
            id: longitudeRow
            labelText: qsTr("经度")
            inputText: waypointLongitude.toString()
            isVisible: isAllMode
            validator: DoubleValidator {
                bottom: -180
                top: 180
                decimals: 7
            }
        }

        // 纬度
        SimpleInputRow {
            id: latitudeRow
            labelText: qsTr("纬度")
            inputText: waypointLatitude.toString()
            isVisible: isAllMode
            validator: DoubleValidator {
                bottom: -180
                top: 180
                decimals: 7
            }
        }

        // 高度（使用NumericInputField）
        SimpleInputRow {
            id: altitudeRow
            labelText: qsTr("高度")
            inputText: waypointAltitude.toString()
            validator: DoubleValidator {
                bottom: -3000
                top: 5000
                decimals: 1
            }
        }

        // 速度（使用NumericInputField）
        SimpleInputRow {
            id: speedRow
            labelText: qsTr("速度")
            inputText: waypointSpeed.toString()
            validator: DoubleValidator {
                bottom: 1
                top: 25
                decimals: 1
            }
        }

        // 转弯方式选择（使用GroupButton）
        SelectionGroup {
            id: turnModeGroup
            labelText: qsTr("转弯方式")
            buttonNames: [qsTr("自动转弯"), qsTr("定点转弯")]
            selectedIndex: waypointHoverTime === 0 ? 0 : 1

            groupButton.onClicked: function (index) {
                waypointHoverTime = index === 0 ? 0 : 1
            }
        }

        // 悬停时间（仅在定点转弯时显示）
        SimpleInputRow {
            id: hoverTimeRow
            labelText: qsTr("悬停时间")
            inputText: waypointHoverTime.toString()
            isVisible: waypointHoverTime !== 0
        }

        // 任务方式选择（使用GroupButton）
        SelectionGroup {
            id: missionModeGroup
            labelText: qsTr("任务方式")
            buttonNames: [qsTr("无任务"), qsTr("拍照")]
            selectedIndex: waypointPhotoMode === 1 ? 0 : 1

            groupButton.onClicked: function (index) {
                waypointPhotoMode = index === 0 ? 1 : 2
            }
        }

        // 拍照方式选择（仅在拍照模式下显示）
        SelectionGroup {
            id: photoModeGroup
            labelText: qsTr("拍照方式")
            buttonNames: [qsTr("按时拍照"), qsTr("按距拍照")]
            selectedIndex: waypointPhotoMode === 2 ? 0 : 1
            visible: waypointPhotoMode !== 1

            groupButton.onClicked: function (index) {
                waypointPhotoMode = index === 0 ? 2 : 3
            }
        }

        // 拍照间隔（仅在拍照模式下显示）
        SimpleInputRow {
            id: photoIntervalRow
            labelText: waypointPhotoMode === 2 ? qsTr("时间间隔") : qsTr("距离间隔")
            inputText: waypointPhotoValue.toString()
            isVisible: waypointPhotoMode !== 1
        }

        Item {
            width: parent.width
            height: 30 * sw
        }

        // 底部按钮（使用TextButton）
        Rectangle {
            id: buttonRect
            width: parent.width
            height: itemHeight
            color: "#00000000"

            Row {
                width: parent.width
                height: parent.height

                // 取消按钮
                Item {
                    width: parent.width / 2
                    height: parent.height

                    TextButton {
                        width: parent.width
                        height: parent.height
                        buttonText: qsTr("取消")
                        backgroundColor: "gray"
                        textColor: buttonFontColor
                        fontSize: buttonFontSize30
                        cornerRadius: 0
                        borderWidth: 0
                        onClicked: popup.close()
                    }
                }

                // 确认按钮
                Item {
                    width: parent.width / 2
                    height: parent.height

                    TextButton {
                        width: parent.width
                        height: parent.height
                        buttonText: qsTr("确认")
                        backgroundColor: selectedBackgroundColor
                        textColor: buttonFontColor
                        fontSize: buttonFontSize30
                        cornerRadius: 0
                        borderWidth: 0

                        onClicked: {
                            if (!isAllMode) {
                                // 更新所有航点
                                missionModel.updateAllWaypointById(
                                            parseFloat(altitudeRow.inputText),
                                            parseFloat(speedRow.inputText),
                                            parseFloat(hoverTimeRow.inputText),
                                            0, // 拍照触发动作
                                            waypointPhotoMode, parseFloat(
                                                photoIntervalRow.inputText),
                                            0, // 云台动作
                                            0, // 云台俯仰
                                            0, // 云台航向
                                            2, 0, 0, // 抛投对地高度
                                            0, // 抛投通道
                                            0, // 环绕模式类型
                                            0, 0, 0 // 0拍照航点 1抛投航点 2环绕模式
                                            )
                            } else {
                                // 更新单个航点
                                missionModel.updateWaypointById(
                                            waypointId, parseFloat(
                                                longitudeRow.inputText), parseFloat(
                                                latitudeRow.inputText), parseFloat(
                                                altitudeRow.inputText), parseFloat(
                                                speedRow.inputText), parseFloat(
                                                hoverTimeRow.inputText), 0,
                                            // 拍照触发动作
                                            waypointPhotoMode, parseFloat(
                                                photoIntervalRow.inputText),
                                            0, // 云台动作
                                            0, // 云台俯仰
                                            0, // 云台航向
                                            2, 0, 0, // 抛投对地高度
                                            0, // 抛投通道
                                            0, // 环绕模式类型
                                            0, 0, 0 // 0拍照航点 1抛投航点 2环绕模式
                                            )
                            }
                            popup.close()
                        }
                    }
                }
            }
        }
    }
}
