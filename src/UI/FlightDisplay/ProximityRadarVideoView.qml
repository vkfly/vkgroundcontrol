

/****************************************************************************
 *
 * (c) 2009-2020 VKGroundControl PROJECT <http://www.VKGroundControl.org>
 *
 * VKGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick
import QtLocation
import QtPositioning

import VKGroundControl
import ScreenTools
import FlightDisplay
import Controls

Item {
    id: _root
    anchors.fill: parent
    visible: proximityValues.telemetryAvailable

    property var vehicle
    ///< Vehicle object, undefined for ADSB vehicle
    property real range: 6 ///< Default 6m view

    property var _minlength: Math.min(_root.width, _root.height)
    property var _ratio: (_minlength / 2) / _root.range

    // ProximityRadarValues {
    //     id:                     proximityValues
    //     vehicle:                _root.vehicle
    //     onRotationValueChanged: _sectorViewEllipsoid.requestPaint()
    // }
    Canvas {
        id: _sectorViewEllipsoid
        anchors.fill: _root
        opacity: 0.5

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.translate(width / 2, height / 2)
            ctx.strokeStyle = Qt.rgba(1, 0, 0, 1)
            ctx.lineWidth = width / 100
            ctx.scale(_root.width / _minlength, _root.height / _minlength)
            ctx.rotate(-Math.PI / 2 - Math.PI / 8)
            for (var i = 0; i < proximityValues.rgRotationValues.length; i++) {
                var rotationValue = proximityValues.rgRotationValues[i]
                if (!isNaN(rotationValue)) {
                    var a = Math.PI / 4 * i
                    ctx.beginPath()
                    ctx.arc(0, 0, rotationValue * _ratio, 0 + a + Math.PI / 50,
                            Math.PI / 4 + a - Math.PI / 50, false)
                    ctx.stroke()
                }
            }
        }
    }

    Item {
        anchors.fill: parent

        Repeater {
            model: proximityValues.rgRotationValues.length

            VKLabel {
                x: (_sectorViewEllipsoid.width / 2) - (width / 2)
                y: (_sectorViewEllipsoid.height / 2) - (height / 2)
                text: proximityValues.rgRotationValueStrings[index]
                font.family: ScreenTools.demiboldFontFamily
                visible: !isNaN(proximityValues.rgRotationValues[index])

                transform: Translate {
                    x: Math.cos(-Math.PI / 2 + Math.PI / 4 * index)
                       * (proximityValues.rgRotationValues[index] * _ratio)
                    y: Math.sin(-Math.PI / 2 + Math.PI / 4 * index)
                       * (proximityValues.rgRotationValues[index] * _ratio)
                }
            }
        }
        transform: Scale {
            origin.x: _sectorViewEllipsoid.width / 2
            origin.y: _sectorViewEllipsoid.height / 2
            xScale: _root.width / _minlength
            yScale: _root.height / _minlength
        }
    }
}
