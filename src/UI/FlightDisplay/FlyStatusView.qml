
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
                        VkSdkInstance.vehicleManager.activeVehicle.downloadMission(
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
                              for (var i = 0; i < areaListModel.path().length; i++) {
                                    let latLng = areaListModel.path()[i]
                                    missionModel.addwppts(i + 1, latLng.longitude,
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
                              for (var i = 0; i < scanListModel.path().length; i++) {
                                    let latLng = scanListModel.path()[i]
                                    missionModel.addwppts(i + 1, latLng.longitude,
                                                          latLng.latitude,
                                                          guanxian.waypointAltitude,
                                                          guanxian.hoverTime,
                                                          guanxian.waypointSpeed, 1,
                                                          guanxian.missionMode,
                                                          guanxian.photoModeValue, 0)
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
                        VkSdkInstance.vehicleManager.activeVehicle.uploadMissionModel(
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

      //左侧航点属性框
      Row {
            z: 100
            height: parent.height
            width: ScreenTools.scaleWidth * 0.35 + 65 * ScreenTools.scaleWidth
            visible: mapControl.add_type !== 0
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

      //飞行页面设置页面
      FlyViewRightSetWindow {
            id: flyviewrightset
            height: parent.height
            z: 100
      }
      FlyViewMsgPanel {
            id: yibiao
            width: 800 * ScreenTools.scaleWidth
            height: 200 * ScreenTools.scaleWidth
            anchors.bottomMargin: 10 * ScreenTools.scaleWidth
            anchors.bottom: parent.bottom
            anchors.leftMargin: 400 * ScreenTools.scaleWidth
            anchors.left: parent.left
            //visible: showidwindow===1
            //visible:video_visible===false&showidwindow===1&( mainWindow.application_setting_id===3112 || mainWindow.application_setting_id===41 || mainWindow.application_setting_id==10|| mainWindow.application_setting_id===11|| mainWindow.application_setting_id==12|| mainWindow.application_setting_id==20|| mainWindow.application_setting_id==21||  mainWindow.application_setting_id==112|| mainWindow.application_setting_id==122|| mainWindow.application_setting_id==212|| mainWindow.application_setting_id==222)
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

      WaypointSettingsDialog {
            id: xunchapoint
            width: 800 * sw
            anchors.centerIn: parent
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

}
