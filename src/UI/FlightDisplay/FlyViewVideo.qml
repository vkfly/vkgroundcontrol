

/****************************************************************************
 *
 * (c) 2009-2020 VKGroundControl PROJECT <http://www.VKGroundControl.org>
 *
 * VKGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick
import QtQuick.Window
import QtQuick.Controls

import VKGroundControl
import Controls
import ScreenTools

Item {
    id: _root
    visible: VKGroundControl.videoManager.hasVideo

    // width: 100
    // height:50
    property Item pipState: videoPipState

    property bool isLeftBtn: false
    property bool isPressed: false
    property bool isdouble: false
    property int startX: 0
    property int startY: 0
    property int disX: 0
    property int disY: 0

    VKPipState {
        id: videoPipState
        pipOverlay: _pipOverlay
        isDark: true

        onWindowAboutToOpen: {
            VKGroundControl.videoManager.stopVideo()
            videoStartDelay.start()
        }

        onWindowAboutToClose: {
            VKGroundControl.videoManager.stopVideo()
            videoStartDelay.start()
        }

        onStateChanged: {
            if (_root.pipState.state !== _root.pipState.fullState) {
                VKGroundControl.videoManager.fullScreen = false
            } else {
                VKGroundControl.videoManager.fullScreen = true
            }
        }
    }

    Component.onCompleted: {

    }
    function setflashOverlay() {
        flashAnimation.start()
    }

    Timer {
        id: videoStartDelay
        interval: 2000
        running: false
        repeat: false
        onTriggered: VKGroundControl.videoManager.startVideo()
    }

    //-- Video Streaming
    FlightDisplayViewVideo {
        id: videoStreaming
        objectName: "childVideoStreaming"
        anchors.fill: parent
        useSmallFont: _root.pipState.state !== _root.pipState.fullState
        visible: VKGroundControl.videoManager.isGStreamer
    }

    GimbalControlWidget {
        id: gimbalControl
        anchors.fill: parent
        videoStreaming: videoStreaming
        visible: _root.pipState.state === _root.pipState.fullState
        property var gimbalController: VKGroundControl.gimbalController
        onRangingClicked: {
            if (gimbalController) {
                gimbalController.enableRanging()
            }
        }
        onStopRangingClicked: {
            if (gimbalController) {
                gimbalController.disableRanging()
            }
        }
        onZoomInClicked: {
            if (gimbalController) {
                gimbalController.zoomIn(10)
            }
        }
        onZoomOutClicked: {
            if (gimbalController) {
                gimbalController.zoomOut(10)
            }
        }
        onStopZoomClicked: {
            if (gimbalController) {
                gimbalController.stopZoom()
            }
        }
        onCenterClicked: {
            if (gimbalController) {
                gimbalController.centerPosition()
            }
        }
        onLookDownClicked: {
            if (gimbalController) {
                gimbalController.lookDown()
            }
        }
        onTakePhotoClicked: {
            if (gimbalController) {
                gimbalController.takePhoto()
            }
        }
        onRecordingClicked: {
            if (gimbalController) {
                gimbalController.startRecording()
            }
        }
        onStopRecordingClicked: {
            if (gimbalController) {
                gimbalController.stopRecording()
            }
        }
        onStopLockClicked: {
            if (gimbalController) {
                gimbalController.unlockTarget()
            }
        }
        onLockModeClicked: {
            if (gimbalController) {
                gimbalController.autoLockTarget()
            }
        }
    }

    //-- UVC Video (USB Camera or Video Device)
    Loader {
        id: cameraLoader
        anchors.fill: parent
        visible: !VKGroundControl.videoManager.isGStreamer
        source: VKGroundControl.videoManager.uvcEnabled ? "qrc:/qml/FlightDisplayViewUVC.qml" : "qrc:/qml/FlightDisplayViewDummy.qml"
    }


    Timer {
        id: timerClick
        interval: 300
        repeat: false
        onTriggered: {
            if (isPressed) {
                videoStartMove.start()
            }
        }
    }
    Timer {
        id: videoStartMove
        interval: 50
        repeat: true
        onTriggered: {
            // .joyControl(1,0,-disY*1.6,disX*1.6)
            if (mainWindow.camera_model === qsTr("先飞D80-Pro")
                    || mainWindow.camera_model === qsTr("先飞Z1-mini")) {
                QGCCwGimbalController.joyControl(1, 0, -disY * 1, disX * 1)
            }
        }
    }
    Timer {
        id: timerSecondClick
        interval: 100
        repeat: false
    }
    Image {
        id: movingImage
        source: "/qmlimages/icon/touch.png" // 替换为实际的图片路径
        visible: false // 初始时隐藏图片
        width: 70
        height: 70
    }
    Rectangle {
        id: flashOverlay
        anchors.fill: parent
        color: "#60ffffff"
        opacity: 0
        //拍照闪光特效
        SequentialAnimation {
            id: flashAnimation
            NumberAnimation {
                target: flashOverlay
                property: "opacity"
                from: 0
                to: 1
                duration: 100
            }
            NumberAnimation {
                target: flashOverlay
                property: "opacity"

                from: 1
                to: 0
                duration: 100
            }
        }
    }

    // Connections {
    //     target: cameractl
    // }
}
