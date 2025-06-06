import QtQuick 2.15
import Controls

Item {

    property string titleName: ""
    default property alias content: contentArea.data
    // 可以被子组件覆盖的返回处理函数
    property var handleReturn: function() {
    }

    id: _baseRoot
    width: parent.width
    height: parent.height

    VKSetToolbar {
        id: vk_toobar
        anchors.top: parent.top
        titleName: _baseRoot.titleName
        onReturnLast: {
            handleReturn()
        }
    }
    
    // 内容区域
    Item {
        id: contentArea
        width: _baseRoot.width
        height: _baseRoot.height - vk_toobar.height
        anchors.bottom: parent.bottom
        
        Rectangle {
            anchors.fill: parent
            color: "white"
        }
        

    }
}
