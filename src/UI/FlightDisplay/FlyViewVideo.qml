

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
            if (pipState.state !== pipState.fullState) {
                VKGroundControl.videoManager.fullScreen = false
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
    //-- UVC Video (USB Camera or Video Device)
    Loader {
        id: cameraLoader
        anchors.fill: parent
        visible: !VKGroundControl.videoManager.isGStreamer
        source: VKGroundControl.videoManager.uvcEnabled ? "qrc:/qml/FlightDisplayViewUVC.qml" : "qrc:/qml/FlightDisplayViewDummy.qml"
    }

    VKLabel {
        //text: qsTr("Double-click to exit full screen")
        font.pointSize: ScreenTools.largeFontPointSize
        visible: VKGroundControl.videoManager.fullScreen
                 && flyViewVideoMouseArea.containsMouse
        anchors.centerIn: parent
        onVisibleChanged: {

        }
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
    MouseArea {
        id: flyViewVideoMouseArea
        anchors.fill: parent
        enabled: pipState.state === pipState.fullState
        hoverEnabled: true

        cursorShape: "PointingHandCursor"
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (timerSecondClick.running) {
                return
            }
            const rootW = _root.width
            const rootH = _root.height

            const lis = videoStreaming.children
            const videoW = lis[1].getWidth()
            const videoH = lis[1].getHeight()

            var dw = (rootW - videoW) / 2

            if (mouse.button === Qt.LeftButton) {
                if (mainWindow.camera_model === qsTr("先飞D80-Pro")
                        || mainWindow.camera_model === qsTr("先飞Z1-mini")) {
                    if ((QGCCwGimbalController.trackBtnState)
                            && QGCCwGimbalController.trackAvailable) {
                        QGCCwGimbalController.trackObject()
                        if ((mouseX > dw) && (mouseX < rootW - dw)) {
                            let x = (mouseX - dw) * 100 / videoW
                            let y = mouseY * 100 / videoH
                            var x1 = x - 5
                            var y1 = y - 5
                            var x2 = x + 5
                            var y2 = y + 5
                            if (x1 < 0) {
                                x1 = 0
                            }
                            if (y1 < 0) {
                                y1 = 0
                            }
                            0
                            if (x2 > 100) {
                                x2 = 100
                            }
                            if (y2 > 100) {
                                y2 = 100
                            }

                            QGCCwGimbalController.videoTrack(x1, y1,
                                                             x2, y2, 0x02)
                        }
                    } else if (QGCCwGimbalController.isPointTemp) {
                        if ((mouseX > dw) && (mouseX < rootW - dw)) {
                            let mx1 = (mouseX - dw) * 10000 / videoW
                            let my1 = mouseY * 10000 / videoH
                            QGCCwGimbalController.spotTempSwitch(mx1, my1, 0x01)
                        }
                    } else {
                        if ((mouseX > dw) && (mouseX < rootW - dw)) {
                            let mx = (mouseX - dw) * 10000 / videoW
                            let my = mouseY * 10000 / videoH
                            QGCCwGimbalController.videoPointTranslation(mx, my)
                        }
                    }
                }
            } else if (mouse.button === Qt.RightButton) {
                if (mainWindow.camera_model === qsTr("先飞D80-Pro")
                        || mainWindow.camera_model === qsTr("先飞Z1-mini")) {
                    QGCCwGimbalController.videoTrack("", "", "", "", 0x00)
                }
            }
        }
        onPressed: {
            startX = 0
            startY = 0
            disX = 0
            disY = 0
            if (mouse.button === Qt.LeftButton) {
                timerClick.start()
                isPressed = true
                isLeftBtn = true
                startX = mouseX
                startY = mouseY
                // 鼠标按下时显示图片
            }
            //isdouble=false
        }
        onPositionChanged: {
            if (isPressed) {
                if (QGCCwGimbalController.modeRaw === 3) {
                    return
                }
                // if(isLeftBtn){
                //     disX = mouse.x-startX
                //     disY = mouse.y-startY
                //     if (Math.abs(disX) > Math.abs(disY)) {
                //         if (disX > 0) {
                //             if(mainWindow.camera_model===qsTr("云卓 C12")){
                //                 if (udpSocketHandler) {
                //                     udpSocketHandler.sendData("#TPUG2wGSY1E","192.168.144.108",5000)
                //                 }
                //             }
                //             if(cameractl){
                //                 cameractl.video_right()
                //             }
                //             // #
                //         } else {
                //             if(mainWindow.camera_model===qsTr("云卓 C12")){
                //                 if (udpSocketHandler) {
                //                     udpSocketHandler.sendData("#TPUG2wGSYE2","192.168.144.108",5000)
                //                 }
                //             }
                //             if(cameractl){
                //                 cameractl.video_left()
                //             }
                //         }
                //     } else {
                //         if (disY > 0) {
                //             if(mainWindow.camera_model===qsTr("云卓 C12")){
                //                 if (udpSocketHandler) {
                //                     udpSocketHandler.sendData("#TPUG2wGSPE2","192.168.144.108",5000)
                //                 }
                //             }
                //             if(cameractl){
                //                 cameractl.video_dowm()
                //             }
                //         } else {
                //             if(mainWindow.camera_model===qsTr("云卓 C12")){
                //                 if (udpSocketHandler) {
                //                     udpSocketHandler.sendData("#TPUG2wGSP1E","192.168.144.108",5000)
                //                 }
                //             }
                //             if(cameractl){
                //                 cameractl.video_up()
                //             }
                //         }
                //     }
                // }
                if (isPressed) {
                    movingImage.visible = true
                    movingImage.x = mouseX - movingImage.width / 2 // 更新图片位置
                    movingImage.y = mouseY - movingImage.height / 2
                }
            }
            isdouble = false
        }
        onReleased: {
            isLeftBtn = false
            isPressed = false
            startX = 0
            startY = 0
            disX = 0
            disY = 0
            movingImage.visible = false
            // if(videoStartMove.running&& isdouble===false){
            //     videoStartMove.stop()
            //     if(mainWindow.camera_model===qsTr("先飞D80-Pro")||mainWindow.camera_model===qsTr("先飞Z1-mini")){
            //         QGCCwGimbalController.joyControl(1,0,0,0)
            //     }
            //     timerSecondClick.start()
            // }
            // if(mainWindow.camera_model===qsTr("云卓 C12")&& isdouble===false){
            //     if (udpSocketHandler) {
            //         udpSocketHandler.sendData("#TPUG2wPTZ00","192.168.144.108",5000)
            //     }
            // }
            // if(cameractl&& isdouble===false){
            //     cameractl.video_stop()
            // }
        }

        onDoubleClicked: {

            // if(cameractl){
            //     cameractl.doubleclick((startX*1920/flyViewVideoMouseArea.width-960),(startY*1080/flyViewVideoMouseArea.height-540))
            // }
            isdouble = true
        }
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
