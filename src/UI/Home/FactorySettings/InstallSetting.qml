import QtQuick
import QtQuick.Controls

import VKGroundControl
import ScreenTools

import "../Common"

// 飞控安装设置主页面
Flickable {
    id: installSettingPage
    
    // 布局设置
    height: parent.height
    width: parent.width
    clip: true
    contentHeight: column.implicitHeight
    
    // 主内容列
    Column {
        id: column
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 6 * ScreenTools.scaleWidth
        
        // 顶部间距
        Item {
            width: parent.width
            height: ScreenTools.scaleWidth * 28.8
        }
        
        // 飞控安装部分
        ToolTitle {
            textTitle: qsTr("飞控安装")
        }
        
        VKInstallPart1 {
            width: parent.width
            height: 500 * sw
        }
        
        // RTK安装部分
        ToolTitle {
            textTitle: qsTr("RTK安装")
        }
        
        VKInstallPart2 {
            width: parent.width
            height: 500 * sw
        }
        
        // GNSS安装部分
        ToolTitle {
            textTitle: mainWindow.dingweimode === "beidou" ? qsTr("北斗安装") : qsTr("GNSS安装")
        }
        
        VKInstallPart3 {
            width: parent.width
            height: 400 * sw
        }
        
        // SBUS复用部分
        ToolTitle {
            textTitle: qsTr("SBUS复用")
        }
        
        VKInstallPart5 {
            width: parent.width
            height: 120 * sw
        }
        
        // 飞控校准部分
        ToolTitle {
            textTitle: qsTr("飞控校准")
        }
        
        VKInstallPart4 {
            width: parent.width
            height: 120 * sw
        }
        
        // 底部间距
        Item {
            width: parent.width
            height: ScreenTools.scaleWidth * 28.8
        }
    }

    VKLevelCalibration{
        width:600 * ScreenTools.scaleWidth
        id:levelCalibrationPopup
        anchors.centerIn: parent
    }

    VKCompassCalibration{
        width:600 * ScreenTools.scaleWidth
        id:compassCalibrationPopup
        anchors.centerIn: parent
    }

    // 消息弹窗
    // VKMessageShow {
    //     id: messagebox
    //     anchors.centerIn: parent
    //     popupWidth: parent.width * 0.5
    //     type: 2
    //     popupHeight: parent.width * 0.4 * 0.8 + 180 * sw
    // }
}
