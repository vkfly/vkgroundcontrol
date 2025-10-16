import QtQuick
import QtQuick.Controls

import VkSdkInstance
import VKGroundControl

MouseArea {
    id: root


    property var videoStreaming: null
    property var gimbalController: VKGroundControl.gimbalController
    property real gestureThreshold: 10
    property real maxGestureSpeed: 2.0
    property real touchSensitivity: 15  // 遥控器触控灵敏度调整

    signal lockTargetRequested(int pixelX, int pixelY)
    signal stopLocked
    // 私有属性
    property bool _isPressed: false
    property bool _isGestureActive: false
    property point _startPos: Qt.point(0, 0)
    property string _currentDirection: ""  // 当前移动方向: "left", "right", "up", "down", ""
    property bool _commandSent: false     // 是否已发送当前方向的指令

    cursorShape: "PointingHandCursor"
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    hoverEnabled: true

    onPressed: function(mouse) {
        if (mouse.button === Qt.LeftButton) {
            _handleLeftPress(mouse)
        }
    }

    onPositionChanged: function(mouse) {
        if (_isPressed && mouse.buttons & Qt.LeftButton) {
            _handleGestureMove(mouse)
        }
    }

    onReleased: function(mouse) {
        if (mouse.button === Qt.LeftButton) {
            _handleLeftRelease()
        }
    }

    onDoubleClicked: function(mouse) {
        if (mouse.button === Qt.LeftButton) {
            _handleDoubleClick(mouse)
        }
    }

    onClicked: function(mouse) {
        if (mouse.button === Qt.RightButton) {
            _handleRightClick()
        }
    }

    // 私有方法
    function _handleLeftPress(mouse) {
        _isPressed = true
        _isGestureActive = false
        _startPos = Qt.point(mouse.x, mouse.y)
        _currentDirection = ""
        _commandSent = false
    }

    function _handleGestureMove(mouse) {
        const delta = Qt.point(mouse.x - _startPos.x, mouse.y - _startPos.y)
        const distance = Math.sqrt(delta.x * delta.x + delta.y * delta.y)

        if (distance > gestureThreshold) {
            _isGestureActive = true
            _executeGestureControl(delta, distance)
        }
    }

    function _handleLeftRelease() {
        _isPressed = false
        if (_isGestureActive && gimbalController && _commandSent) {
            console.log(`停止移动指令: ${_currentDirection}`)
            gimbalController.stopMovement()
        }
        _isGestureActive = false
        _startPos = Qt.point(0, 0)
        _currentDirection = ""
        _commandSent = false
    }

    function _handleDoubleClick(mouse) {
        if (!gimbalController || !videoStreaming) return
        const coords = _calculateVideoCoordinates(mouse.x, mouse.y)
        if (coords.valid) {
            console.log(`coords.pixelX:${coords.pixelX},coords.pixelY:${coords.pixelY}`)
            gimbalController.lockTarget(coords.pixelX, coords.pixelY)
            lockTargetRequested(mouse.x, mouse.y)
        }
    }

    function _handleRightClick() {
        if (gimbalController) {
            gimbalController.unlockTarget()
            stopLockClicked()
        }
    }

    function _executeGestureControl(delta, distance) {
        if (!gimbalController) return

        // 使用更大的阈值来避免遥控器触控时的误触
        const threshold = touchSensitivity
        let newDirection = ""
        
        // 确定移动方向，增加防抖动逻辑
        if (Math.abs(delta.x) > Math.abs(delta.y) && Math.abs(delta.x) > threshold) {
            // 水平移动
            newDirection = delta.x > 0 ? "right" : "left"
        } else if (Math.abs(delta.y) > threshold) {
            // 垂直移动
            newDirection = delta.y > 0 ? "down" : "up"
        }
        
        // 只在方向改变时发送新指令
        if (newDirection !== "" && newDirection !== _currentDirection) {
            _currentDirection = newDirection
            _commandSent = true
            
            const speed = 10
            console.log(`发送移动指令: ${newDirection}`)
            
            switch (newDirection) {
                case "right":
                    gimbalController.moveRight(speed)
                    break
                case "left":
                    gimbalController.moveLeft(speed)
                    break
                case "down":
                    gimbalController.moveDown(speed)
                    break
                case "up":
                    gimbalController.moveUp(speed)
                    break
            }
        }
    }

    function _calculateVideoCoordinates(mouseX, mouseY) {
        const rootW = root.width
        const rootH = root.height
        const videoW = videoStreaming.getWidth()
        const videoH = videoStreaming.getHeight()
        console.log(`videoW:${videoW},videoH:${videoH}`)

        // 计算视频在容器中的偏移量
        const videoOffsetX = (rootW - videoW) / 2
        const videoOffsetY = (rootH - videoH) / 2
        
        // 检查鼠标点击是否在视频区域内
        if (mouseX >= videoOffsetX && mouseX <= videoOffsetX + videoW &&
            mouseY >= videoOffsetY && mouseY <= videoOffsetY + videoH) {
            
            const relativeX = (mouseX - videoOffsetX) / videoW
            const relativeY = (mouseY - videoOffsetY) / videoH
        
            const actualVideoWidth = VKGroundControl.videoManager.videoSize.width === -1 ? 1920 : VKGroundControl.videoManager.videoSize.width
            const actualVideoHeight = VKGroundControl.videoManager.videoSize.height === -1 ? 1080 : VKGroundControl.videoManager.videoSize.height
            console.log(`actualVideoWidth:${actualVideoWidth},actualVideoHeight:${actualVideoHeight}`)

           const centerX = actualVideoWidth / 2
           const centerY = actualVideoHeight / 2
           const pixelX = Math.floor((relativeX - 0.5) * actualVideoWidth)
           const pixelY = Math.floor((0.5 - relativeY) * actualVideoHeight)
           const halfWidth = Math.floor(actualVideoWidth / 2)
           const halfHeight = Math.floor(actualVideoHeight / 2)
           const clampedX = Math.max(-halfWidth, Math.min(pixelX, halfWidth - 1))
           const clampedY = Math.max(-halfHeight, Math.min(pixelY, halfHeight - 1))
           console.log(`相对坐标: (${relativeX.toFixed(3)}, ${relativeY.toFixed(3)})`)
           console.log(`中心坐标系像素坐标: (${clampedX}, ${clampedY})`)
           console.log(`坐标范围: X[${-halfWidth}, ${halfWidth-1}], Y[${-halfHeight}, ${halfHeight-1}]`)
           return {
               valid: true,
               pixelX: clampedX,
               pixelY: clampedY
           }

        }

        return { valid: false }
    }
}
