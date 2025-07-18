import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import VKGroundControl
import Controls
import VKGroundControl.Palette
import VkSdkInstance
// import VKGroundControl.Vehicle
// import VKGroundControl.MultiVehicleManager

import "../Common"

Flickable {
    // UI相关属性
    property real buttonFontSize: 30 * sw * 5 / 6
    property var buttonMain: qgcPal.titleColor

    // 车辆管理相关属性

    property var paramvalue11 : VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_MIN_THR"]


    onParamvalue11Changed: {
        if(paramvalue11.toFixed(2)==="0.05"){
                    _install_bt.selectedIndex=0
                }
        if(paramvalue11.toFixed(2)==="0.10"){
                    _install_bt.selectedIndex=1
                }
        if(paramvalue11.toFixed(2)==="0.15"){
                    _install_bt.selectedIndex=2
                }
        if(paramvalue11.toFixed(2)==="0.20"){
                    _install_bt.selectedIndex=3
                }
        if(paramvalue11.toFixed(2)==="0.25"){
                    _install_bt.selectedIndex=4
                }
    }
    // 高级设置相关属性
    property bool isAdvanced: false
    property string advancedIconUp: "/qmlimages/icon/up_arrow.png"
    property string advancedIconDown: "/qmlimages/icon/down_arrow.png"

    // 参数相关属性
    // property var paramName: _parameterManager.paramName
    // property var paramValue: _parameterManager.paramValue
    property int gyroFilterId: -1
    property int accelFilterId: -1
    property int idleValue: 5
    property int btOpenValue: 0
    height: parent.height
    width: parent.width
    clip: true
    contentHeight: column.implicitHeight

    VKPalette {
        id: qgcPal
    }
    // 参数值变化处理
    // onParamValueChanged: {
    //     var paramValueArray = paramValue.split("--")

    //     switch (paramName) {
    //     case "IMU_GFLT_TYPE":
    //         gyroFilterId = parseInt(paramValueArray)
    //         break
    //     case "IMU_AFLT_TYPE":
    //         accelFilterId = parseInt(paramValueArray)
    //         break
    //     case "LADRC_EN":
    //         btOpenValue = parseInt(paramValueArray)
    //         break
    //     case "MC_MIN_THR":
    //         idleValue = Math.round(parseFloat(paramValueArray) * 100)
    //         break
    //     }
    // }
    // 主布局容器
    Column {
        id: column
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 40 * sw

        ToolTitle {
            textTitle: qsTr("感度设置")
        }

        //感度参数第一列
        Item {
            width: parent.width
            height: 660 * sw
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: _item1
                width: parent.width
                height: parent.height - 20 * sw
                anchors.verticalCenter: parent.verticalCenter
                Row {
                    width: parent.width
                    height: parent.width
                    Item {
                        width: parent.width * 3 / 4 - 2
                        height: parent.height
                        Column {
                            width: parent.width
                            height: parent.width
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("姿态跟随")
                                param: "MC_RP_ANG_KP"
                                valueType: 3
                                addValue: 1
                                minValue: 200
                                maxValue: 800
                                curValue: 200
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_RP_ANG_KP"]
                                onValueChanged: {

                                }
                            }

                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("横滚姿态自稳")
                                param: "MC_RSPD_KP"
                                valueType: 3
                                addValue: 1
                                minValue: 30
                                maxValue: 400
                                curValue: 30
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_RSPD_KP"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("俯仰姿态自稳")
                                param: "MC_PSPD_KP"
                                valueType: 3
                                addValue: 1
                                minValue: 30
                                maxValue: 400
                                curValue: 30
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_PSPD_KP"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw

                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("横滚阻尼")

                                param: "MC_RSPD_KD"
                                valueType: 3
                                addValue: 1
                                minValue: 0
                                maxValue: 50
                                curValue: 0
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_RSPD_KD"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("俯仰阻尼")

                                param: "MC_PSPD_KD"
                                valueType: 3
                                addValue: 1
                                minValue: 0
                                maxValue: 50
                                curValue: 0
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_PSPD_KD"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("最大倾斜角度")
                                param: "TILT_ANG_MAX"
                                valueType: 9
                                addValue: 1
                                minValue: 10
                                maxValue: 35
                                curValue: 10
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["TILT_ANG_MAX"]
                                onValueChanged: {

                                }
                            }
                        }
                    }
                    Item {

                        width: 2
                        height: parent.height

                        Rectangle {
                            width: parent.width
                            height: _item1.height
                            color: "gray"
                        }
                    }
                    Item {
                        width: parent.width * 1 / 4
                        height: parent.height

                        Column {
                            width: parent.width * 0.95
                            height: parent.width
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text {
                                width: parent.width
                                height: 30 * sw
                            }
                            Repeater {
                                model: [qsTr("数值越大,姿态跟随越快"), qsTr(
                                        "数值越大,自稳能力越强，过大会造成自激震荡"), qsTr(
                                        "数值越大,自稳能力越强，过大会造成自激震荡"), qsTr(
                                        "数值越大，抑制晃动能力越强"), qsTr("数值越大，抑制晃动能力越强")]
                                Text {
                                    width: parent.width
                                    height: 100 * sw
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData
                                    font.pixelSize: buttonFontSize
                                    verticalAlignment: Text.AlignVCenter
                                    wrapMode: Text.Wrap
                                    color: "red"
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
        Item {

            width: parent.width
            height: 350 * sw
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
                        width: parent.width * 3 / 4 - 2
                        height: parent.height
                        Column {
                            width: parent.width
                            height: parent.width

                            //航向姿态感度、基础感度、阻尼 ，最大航向角速度
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("航向姿态感度")
                                param: "MC_YAW_ANG_KP"
                                valueType: 3
                                addValue: 1
                                minValue: 200
                                maxValue: 800
                                curValue: 200
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_YAW_ANG_KP"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("航向基础感度")
                                param: "MC_YSPD_KP"
                                valueType: 3
                                addValue: 1
                                minValue: 50
                                maxValue: 400
                                curValue: 50
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_YSPD_KP"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("航向阻尼")
                                param: "MC_YSPD_KD"
                                valueType: 3
                                addValue: 1
                                minValue: 0
                                maxValue: 20
                                curValue: 0
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_YSPD_KD"]
                                onValueChanged: {

                                }
                            }
                        }
                    }
                    Item {

                        width: 2
                        height: parent.height

                        Rectangle {
                            width: parent.width
                            height: _item5.height
                            color: "gray"
                        }
                    }
                    Item {
                        width: parent.width * 1 / 4
                        height: parent.height
                        Column {
                            width: parent.width * 0.95
                            height: parent.width
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text {
                                width: parent.width
                                height: 30 * sw
                            }
                            Repeater {
                                model: [qsTr("数值越大，航向旋转响应越快"), qsTr(
                                        "数值越大，航向自锁能力越强"), qsTr("可抑制航向小幅度的摆动")]
                                Text {
                                    width: parent.width
                                    height: 100 * sw
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData
                                    font.pixelSize: buttonFontSize
                                    verticalAlignment: Text.AlignVCenter
                                    wrapMode: Text.Wrap
                                    color: "red"
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

        Item {
            width: parent.width
            height: 370 * sw
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: _item6
                width: parent.width - 60 * sw
                height: parent.height - 20 * sw
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    width: parent.width
                    height: parent.width
                    Item {
                        width: parent.width
                        height: 60 * sw
                        Row {
                            Text {
                                height: 50 * sw
                                font.pixelSize: buttonFontSize
                                fontSizeMode: Text.HorizontalFit
                                text: qsTr("角速度滤波带宽")
                                font.bold: false
                                verticalAlignment: Text.AlignVCenter
                                anchors.verticalCenter: parent.verticalCenter
                                color: "gray"
                            }
                            Text {
                                height: 60 * sw
                                text: qsTr("(桨叶尺寸:>36(0) 28~36(1) 22~28(2) 18~22(3) 12~18(4) <12(5))")
                                font.pixelSize: buttonFontSize
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                                color: "red"
                            }
                        }
                    }
                    Item {
                        width: parent.width
                        height: 50 * sw
                        GroupButton {
                            width: parent.width
                            height: parent.height
                            spacing: 2
                            selectedIndex: VkSdkInstance.vehicleManager.activeVehicle.parameters["IMU_GFLT_TYPE"]
                            names: ["0", "1", "2", "3", "4", "5"]
                            onClicked: {
                                VkSdkInstance.vehicleManager.activeVehicle.setParam("IMU_GFLT_TYPE",index)
                            }
                        }
                    }

                    Item {
                        width: parent.width
                        height: 60 * sw
                        Row {
                            Text {
                                height: 50 * sw
                                font.pixelSize: buttonFontSize
                                fontSizeMode: Text.HorizontalFit
                                text: qsTr("加速度滤波带宽")
                                font.bold: false
                                verticalAlignment: Text.AlignVCenter
                                anchors.verticalCenter: parent.verticalCenter
                                color: "gray"
                            }
                            Text {
                                height: 60 * sw
                                text: qsTr("(非特殊机型默认1即可)")
                                font.pixelSize: buttonFontSize
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                                color: "red"
                            }
                        }
                    }
                    Item {
                        width: parent.width
                        height: 50 * sw
                        GroupButton {
                            width: parent.width
                            height: parent.height
                            spacing: 2
                            selectedIndex: VkSdkInstance.vehicleManager.activeVehicle.parameters["IMU_AFLT_TYPE"]

                            names: ["0", "1", "2", "3", "4", "5"]
                            onClicked: {
                                VkSdkInstance.vehicleManager.activeVehicle.setParam("IMU_AFLT_TYPE",index)
                            }
                        }
                    }
                    Item {
                        width: parent.width
                        height: 60 * sw

                        Row {
                            Text {
                                //width: parent.width
                                height: 50 * sw
                                font.pixelSize: buttonFontSize
                                fontSizeMode: Text.HorizontalFit
                                text: qsTr("电机解锁阈值")
                                font.bold: false
                                verticalAlignment: Text.AlignVCenter
                                anchors.verticalCenter: parent.verticalCenter
                                color: "gray"
                            }
                            Text {
                                //width: parent.width
                                height: 60 * sw
                                //anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("(无人机解锁后的最小转速)")
                                font.pixelSize: buttonFontSize
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                                color: "red"
                            }
                        }
                    }
                    Item {

                        width: parent.width
                        height: 50 * sw
                        GroupButton {
                            id:_install_bt
                            width: parent.width
                            height: parent.height
                            spacing: 2

                            names: [qsTr("低速"), qsTr("慢速"), qsTr("中速"), qsTr(
                                    "快速"), qsTr("高速")]
                            onClicked: {
                                if(index===0)
                                    VkSdkInstance.vehicleManager.activeVehicle.setParam("MC_MIN_THR",0.05)
                                if(index===1)
                                    VkSdkInstance.vehicleManager.activeVehicle.setParam("MC_MIN_THR",0.10)
                                if(index===2)
                                    VkSdkInstance.vehicleManager.activeVehicle.setParam("MC_MIN_THR",0.15)
                                if(index===3)
                                    VkSdkInstance.vehicleManager.activeVehicle.setParam("MC_MIN_THR",0.20)
                                if(index===4)
                                    VkSdkInstance.vehicleManager.activeVehicle.setParam("MC_MIN_THR",0.25)
                                //VkSdkInstance.vehicleManager.activeVehicle.setParam("IMU_AFLT_TYPE",index)
                            }
                        }
                    }
                }
            }
        }

        ToolTitle {
            textTitle: qsTr("高级设置")
            visible: isAdvanced
        }
        Item {
            visible: isAdvanced
            width: parent.width
            height: colums.height + 50 * sw
            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border.color: "gray"
                border.width: 2
                radius: 30
            }
            Item {
                id: _item3
                width: parent.width
                height: parent.height - 20 * sw
                anchors.verticalCenter: parent.verticalCenter
                Row {
                    width: parent.width
                    height: parent.width
                    Item {
                        width: parent.width * 3 / 4 - 2
                        height: parent.height
                        Column {
                            id: colums
                            width: parent.width
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("水平位置比例")
                                param: "MC_PXY_KP"
                                valueType: 3
                                addValue: 1
                                minValue: 20
                                maxValue: 150
                                curValue: 20
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_PXY_KP"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("水平速度比例")
                                param: "MC_VXY_KP"
                                valueType: 3
                                addValue: 1
                                minValue: 80
                                maxValue: 200
                                curValue: 80
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_VXY_KP"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("水平误差补偿")
                                param: "MC_VXY_KI"
                                valueType: 3
                                addValue: 1
                                minValue: 0
                                maxValue: 20
                                curValue: 0
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_VXY_KI"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("水平速度阻尼")
                                param: "MC_VXY_KD"
                                valueType: 3
                                addValue: 1
                                minValue: 0
                                maxValue: 20
                                curValue: 0
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_VXY_KD"]
                                onValueChanged: {

                                }
                            }

                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("垂直速度比例")
                                param: "MC_VZ_KP"
                                valueType: 3
                                addValue: 1
                                minValue: 300
                                maxValue: 500
                                curValue: 300
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_VZ_KP"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("垂直加速比例")
                                param: "MC_AZ_KP"
                                valueType: 3
                                addValue: 1
                                minValue: 5
                                maxValue: 20
                                curValue: 5
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_AZ_KP"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("垂直误差补偿")
                                param: "MC_AZ_KI"
                                valueType: 3
                                addValue: 1
                                minValue: 5
                                maxValue: 20
                                curValue: 5
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_AZ_KI"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("最大加加速度")
                                param: "MC_JERKXY_MAX"
                                valueType: 9
                                addValue: 1
                                minValue: 0
                                maxValue: 20
                                curValue: 0
                                unit: "m/s³"
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["MC_JERKXY_MAX"]
                                onReleased: {
                                    messagebox.text_msg = "设置" + titil_bar_name
                                            + "为" + curvalue + danwei
                                    messagebox.open()
                                }
                            }
                            VKSeekBar {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("抗风补偿")
                                param: "WIND_COMP_KP"
                                valueType: 9
                                addValue: 0.1
                                minValue: 0
                                maxValue: 1
                                toFix: 1
                                curValue: 0
                                unit: ""
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["WIND_COMP_KP"]
                                onReleased: {
                                    messagebox.text_msg = "设置" + titil_bar_name
                                            + "为" + curvalue + danwei
                                    messagebox.open()
                                }
                            }

                            Item {
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                Row {
                                    width: parent.width
                                    height: 50 * sw
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 2
                                    Text {
                                        height: 50 * sw
                                        width: 200 * sw
                                        font.pixelSize: buttonFontSize
                                        fontSizeMode: Text.HorizontalFit
                                        text: qsTr("LADRC控制开关")
                                        font.bold: false
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: "gray"
                                    }
                                    GroupButton {
                                        width: (parent.width - 10) / 3
                                        height: parent.height
                                        spacing: 2
                                        names: [qsTr("关闭"), qsTr("开启")]
                                    }
                                }
                            }
                            VKSeekBar {
                                visible: btopen_value === 1
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("LADRC横滚感度")
                                param: "LADRC_R_B0"
                                valueType: 9
                                addValue: 1
                                minValue: 0
                                maxValue: 1000
                                curValue: 300
                                unit: ""
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["LADRC_R_B0"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                visible: btopen_value === 1
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("LADRC俯仰感度")
                                param: "LADRC_P_B0"
                                valueType: 9
                                addValue: 1
                                minValue: 0
                                maxValue: 1000
                                curValue: 300
                                unit: ""
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["LADRC_P_B0"]
                                onValueChanged: {

                                }
                            }
                            VKSeekBar {
                                visible: btopen_value === 1
                                width: parent.width - 60 * sw
                                height: 100 * sw
                                anchors.horizontalCenter: parent.horizontalCenter
                                titleBarName: qsTr("LADRC航向感度")
                                param: "LADRC_Y_B0"
                                valueType: 9
                                addValue: 1
                                minValue: 0
                                maxValue: 1000
                                curValue: 300
                                unit: ""
                                param_value: VkSdkInstance.vehicleManager.activeVehicle.parameters["LADRC_Y_B0"]
                                onValueChanged: {

                                }
                            }
                        }
                    }
                    Item {
                        width: 2
                        height: parent.height
                        Rectangle {
                            width: parent.width
                            height: _item3.height
                            color: "gray"
                        }
                    }
                    Item {
                        width: parent.width * 1 / 4
                        height: parent.height
                        Column {
                            width: parent.width * 0.95
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: parent.width
                            Text {
                                width: parent.width
                                height: 30 * sw
                            }
                            Repeater {
                                model: [qsTr("调整水平位置锁定能力"), qsTr(
                                        "调整水平速度跟随快慢"), "", "", qsTr(
                                        "调整悬停时高度锁定能力"), qsTr(
                                        "调整垂直速度跟随快慢"), "", qsTr("调整加速和减速快慢")]
                                Text {
                                    width: parent.width
                                    height: 100 * sw
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData
                                    font.pixelSize: buttonFontSize
                                    verticalAlignment: Text.AlignVCenter
                                    wrapMode: Text.Wrap
                                    color: "red"
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            width: parent.width - 60 * sw
            height: 100 * sw
            anchors.horizontalCenter: parent.horizontalCenter
            GroupButton {
                width: 800 * sw
                height: 100 * sw
                spacing: 100 * sw
                names: [qsTr("一键保存"),qsTr("一键导入")]
                onClicked: {
                if(index===0)
                    saveFileDialog.open()
                if(index===1)
                    loadFiledialog.open()
                }

            }

            Button {
                anchors.right: parent.right
                width: 40 * sw
                height: 40 * sw
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    isAdvanced = !isAdvanced
                }
                background: Rectangle {
                    radius: 5
                    color: buttonMain

                    Image {
                        anchors.fill: parent
                        source: isAdvanced ? advancedIconUp : advancedIconDown
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 40 * sw
        }
    }

    // VKMessageShow {
    //     id: messagebox
    //     anchors.centerIn: parent
    //     popupWidth: parent.width * 0.5
    //     type: 1
    //     popupHeight: 240 * sw
    // }

    // FileDialog {
    //     id: fileDialog
    //     title: qsTr("保存参数文件")
    //     fileMode: FileDialog.SaveFile
    //     nameFilters: ["XML files (*.xml)"]

    //     onAccepted: {
    //         var fileUrl = fileDialog.fileUrl
    //         if (fileUrl !== "") {
    //             // 将文件路径传递给C++
    //             VkSdkInstance.vehicleManager.activeVehicle.saveParamsToXML(fileUrl.toString().replace("file:///", ""))
    //             // cppObject.loadFile(fileUrl.toString().replace("file://", ""))
    //             console.log("参数已保存到:", filePath);
    //         }
    //     }
    // }

    FileDialog {
        id: saveFileDialog
        title: qsTr("保存参数文件")
        fileMode: FileDialog.SaveFile
        nameFilters: ["JSON files (*.json)"]

        onAccepted: {
            // 获取文件路径（QUrl对象）
            var fileUrl = selectedFile;

            // 将 QUrl 转换为字符串
            var filePath = fileUrl.toString();

            // 保存参数
            VkSdkInstance.vehicleManager.activeVehicle.saveParamMapToJSON(filePath.replace("file:///", ""));

            // 添加成功提示
            console.log("参数已保存到:", filePath);
        }
    }


    // FileDialog {
    //     id: fileDialog
    //     title: qsTr("保存参数文件")
    //     nameFilters: ["XML files (*.xml)"]
    //     onAccepted: {
    //         var filePath = fileDialog.fileUrl.toString().replace("file:///", "");
    //         console.log("保存到:", filePath);
    //         VkSdkInstance.vehicleManager.activeVehicle.saveParamsToXML(filePath);
    //     }
    // }

    // FileDialog {
    //     id: openfiledialog
    //     title: qsTr("选择文件")
    //     nameFilters: ["XML files (*.xaml)"]
    //     onAccepted: {
    //         var fileUrl = openfiledialog.fileUrl
    //         if (fileUrl !== "") {
    //             // 转换路径，去掉 file:///
    //             var filePath = fileUrl.toString().replace("file:///", "")
    //             VKGroundControl.multiVehicleManager.activeVehicle1.parameterManager.loadParamMapFromXML(
    //                         filePath)
    //         }
    //     }
    // }

    FileDialog {
        id: loadFiledialog
        title: qsTr("读取参数文件")
        nameFilters: ["JSON files (*.json)"]

        onAccepted: {
            // 获取文件路径（QUrl对象）
            var fileUrl = selectedFile;

            // 将 QUrl 转换为字符串
            var filePath = fileUrl.toString();

            // 保存参数
            VkSdkInstance.vehicleManager.activeVehicle.loadParamMapFromJSON(filePath.replace("file:///", ""));

            console.log("文件已经打开:", filePath);
        }
    }
}
