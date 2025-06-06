

/****************************************************************************
 *
 * (c) 2009-2020 VKGroundControl PROJECT <http://www.VKGroundControl.org>
 *
 * VKGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick
import QtQuick.Controls

import VKGroundControl
import FlightDisplay
import FlightMap
import ScreenTools
import Controls

Item {
    id: root
    clip: true

    property bool useSmallFont: true

    property double _ar: VKGroundControl.videoManager.gstreamerEnabled ? VKGroundControl.videoManager.videoSize.width / VKGroundControl.videoManager.videoSize.height : VKGroundControl.videoManager.aspectRatio
    property bool _showGrid: VKGroundControl.settingsManager.videoSettings.gridLines.rawValue
    property var _dynamicCameras: globals.activeVehicle ? globals.activeVehicle.cameraManager : null
    property bool _connected: globals.activeVehicle ? !globals.activeVehicle.communicationLost : false
    property int _curCameraIndex: _dynamicCameras ? _dynamicCameras.currentCamera : 0
    property bool _isCamera: _dynamicCameras ? _dynamicCameras.cameras.count > 0 : false
    property var _camera: _isCamera ? _dynamicCameras.cameras.get(
                                          _curCameraIndex) : null
    property bool _hasZoom: _camera && _camera.hasZoom
    property int _fitMode: VKGroundControl.settingsManager.videoSettings.videoFit.rawValue

    property bool _isMode_FIT_WIDTH: _fitMode === 0
    property bool _isMode_FIT_HEIGHT: _fitMode === 1
    property bool _isMode_FILL: _fitMode === 2
    property bool _isMode_NO_CROP: _fitMode === 3

    function getWidth() {
        return videoBackground.getWidth()
    }
    function getHeight() {
        return videoBackground.getHeight()
    }

    property double _thermalHeightFactor: 0.85 //-- TODO

    Image {
        id: noVideo
        anchors.fill: parent
        source: "/qmlimages/icon/NoVideoBackground.jpg"
        fillMode: Image.PreserveAspectCrop
        visible: !(VKGroundControl.videoManager.decoding)

        Rectangle {
            anchors.centerIn: parent
            width: noVideoLabel.contentWidth + ScreenTools.defaultFontPixelHeight
            height: noVideoLabel.contentHeight + ScreenTools.defaultFontPixelHeight
            radius: ScreenTools.defaultFontPixelWidth / 2
            color: "black"
            opacity: 0.5
        }

        VKLabel {
            id: noVideoLabel
            text: VKGroundControl.settingsManager.videoSettings.streamEnabled.rawValue ? qsTr("WAITING FOR VIDEO") : qsTr("VIDEO DISABLED")
            font.bold: true
            color: "white"
            font.pointSize: useSmallFont ? ScreenTools.smallFontPointSize : ScreenTools.largeFontPointSize
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: videoBackground
        anchors.fill: parent
        color: "black"
        visible: VKGroundControl.videoManager.decoding
        function getWidth() {
            if (_ar != 0.0) {
                if (_isMode_FIT_HEIGHT || (_isMode_FILL
                                           && (root.width / root.height < _ar))
                        || (_isMode_NO_CROP
                            && (root.width / root.height > _ar))) {
                    // This return value has different implications depending on the mode
                    // For FIT_HEIGHT and FILL
                    //    makes so the video width will be larger than (or equal to) the screen width
                    // For NO_CROP Mode
                    //    makes so the video width will be smaller than (or equal to) the screen width
                    return root.height * _ar
                }
            }
            return root.width
        }
        function getHeight() {
            if (_ar != 0.0) {
                if (_isMode_FIT_WIDTH || (_isMode_FILL
                                          && (root.width / root.height > _ar))
                        || (_isMode_NO_CROP
                            && (root.width / root.height < _ar))) {
                    // This return value has different implications depending on the mode
                    // For FIT_WIDTH and FILL
                    //    makes so the video height will be larger than (or equal to) the screen height
                    // For NO_CROP Mode
                    //    makes so the video height will be smaller than (or equal to) the screen height
                    return root.width * (1 / _ar)
                }
            }
            return root.height
        }
        Component {
            id: videoBackgroundComponent
            VKVideoBackground {
                id: videoContent
                objectName: "videoContent"

                Connections {
                    target: VKGroundControl.videoManager
                    function onImageFileChanged() {
                        videoContent.grabToImage(function (result) {
                            if (!result.saveToFile(
                                        VKGroundControl.videoManager.imageFile)) {
                                console.error('Error capturing video frame')
                            }
                        })
                    }
                }
                Rectangle {
                    color: Qt.rgba(1, 1, 1, 0.5)
                    height: parent.height
                    width: 1
                    x: parent.width * 0.33
                    visible: _showGrid
                             && !VKGroundControl.videoManager.fullScreen
                }
                Rectangle {
                    color: Qt.rgba(1, 1, 1, 0.5)
                    height: parent.height
                    width: 1
                    x: parent.width * 0.66
                    visible: _showGrid
                             && !VKGroundControl.videoManager.fullScreen
                }
                Rectangle {
                    color: Qt.rgba(1, 1, 1, 0.5)
                    width: parent.width
                    height: 1
                    y: parent.height * 0.33
                    visible: _showGrid
                             && !VKGroundControl.videoManager.fullScreen
                }
                Rectangle {
                    color: Qt.rgba(1, 1, 1, 0.5)
                    width: parent.width
                    height: 1
                    y: parent.height * 0.66
                    visible: _showGrid
                             && !VKGroundControl.videoManager.fullScreen
                }
            }
        }
        Loader {
            // GStreamer is causing crashes on Lenovo laptop OpenGL Intel drivers. In order to workaround this
            // we don't load a vkVideoBackground object when video is disabled. This prevents any video rendering
            // code from running. Hence the Loader to completely remove it.
            height: parent.getHeight()
            width: parent.getWidth()
            anchors.centerIn: parent
            visible: VKGroundControl.videoManager.decoding
            sourceComponent: videoBackgroundComponent

            property bool videoDisabled: VKGroundControl.settingsManager.videoSettings.videoSource.rawValue === VKGroundControl.settingsManager.videoSettings.disabledVideoSource
        }

        //-- Thermal Image
        Item {
            id: thermalItem
            width: height * VKGroundControl.videoManager.thermalAspectRatio
            height: _camera ? (_camera.thermalMode === MavlinkCameraControl.THERMAL_FULL ? parent.height : (_camera.thermalMode === MavlinkCameraControl.THERMAL_PIP ? ScreenTools.defaultFontPixelHeight * 12 : parent.height * _thermalHeightFactor)) : 0
            anchors.centerIn: parent
            visible: VKGroundControl.videoManager.hasThermal
                     && _camera.thermalMode !== MavlinkCameraControl.THERMAL_OFF
            function pipOrNot() {
                if (_camera) {
                    if (_camera.thermalMode === MavlinkCameraControl.THERMAL_PIP) {
                        anchors.centerIn = undefined
                        anchors.top = parent.top
                        anchors.topMargin = mainWindow.header.height
                                + (ScreenTools.defaultFontPixelHeight * 0.5)
                        anchors.left = parent.left
                        anchors.leftMargin = ScreenTools.defaultFontPixelWidth * 12
                    } else {
                        anchors.top = undefined
                        anchors.topMargin = undefined
                        anchors.left = undefined
                        anchors.leftMargin = undefined
                        anchors.centerIn = parent
                    }
                }
            }
            Connections {
                target: _camera
                onThermalModeChanged: thermalItem.pipOrNot()
            }
            onVisibleChanged: {
                thermalItem.pipOrNot()
            }
            VKVideoBackground {
                id: thermalVideo
                objectName: "thermalVideo"
                anchors.fill: parent
                opacity: _camera ? (_camera.thermalMode === MavlinkCameraControl.THERMAL_BLEND ? _camera.thermalOpacity / 100 : 1.0) : 0
            }
        }
        //-- Zoom
        PinchArea {
            id: pinchZoom
            enabled: _hasZoom
            anchors.fill: parent
            onPinchStarted: pinchZoom.zoom = 0
            onPinchUpdated: {
                if (_hasZoom) {
                    var z = 0
                    if (pinch.scale < 1) {
                        z = Math.round(pinch.scale * -10)
                    } else {
                        z = Math.round(pinch.scale)
                    }
                    if (pinchZoom.zoom != z) {
                        _camera.stepZoom(z)
                    }
                }
            }
            property int zoom: 0
        }
    }
}
