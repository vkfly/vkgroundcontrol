

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
import QtQuick.Window

import VKGroundControl
import FlightMap
import FlightDisplay
import ScreenTools
import Controls
import Home

/// @brief Native QML top level window
/// All properties defined here are visible to all QML pages.
import VkSdkInstance 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    // minimumWidth: ScreenTools.isMobile ? Screen.width : Math.min(
    //                                          ScreenTools.defaultFontPixelWidth * 100,
    //                                          Screen.width)
    // minimumHeight: ScreenTools.isMobile ? Screen.height : Math.min(
    //                                           ScreenTools.defaultFontPixelWidth * 50,
    //                                           Screen.height)
    flags: Qt.FramelessWindowHint | Qt.WindowSystemMenuHint
           | Qt.WindowMinimizeButtonHint | Qt.Window

    enum WindowState {
        Home,
        MainWindow
    }
    property double sw: ScreenTools.scaleWidth
    property double sh: ScreenTools.scaleHeight
    property var videoVisible: false
    property int windowState: MainRootWindow.WindowState.Home
    property var appversion: "V1.2.41"
    //property bool isgongchang : false //工厂模式密码

    //报错属性
    property var parsedErrors: ""

    property bool isvisible: true

    //屏幕属性
    property var titlecolor: "#3bae36"

    Component.onCompleted: {
        if (!ScreenTools.isFakeMobile
                && (ScreenTools.isMobile
                    || Screen.height / ScreenTools.realPixelDensity < 120)) {
            mainWindow.showFullScreen()
        } else {
            mainWindow.showMaximized()
        }
    }

    property bool _forceClose: false

    function finishCloseProcess() {
        _forceClose = true

        // For some reason on the Qml side Qt doesn't automatically disconnect a signal when an object is destroyed.
        // So we have to do it ourselves otherwise the signal flows through on app shutdown to an object which no longer exists.
        // firstRunPromptManager.clearNextPromptSignal()
        VKGroundControl.videoManager.stopVideo()
        VkSdkInstance.stopLink()
        mainWindow.close()
    }

    readonly property int _skipUnsavedMissionCheckMask: 0x01
    readonly property int _skipPendingParameterWritesCheckMask: 0x02
    readonly property int _skipActiveConnectionsCheckMask: 0x04
    property int _closeChecksToSkip: 0
    function performCloseChecks() {
        // if (!(_closeChecksToSkip & _skipUnsavedMissionCheckMask)) {
        //     return false
        // }
        // if (!(_closeChecksToSkip & _skipPendingParameterWritesCheckMask)) {
        //     return false
        // }
        // if (!(_closeChecksToSkip & _skipActiveConnectionsCheckMask)) {
        //     return false
        // }
        finishCloseProcess()
        return true
    }

    function isMainWindow() {
        return windowState === MainRootWindow.WindowState.MainWindow
    }

    function goHome() {
        return windowState = MainRootWindow.WindowState.Home
    }

    onClosing: close => {
                   if (!_forceClose) {
                       _closeChecksToSkip = 0
                       close.accepted = performCloseChecks()
                   }
               }

    header: MainVKToolBar {
          id: header
          width: parent.width
          height: sw * 65
          visible: windowState === MainRootWindow.WindowState.MainWindow
    }

    HomePage {
        anchors.fill: parent
        visible: windowState === MainRootWindow.WindowState.Home
        onClickSend: {

        }
        onGoToFlyPage: {
            windowState = MainRootWindow.WindowState.MainWindow
        }
    }

    FlyView {
        anchors.fill: parent
        visible: windowState === MainRootWindow.WindowState.MainWindow
    }

    VKMessageShow {
        id: messageboxs
        anchors.centerIn: parent
        popupWidth: parent.width * 0.5
    }

    VKPassWordMsg
    {
        width: 800 * ScreenTools.scaleWidth
        id: vkPasswordmsg
        anchors.centerIn: parent
    }

    KeyboardNumView{
        anchors{
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        id: keyBoardNumView
        visible: false
        onKeyboardConfirmed: {
            //popupWindow.visible=false
            if (keyBoardNumView.sendId === 1) {
                if (_activeVehicle)
                    _activeVehicle.sendSpeed(keyBoardNumView.currentText)
            }
            if (keyBoardNumView.sendId === 2) {
                if (_activeVehicle)
                    _activeVehicle.sendalttitude(keyBoardNumView.currentText)
            }
            if (keyBoardNumView.sendId === 3) {
                if (_activeVehicle)
                    _activeVehicle.sendesc_index(keyBoardNumView.currentText)
            }
            if (keyBoardNumView.sendId === 99) {
                if (VkSdkInstance.vehicleManager.activeVehicle) {
                    VkSdkInstance.vehicleManager.activeVehicle.setParam(
                                keyBoardNumView.parameterName,
                                keyBoardNumView.currentText)
                }
            }
            keyBoardNumView.visible = false
        }

        onKeyboardCancelled: {
            keyBoardNumView.visible = false
        }
    }


}
