
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
      property var _vehicles: VkSdkInstance.vehicleManager.activeVehicle
      property var rc_rssi_status: _vehicles.rcChannels
      property var msgqingxie: _vehicles.qingxieBms
      property var msgecu_cell: ecu_cell[8]
      property var gps_status: _vehicles.GNSS1
      property var rtk_status: _vehicles.RtkMsg
      property var bms_status: _vehicles.bmsStatus
      visible: false

      onBaojingerror1Changed: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2, baojingerror3)
      }
      onBaojingerror2Changed: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2, baojingerror3)
      }
      onBaojingerror3Changed: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2, baojingerror3)
      }
      onMsgecu_cellChanged: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2, baojingerror3)
      }
      onMsgqingxieChanged: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2, baojingerror3)
      }
      onRc_rssi_statusChanged: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2, baojingerror3)
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
                        gnss1.text = mainWindow.dingweimode === "beidou" ? qsTr("北斗-A:未连接") : qsTr(
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
                        gnss2.text = mainWindow.dingweimode === "beidou" ? qsTr("北斗-B:未连接") : qsTr(
                                                                                 "GNSS-B:未连接")
                        gnss2.color = "red"
                  }
            }
            parsedErrors = parseSysError1(baojingerror1, baojingerror2, baojingerror3)
      }
      onRtk_statusChanged: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2, baojingerror3)
      }
      onBms_statusChanged: {
            parsedErrors = parseSysError1(baojingerror1, baojingerror2, baojingerror3)
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
            show: (videoControl.pipState.state === videoControl.pipState.pipState
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

      FlyStatusView {
         anchors.fill: parent
         z:100
         visible: !VKGroundControl.videoManager.fullScreen
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
