

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
import QtQuick 2.3
import QtPositioning
import QtLocation

import VKGroundControl
import VkSdkInstance

Map {
    id: _map

    property bool allowVehicleLocationCenter: false
    property bool firstVehiclePositionReceived: false

    property var _activeVehicle: VkSdkInstance.vehicleManager.activeVehicle
    property var _activeVehicleCoordinate: _activeVehicle.coordinate

    plugin: Plugin {
        name: "QGroundControl"
    }
    opacity: 0.99 // https://bugreports.qt.io/browse/QTBUG-82185

    maximumZoomLevel: 20

    Component.onCompleted: {
        updateActiveMapType()
        _possiblyCenterToVehiclePosition()
    }

    onVisibleChanged: {
        if(visible) {
            _possiblyCenterToVehiclePosition()
        } else {
            firstVehiclePositionReceived = false
        }
    }

    function updateActiveMapType() {
        var settings = VKGroundControl.settingsManager.flightMapSettings
        var fullMapName = settings.mapProvider.value + " " + settings.mapType.value

        for (var i = 0; i < _map.supportedMapTypes.length; i++) {
            if (fullMapName === _map.supportedMapTypes[i].name) {
                _map.activeMapType = _map.supportedMapTypes[i]
                return
            }
        }
    }

    function _possiblyCenterToVehiclePosition() {
        if (!firstVehiclePositionReceived && allowVehicleLocationCenter
                && _activeVehicleCoordinate && _activeVehicleCoordinate.isValid) {
            firstVehiclePositionReceived = true
            center = _activeVehicleCoordinate
            zoomLevel = VKGroundControl.flightMapInitialZoom
        }
    }

    onMapReadyChanged: {
        if (mapReady) {
            updateActiveMapType()
            _possiblyCenterToVehiclePosition()
        }
    }

    Connections {
        target: VKGroundControl.settingsManager.flightMapSettings.mapType
        function onRawValueChanged() {
            updateActiveMapType()
        }
    }

    Connections {
        target: VKGroundControl.settingsManager.flightMapSettings.mapProvider
        function onRawValueChanged() {
            updateActiveMapType()
        }
    }

    signal mapPanStart
    signal mapPanStop
    signal mapClicked(var position)

    PinchHandler {
        id: pinchHandler
        target: null

        property var pinchStartCentroid

        onActiveChanged: {
            if (active) {
                pinchStartCentroid = _map.toCoordinate(
                            pinchHandler.centroid.position, false)
            }
        }
        onScaleChanged: delta => {
                            _map.zoomLevel += Math.log2(delta)
                            _map.alignCoordinateToPoint(
                                pinchStartCentroid,
                                pinchHandler.centroid.position)
                        }
    }

    WheelHandler {
        // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:
        // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler
        // and we don't yet distinguish mice and trackpads on Wayland either
        acceptedDevices: Qt.platform.pluginName === "cocoa"
                         || Qt.platform.pluginName
                         === "wayland" ? PointerDevice.Mouse
                                         | PointerDevice.TouchPad : PointerDevice.Mouse
        rotationScale: 1 / 120
        property: "zoomLevel"
    }

    MultiPointTouchArea {
        parent: map
        anchors.fill: parent
        maximumTouchPoints: 1
        mouseEnabled: true

        property bool dragActive: false
        property real lastMouseX
        property real lastMouseY

        onPressed: touchPoints => {
                       lastMouseX = touchPoints[0].x
                       lastMouseY = touchPoints[0].y
                   }

        onGestureStarted: gesture => {
                              dragActive = true
                              gesture.grab()
                              mapPanStart()
                          }

        onUpdated: touchPoints => {
                       if (dragActive) {
                           let deltaX = touchPoints[0].x - lastMouseX
                           let deltaY = touchPoints[0].y - lastMouseY
                           if (Math.abs(deltaX) >= 1.0 || Math.abs(
                                   deltaY) >= 1.0) {
                               _map.pan(lastMouseX - touchPoints[0].x,
                                        lastMouseY - touchPoints[0].y)
                               lastMouseX = touchPoints[0].x
                               lastMouseY = touchPoints[0].y
                           }
                       }
                   }

        onReleased: touchPoints => {
                        if (dragActive) {
                            _map.pan(lastMouseX - touchPoints[0].x,
                                     lastMouseY - touchPoints[0].y)
                            dragActive = false
                            mapPanStop()
                        } else {
                            mapClicked(Qt.point(touchPoints[0].x,
                                                touchPoints[0].y))
                        }
                    }
    }
}
