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
import QtQuick.Layouts
import QtQuick.Dialogs

import VKGroundControl
import Controls
import VKGroundControl.Palette
import ScreenTools

// Provides the standard dialog mechanism for QGC. Works 99% like Qml Dialog.
//
// Example usage:
//      Component {
//          id: dialogComponent
//
//          QGCPopupDialog {
//              ...
//          }
//      }
//
//      onFoo: dialogComponent.createObject(mainWindow).open()
//
// Notes:
//  * QGCPopupDialog should be created from a component to limit the memory usage of the dialog
//      to only when it is displayed.
//  * Parent for createObject should always be mainWindow.
// Differences from standard Qml Dialog:
//  * The QGCPopupDialog object will automatically be destroyed when it closed. You can override this
//      behaviour by setting destroyOnClose to false if it was not created dynamically.
//  * Dialog will automatically close after accepted/rejected signal processing. You can prevent this by setting
//      preventClose = true prior to returning from your signal handlers.
Popup {
    id:                 root
    width:  mainWindow.width
    height: mainWindow.height
    parent:             Overlay.overlay
    modal:              true
    focus:              true
    margins:            0

    property string title
    property var    buttons:                Dialog.Ok
    property alias  acceptButtonEnabled:    acceptButton.enabled
    property alias  rejectButtonEnabled:    rejectButton.enabled
    property var    dialogProperties
    property bool   destroyOnClose:         true
    property bool   preventClose:           false
    
    readonly property real headerMinWidth: titleLable.implicitWidth + rejectButton.width + acceptButton.width + titleRowLayout.spacing * 2

    signal accepted
    signal rejected

    property var    _qgcPal:            VKGroundControl.globalPalette
    property real   _frameSize:         ScreenTools.defaultFontPixelWidth
    property real   _contentMargin:     ScreenTools.defaultFontPixelHeight / 2
    property bool   _acceptAllowed:     acceptButton.visible
    property bool   _rejectAllowed:     rejectButton.visible
    property int    _previousValidationErrorCount: 0

    background: VKMouseArea {
        width:  mainWindow.width
        height: mainWindow.height

        onClicked: {
            if (closePolicy & Popup.CloseOnPressOutside) {
                _reject()
            }
        }
    }

    Component.onCompleted: {
        // The last child item will be the true dialog content.
        // Re-Parent it to the right place in the ui hierarchy.
        contentChildren[contentChildren.length - 1].parent = dialogContentParent
    }

    onAboutToShow: {
        setupDialogButtons(buttons)
    }

    onClosed: {
        Qt.inputMethod.hide()
        if (destroyOnClose) {
            root.destroy()
        }
    }

    function _accept() {
        if (_acceptAllowed) {
            accepted()
            if (preventClose) {
                preventClose = false
            } else {
                close()
            }
        }
    }

    function _reject() {
        // Dialogs with cancel button are allowed to close with validation errors
        if (_rejectAllowed && ((buttons & Dialog.Cancel) || mainWindow.allowViewSwitch(_previousValidationErrorCount))) {
            rejected()
            if (preventClose) {
                preventClose = false
            } else {
                close()
            }
        }
    }

    VKPalette { id: qgcPal; colorGroupEnabled: parent.enabled }

    function setupDialogButtons(buttons) {
        acceptButton.visible = false
        rejectButton.visible = false
        // Accept role buttons
        if (buttons & Dialog.Ok) {
            acceptButton.buttonText = qsTr("确认")
            acceptButton.visible = true
        } else if (buttons & Dialog.Open) {
            acceptButton.buttonText = qsTr("打开")
            acceptButton.visible = true
        } else if (buttons & Dialog.Save) {
            acceptButton.buttonText = qsTr("保存")
            acceptButton.visible = true
        } else if (buttons & Dialog.Apply) {
            acceptButton.buttonText = qsTr("应用")
            acceptButton.visible = true
        } else if (buttons & Dialog.SaveAll) {
            acceptButton.buttonText = qsTr("全部保存")
            acceptButton.visible = true
        } else if (buttons & Dialog.Yes) {
            acceptButton.buttonText = qsTr("是")
            acceptButton.visible = true
        } else if (buttons & Dialog.YesToAll) {
            acceptButton.buttonText = qsTr("全部是")
            acceptButton.visible = true
        } else if (buttons & Dialog.Retry) {
            acceptButton.buttonText = qsTr("重试")
            acceptButton.visible = true
        } else if (buttons & Dialog.Reset) {
            acceptButton.buttonText = qsTr("重置")
            acceptButton.visible = true
        } else if (buttons & Dialog.RestoreToDefaults) {
            acceptButton.buttonText = qsTr("恢复默认设置")
            acceptButton.visible = true
        } else if (buttons & Dialog.Ignore) {
            acceptButton.buttonText = qsTr("忽略")
            acceptButton.visible = true
        }

        // Reject role buttons
        if (buttons & Dialog.Cancel) {
            rejectButton.buttonText = qsTr("取消")
            rejectButton.visible = true
        } else if (buttons & Dialog.Close) {
            rejectButton.buttonText = qsTr("关闭")
            rejectButton.visible = true
        } else if (buttons & Dialog.No) {
            rejectButton.buttonText = qsTr("否")
            rejectButton.visible = true
        } else if (buttons & Dialog.NoToAll) {
            rejectButton.buttonText = qsTr("全部否")
            rejectButton.visible = true
        } else if (buttons & Dialog.Abort) {
            rejectButton.buttonText = qsTr("终止")
            rejectButton.visible = true
        }

        closePolicy = Popup.NoAutoClose
        if (buttons & Dialog.Cancel) {
            closePolicy |= Popup.CloseOnEscape
        }
    }

    function disableAcceptButton() {
        acceptButton.enabled = false
    }

    Rectangle {
        x:              mainLayout.x - _contentMargin
        y:              mainLayout.y - _contentMargin
        width:          mainLayout.width + _contentMargin * 2
        height:         mainLayout.height + _contentMargin * 2
        color:          _qgcPal.windowShade
        radius:         root.padding / 2
        border.width:   1
        border.color:   _qgcPal.windowShadeLight
    }

    ColumnLayout {
        id:                 mainLayout
        anchors.centerIn:   parent
        x:          _contentMargin
        y:          _contentMargin
        spacing:    _contentMargin

        RowLayout {
            id:                     titleRowLayout
            Layout.fillWidth:       true
            spacing:                _contentMargin

            VKLabel {
                id: titleLable
                Layout.fillWidth:   true
                text:               root.title
                font.pixelSize: 25 * ScreenTools.scaleWidth
                verticalAlignment:	Text.AlignVCenter
            }

            TextButton {
                id:                     rejectButton
                onClicked:              _reject()
                Layout.minimumWidth:    height * 1.5
                backgroundColor: "gray"
                pressedColor: ScreenTools.titleColor
                textColor: "white"
                cornerRadius: 4 * ScreenTools.scaleWidth
                topPadding: 8 * ScreenTools.scaleWidth
                bottomPadding: 8 * ScreenTools.scaleWidth
                leftPadding: 16 * ScreenTools.scaleWidth
                rightPadding: 16 * ScreenTools.scaleWidth
            }

            TextButton {
                id:                     acceptButton
                onClicked:              _accept()
                Layout.minimumWidth:    height * 1.5
                backgroundColor: ScreenTools.titleColor
                pressedColor: "gray"
                textColor: "white"
                cornerRadius: 4 * ScreenTools.scaleWidth
                topPadding: 8 * ScreenTools.scaleWidth
                bottomPadding: 8 * ScreenTools.scaleWidth
                leftPadding: 16 * ScreenTools.scaleWidth
                rightPadding: 16 * ScreenTools.scaleWidth
            }
        }

        Rectangle {
            Layout.fillWidth:       true
            Layout.preferredWidth:  Math.min(maxAvailableWidth, totalContentWidth)
            Layout.preferredHeight: Math.min(maxAvailableHeight, totalContentHeight)
            color:                  _qgcPal.window

            property real maxAvailableWidth:    mainWindow.width - _contentMargin * 4
            property real maxAvailableHeight:   mainWindow.height - titleRowLayout.height - _contentMargin * 5
            property real totalContentWidth:    dialogContentParent.childrenRect.width + _contentMargin * 2
            property real totalContentHeight:   dialogContentParent.childrenRect.height + _contentMargin * 2

            VKFlickable {
                anchors.margins:    _contentMargin
                anchors.fill:       parent
                contentWidth:       dialogContentParent.childrenRect.width
                contentHeight:      dialogContentParent.childrenRect.height

                Item {
                    id:     dialogContentParent
                    focus:  true

                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Escape && _rejectAllowed) {
                            _reject()
                            event.accepted = true
                        }
                    }
                }
            }
        }
    }
}
