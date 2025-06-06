

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
import QtQuick.Dialogs
import QtQuick.Layouts

import QtLocation
import QtPositioning
import QtQuick.Window
import QtQml.Models

import Controls

// To implement a custom overlay copy this code to your own control in your custom code source. Then override the
// FlyViewCustomLayer.qml resource with your own qml. See the custom example and documentation for details.
Item {
    id: _root

    property var parentToolInsets
    // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets: _toolInsets // These are the insets for your custom overlay additions
    property var mapControl

    VKToolInsets {
        id: _toolInsets
        leftEdgeCenterInset: 0
        leftEdgeTopInset: 0
        leftEdgeBottomInset: 0
        rightEdgeCenterInset: 0
        rightEdgeTopInset: 0
        rightEdgeBottomInset: 0
        topEdgeCenterInset: 0
        topEdgeLeftInset: 0
        topEdgeRightInset: 0
        bottomEdgeCenterInset: 0
        bottomEdgeLeftInset: 0
        bottomEdgeRightInset: 0
    }
}
