import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Controls
import ScreenTools

import "../Common"

BaseSettingPage {
    id: _root
    enum DeviceSettingType {
        Main,
        RcSet,
        FlightController,
        Battery,
        Camera,
        Payload,
        Radar
    }

    width: parent.width
    height: parent.height

    titleName: qsTr("设备管理")
    property int _currentType: DeviceManager.DeviceSettingType.Main
    signal goToMain

    handleReturn: function () {
        if (!isRoot()) {
            toRoot()
            titleName = qsTr("设备管理")
        } else {
            goToMain()
        }
    }

    Loader {
        id: pageLoader
        anchors.fill: parent
        sourceComponent: getPageComponent(_currentType)
    }

    DeviceManagerMainView {
        id: mainPage
        anchors.fill: parent
        visible: _currentType === DeviceManager.DeviceSettingType.Main
        onSetOnlick: function (selID) {
            _currentType = selID
            switch (selID) {
            case DeviceManager.DeviceSettingType.RcSet:
                titleName = qsTr("遥控器")
                break
            case DeviceManager.DeviceSettingType.FlightController:
                titleName = qsTr("飞控")
                break
            case DeviceManager.DeviceSettingType.Battery:
                titleName = qsTr("电池")
                break
            case DeviceManager.DeviceSettingType.Camera:
                titleName = qsTr("吊舱")
                break
            case DeviceManager.DeviceSettingType.Payload:
                titleName = qsTr("载荷")
                break
            case DeviceManager.DeviceSettingType.Radar:
                titleName = qsTr("雷达")
                break
            }
        }
    }

    function getPageComponent(index) {
        switch (index) {
        case 0:
            return null // 主页面单独处理
        case 1:
            return rcSetComponent
        case 2:
            return flightControllerComponent
        case 3:
            return batteryComponent
        case 4:
            return cameraComponent
        case 5:
            return payloadComponent
        case 6:
            return radarComponent
        default:
            return null
        }
    }

    function isRoot() {
        return _currentType === DeviceManager.DeviceSettingType.Main
    }

    function toRoot() {
        _currentType = DeviceManager.DeviceSettingType.Main
    }

    Component {
        id: rcSetComponent
        RCSet {}
    }

    Component {
        id: batteryComponent
        BatteryManagerPage {}
    }

    Component {
        id: cameraComponent
        CameraManagerPage {}
    }

    Component {
        id: flightControllerComponent
        FlightControllerManagerPage {}
    }

    Component {
        id: payloadComponent
        PayloadManagerPage {}
    }

    Component {
        id: radarComponent
        RadarManagerPage {}
    }
}
