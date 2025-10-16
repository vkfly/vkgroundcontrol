import QtQuick 
import QtQuick.Controls

import Controls
import ScreenTools

// 云台控制组件 - 重构为行列布局
Item {
    id: _root
    width: 400
    height: 300
    
    property var videoStreaming: null
    // 公共属性
    property bool isDraggable: true
    property real buttonImageSize: 86 * ScreenTools.scaleWidth  // 重命名
    property real pressedImageSize: buttonImageSize * 0.8        // 使用新名称
    
    // 布局属性
    property bool showTopRow: true  // 是否显示顶部工具栏按钮
    property bool showRightColumn: true  // 是否显示右侧按钮
    
    // 状态属性
    property bool isRecording: false
    property bool isRanging: false
    property bool isLocked: false
    
    // 信号定义
    signal lockModeClicked()
    signal followMeClicked()
    signal rangingClicked()
    signal stopRangingClicked()
    signal longRangingClicked()
    signal nightVisionClicked()
    signal thermalClicked()
    signal pipClicked()
    signal centerClicked()
    signal lookDownClicked()
    signal recordingClicked()
    signal stopRecordingClicked()
    signal takePhotoClicked()
    signal zoomInClicked()
    signal zoomOutClicked()
    signal stopZoomClicked()
    signal positionChanged(real x, real y)
    signal stopLockClicked()

    GimbalGestureControl {
        anchors.fill: parent
        videoStreaming: _root.videoStreaming
        onLockTargetRequested: {
            _root.isLocked = true
        }
        onStopLocked: {
            _root.isLocked = false
        }
    }

    // 顶部工具栏按钮组 - 水平排列
    Row {
        id: topToolbarButtons
        anchors {
            right: parent.right
            rightMargin: _root.buttonImageSize
            top: parent.top
            topMargin: 16 * ScreenTools.scaleWidth
        }
        visible: _root.showTopRow
        spacing: 16 * ScreenTools.scaleWidth
        IconButton {
            id: lockModeButton
            imageSource: _root.isLocked ? "/qmlimages/icon/stop.png" : "/qmlimages/icon/lockvideo.png"
            width: _root.buttonImageSize
            height: _root.buttonImageSize
            imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
            autoSize: false
            ToolTip.text: "锁定"
            ToolTip.visible: hovered
            onClicked: {
                if(!isLocked) {
                    _root.lockModeClicked()
                }else{
                    _root.stopLockClicked()
                }
                _root.isLocked = !_root.isLocked
            }
        }
        
        IconButton {
            id: followMeButton
            imageSource: "/qmlimages/icon/fllowvideo.png"
            width: _root.buttonImageSize
            height: _root.buttonImageSize
            imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
            autoSize: false
            ToolTip.text: "跟随"
            ToolTip.visible: hovered  
            onClicked: _root.followMeClicked()
        }
        
        IconButton {
            id: rangingButton
            imageSource: _root.isRanging ? "/qmlimages/icon/stop.png" : "/qmlimages/icon/videodis.png"
            width: _root.buttonImageSize
            height: _root.buttonImageSize
            imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
            autoSize: false
            ToolTip.text: "测距"
            ToolTip.visible: hovered
            onClicked: {
                if(_root.isRanging) {
                    _root.stopRangingClicked()
                }else{
                    _root.rangingClicked()
                }
                _root.isRanging = !_root.isRanging
            }

        }
        
        IconButton {
            id: centerButton
            imageSource: "/qmlimages/icon/autocenter.png"
            width: _root.buttonImageSize
            height: _root.buttonImageSize
            imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
            ToolTip.text: "一键回中"
            ToolTip.visible: hovered
            autoSize: false
            onClicked: _root.centerClicked()
        }

        IconButton {
            id: lookDownButton
            imageSource: "/qmlimages/icon/autodown.png"
            width: _root.buttonImageSize
            height: _root.buttonImageSize
            imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
            ToolTip.text: "一键下视"
            ToolTip.visible: hovered
            autoSize: false
            onClicked: _root.lookDownClicked()
        }

        // IconButton {
        //     id: thermalButton
        //     imageSource: "/qmlimages/icon/weicai.png"
        //     width: _root.buttonImageSize
        //     height: _root.buttonImageSize
        //     imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
        //     ToolTip.text: "伪彩"
        //     ToolTip.visible: hovered
        //     onClicked: _root.thermalClicked()
        // }
        
        // IconButton {
        //     id: pipButton
        //     imageSource: "/qmlimages/icon/pip.png"
        //     width: _root.buttonImageSize
        //     height: _root.buttonImageSize
        //     imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
        //     ToolTip.text: "画中画"
        //     ToolTip.visible: hovered
            
        //     onClicked: _root.pipClicked()
        // }
    }
    
    // 右侧控制按钮组 - 垂直排列
    Column {
        id: rightControlButtons
        visible: _root.showRightColumn
        anchors {
            right: parent.right
            top: parent.top
            topMargin: 160 * sw
        }
        spacing: 16 * ScreenTools.scaleWidth

        IconButton {
            id: recordingButton
            imageSource: _root.isRecording ? "/qmlimages/icon/stopvideo.png" : "/qmlimages/icon/startvideo.png"
            width: _root.buttonImageSize
            height: _root.buttonImageSize
            imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
            ToolTip.text: _root.isRecording ? "停止录像" : "开始录像"
            ToolTip.visible: hovered
            autoSize: false
            onClicked: {
                if(_root.isRecording) {
                    _root.stopRecordingClicked()
                } else {
                    _root.recordingClicked()
                }
                _root.isRecording = !_root.isRecording
            }
        }
        
        IconButton {
            id: takePhotoButton
            imageSource: "/qmlimages/icon/takephoto.png"
            width: _root.buttonImageSize
            height: _root.buttonImageSize
            imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
            autoSize: false
            ToolTip.text: "拍照"
            ToolTip.visible: hovered
            onClicked: _root.takePhotoClicked()
        }
        
        IconButton {
            id: zoomInButton
            imageSource: "/qmlimages/icon/zoommax.png"
            width: _root.buttonImageSize
            height: _root.buttonImageSize
            imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
            ToolTip.text: "放大"
            ToolTip.visible: hovered
            autoSize: false
            onPressed: _root.zoomInClicked()
            onReleased: _root.stopZoomClicked()
        }
        
        IconButton {
            id: zoomOutButton
            imageSource: "/qmlimages/icon/zoommin.png"
            width: _root.buttonImageSize
            height: _root.buttonImageSize
            imageSize: pressed ? _root.pressedImageSize : _root.buttonImageSize
            autoSize: false
            ToolTip.text: "缩小"
            ToolTip.visible: hovered
            onPressed: {
                _root.zoomOutClicked()
            }
            onReleased: {
                _root.stopZoomClicked()
            }
        }
    }

}
