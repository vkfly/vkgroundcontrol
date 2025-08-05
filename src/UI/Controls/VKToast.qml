import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import ScreenTools
import VKGroundControl.Palette

Item {
    id: toastRoot
    
    // === 公开属性 ===
    property string message: ""
    property int duration: 3000  // 显示时长(毫秒)
    property int toastType: VKToast.ToastType.Info  // Toast类型
    property real maxWidth: 400 * ScreenTools.scaleWidth
    property real minWidth: 200 * ScreenTools.scaleWidth
    
    // === Toast类型枚举 ===
    enum ToastType {
        Info,     // 信息提示 - 蓝色
        Success,  // 成功提示 - 绿色
        Warning,  // 警告提示 - 橙色
        Error     // 错误提示 - 红色
    }
    
    // === 私有属性 ===
    property bool _isVisible: false
    property var _parentItem: null
    
    // === 样式配置 ===
    readonly property var _typeColors: ({
        [VKToast.ToastType.Info]: "#2196F3",
        [VKToast.ToastType.Success]: "#4CAF50", 
        [VKToast.ToastType.Warning]: "#FF9800",
        [VKToast.ToastType.Error]: "#F44336"
    })
    
    readonly property var _typeIcons: ({
        [VKToast.ToastType.Info]: "ℹ",
        [VKToast.ToastType.Success]: "✓",
        [VKToast.ToastType.Warning]: "⚠",
        [VKToast.ToastType.Error]: "✕"
    })
    
    // === 组件尺寸和位置 ===
    anchors.fill: parent
    z: 9999  // 确保在最顶层显示
    
    VKPalette { id: qgcPal }
    
    // === Toast容器 ===
    Rectangle {
        id: toastContainer
        
        // 动态计算宽度
        width: Math.max(minWidth, Math.min(maxWidth, toastContent.implicitWidth + 40 * ScreenTools.scaleWidth))
        height: toastContent.implicitHeight + 20 * ScreenTools.scaleHeight
        
        // 居中显示，稍微偏上
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 100 * ScreenTools.scaleHeight
        
        // 样式设置
        color: _typeColors[toastType] || _typeColors[VKToast.ToastType.Info]
        radius: 8 * ScreenTools.scaleWidth
        opacity: 0
        scale: 0.8
        
        // 边框效果
        border.width: 1
        border.color: Qt.darker(color, 1.2)
        
        // === Toast内容 ===
        RowLayout {
            id: toastContent
            anchors.centerIn: parent
            spacing: 8 * ScreenTools.scaleWidth
            
            // 图标
            Text {
                text: _typeIcons[toastType] || _typeIcons[VKToast.ToastType.Info]
                font.pixelSize: 16 * ScreenTools.scaleWidth
                color: "white"
                font.bold: true
            }
            
            // 消息文本
            Text {
                text: message
                font.pixelSize: 14 * ScreenTools.scaleWidth
                color: "white"
                wrapMode: Text.Wrap
                Layout.maximumWidth: maxWidth - 60 * ScreenTools.scaleWidth
            }
        }
        
        // === 显示动画 ===
        ParallelAnimation {
            id: showAnimation
            
            NumberAnimation {
                target: toastContainer
                property: "opacity"
                from: 0
                to: 1
                duration: 300
                easing.type: Easing.OutCubic
            }
            
            NumberAnimation {
                target: toastContainer
                property: "scale"
                from: 0.8
                to: 1.0
                duration: 300
                easing.type: Easing.OutBack
            }
        }
        
        // === 隐藏动画 ===
        ParallelAnimation {
            id: hideAnimation
            
            NumberAnimation {
                target: toastContainer
                property: "opacity"
                from: 1
                to: 0
                duration: 300
                easing.type: Easing.InCubic
            }
            
            NumberAnimation {
                target: toastContainer
                property: "scale"
                from: 1.0
                to: 0.8
                duration: 300
                easing.type: Easing.InBack
            }
            
            onFinished: {
                _isVisible = false
                toastRoot.visible = false
            }
        }
    }
    
    // === 自动隐藏定时器 ===
    Timer {
        id: autoHideTimer
        interval: duration
        onTriggered: hide()
    }
    
    // === 公开方法 ===
    
    /**
     * 显示Toast消息
     * @param msg 要显示的消息
     * @param type Toast类型 (可选，默认为Info)
     * @param showDuration 显示时长 (可选，默认为3000ms)
     */
    function show(msg, type, showDuration) {
        if (!msg) return
        
        // 设置参数
        message = msg
        if (type !== undefined) toastType = type
        if (showDuration !== undefined) duration = showDuration
        
        // 显示Toast
        _isVisible = true
        toastRoot.visible = true
        
        // 停止之前的动画和定时器
        hideAnimation.stop()
        autoHideTimer.stop()
        
        // 开始显示动画
        showAnimation.start()
        
        // 启动自动隐藏定时器
        autoHideTimer.start()
    }
    
    /**
     * 隐藏Toast
     */
    function hide() {
        if (!_isVisible) return
        
        autoHideTimer.stop()
        showAnimation.stop()
        hideAnimation.start()
    }
    
    /**
     * 显示错误消息的便捷方法
     * @param errorMsg 错误消息
     */
    function showError(errorMsg) {
        show(errorMsg, VKToast.ToastType.Error)
    }
    
    /**
     * 显示成功消息的便捷方法
     * @param successMsg 成功消息
     */
    function showSuccess(successMsg) {
        show(successMsg, VKToast.ToastType.Success)
    }
    
    /**
     * 显示警告消息的便捷方法
     * @param warningMsg 警告消息
     */
    function showWarning(warningMsg) {
        show(warningMsg, VKToast.ToastType.Warning)
    }
    
    /**
     * 显示信息消息的便捷方法
     * @param infoMsg 信息消息
     */
    function showInfo(infoMsg) {
        show(infoMsg, VKToast.ToastType.Info)
    }
    
    // === 初始状态 ===
    Component.onCompleted: {
        toastRoot.visible = false
    }
}
