import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VKGroundControl
import ScreenTools
import VkSdkInstance
// 工厂设置主界面
Item {
    id: driveMain
    width: parent.width
    height: parent.height

    // ===== 属性定义 =====
    property var _Vehicle : VkSdkInstance.vehicleManager.activeVehicle

    property var comversions: _activeVehicle ? _activeVehicle.comversions : new Array(6)

    // 版本检查URL常量
    readonly property string v12UpdateUrl: "http://vk-fly.com:8081/v12_rbl_update_folder/updata.txt"
    readonly property string v10ProUpdateUrl: "http://vk-fly.com:8081/v10_3rbl_update_folder/updata.txt"
    readonly property string apkUpdateUrl: "http://vk-fly.com:8081/v10_apk_update_folder/updata.txt"
    readonly property real marginSpacing: 24 * ScreenTools.scaleWidth
    signal setOnlick(var selID)

    Component.onCompleted: {
        if (Qt.platform.os === "android") {
            checkVersionapk()
        }
    }
    Rectangle{
        anchors.fill: parent
        color:"lightgray"
    }
    /**
     * 检查飞控固件版本
     * @param {string} type - 设备类型，如 "V12" 或 "V10Pro"
     */
    function checkVersion(type) {
        var url = type === "V12" ? v12UpdateUrl : type === "V10Pro" ? v10ProUpdateUrl : ""

        if (!url)
            return

        sendVersionRequest(url, function (response) {
            var remoteVersion = response.versoncode
            var blacklist = response.blacklist || []

            // 更新飞控固件版本信息
            updateVersionInfo({
                                  "infoIndex": 1,
                                  "currentVersion": title_uav.deviceInfos[1].value,
                                  "remoteVersion": remoteVersion,
                                  "blacklist": blacklist,
                                  "updateFlag": "have_fcu_update",
                                  "updateMessage": qsTr("当前飞控固件需要升级后在进行飞行！")
                              })
        })
    }


    /**
     * 检查APK版本
     */
    function checkVersionapk() {
        sendVersionRequest(apkUpdateUrl, function (response) {
            var remoteVersion = response.versoncode
            var blacklist = response.blacklist || []

            // 更新APK版本信息
            updateVersionInfo({
                                  "infoIndex": 2,
                                  "currentVersion": mainWindow.appversion,
                                  "remoteVersion": remoteVersion,
                                  "blacklist": blacklist,
                                  "updateFlag": "have_apk_update",
                                  "updateMessage": qsTr("当前地面站软件需要升级，请升级后在进行作业")
                              })
        })
    }


    /**
     * 发送版本检查请求
     * @param {string} url - 请求URL
     * @param {function} callback - 成功回调函数
     */
    function sendVersionRequest(url, callback) {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", url, true)
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText)
                    callback(response)
                }
            }
        }
        xhr.send()
    }


    /**
     * 更新版本信息
     * @param {Object} params - 更新参数
     */
    function updateVersionInfo(params) {
        var updatedInfos = title_uav.deviceInfos

        if (isBlacklisted(params.currentVersion, params.blacklist)) {
            // 版本在黑名单中，必须更新
            updatedInfos[params.infoIndex].hasUpdate = true
            title_uav.deviceInfos = updatedInfos

            // 显示更新提示
            messageboxs.messageText = params.updateMessage
            messageboxs.sendId = ""
            messageboxs.parameterY = 0
            messageboxs.messageType = 1
            if (params.updateFlag) {
                eval(params.updateFlag + " = true")
            }
            messageboxs.open()
        } else {
            // 检查版本是否需要更新
            var needUpdate = compareVersions(params.currentVersion,
                                             params.remoteVersion)
            updatedInfos[params.infoIndex].hasUpdate = needUpdate
            title_uav.deviceInfos = updatedInfos

            if (needUpdate && params.updateFlag) {
                eval(params.updateFlag + " = true")
            }
        }
    }


    /**
     * 判断当前版本是否在黑名单中
     * @param {string} version - 当前版本号
     * @param {Array} blacklist - 黑名单列表
     * @return {boolean} 是否在黑名单中
     */
    function isBlacklisted(version, blacklist) {
        for (var i = 0; i < blacklist.length; i++) {
            if (blacklist[i] === version) {
                return true // 当前版本在黑名单中
            }
        }
        return false // 当前版本不在黑名单中
    }


    /**
     * 版本号比较函数
     * @param {string} localVersion - 本地版本号
     * @param {string} remoteVersion - 远程版本号
     * @return {boolean} 远程版本是否更高
     */
    function compareVersions(localVersion, remoteVersion) {
        // 分割版本号并转换为数字进行逐段比较
        var localParts = localVersion.split(".")
        var remoteParts = remoteVersion.split(".")

        for (var i = 0; i < Math.max(localParts.length,
                                     remoteParts.length); i++) {
            var localPart = parseInt(localParts[i] || "0")
            var remotePart = parseInt(remoteParts[i] || "0")

            if (remotePart > localPart) {
                return true // 远程版本较高
            } else if (remotePart < localPart) {
                return false // 本地版本较高
            }
        }
        return false // 版本相同
    }

    // ===== 数据更新处理 =====
    onComversionsChanged: {
        // 处理电池信息
        if (["10", "11", "12", "13", "14", "15"].includes(comversions[0])) {
            battery_id.deviceInfos = [{
                                          "name": qsTr("电池厂家"),
                                          "value": comversions[4],
                                          "hasUpdate": false
                                      }]
        }

        // 处理雷达信息
        updateRadarInfo(comversions[0], comversions[2])

        // 处理飞控信息
        if (comversions[0] === "1") {
            title_uav.deviceInfos = [{
                                         "name": qsTr("飞控序列号"),
                                         "value": comversions[3],
                                         "hasUpdate": false
                                     }, {
                                         "name": qsTr("飞控固件版本"),
                                         "value": comversions[2],
                                         "hasUpdate": false
                                     }, {
                                         "name": qsTr("APP版本号"),
                                         "value": mainWindow.appversion,
                                         "hasUpdate": false
                                     }, {
                                         "name": qsTr("设备型号"),
                                         "value": comversions[5],
                                         "hasUpdate": false
                                     }]
            checkVersion(comversions[5])
        }
    }


    /**
     * 更新雷达信息
     * @param {string} type - 雷达类型
     * @param {string} version - 雷达版本
     */
    function updateRadarInfo(type, version) {
        var radarInfo = [{
                             "name": qsTr("前避障雷达"),
                             "value": "",
                             "hasUpdate": false
                         }, {
                             "name": qsTr("后避障雷达"),
                             "value": "",
                             "hasUpdate": false
                         }, {
                             "name": qsTr("仿地雷达"),
                             "value": "",
                             "hasUpdate": false
                         }]

        // 根据类型更新对应雷达信息
        if (type === "5") {
            radarInfo[0].value = version
        } else if (type === "6") {
            radarInfo[1].value = version
        } else if (type === "7") {
            radarInfo[2].value = version
        }

        radar_id.deviceInfos = radarInfo
    }

    // ===== UI布局 =====
    GridLayout {
        anchors.fill: parent
        anchors.margins: marginSpacing
        columnSpacing: marginSpacing
        rowSpacing: marginSpacing
        columns: 3
        rows: 2

        // 遥控器按钮
        DeviceButton {
            id: bt_rc
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.row: 0
            Layout.column: 0
            buttonText: qsTr("遥控器")
            iconSource: "/qmlimages/icon/rc_select_u.png"
            selectedIconSource: "/qmlimages/icon/rc_select_d.png"
            deviceInfos: [{
                    "name": qsTr("型号"),
                    "value": "",
                    "hasUpdate": false
                }, {
                    "name": qsTr("摇杆模式"),
                    "value": "",
                    "hasUpdate": false
                }]
            onClicked: setOnlick(1)
        }

        // 飞控按钮
        DeviceButton {
            id: bt_uav
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.row: 0
            Layout.column: 1
            buttonText: qsTr("飞控")
            iconSource: "/qmlimages/icon/plane_select_u.png"
            selectedIconSource: "/qmlimages/icon/plane_select_d.png"
            deviceInfoComponent: title_uav
            deviceInfos: [{
                    "name": qsTr("飞控序列号"),
                    "value": _Vehicle ? _Vehicle.FlightController.serialNumber : "--------",
                    "hasUpdate": false
                }, {
                    "name": qsTr("飞控固件版本"),
                    "value": _Vehicle ? _Vehicle.FlightController.firmwareVersion : "--------",
                    "hasUpdate": false
                }, {
                    "name": qsTr("APP版本号"),
                    "value": mainWindow.appversion,
                    "hasUpdate": false
                }, {
                    "name": qsTr("设备型号"),
                    "value": _Vehicle ? _Vehicle.FlightController.deviceModel : "--------",
                    "hasUpdate": false
                }]
            onClicked: {
                setOnlick(2)
                _activeVehicle.sendversion()
                _activeVehicle.getcompoidversion()
            }
        }

        // 电池按钮
        DeviceButton {
            id: bt_battery
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.row: 0
            Layout.column: 2
            buttonText: qsTr("电池")
            iconSource: "/qmlimages/icon/battery_u.png"
            selectedIconSource: "/qmlimages/icon/battery_d.png"
            deviceInfoComponent: battery_id
            deviceInfos: [{
                    "name": qsTr("电池厂家"),
                    "value": "",
                    "hasUpdate": false
                }]
            onClicked: setOnlick(3)
        }

        // 吊舱按钮
        DeviceButton {
            id: bt_camera
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.row: 1
            Layout.column: 0
            buttonText: qsTr("吊舱")
            iconSource: "/qmlimages/icon/camera_u.png"
            selectedIconSource: "/qmlimages/icon/camera_d.png"
            deviceInfos: []
            onClicked: setOnlick(4)
        }

        // 载荷按钮
        DeviceButton {
            id: bt_paotou
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.row: 1
            Layout.column: 1
            buttonText: qsTr("载荷")
            iconSource: "/qmlimages/icon/paotouqi.png"
            selectedIconSource: "/qmlimages/icon/paotouqi.png"
            deviceInfos: []
            onClicked: setOnlick(5)
        }

        // 雷达按钮
        DeviceButton {
            id: bt_Radar
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.row: 1
            Layout.column: 2
            buttonText: qsTr("雷达")
            iconSource: "/qmlimages/icon/radar.png"
            selectedIconSource: "/qmlimages/icon/radar.png"
            deviceInfoComponent: radar_id
            deviceInfos: [{
                    "name": qsTr("前避障雷达"),
                    "value": "",
                    "hasUpdate": false
                }, {
                    "name": qsTr("后避障雷达"),
                    "value": "",
                    "hasUpdate": false
                }, {
                    "name": qsTr("仿地雷达"),
                    "value": "",
                    "hasUpdate": false
                }]
            onClicked: setOnlick(6)
        }
    }

}
