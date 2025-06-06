import QtQuick
import QtQuick.Controls

import VKGroundControl
import VKGroundControl.Palette
// import VKGroundControl.MultiVehicleManager

// 基础安装设置组件，提供共享的布局和属性
Item {
    id: installBase
    width: parent.width
    height: parent.height

    // 公共属性
    property real buttonFontsize: 30 * sw * 5/6
    property var buttonMain: qgcPal.titleColor

    property int installId: 0

    VKPalette { id: qgcPal}
    // 基础背景
    Rectangle {
        anchors.fill: parent
        color: "#00000000"
    }
    

}
