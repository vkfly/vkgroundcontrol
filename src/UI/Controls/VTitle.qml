import QtQuick
import ScreenTools

Text {
    property string vt_title: qsTr("飞控安装方向和偏差")
    text: vt_title
    width: parent.width
    height: 40 * ScreenTools.scaleWidth
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    font.pixelSize: 25 * ScreenTools.scaleHeight
    font.bold: false
    color: "white"
}
