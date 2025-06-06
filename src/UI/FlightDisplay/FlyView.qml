
/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

import QtLocation
import QtPositioning
import QtQuick.Window
import QtQml.Models

import VKGroundControl
import Controls
import ScreenTools
import VKGroundControl.MissionModel 1.0
import VKGroundControl.ScanMissionModel 1.0
import VKGroundControl.AreaMissionModel 1.0
import VkSdkInstance 1.0

Item {
      id: _root
      property var _videoSettings: VKGroundControl.settingsManager.videoSettings
      property real _fullItemZorder: 0
      property real _pipItemZorder: 25
      property bool _mainWindowIsMap: mapControl.pipState.state === mapControl.pipState.fullState
      property bool _isFullWindowItemDark: _mainWindowIsMap ? mapControl.isSatelliteMap : true
      property int button_height: 50 * ScreenTools.scaleWidth
      property int right_button_status: 0
      property bool isleftsetbool: true
      //报警信息相关属性
      property int baojingerror1: _vehicles ? _vehicles.sysStatus.errorCount1 : 0
      property int baojingerror2: _vehicles ? _vehicles.sysStatus.errorCount2 : 0
      property int baojingerror3: _vehicles ? _vehicles.sysStatus.errorCount3 : 0
      property var _vehicles: VkSdkInstance.vehicleManager.vehicles[0]
      property var rc_rssi_status: _vehicles.rcChannels
      property var msgqingxie: _vehicles.qingxieBms
      property var msgecu_cell: ecu_cell[8]
      property var gps_status: _vehicles.GNSS1
      property var rtk_status: _vehicles.RtkMsg
      property var bms_status: _vehicles.bmsStatus

      Component.onCompleted: {
            _videoSettings.videoSource.value = "RTSP Video Stream"
            _videoSettings.rtspUrl.value = "rtsp://192.168.144.119/554"
      }
      onBaojingerror1Changed: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2,
                                          baojingerror3)
      }
      onBaojingerror2Changed: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2,
                                          baojingerror3)
      }
      onBaojingerror3Changed: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2,
                                          baojingerror3)
      }
      onMsgecu_cellChanged: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2,
                                          baojingerror3)
      }
      onMsgqingxieChanged: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2,
                                          baojingerror3)
      }
      onRc_rssi_statusChanged: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2,
                                          baojingerror3)
      }

      //property type name: value
      onGps_statusChanged: {
            if (gps_status === 0) {
                  if (_activeVehicle.gps_intraw1[19] === 1) {
                        gnss1.text = mainWindow.dingweimode
                                    === "beidou" ? qsTr("北斗-A:%1").arg(
                                                         _activeVehicle.gps_intraw1[9]) : qsTr(
                                                         "GNSS-A:%1").arg(
                                                         _activeVehicle.gps_intraw1[9])
                        gnss1.color = "white"
                  } else {
                        gnss1.text = mainWindow.dingweimode
                                    === "beidou" ? qsTr("北斗-A:未连接") : qsTr(
                                                         "GNSS-A:未连接")
                        gnss1.color = "red"
                  }
            }
            if (gps_status === 1) {
                  if (_activeVehicle.gps_intraw1[19] === 1) {
                        gnss2.text = mainWindow.dingweimode
                                    === "beidou" ? qsTr("北斗-B:%1").arg(
                                                         _activeVehicle.gps_intraw1[9]) : qsTr(
                                                         "GNSS-B:%1").arg(
                                                         _activeVehicle.gps_intraw1[9])
                        gnss2.color = "white"
                  } else {
                        gnss2.text = mainWindow.dingweimode
                                    === "beidou" ? qsTr("北斗-B:未连接") : qsTr(
                                                         "GNSS-B:未连接")
                        gnss2.color = "red"
                  }
            }
            parsedErrors = parseSysError1(baojingerror1, baojingerror2,
                                          baojingerror3)
      }
      onRtk_statusChanged: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2,
                                          baojingerror3)
      }
      onBms_statusChanged: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2,
                                          baojingerror3)
      }

      MissionModel {
            id: missionModel
      }

      ScanMissionModel {
            id: scanListModel
      }

      AreaMissionModel {
            id: areaListModel
      }

      VKPipOverlay {
            id: _pipOverlay
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 0
            item1IsFullSettingsKey: "MainFlyWindowIsMap"
            item1: mapControl
            item2: videoControl
            fullZOrder: _fullItemZorder
            pipZOrder: _pipItemZorder
            show: !VKGroundControl.videoManager.fullScreen
                  && (videoControl.pipState.state === videoControl.pipState.pipState
                      || mapControl.pipState.state === mapControl.pipState.pipState)
      }

      FlyViewCustomLayer {
            id: customOverlay
            z: _fullItemZorder + 2
            mapControl: mapControl

            visible: !VKGroundControl.videoManager.fullScreen
      }

      FlyViewMap {
            id: mapControl
            pipMode: !_mainWindowIsMap
            toolInsets: customOverlay.totalToolInsets
            mapName: "FlightDisplayView"
      }

      FlyViewVideo {
            id: videoControl
      }

      //飞行页面右侧主界面按钮
      Column {
            visible: right_button_status === 0
            anchors {
                  verticalCenter: parent.verticalCenter
                  right: parent.right
                  rightMargin: 65 * ScreenTools.scaleWidth
            }
            spacing: 20 * ScreenTools.scaleWidth

            TextButton {
                  buttonText: qsTr("规划任务")
                  height: button_height
                  width: 200 * ScreenTools.scaleWidth
                  onClicked: {
                        vkxuncha_msg.open()
                  }
            }
            TextButton {
                  buttonText: qsTr("执行任务")
                  height: button_height
                  width: 200 * ScreenTools.scaleWidth
                  onClicked: {
                        right_button_status = 3
                        VkSdkInstance.vehicleManager.vehicles[0].downloadMission(
                                          missionModel)
                  }
            }
            TextButton {
                  buttonText: qsTr("清空任务")
                  enabled: missionModel.itemCount > 0
                  height: button_height
                  width: 200 * ScreenTools.scaleWidth
                  onClicked: {
                        if (missionModel.itemCount >= 0) {
                              missionModel.clear()
                        }
                  }
            }
      }
      //区域规划和带状规划按钮
      Column {
            visible: right_button_status === 1
            anchors {
                  verticalCenter: parent.verticalCenter
                  right: parent.right
                  rightMargin: 65 * ScreenTools.scaleWidth
            }
            spacing: 20 * ScreenTools.scaleWidth

            TextButton {
                  buttonText: qsTr("生成航线")
                  height: button_height
                  width: 200 * ScreenTools.scaleWidth
                  onClicked: {
                        if (mapControl.add_type === 3) {
                              missionModel.clear()
                              for (var i = 0; i < areaListModel.path(
                                         ).length; i++) {
                                    let latLng = areaListModel.path()[i]
                                    missionModel.addwppts(
                                                      i + 1, latLng.longitude,
                                                      latLng.latitude,
                                                      areaSet.waypointAltitude,
                                                      areaSet.hoverTime,
                                                      areaSet.waypointSpeed, 1,
                                                      areaSet.waypointPhotoMode,
                                                      areaSet.photoModeValue, 0)
                              }
                              areaListModel.clear()
                              mapControl.add_type = 1
                        }
                        if (mapControl.add_type === 2) {
                              //missionModel.clear()
                              missionModel.clear()
                              for (var i = 0; i < scanListModel.path(
                                         ).length; i++) {
                                    let latLng = scanListModel.path()[i]
                                    missionModel.addwppts(
                                                      i + 1, latLng.longitude,
                                                      latLng.latitude,
                                                      guanxian.waypointAltitude,
                                                      guanxian.hoverTime,
                                                      guanxian.waypointSpeed,
                                                      1, guanxian.missionMode,
                                                      guanxian.photoModeValue,
                                                      0)
                              }
                              scanListModel.clear()
                              mapControl.add_type = 1
                        }
                        right_button_status = 2
                  }
            }
            TextButton {
                  buttonText: qsTr("返回")
                  height: button_height
                  width: 200 * ScreenTools.scaleWidth
                  onClicked: {
                        areaListModel.clear()
                        scanListModel.clear()
                        right_button_status = 0
                        mapControl.add_type = 0
                  }
            }
      }
      //上传航线按钮
      Column {
            visible: right_button_status === 2
            anchors {
                  verticalCenter: parent.verticalCenter
                  right: parent.right
                  rightMargin: 65 * ScreenTools.scaleWidth
            }
            spacing: 20 * ScreenTools.scaleWidth

            TextButton {
                  buttonText: qsTr("上传航点")
                  height: button_height
                  width: 200 * ScreenTools.scaleWidth
                  onClicked: {
                        VkSdkInstance.vehicleManager.vehicles[0].uploadMissionModel(
                                          missionModel)
                        mapControl.add_type = 0
                        right_button_status = 3 //显示执行页面
                  }
            }

            TextButton {
                  buttonText: qsTr("返回")
                  height: button_height
                  width: 200 * ScreenTools.scaleWidth
                  onClicked: {
                        right_button_status = 0
                        missionModel.clear()
                        mapControl.add_type = 0
                  }
            }
      }
      //执行任务页面按钮
      Column {
            visible: right_button_status === 3
            anchors {
                  verticalCenter: parent.verticalCenter
                  right: parent.right
                  rightMargin: 65 * ScreenTools.scaleWidth
            }
            spacing: 20 * ScreenTools.scaleWidth

            TextButton {
                  buttonText: qsTr("开始航线")
                  height: button_height
                  width: 200 * ScreenTools.scaleWidth
                  onClicked: {
                        vk_start.open()
                  }
            }
            TextButton {
                  buttonText: qsTr("返航")
                  height: button_height
                  width: 200 * ScreenTools.scaleWidth
                  onClicked: {
                        vkreturn.open()
                  }
            }
            TextButton {
                  buttonText: qsTr("返回")
                  //enabled:  customListModel.itemCount>0
                  height: button_height
                  width: 200 * ScreenTools.scaleWidth
                  onClicked: {
                        right_button_status = 0
                        mapControl.add_type = 0
                  }
            }
      }

      //飞行页面设置页面
      FlyViewRightSetWindow {
            id: flyviewrightset
            height: parent.height
            z: 100
      }
      //左侧航点属性框
      Row {
            z: 100
            height: parent.height
            width: ScreenTools.scaleWidth * 0.35 + 65 * ScreenTools.scaleWidth
            visible: mainWindow.isMainWindow() && mapControl.add_type !== 0
            Item {
                  width: mainWindow.width * 0.35
                  height: parent.height
                  visible: isleftsetbool
                  Rectangle {
                        width: mainWindow.width * 0.35
                        color: "#C0000000"
                        height: parent.height
                        visible: isleftsetbool

                        Item {
                              width: mainWindow.width * 0.35 - 4
                              height: parent.height

                              WaypointListPanel {
                                    id: missionPointPanel
                                    visible: mapControl.add_type === 1
                                    width: mainWindow.width * 0.35 - 4
                                    height: parent.height
                              }

                              VKAreaSet {
                                    id: areaSet
                                    visible: mapControl.add_type === 3
                                    width: mainWindow.width * 0.35 - 4
                                    height: parent.height
                              }

                              SurveyLineSettings {
                                    id: guanxian
                                    visible: mapControl.add_type === 2
                                    width: mainWindow.width * 0.35 - 4
                                    height: parent.height
                              }
                        }
                  }
            }
            Button {
                  //anchors.right:parent.right
                  //id:setbt
                  height: 100 * ScreenTools.scaleWidth
                  width: 50 * ScreenTools.scaleWidth
                  anchors.verticalCenter: parent.verticalCenter
                  Image {
                        id: setbt_img3
                        anchors.fill: parent
                        source: "/qmlimages/icon/right_arrow.png"
                  }
                  background: Rectangle {
                        color: "transparent"
                  }
                  MouseArea {
                        anchors.fill: parent
                        onClicked: {

                              isleftsetbool = !isleftsetbool
                              if (isleftsetbool) {
                                    setbt_img3.source = "/qmlimages/icon/left_arrow.png"
                              } else {
                                    setbt_img3.source = "/qmlimages/icon/right_arrow.png"
                              }
                        }
                  }
            }
      }
      MissionTypeSelector {
            width: parent.width / 2
            id: vkxuncha_msg
            anchors.centerIn: parent
            onMissionTypeSelected: function (missionType) {
                  if (missionType === 1) {

                        mapControl.add_type = 1
                        right_button_status = 2
                  }
                  if (missionType === 2) {

                        mapControl.add_type = 2
                        right_button_status = 1
                  }
                  if (missionType === 3) {

                        mapControl.add_type = 3
                        right_button_status = 1
                  }
            }
      }

      FlyViewMsgPanel {
            id: yibiao
            width: 800 * ScreenTools.scaleWidth
            height: 200 * ScreenTools.scaleWidth
            // Rectangle{
            //   anchors.fill: parent
            //   color: "yellow"
            // }
            anchors.bottomMargin: 10 * ScreenTools.scaleWidth
            anchors.bottom: parent.bottom
            anchors.leftMargin: 400 * ScreenTools.scaleWidth
            anchors.left: parent.left

            //visible: showidwindow===1
            //visible:video_visible===false&showidwindow===1&( mainWindow.application_setting_id===3112 || mainWindow.application_setting_id===41 || mainWindow.application_setting_id==10|| mainWindow.application_setting_id===11|| mainWindow.application_setting_id==12|| mainWindow.application_setting_id==20|| mainWindow.application_setting_id==21||  mainWindow.application_setting_id==112|| mainWindow.application_setting_id==122|| mainWindow.application_setting_id==212|| mainWindow.application_setting_id==222)
      }

      VKStartMission {
            width: 800 * ScreenTools.scaleWidth
            id: vk_start
            anchors.centerIn: parent
      }

      VKReturn {
            width: 800 * ScreenTools.scaleWidth
            id: vkreturn
            anchors.centerIn: parent
      }

      WaypointSettingsDialog {
            id: xunchapoint
            width: 800 * sw
            anchors.centerIn: parent
      }

      ListView {
            //报警信息
            id: msg_id
            width: 300 * ScreenTools.scaleWidth
            height: 200 * ScreenTools.scaleWidth
            spacing: 5 * ScreenTools.scaleWidth
            model: parsedErrors
            delegate: Rectangle {
                  width: parent.width
                  height: 40 * ScreenTools.scaleWidth // Adjust height as per your requirement
                  radius: 5 * ScreenTools.scaleWidth
                  color: "red"
                  Text {
                        anchors.fill: parent
                        text: modelData // Use modelData to access each item in the model (dataArray)
                        font.pixelSize: 25 * ScreenTools.scaleWidth // Adjust font size as per your requirement
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "white"
                  }
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
}
