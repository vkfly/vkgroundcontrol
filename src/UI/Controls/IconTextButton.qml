import QtQuick 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 2.3

import VKGroundControl.Palette 1.0
import ScreenTools

/// Standard push button control:
///     If there is both an icon and text the icon will be to the left of the text
///     If icon only, icon will be centered
Button {
    id:             control
    hoverEnabled:   !ScreenTools.isMobile
    topPadding:     _verticalPadding
    bottomPadding:  _verticalPadding
    leftPadding:    _horizontalPadding
    rightPadding:   _horizontalPadding
    focusPolicy:    Qt.ClickFocus
    text:           ""

    property bool   primary:        false                               ///< primary button for a group of buttons
    property bool   showBorder:     qgcPal.globalTheme === VKPalette.Light
    property real   backRadius:     ScreenTools.buttonBorderRadius
    property real   heightFactor:   0.5
    property string iconSource:     ""
    property real   iconWidth:      text.height
    property real   fontWeight:     Font.Normal // default for qml Text
    property real   pixelSize:      ScreenTools.defaultFontPointSize

    property alias wrapMode:            text.wrapMode
    property alias horizontalAlignment: text.horizontalAlignment
    property alias backgroundColor:     backRect.color
    property alias textColor:           text.color

    property bool  showHighlight:     enabled && (pressed | checked | hovered)

    property int _horizontalPadding:    ScreenTools.scaleWidth * 12
    property int _verticalPadding:      Math.round(6 * ScreenTools.scaleWidth)
    property real iconTextSpacing: 8 * ScreenTools.scaleWidth

    VKPalette { id: qgcPal; colorGroupEnabled: enabled }

    background: Rectangle {
        id:             backRect
        radius:         backRadius
        implicitWidth:  ScreenTools.implicitButtonWidth
        implicitHeight: ScreenTools.implicitButtonHeight
        border.width:   showBorder ? 1 : 0
        border.color:   qgcPal.buttonBorder
        color:          primary ? qgcPal.primaryButton : qgcPal.button

        Rectangle {
            anchors.fill:   parent
            color:          qgcPal.buttonHighlight
            opacity:        showHighlight ? control.enabled && (control.pressed | control.checked) ? 1 : .2  : 0
            radius:         parent.radius
        }
    }

    contentItem: RowLayout {
            spacing: control.iconTextSpacing

            VKColoredImage {
                id:                     icon
                Layout.alignment:       Qt.AlignHCenter
                source:                 control.iconSource
                height:                 control.iconWidth
                width:                  control.iconWidth
                color:                  text.color
                fillMode:               Image.PreserveAspectFit
                sourceSize.height:      height
                visible:                control.iconSource !== ""
            }

            VKLabel {
                id:                     text
                Layout.alignment:       Qt.AlignHCenter
                text:                   control.text
                font.pixelSize:         control.pixelSize
                font.weight:            fontWeight
                color:                  showHighlight ? qgcPal.buttonHighlightText : (primary ? qgcPal.primaryButtonText : qgcPal.buttonText)
                visible:                control.text !== ""
            }
    }
}
