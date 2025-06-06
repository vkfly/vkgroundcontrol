

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
import QtLocation
import QtPositioning
import QtQuick.Dialogs
import QtQuick.Layouts

import VKGroundControl
import FlightDisplay
import FlightMap
import Controls
import ScreenTools

import VkSdkInstance

FlightMap {
    id: _root
    property Item pipState: _pipState
    property string mapName: 'defaultMap'
    property bool isSatelliteMap: activeMapType.name.indexOf("Satellite") > -1
                                  || activeMapType.name.indexOf("Hybrid") > -1
    property bool pipMode: false // true: map is shown in a small pip mode
    property var toolInsets
    // Insets for the center viewport area
    property bool _saveZoomLevelSetting: true
    property bool _disableVehicleTracking: false
    property real _toolsMargin: ScreenTools.defaultFontPixelWidth * 0.75

    property int add_type: 0
    property int currentIndex: -1
    property int mousex: 0
    property int mousey: 0
    readonly property int _decimalPlaces: 7
    property bool mousePressed: false

    VKPipState {
        id: _pipState
        pipOverlay: _pipOverlay
        isDark: _isFullWindowItemDark
    }

    function _adjustMapZoomForPipMode() {
        _saveZoomLevelSetting = false
        if (pipMode) {
            if (VKGroundControl.flightMapZoom > 3) {
                zoomLevel = VKGroundControl.flightMapZoom - 3
            }
        } else {
            zoomLevel = VKGroundControl.flightMapZoom
        }
        _saveZoomLevelSetting = true
    }

    onPipModeChanged: _adjustMapZoomForPipMode()

    onVisibleChanged: {
        if (visible) {
            center = VKGroundControl.flightMapPosition
        }
    }

    Timer {
        id: panRecenterTimer
        interval: 10000
        running: false
        onTriggered: {
            _disableVehicleTracking = false
            // updateMapToVehiclePosition()
        }
    }

    MapScale {
        id: mapScale
        anchors.margins: _toolsMargin
        anchors.left: parent.left
        anchors.top: parent.top
        mapControl: _root
        buttonsOnLeft: true
        // visible:            !ScreenTools.isTinyScreen && VKGroundControl.corePlugin.options.flyView.showMapScale && mapControl.pipState.state === mapControl.pipState.windowState
        visible: false
        property real centerInset: visible ? parent.height - y : 0
    }
    MapItemView {
        z: flightPath.z + 20
        parent: _root
        model: VkSdkInstance.vehicleManager.vehicles
        delegate: VehicleMapItem {
            coordinate: modelData.coordinate
            heading: modelData.attitude.attitudeYaw
            map: _root
            //size: pipMode ? ScreenTools.defaultFontPixelHeight*2.5 : ScreenTools.defaultFontPixelHeight * 3
            z: flightPath.z + 20
        }
    }

    //区域规划的周边点
    MapItemView {
        z: flightPath.z + 15
        parent: _root
        model: areaListModel
        delegate: MapQuickItem {
            id: mark_area
            coordinate: QtPositioning.coordinate(model.latitude,
                                                 model.longitude)
            anchorPoint.x: 15 * ScreenTools.scaleWidth
            anchorPoint.y: 15 * ScreenTools.scaleWidth
            sourceItem: Rectangle {
                width: 30 * ScreenTools.scaleWidth
                height: 30 * ScreenTools.scaleWidth
                radius: 15 * ScreenTools.scaleWidth
                color: "#00000000"
                border.width: 3 * ScreenTools.scaleWidth
                border.color: "white"

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    id: rect_1
                    width: 30 * ScreenTools.scaleWidth
                    height: 30 * ScreenTools.scaleWidth
                    radius: Math.min(width, height) / 2
                    color: "red"
                    border.width: 3 * ScreenTools.scaleWidth
                    border.color: "white"
                    MouseArea {
                        anchors.fill: parent
                        drag.target: mark_area
                        enabled: add_type === 3 // 确保 MouseArea 启用
                        hoverEnabled: true // 启用悬停效果
                        acceptedButtons: Qt.LeftButton
                        onPressed: function (mouse) {
                            if (add_type === 3) {
                                if (index >= 0) {
                                    currentIndex = index
                                    mousePressed = true
                                    mouse.accepted = true
                                }
                            }
                        }

                        onPositionChanged: {
                            if (add_type === 3) {
                                if (currentIndex >= 0 && currentIndex != -1) {
                                    if (mousePressed === true)
                                        areaListModel.updateWaypointById(
                                                    parseInt(currentIndex + 1),
                                                    mark_area.coordinate.longitude,
                                                    mark_area.coordinate.latitude)
                                    //mark.coordinate=mark.coordinate
                                }
                            }
                        }
                        onReleased: {
                            if (add_type === 3)
                                areaListModel.updateWaypointById(
                                            parseInt(currentIndex + 1),
                                            mark_area.coordinate.longitude,
                                            mark_area.coordinate.latitude)
                            mousePressed = false
                        }
                    }

                    Text {
                        id: text_id
                        text: model.id
                        font.pixelSize: 20 * ScreenTools.scaleWidth
                        font.bold: false
                        color: "white"
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

    //管线规划的周边点
    MapItemView {
        z: flightPath.z + 13
        parent: _root
        model: scanListModel
        delegate: MapQuickItem {
            coordinate: QtPositioning.coordinate(model.latitude,
                                                 model.longitude)
            anchorPoint.x: 15 * ScreenTools.scaleWidth
            anchorPoint.y: 15 * ScreenTools.scaleWidth
            id: mark_scan
            sourceItem: Rectangle {
                width: 30 * ScreenTools.scaleWidth
                height: 30 * ScreenTools.scaleWidth
                radius: 15 * ScreenTools.scaleWidth
                color: "#00000000"
                border.width: 3 * ScreenTools.scaleWidth
                border.color: "white"

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    // id:rect_1
                    width: 30 * ScreenTools.scaleWidth
                    height: 30 * ScreenTools.scaleWidth
                    radius: Math.min(width, height) / 2
                    color: "red" // 使鼠标事件能够穿透到底部的 MouseArea
                    border.width: 1
                    border.color: "white"
                    MouseArea {
                        anchors.fill: parent
                        drag.target: mark_scan
                        enabled: add_type === 2 // 确保 MouseArea 启用
                        hoverEnabled: true // 启用悬停效果
                        acceptedButtons: Qt.LeftButton
                        onPressed: function (mouse) {
                            if (add_type === 2) {

                                if (index >= 0) {
                                    currentIndex = index
                                    mousePressed = true
                                    mouse.accepted = true
                                }
                            }
                        }

                        onPositionChanged: {
                            if (add_type === 2) {
                                if (currentIndex >= 0 && currentIndex != -1) {
                                    if (mousePressed === true)
                                        scanListModel.updateWaypointById(
                                                    parseInt(currentIndex + 1),
                                                    mark_scan.coordinate.longitude,
                                                    mark_scan.coordinate.latitude)
                                    //mark.coordinate=mark.coordinate
                                }
                            }
                        }
                        onReleased: {
                            if (add_type === 2)
                                scanListModel.updateWaypointById(
                                            parseInt(currentIndex + 1),
                                            mark_scan.coordinate.longitude,
                                            mark_scan.coordinate.latitude)
                            mousePressed = false
                        }
                    }

                    Text {
                        //id:text_id
                        text: (model.id)
                        font.pixelSize: 20 * ScreenTools.scaleWidth
                        font.bold: false
                        color: "white"
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

    //手动添加航点航线
    MapItemView {
        id: map_add
        z: flightPath.z + 12
        parent: _root
        model: missionModel
        delegate: MapQuickItem {
            id: mark
            coordinate: QtPositioning.coordinate(model.latitude,
                                                 model.longitude)
            anchorPoint.x: 20 * ScreenTools.scaleWidth
            anchorPoint.y: 20 * ScreenTools.scaleWidth
            sourceItem: Rectangle {
                width: 40 * ScreenTools.scaleWidth
                height: 40 * ScreenTools.scaleWidth
                radius: 20 * ScreenTools.scaleWidth
                //border.width: 3*ScreenTools.scaleWidth
                // border.color:"white"
                color: "#00000000"
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    //id:rect_1
                    width: 30 * ScreenTools.scaleWidth
                    height: 30 * ScreenTools.scaleWidth
                    radius: Math.min(width, height) / 2
                    color: "green" // 使鼠标事件能够穿透到底部的 MouseArea
                    border.width: 2
                    border.color: "white"
                    MouseArea {
                        anchors.fill: parent
                        drag.target: mark
                        enabled: add_type === 1 // 确保 MouseArea 启用
                        hoverEnabled: true // 启用悬停效果
                        acceptedButtons: Qt.LeftButton
                        onPressed: {

                            if (add_type === 1) {

                                if (index >= 0) {
                                    currentIndex = index
                                    mousePressed = true
                                }
                            }
                        }

                        onPositionChanged: {
                            if (currentIndex >= 0 && currentIndex != -1) {
                                if (mousePressed === true) {
                                    missionModel.updateWaypointById(
                                                currentIndex,
                                                mark.coordinate.longitude,
                                                mark.coordinate.latitude)
                                }
                            }
                        }
                        onReleased: {
                            if (add_type === 1)
                                missionModel.updateWaypointById(
                                            currentIndex,
                                            mark.coordinate.longitude,
                                            mark.coordinate.latitude)
                            mousePressed = false
                        }
                    }
                    Text {
                        text: model.index + 1
                        font.pixelSize: 20 * ScreenTools.scaleWidth
                        font.bold: false
                        color: "white"
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

    //航点中间插入图标
    MapItemView {
        parent: _root
        z: flightPath.z + 2
        model: missionModel
        delegate: MapQuickItem {
            visible: model.dis > 10
            coordinate: QtPositioning.coordinate(model.center_latitude,
                                                 model.center_longintude)
            anchorPoint.x: rect_2.height / 2
            anchorPoint.y: rect_2.height / 2
            sourceItem: Rectangle {
                id: rect_2
                width: add_type === 1 ? 30 * ScreenTools.scaleWidth : 0
                height: add_type === 1 ? 30 * ScreenTools.scaleWidth : 0
                border.width: 3 * ScreenTools.scaleWidth
                border.color: "green"
                radius: Math.min(width, height) / 2
                color: "#00000000"
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    propagateComposedEvents: true
                    onClicked: {
                        //插入航点
                        if (add_type === 1) {
                            missionModel.insertAt(index)
                        }
                    }
                }

                Text {
                    id: text1
                    text: add_type === 1 ? "+" : ""
                    font.pixelSize: 24 * ScreenTools.scaleWidth
                    font.bold: false
                    color: "white"
                    anchors.centerIn: parent
                }
                Text {
                    text: model.dis + "m"
                    visible: model.dis > 5
                    font.pixelSize: 20 * ScreenTools.scaleWidth
                    font.bold: false
                    color: "white"
                    anchors.left: text1.right
                    anchors.leftMargin: 10 * ScreenTools.scaleWidth
                    anchors.verticalCenter: parent.verticalCenter
                    //anchors.centerIn: parent
                }
            }
        }
    }

    MapPolyline {
        id: flightPath
        parent: _root
        line.color: "yellow"
        line.width: 3
        path: missionModel.path
    }

    MapPolyline {
        id: flightPaths
        parent: _root
        line.color: "white"
        line.width: 3
        z: flightPath.z + 13
    }

    onMapClicked: {
        addPoint(position)
    }

    function addPoint(mouse) {
        var coordinate = _root.toCoordinate(Qt.point(mouse.x, mouse.y), false)
        coordinate.latitude = coordinate.latitude.toFixed(_decimalPlaces)
        coordinate.longitude = coordinate.longitude.toFixed(_decimalPlaces)
        if (add_type === 1) {
            //手动添加航点
            if (mousePressed == false) {
                _root.focus = true
                coordinate.latitude = coordinate.latitude.toFixed(
                            _decimalPlaces)
                coordinate.longitude = coordinate.longitude.toFixed(
                            _decimalPlaces)
                coordinate.altitude = coordinate.altitude.toFixed(
                            _decimalPlaces)
                var point = Qt.point(mouse.x, mouse.y)
                var coord = _root.toCoordinate(point)
                missionModel.addWpt(coordinate.longitude,
                                    coordinate.latitude) //添加B点
            }
        }
        if (add_type === 3) {

            //区域规划
            if (mousePressed == false) {
                _root.focus = true
                coordinate.latitude = coordinate.latitude.toFixed(
                            _decimalPlaces)
                coordinate.longitude = coordinate.longitude.toFixed(
                            _decimalPlaces)
                coordinate.altitude = coordinate.altitude.toFixed(
                            _decimalPlaces)
                var point = Qt.point(mouse.x, mouse.y)
                var coord = _root.toCoordinate(point)
                areaListModel.addWpt(coordinate.longitude, coordinate.latitude)
            }
        }
        if (add_type === 2) {
            //管线
            if (mousePressed == false) {
                _root.focus = true
                coordinate.latitude = coordinate.latitude.toFixed(
                            _decimalPlaces)
                coordinate.longitude = coordinate.longitude.toFixed(
                            _decimalPlaces)
                coordinate.altitude = coordinate.altitude.toFixed(
                            _decimalPlaces)

                // customListModel.setcentermodel(m_wptCenterModel)
                scanListModel.addWpt(coordinate.longitude,
                                     coordinate.latitude) //添加B点
                //scanListModel.addWpt(coordinate.longitude,coordinate.latitude)
                //var coordinate = mapView.coordinateAt(mouse.x, mouse.y);
                // 如果之前已经添加了标记点，先清除
            }
        }
        mousePressed = false
    }

    Connections {
        target: scanListModel
        onPathChanged: {
            flightPaths.path = scanListModel.path()
        }
    }
    Connections {
        target: areaListModel
        onPathChanged: {
            flightPaths.path = areaListModel.path()
        }
    }
}
