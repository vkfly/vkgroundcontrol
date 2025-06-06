import QtQuick
import QtQuick.Controls
import QtCore

import VKGroundControl
import ScreenTools
import VkSdkInstance 1.0

Item {
    id: _root
    property double batteryVoltage: _activeVehicle ? _activeVehicle.batteryVoltage.toFixed(
                                                         1) : 0
    property double satellites_num: 0
    property bool gps2_status: false
    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle1 ? QGroundControl.multiVehicleManager.activeVehicle1 : ""
    property var weigher_cell: _vehicles.weigherState
    property var parachute_cell: _vehicles.formationLeader
    property var gps_status: _activeVehicle ? _activeVehicle.gps_intraw1[18] : ""
    property var selectevehicle
    property var parsedErrors: ""
    property var bms_cell: _activeVehicle.bms_cell
    property var gps1_num: 0
    property var gps2_num: 0
    property var showzuoye: false

    //测试代码和showRtk
    property bool showRtk: false
    property var _vehicles: VkSdkInstance.vehicleManager.activeVehicle
    property var _appSettings: VKGroundControl.settingsManager.appSettings
    signal settingChanged(int newValue)

    property int baojingerror1: _vehicles ? _vehicles.sysStatus.errorCount1 : 0
    property int baojingerror2: _vehicles ? _vehicles.sysStatus.errorCount2 : 0
    property int baojingerror3: _vehicles ? _vehicles.sysStatus.errorCount3 : 0

    property var custmode: _vehicles.heartbeat.heartbeatCustomMode

    onCustmodeChanged: {

    }

    Component.onCompleted: {

    }

    onWeigher_cellChanged: {
        if (weigher_cell.timestamp !== "" && weigher_cell.timestamp !== 0
                && weigher_cell.timestamp !== "0") {
            weigher_text.visible = true
            weigher_img.visible = true
        }
    }
    onParachute_cellChanged: {
        if (parachute_cell.timestamp !== "" && parachute_cell.timestamp !== 0
                && parachute_cell.timestamp !== "0") {
            parachute.visible = true
            parachute_img.visible = true
        }
    }
    onGps_statusChanged: {
        if (gps_status === "0") {
            if (_activeVehicle.gps_intraw1[19] === "1") {
                gps1_num = _activeVehicle.gps_intraw1[9]
                if (gps2_status === true) {
                    gnssnum.text = qsTr("%1/%2").arg(gps1_num).arg(gps2_num)
                } else {
                    gnssnum.text = qsTr("%1").arg(gps1_num)
                }

                //gnss1.text=qsTr("GNSS-A:%1").arg(_activeVehicle.gps_intraw1[9])
            } else {
                gps1_num = 0
                if (gps2_status === true) {
                    gnssnum.text = qsTr("%1/%2").arg(gps1_num).arg(gps2_num)
                } else {
                    gnssnum.text = qsTr("%1").arg(gps1_num)
                } //gnss1.text=qsTr("GNSS-A:未连接")
            }
        }
        if (gps_status === "1") {
            if (_activeVehicle.gps_intraw1[19] === "1") {
                gps2_status = true
                gps2_num = _activeVehicle.gps_intraw1[9]
                //gnss2.text=qsTr("GNSS-B:%1").arg(_activeVehicle.gps_intraw1[9])
            } else {
                gps2_status = false
                //gnss2.text=qsTr("GNSS-B:未连接")
            }
        }
        parsedErrors = parseSysError1(baojingerror1, baojingerror2,
                                      baojingerror3)
    }

    function setapptaskmode(taskid, id) {
        if (taskid === 0) {
            comobox1.model = wuliuModel
            if (id === 10) {
                comobox1.currentIndex = 0
            }
            if (id === 11) {
                comobox1.currentIndex = 1
            }
            if (id === 12) {
                comobox1.currentIndex = 2
            }
        }
        if (taskid === 1) {
            comobox1.model = xunchaModel
            if (id === 20) {
                comobox1.currentIndex = 0
            }
            if (id === 41) {
                comobox1.currentIndex = 1
            }
            if (id === 22) {
                comobox1.currentIndex = 2
            }
        }
        if (taskid === 2) {
            comobox1.model = bianduiModel
            comobox1.currentIndex = 0
        }
    }
    Settings {
        id: settings
        property int application_setting: 0 //0物流模式 1巡检模式 2 侦察模式
        property int application_setting_id: 0 //00物流模式 10巡检模式 20 侦察模式  0-9为物流模式id 10到19为巡检模式id 20-29为侦察模式id
    }
    property ListModel wuliuModel: ListModel {
        ListElement {
            text: qsTr("手动物流")
        }
        ListElement {
            text: qsTr("AB物流")
        }
        ListElement {
            text: qsTr("多点物流")
        }
    }
    property ListModel xunchaModel: ListModel {
        ListElement {
            text: qsTr("手动巡查")
        }
        ListElement {
            text: qsTr("指点巡查")
        }
        ListElement {
            text: qsTr("航线巡查")
        }
    }
    property ListModel bianduiModel: ListModel {
        ListElement {
            text: qsTr("编队飞行")
        }
    }
    onSelectevehicleChanged: {
        bmss0.visible = false
        bmss1.visible = false
        bmss2.visible = false
        bmss3.visible = false
        bmss4.visible = false
        bmss5.visible = false
        battery_count[0] = 0
        battery_count[1] = 0
        battery_count[2] = 0
        battery_count[3] = 0
        battery_count[4] = 0
        battery_count[5] = 0
    }
    property var battery_count: [0, 0, 0, 0, 0, 0]
    function getbatterycount() {
        return battery_count[0] + battery_count[1] + battery_count[2]
                + battery_count[3] + battery_count[4] + battery_count[5]
    }
    //property var  name: value
    onBms_cellChanged: {
        if (bms_cell[30] === "0" && bms_cell[37] === "1") {
            // groupbox.visible=true
            if (getbatterycount() <= 2) {
                battery_count[0] = 1
                bmss0.visible = true
                vol_msg.visible = false
                // vt_bms.visible=true;
                bmss0.bmsmsg = bms_cell
            } else {
                battery_count[0] = 1
                bmss0.visible = false
                vol_msg.visible = true
                bmss0.bmsmsg = bms_cell
            }
        } else if (bms_cell[30] === "0" && bms_cell[37] !== "1") {
            battery_count[0] = 0

            bmss0.visible = false
        }

        if (bms_cell[30] === "1" && bms_cell[37] === "1") {
            battery_count[1] = 1
            if (getbatterycount() <= 2) {
                //vt_bms.visible=true;
                //groupbox.visible=true
                bmss1.visible = true
                vol_msg.visible = false
                bmss1.bmsmsg = bms_cell
            } else {
                bmss1.visible = false
                vol_msg.visible = true
                bmss1.bmsmsg = bms_cell
            }
        } else if (bms_cell[30] === "1" && bms_cell[37] !== "1") {
            bmss1.visible = false
            battery_count[1] = 0
        }
        if (bms_cell[30] === "2" && bms_cell[37] === "1") {
            battery_count[2] = 1
            if (getbatterycount() <= 2) {
                bmss2.visible = true
                vol_msg.visible = false
                bmss2.bmsmsg = bms_cell
            } else {
                bmss2.visible = false
                vol_msg.visible = true
                bmss2.bmsmsg = bms_cell
            }
        } else if (bms_cell[30] === "2" && bms_cell[37] !== "1") {
            battery_count[2] = 0
            bmss2.visible = false
        }
        if (bms_cell[30] === "3" && bms_cell[37] === "1") {
            battery_count[3] = 1
            if (getbatterycount() <= 2) {

                bmss3.visible = true
                vol_msg.visible = false
                bmss3.bmsmsg = bms_cell
            } else {
                bmss3.visible = false
                vol_msg.visible = true
                bmss3.bmsmsg = bms_cell
            }
        } else if (bms_cell[30] === "3" && bms_cell[37] !== "1") {
            battery_count[3] = 0
            bmss3.visible = false
        }
        if (bms_cell[30] === "4" && bms_cell[37] === "1") {
            battery_count[4] = 1
            if (getbatterycount() <= 2) {
                bmss4.visible = true
                vol_msg.visible = false
                bmss4.bmsmsg = bms_cell
            } else {
                bmss4.visible = false
                vol_msg.visible = true
                bmss4.bmsmsg = bms_cell
            }
        } else if (bms_cell[30] === "4" && bms_cell[37] !== "1") {
            battery_count[4] = 0
            bmss4.visible = false
        }
        if (bms_cell[30] === "5" && bms_cell[37] === "1") {
            battery_count[5] = 1
            if (getbatterycount() <= 2) {
                bmss5.visible = true
                vol_msg.visible = false
                bmss5.bmsmsg = bms_cell
            } else {
                bmss5.visible = false
                vol_msg.visible = true
                bmss5.bmsmsg = bms_cell
            }
        } else if (bms_cell[30] === "5" && bms_cell[37] !== "1") {
            battery_count[5] = 0
            bmss5.visible = false
        }
    }

    function parseSysError1(baojingerror1, baojingerror2, baojingerror3) {
        var errors = []

        if (baojingerror1 & 1)
            errors.push(qsTr("Gcs 失联"))
        if (baojingerror1 & 2)
            errors.push(qsTr("电池电压低"))
        if (baojingerror1 & 4)
            errors.push(qsTr("电机平衡差"))
        if (baojingerror1 & 8)
            errors.push(qsTr("动力故障"))
        if (baojingerror1 & 16)
            errors.push(qsTr("飞控温度高"))
        if (baojingerror1 & 32)
            errors.push(qsTr("飞控无INS解算定位"))
        if (baojingerror1 & 64)
            errors.push(qsTr("超出电子围栏范围"))

        if (baojingerror2 & 1)
            errors.push(qsTr("imu数据超范围"))
        if (baojingerror2 & 2)
            errors.push(qsTr("倾斜姿态过大"))
        if (baojingerror2 & 4)
            errors.push(qsTr("速度超范围"))
        if (baojingerror2 & 8)
            errors.push(qsTr("遥控器数据未就绪"))

        if (baojingerror3 & 1)
            errors.push(qsTr("mag1 磁干扰"))
        if (baojingerror3 & 2)
            errors.push(qsTr("mag2 磁干扰"))
        if (baojingerror3 & 4)
            errors.push(qsTr("imu1 数据异常"))
        if (baojingerror3 & 8)
            errors.push(qsTr("imu2 数据异常"))
        if (baojingerror3 & 16)
            errors.push(qsTr("气压计数据异常"))
        if (baojingerror3 & 32)
            errors.push(qsTr("普通gps1数据异常"))
        if (baojingerror3 & 64)
            errors.push(qsTr("普通gps2数据异常"))
        if (baojingerror3 & 128)
            errors.push(qsTr("RTK板卡数据异常"))
        return errors
    }

    function getflightmode() {
        if (_vehicles.heartbeat.heartbeatCustomMode === 3) {
            return qsTr("姿态模式")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 4) {
            return qsTr("定点模式")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 10) {
            return qsTr("自动起飞")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 11) {
            return qsTr("自动悬停")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 12) {
            return qsTr("自动返航")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 13) {
            return qsTr("飞向目标点")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 15) {
            return qsTr("自动巡航")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 18) {
            return qsTr("指点飞行")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 19) {
            return qsTr("降落")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 20) {
            return qsTr("迫降")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 21) {
            return qsTr("跟随")
        }

        if (_vehicles.heartbeat.heartbeatCustomMode === 23) {
            return qsTr("航点环绕")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 24) {
            return qsTr("动平台起飞")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 25) {
            return qsTr("动平台降落")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 26) {
            return qsTr("自主避障")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 27) {
            return qsTr("OFFBORAD 控制")
        }
        if (_vehicles.heartbeat.heartbeatCustomMode === 28) {
            return qsTr("队形编队")
        }
    }
    function getfixed() {
        if (_vehicles) {
            if (_vehicles.RtkMsg.rtkMsgFixType === 6) {
                return "R"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    function getheading() {
        if (_vehicles) {
            if (_vehicles.RtkMsg.rtkMsgYaw > 0
                    && _vehicles.RtkMsg.rtkMsgYaw <= 36000) {
                return "H"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    function getuavid() {

        // if (QGroundControl.multiVehicleManager.vehicles.count >= 2) {
        //     return "UAV" + _activeVehicle.id + " "
        // } else {
        //     return ""
        // }
        if (VkSdkInstance.vehicleManager.vehicles.length >= 2) {
            return "UAV" + _activeVehicle.id + " "
        } else {
            return ""
        }
    }

    width: parent.width
    height: sw * 65

    Row {
        width: parent.width
        height: parent.height

        //anchors.left: parent.left
        Rectangle {
            id: main_rect
            width: parent.width
            height: sw * 65
            color: "black"
            property int speedValue: 0 // 初始速度为0
            Button {
                id: exitmainwindow
                // text: "退出"
                width: parent.height * 1.5
                height: parent.height
                onClicked: mainWindow.windowState = 0
                background: Rectangle {
                    anchors.fill: parent
                    color: "#00000000"
                    Image {
                        width: parent.height * 0.9
                        height: parent.height * 0.9
                        anchors.centerIn: parent
                        source: "/qmlimages/icon/left.png"
                    }
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                //第八个
                Item {
                    width: 500 * sw
                    height: 45 * sw
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        id: baojingtext
                        width: 440 * sw
                        height: 45 * sw
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter // 垂直居中
                        text: ""
                        //wrapMode: Text.Wrap
                        color: "white"
                        font.pixelSize: 50 * sh
                        font.bold: false
                    }
                }
            }

            Rectangle {
                width: 500 * sw
                //anchors.fill: parent
                anchors.left: main_rect.left
                anchors.leftMargin: exitmainwindow.width
                Rectangle {
                    height: 65 * sw
                    width: 500 * sw
                    // radius: 20 * sw
                    anchors.horizontalCenter: parent.horizontalCenter
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            position: 0.0
                            //: _activeVehicle.single_value > 0 ? "#900bff05" : "#90ff0000"
                            color: "#900bff05"
                        }
                        GradientStop {
                            position: 1.0
                            color: "#00000000"
                        }
                    }
                    Text {
                        id: tt2
                        height: 60 * sw
                        width: 450 * sw
                        verticalAlignment: Text.AlignVCenter
                        //horizontalAlignment: Text.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter // 垂直居中
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: _vehicles ? (_vehicles.heartbeat.heartbeatCustomMode
                                           === 12 ? (getuavid() + getstrreason(
                                                         _vehicles.fmuStatus.loiterReason)) : _vehicles.heartbeat.heartbeatCustomMode === 11 ? gethoverreason(_vehicles.fmuStatus.loiterReason) : (getuavid() + getflightmode())) : ""
                        color: "white"
                        wrapMode: Text.Wrap
                        font.pixelSize: 55 * sh
                        font.bold: false //粗体
                    }
                }
            }
            Rectangle {
                width: 400 * sw
                anchors.right: main_rect.right
                Row {
                    id: wen1
                    anchors.right: parent.right
                    height: 65 * sw
                    spacing: 0 //左右的距离（现在是没有距离）
                    //第六个
                    // QXBMSMsgToolBar{
                    // }
                    Row {
                        id: vol_msg
                        //id:bms0
                        height: 65 * sw
                        spacing: 10 * sw
                        Item {
                            width: 50 * sw
                            height: 65 * sw
                            Item {
                                width: 50 * sw
                                height: 50 * sw
                                anchors.centerIn: parent.Center

                                anchors.verticalCenter: parent.verticalCenter
                                //anchors.horizontalCenter: parent.horizontalCenter
                                Rectangle {
                                    anchors.fill: parent
                                    color: mainWindow.showBattery ? "#40ffffff" : "#000000"
                                }
                                Image {
                                    width: 40 * sw
                                    height: 40 * sw
                                    anchors.centerIn: parent.Center
                                    mipmap: true
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    anchors.verticalCenter: parent.verticalCenter
                                    fillMode: Image.PreserveAspectFit
                                    source: "/qmlimages/icon/battrey.png"
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {

                                            //mainWindow.showBattery=!mainWindow.showBattery;
                                            //anotherWindow.visible = true;
                                        }
                                    }
                                }
                            }
                        }

                        Column {
                            width: 120 * sw
                            anchors.verticalCenter: parent.verticalCenter
                            //height: 60*sw
                            spacing: 0
                            Text {
                                width: 120 * sw
                                height: 30 * sw
                                //anchors.verticalCenter: parent.verticalCenter // 垂直居中
                                text: VkSdkInstance.vehicleManager.vehicles[0].sysStatus.batteryVoltage.toFixed(
                                          2) + "V"
                                //horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: "#FFFFFF"
                                font.pixelSize: 55 * sh
                                //font.bold: false
                            }
                            Text {
                                width: 120 * sw
                                height: 30 * sw
                                visible: false
                                //anchors.verticalCenter: parent.verticalCenter // 垂直居中
                                text: _activeVehicle ? (_activeVehicle.prc_vol + "%")
                                                       + ((_activeVehicle.current_battery
                                                           * 0.01).toFixed(
                                                              0.) + "A") : "N/A"
                                //   text: _activeVehicle?(_activeVehicle.prc_vol+"%"):"N/A"
                                // horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: "#FFFFFF"
                                font.pixelSize: 48 * sh
                                //font.bold: false
                            }
                        }
                    }
                    BMSMsgToolbar {
                        id: bmss0
                        visible: false
                    }
                    BMSMsgToolbar {
                        id: bmss1
                        visible: false
                    }
                    BMSMsgToolbar {
                        id: bmss2
                        visible: false
                    }
                    BMSMsgToolbar {
                        id: bmss3
                        visible: false
                    }
                    BMSMsgToolbar {
                        id: bmss4
                        visible: false
                    }
                    BMSMsgToolbar {
                        id: bmss5
                        visible: false
                    }
                    Row {

                        height: 65 * sw
                        spacing: 10 * sw

                        //第七个
                        Item {
                            id: signalIcon // 添加此行
                            width: 50 * sw
                            height: 60 * sw
                            Item {
                                width: 50 * sw
                                height: 50 * sw
                                anchors.centerIn: parent
                                //anchors.verticalCenter: parent.verticalCenter
                                Rectangle {
                                    anchors.fill: parent
                                    color: _root.showRtk ? "#40ffffff" : "#000000"
                                }
                                Image {
                                    width: 40 * sw
                                    height: 40 * sw
                                    anchors.centerIn: parent
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    fillMode: Image.PreserveAspectFit
                                    source: "/qmlimages/icon/star.png"

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            _root.showRtk = !_root.showRtk
                                            //setelliteWindow.visible = true;
                                        }
                                    }
                                }
                            }
                        }

                        Column {
                            width: 60 * sw
                            anchors.verticalCenter: parent.verticalCenter
                            //height: 60*sw
                            spacing: 0
                            Text {
                                id: stat_type
                                visible: stat_type.text !== ""
                                width: 60 * sw
                                height: 30 * sw
                                //anchors.verticalCenter: parent.verticalCenter // 垂直居中
                                text: getfixed() + getheading() + get_rtk_star()
                                //horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: "#FFFFFF"
                                font.pixelSize: 48 * sh
                                font.bold: false
                            }
                            Text {
                                id: gnssnum
                                width: 60 * sw
                                height: 30 * sw
                                // /anchors.verticalCenter: parent.verticalCenter // 垂直居中
                                // horizontalAlignment: Text.AlignHCenter
                                text: _vehicles.GNSS1.gpsInputSatellitesVisible
                                verticalAlignment: Text.AlignVCenter

                                color: "#FFFFFF"
                                font.pixelSize: stat_type.visible ? 48 * sh : 55 * sh
                                //font.bold: false
                            }
                        }
                    }
                    Item {
                        width: 20 * sw
                        height: 50 * sw
                    }
                    Item {
                        width: 90 * sw
                        height: 65 * sw
                        Image {
                            width: 90 * sw
                            height: 38 * sw
                            anchors.centerIn: parent
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: getsignal()
                        }
                    }
                    Item {
                        width: 20 * sw
                        height: 50 * sw
                    }
                    Row {
                        height: 65 * sw
                        spacing: 10 * sw
                        Item {
                            width: 40 * sw
                            height: 60 * sw
                            Image {
                                width: 40 * sw
                                height: 40 * sw
                                anchors.centerIn: parent.Center
                                anchors.verticalCenter: parent.verticalCenter
                                fillMode: Image.PreserveAspectFit
                                source: "/qmlimages/icon/clock.png"
                            }
                        }
                        Text {
                            width: 120 * sw
                            height: 60 * sw
                            anchors.verticalCenter: parent.verticalCenter // 垂直居中
                            horizontalAlignment: Text.AlignHCenter
                            text: _activeVehicle ? secondsToHMS(
                                                       _activeVehicle.flytime) : "00:00:00"
                            verticalAlignment: Text.AlignVCenter
                            color: "#FFFFFF"
                            font.pixelSize: 55 * sh
                            //font.bold: false
                        }
                        Item {
                            id: parachute_img
                            width: 40 * sw
                            height: 60 * sw
                            visible: false
                            Image {
                                width: 40 * sw
                                height: 40 * sw
                                anchors.centerIn: parent
                                anchors.verticalCenter: parent.verticalCenter
                                fillMode: Image.PreserveAspectFit
                                source: "/qmlimages/icon/parachute.png"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        ctlmsg.text_slider = qsTr("立即停桨开伞")
                                        ctlmsg.ctl_id = 11 //立即停桨叶开伞
                                        ctlmsg.open()
                                        //mainWindow.showRtk=!mainWindow.showRtk;
                                        //setelliteWindow.visible = true;
                                    }
                                }
                            }
                        }
                        Text {
                            id: parachute
                            visible: false
                            width: 100 * sw
                            height: 60 * sw
                            anchors.verticalCenter: parent.verticalCenter // 垂直居中
                            horizontalAlignment: Text.AlignHCenter
                            text: parachute_cell.state
                                  === "0" ? qsTr("未就绪") : parachute_cell.state
                                            === 1 ? qsTr("已就绪") : parachute_cell.state
                                                    === 2 ? qsTr("已开伞") : parachute_cell.state
                                                            === 3 ? qsTr("故障") : ""
                            verticalAlignment: Text.AlignVCenter
                            color: "#FFFFFF"
                            font.pixelSize: 55 * sh
                            //font.bold: false
                        }
                        Item {
                            id: weigher_img
                            width: 40 * sw
                            height: 60 * sw
                            visible: false
                            Image {
                                width: 40 * sw
                                height: 40 * sw
                                anchors.centerIn: parent.Center
                                anchors.verticalCenter: parent.verticalCenter
                                fillMode: Image.PreserveAspectFit
                                source: "/qmlimages/icon/weighter.png"
                            }
                        }
                        Text {
                            id: weigher_text
                            visible: false
                            width: 60 * sw
                            height: 60 * sw
                            anchors.verticalCenter: parent.verticalCenter // 垂直居中
                            horizontalAlignment: Text.AlignHCenter
                            text: qsTr("%1kg").arg(
                                      _vehicles ? (_vehicles.weigher_cell.weight * 0.001).toFixed(
                                                      1) : 0)
                            verticalAlignment: Text.AlignVCenter
                            color: "#FFFFFF"
                            font.pixelSize: 55 * sh
                            //font.bold: false
                        }
                    }

                    Item {
                        width: 20 * sw
                        height: 50 * sw
                    }
                    ComboBox {
                        id: comobox1
                        width: 220 * sw
                        height: 50 * sw
                        anchors.verticalCenter: parent.verticalCenter
                        model: mainWindow.application_setting
                               === 0 ? wuliuModel : mainWindow.application_setting
                                       === 1 ? xunchaModel : mainWindow.application_setting
                                               === 1 ? bianduiModel : wuliuModel
                        background: Rectangle {
                            anchors.fill: parent
                            radius: 10
                            color: "white"
                        }
                        contentItem: Text {
                            text: comobox1.currentText
                            font.bold: false
                            font.pixelSize: 22 * sw
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        delegate: ItemDelegate {
                            width: 220 * sw
                            height: 50 * sw
                            background: Rectangle {
                                anchors.fill: parent
                                color: "white"
                            }
                            Text {
                                width: 220 * sw
                                height: 50 * sw
                                font.pixelSize: 22 * sw
                                font.bold: false
                                text: model.text
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        onCurrentIndexChanged: {
                            if (mainWindow.application_setting === 0) {
                                if (currentIndex === 0) {
                                    mainWindow.setpoint = false
                                    showzuoye = false
                                    settings.application_setting = 0
                                    settings.application_setting_id = 10 //0为手动物流
                                    mainWindow.application_setting_id = 10
                                    settings.sync()
                                } else if (currentIndex === 1) {
                                    mainWindow.setpoint = false
                                    if (missionModel.itemCount === 0
                                            || missionModel.getwpt_mode(
                                                ) === 111) {
                                        settings.application_setting = 0
                                        settings.application_setting_id = 11 //1为AB物流
                                        mainWindow.application_setting_id = 11

                                        missionModel.setwpt_mode(111)
                                        settings.sync()
                                    } else if (missionModel.getwpt_mode(
                                                   ) !== 111) {
                                        messageboxs.sendId = "Enterab" //进入AB模式
                                        messageboxs.messageText = qsTr(
                                                    "该航线不是AB物流航线，是否删除该航线？")
                                        messageboxs.parameterY = 0
                                        messageboxs.messageType = 1
                                        messageboxs.open()
                                    }
                                    showzuoye = false
                                    settings.sync()
                                } else if (currentIndex === 2) {
                                    mainWindow.setpoint = false
                                    if (missionModel.itemCount === 0
                                            || missionModel.getwpt_mode(
                                                ) === 121) {
                                        //text_wuliu_title.text="多点物流"
                                        settings.application_setting = 0
                                        settings.application_setting_id = 12 //1为AB物流
                                        mainWindow.application_setting_id = 12
                                        missionModel.setwpt_mode(
                                                    121) //settingChanged(1)
                                        settings.sync()
                                    } else if (missionModel.getwpt_mode(
                                                   ) !== 121) {
                                        messageboxs.sendId = "Enterduodian" //进入AB模式
                                        messageboxs.messageText = qsTr(
                                                    "该航线不是多点物流航线，是删除该航线？")
                                        messageboxs.messageType = 1
                                        messageboxs.parameterY = 0
                                        messageboxs.open()
                                    }
                                    settings.sync()
                                    showzuoye = false
                                }
                            }
                            if (mainWindow.application_setting === 1) {
                                if (currentIndex === 0) {
                                    showzuoye = false
                                    settings.application_setting = 1
                                    settings.application_setting_id = 20 //0为手动物流
                                    mainWindow.application_setting_id = 20
                                    mainWindow.setpoint = false
                                    settings.sync()
                                }
                                if (currentIndex === 1) {
                                    showzuoye = false
                                    settings.application_setting = 1
                                    settings.application_setting_id = 41 //11为管线巡检
                                    mainWindow.application_setting_id = 41
                                    mainWindow.setpoint = true
                                    settings.sync()
                                }
                                if (currentIndex === 2) {
                                    showzuoye = false
                                    settings.application_setting = 1
                                    settings.application_setting_id = 22 //2为多点物流
                                    mainWindow.application_setting_id = 22
                                    mainWindow.setpoint = false
                                    settings.sync()
                                }
                            }
                            if (mainWindow.application_setting === 2) {
                                mainWindow.setpoint = false
                            }
                        }
                    }
                    Item {
                        width: 5 * sw
                        height: 50 * sw
                    }
                }
            }
        }
    }
    Item {
        visible: showRtk
        width: 560 * ScreenTools.scaleWidth
        height: 140 * ScreenTools.scaleWidth
        //anchors.top: parent.top
        //anchors.right: parent.right
        //anchors.topMargin: 0
        //anchors.rightMargin: 70*ScreenTools.scaleWidth
        // 智能定位
        x: {
            // 强制绑定动态属性
            signalIcon.parent.x
            signalIcon.parent.parent.width

            // 计算全局坐标（目标为窗口根元素）
            let iconGlobalPos = signalIcon.mapToItem(_root, 0, 0)
            let finalX = iconGlobalPos.x

            // 边界保护
            Math.max(10, Math.min(finalX, _root.width - width - 10))
        }

        y: {
            let iconGlobalPos = signalIcon.mapToItem(_root, 0, 0)
            iconGlobalPos.y + signalIcon.height + 5
        }

        Rectangle {
            anchors.fill: parent
            color: "#90000000"
            border.width: 1
            border.color: "white"
            radius: 5
        }
        Column {
            width: 560 * ScreenTools.scaleWidth
            height: 120 * ScreenTools.scaleWidth
            anchors.verticalCenter: parent.verticalCenter
            Row {
                width: 560 * ScreenTools.scaleWidth
                height: 40 * ScreenTools.scaleWidth
                spacing: 10 * ScreenTools.scaleWidth
                Text {
                    width: 10 * ScreenTools.scaleWidth
                    height: 40 * ScreenTools.scaleWidth
                }
                Text {
                    height: 40 * ScreenTools.scaleWidth
                    width: 180 * ScreenTools.scaleWidth

                    color: "white"
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    text: qsTr("RTK状态:%1").arg(showrtkstatus())
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    height: 40 * ScreenTools.scaleWidth
                    width: 180 * ScreenTools.scaleWidth
                    color: "white"
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    text: qsTr("ANT1:%1").arg(
                              _vehicles ? _vehicles.RtkMsg.rtkMsgSatellitesVisible : "")
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    //anchors.left:parent.left
                    height: 40 * ScreenTools.scaleWidth
                    width: 180 * ScreenTools.scaleWidth
                    color: "white"
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    text: qsTr("ANT2:%1").arg(
                              _vehicles ? _vehicles.RtkMsg.rtkMsgDgpsSatellites : "")
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Row {
                width: 560 * ScreenTools.scaleWidth
                height: 40 * ScreenTools.scaleWidth
                spacing: 10 * ScreenTools.scaleWidth
                Text {
                    width: 10 * ScreenTools.scaleWidth
                    height: 40 * ScreenTools.scaleWidth
                    //anchors.left:parent.left
                }
                Text {
                    height: 40 * ScreenTools.scaleWidth
                    width: 180 * ScreenTools.scaleWidth
                    //anchors.left:parent.left
                    color: "white"
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    text: qsTr("航向类型:%1").arg(gethead())
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    height: 40 * ScreenTools.scaleWidth
                    width: 180 * ScreenTools.scaleWidth
                    //anchors.left:parent.left
                    color: "white"
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    text: qsTr("RTK海拔:%1").arg(
                              _vehicles ? (_vehicles.RtkMsg.rtkMsgAltitudeMsl / 1000.0).toFixed(
                                              1) : "")
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: gnss1
                    height: 40 * ScreenTools.scaleWidth
                    width: 180 * ScreenTools.scaleWidth
                    //height: 40*ScreenTools.scaleWidth
                    //anchors.left:parent.left
                    color: "white"
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    //text:_activeVehicle?_activeVehicle.gps_intraw1[8]==="0"?qsTr("GNSS:断开"):qsTr("GNSS星数:%1").arg(_activeVehicle.gps_intraw1[9]):""
                    //text:qsTr("GNSS星数:%1").arg(_activeVehicle.gps_intraw1[8])
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Row {
                width: 560 * ScreenTools.scaleWidth
                height: 40 * ScreenTools.scaleWidth
                spacing: 10 * ScreenTools.scaleWidth
                Text {
                    width: 10 * ScreenTools.scaleWidth
                    height: 40 * ScreenTools.scaleWidth
                    //anchors.left:parent.left
                }
                Text {
                    //anchors.left:parent.left
                    height: 40 * ScreenTools.scaleWidth
                    width: 180 * ScreenTools.scaleWidth
                    color: "white"
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    text: mainWindow.dingweimode
                          === "beidou" ? qsTr("北斗海拔:%1m").arg(
                                             _vehicles ? (_vehicles.RtkMsg.rtkMsgAltitudeMsl
                                                          * 0.1 * 10).toFixed(
                                                             1) : "") : qsTr(
                                             "GNSS海拔:%1m").arg(
                                             _vehicles ? (_vehicles.RtkMsg.rtkMsgAltitudeMsl
                                                          * 0.1 * 10).toFixed(
                                                             1) : "")
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    height: 40 * ScreenTools.scaleWidth
                    width: 180 * ScreenTools.scaleWidth
                    //anchors.left:parent.left
                    color: "white"
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    text: mainWindow.dingweimode
                          === "beidou" ? qsTr("北斗 PDOP:%1").arg(
                                             _vehicles ? (_vehicles.RtkMsg.rtkMsgHdop
                                                          * 0.01).toFixed(
                                                             1) + "m" : "") : qsTr(
                                             "GNSS PDOP:%1").arg(
                                             _vehicles ? (_vehicles.RtkMsg.rtkMsgHdop
                                                          * 0.01).toFixed(
                                                             1) + "m" : "")
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: gnss2
                    height: 40 * ScreenTools.scaleWidth
                    width: 180 * ScreenTools.scaleWidth
                    //height: 40*ScreenTools.scaleWidth
                    //anchors.left:parent.left
                    //color:_activeVehicle.gps_intraw1[18]==="1"&&_activeVehicle.gps_intraw1[8]==="0"?"red": "white"
                    color: "white"
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    //text:qsTr("GNSS-B:未连接")
                    //text:_activeVehicle?_activeVehicle.gps_intraw1[8]==="0"?qsTr("GNSS:断开"):qsTr("GNSS星数:%1").arg(_activeVehicle.gps_intraw1[9]):""
                    //text:qsTr("GNSS星数:%1").arg(_activeVehicle.gps_intraw1[8])
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    function secondsToHMS(seconds) {
        var hours = Math.floor(seconds / 3600)
        var minutes = Math.floor((seconds % 3600) / 60)
        var remainingSeconds = seconds % 60
        // Format hours, minutes, and seconds with leading zeros if necessary
        var formattedHours = ("0" + hours).slice(-2)
        var formattedMinutes = ("0" + minutes).slice(-2)
        var formattedSeconds = ("0" + remainingSeconds).slice(-2)
        return formattedHours + ":" + formattedMinutes + ":" + formattedSeconds
    }
    function get_alt() {
        if (_activeVehicle)
            return (_activeVehicle.gps_intraw1[3] * 0.001).toFixed(1)
        else {
            return ""
        }
    }
    function getstrreason(reason) {
        if (reason === 1)
            return qsTr("地面站指令返航")
        if (reason === 2)
            return qsTr("遥控器指令返航")
        if (reason === 3)
            return qsTr("地面站失联返航")
        if (reason === 4)
            return qsTr("遥控器信号FS返航")
        if (reason === 5)
            return qsTr("遥控器信号失联返航")
        if (reason === 6)
            return qsTr("电压低保护返航")
        if (reason === 7)
            return qsTr("OFFBORAD控制指令返航")
        if (reason === 8)
            return qsTr("超出高度限制保护返航")
        if (reason === 9)
            return qsTr("超出电子围栏范围保护返航")
        if (reason === 10)
            return qsTr("电池BMS电量低保护返航")
        if (reason === 11)
            return qsTr("电池BMS通信失联保护返航")
        if (reason === 12)
            return qsTr("伺服动力故障保护返航")
        if (reason === 13)
            return qsTr("航线完成返航")
    }

    function gethoverreason(reason) {
        if (reason === 2)
            return qsTr("定点悬停(地面站指令)")
        if (reason === 3)
            return qsTr("定点悬停(任务完成)")
        if (reason === 5)
            return qsTr("定点悬停(GPS重定位)")
        if (reason === 6)
            return qsTr("定点悬停(遥控器指令)")
        if (reason === 7)
            return qsTr("定点悬停(跟随目标结束)")
        if (reason === 9)
            return qsTr("定点悬停(自动起飞结束)")
        if (reason === 10)
            return qsTr("定点悬停(电池电压低)")
        if (reason === 11)
            return qsTr("定点悬停(遥控器失控)")
        if (reason === 12)
            return qsTr("定点悬停(遥控器失联)")
        if (reason === 13)
            return qsTr("定点悬停(遥控器数据异常)")
        if (reason === 14)
            return qsTr("定点悬停(电池电量低)")
        if (reason === 15)
            return qsTr("定点悬停(OFFBORAD控制)")
        if (reason === 16)
            return qsTr("退队编队悬停")
        if (reason === 17)
            return qsTr("氢能气压低悬停")
        if (reason === 18)
            return qsTr("发动机油量低悬停")
        if (reason === 21)
            return qsTr("定点悬停(航点数据异常)")
    }

    function get_rtk_star() {
        if (_vehicles)
            return (_vehicles.RtkMsg.rtkMsgSatellitesVisible)
        else {
            return ""
        }
    }

    //TODO:旧的showrtkstatus
    function showrtkstatus() {
        if (_vehicles) {
            switch (parseInt(_vehicles.RtkMsg.rtkMsgFixType)) {
            case 0:
                return qsTr("未连接")
            case 1:
                return qsTr("未定位")
            case 2:
                return qsTr("单点")
            case 3:
                return qsTr("单点")
            case 4:
                return qsTr("单点")
            case 5:
                return qsTr("浮点解")
            case 6:
                return qsTr("固定解")
            default:
                return _vehicles ? _vehicles.RtkMsg.rtkMsgFixType : ""
            }
        } else {
            return ""
        }
    }

    function gethead() {
        if (_vehicles) {
            if (parseInt(_vehicles.RtkMsg.rtkMsgYaw) > 0 && parseInt(
                        _vehicles.RtkMsg.rtkMsgYaw) < 36000)
                return (parseInt(_vehicles.RtkMsg.rtkMsgYaw) * 0.01).toFixed(1)
            else if (parseInt(_vehicles.RtkMsg.rtkMsgYaw) === 0) {
                return qsTr("无侧向")
            } else if (parseInt(_vehicles.RtkMsg.rtkMsgYaw) === 65535) {
                return qsTr("无侧向")
            } else {
                return ""
            }
        } else {
            return ""
        }
    }

    function getsignal() {

        if (_activeVehicle) {
            if (_activeVehicle.single_value === 0) {
                return "/qmlimages/icon/rc_0.png"
            }
            if (_activeVehicle.single_value === 1) {
                return "/qmlimages/icon/rc_1.png"
            }
            if (_activeVehicle.single_value === 2) {
                return "/qmlimages/icon/rc_2.png"
            }
            if (_activeVehicle.single_value === 3) {
                return "/qmlimages/icon/rc_3.png"
            }
            if (_activeVehicle.single_value === 4) {
                return "/qmlimages/icon/rc_4.png"
            }
            if (_activeVehicle.single_value >= 5) {
                return "/qmlimages/icon/rc_5.png"
            }
        } else {
            return "/qmlimages/icon/rc_0.png"
        }
    }
}
