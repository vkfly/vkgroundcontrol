import QtQuick
import QtQuick.Controls

import ScreenTools
import VKGroundControl.Palette

Text {
    id: text
    property alias fontSize: text.font.pixelSize

    width: 200 * ScreenTools.scaleWidth
    height: 30 * sw
    text: "labelName"
    font.pixelSize: 40 * ScreenTools.scaleHeight
    font.bold: false
    VKPalette {
        id: qgcPal
        colorGroupEnabled: enabled
    }
}
