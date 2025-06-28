import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VKGroundControl
import ScreenTools
import VKGroundControl.Palette
import VkSdkInstance
import Controls

/**
 * 飞机模型选择组件
 * 用于显示和选择不同类型的多旋翼飞机模型
 */
Item {
    id: planeModelSelector
    width: parent.width
    height: parent.height

    // 定义飞机类型枚举
    enum PlaneType {
        None = 0,
        QuadX = 41,
        QuadPlus = 42,
        HexaX = 61,
        HexaPlus = 62,
        HexaCoaxX = 63,
        HexaCoaxPlus = 64,
        HexaH = 65,
        OctoX = 81,
        OctoPlus = 82,
        OctoCoaxX = 83,
        OctoCoaxPlus = 84,
        OctoCoaxH = 85,
        OctoCoaxV = 86,
        // 修改了重复的枚举名称
        DodecaHexaX = 121,
        DodecaHexaPlus = 122,
        DodecaHexaH = 123,
        DodecaOctoX = 162
    }


    // UI相关属性
    property var selectedColor: qgcPal.titleColor
    property real planeIconWidth: ScreenTools.scaleWidth * 174

    // 图标相关属性
    property string uploadSuccessIcon: "/qmlimages/icon/upload.png"
    property string uploadFailIcon: "/qmlimages/icon/uploadfail.png"
    property string currentUploadIcon: "/qmlimages/icon/upload.png"


    property string paramKey: "AIRFRAME"
    property int parsedParamValue: 0
    property int currentPlaneType: 0

    // 选择相关属性
    property int selectedImage: 0 // 用于跟踪当前选中的图片，0表示未选中任何图片
    property string motorRotationInfo: " 1/3电机逆时针旋转 \n 2/4电机顺时针旋转"
    property var _activeVehicle: VkSdkInstance.vehicleManager.activeVehicle
    property var paramvalue : _activeVehicle ? _activeVehicle.parameters["AIRFRAME"] : 0


    onParamvalueChanged: {
        currentPlaneType=paramvalue
    }

    VKPalette {
        id: qgcPal
    }

    Column {
        spacing: planeIconWidth / 3
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        // 第一行飞机模型按钮
        Row {
            spacing: planeIconWidth / 3
            // 四轴X型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.QuadX
                iconSource: getPlaneType(PlaneModel.PlaneType.QuadX)
                rotationInfo: " 1/3电机逆时针旋转 \n 2/4电机顺时针旋转"
                currentPlaneType: planeModelSelector.currentPlaneType
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 四轴十字型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.QuadPlus
                iconSource: getPlaneType(PlaneModel.PlaneType.QuadPlus)
                rotationInfo: " 1/3电机逆时针旋转 \n 2/4电机顺时针旋转"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 六轴共轴X型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.HexaCoaxX
                iconSource: getPlaneType(PlaneModel.PlaneType.HexaCoaxX)
                rotationInfo: " 1/2/3号电机在上并且全部逆时针方向 \n 456号电机在下并且全部顺时针方向"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 六轴共轴十字型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.HexaCoaxPlus
                iconSource: getPlaneType(PlaneModel.PlaneType.HexaCoaxPlus)
                rotationInfo: " 1/2/3号电机在上并且全部逆时针方向 \n 456号电机在下并且全部顺时针方向"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 六轴X型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.HexaX
                iconSource: getPlaneType(PlaneModel.PlaneType.HexaX)
                rotationInfo: " 1/3/5电机逆时针旋转 \n 2/4/6电机顺时针旋转"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
        }
        // 第二行飞机模型按钮
        Row {
            spacing: planeIconWidth / 3
            // 六轴十字型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.HexaPlus
                iconSource: getPlaneType(PlaneModel.PlaneType.HexaPlus)
                rotationInfo: " 1/3/5电机逆时针旋转 \n 2/4/6电机顺时针旋转"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 六轴H型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.HexaH
                iconSource: getPlaneType(PlaneModel.PlaneType.HexaH)
                rotationInfo: " 1/3/5电机逆时针旋转 \n 2/4/6电机顺时针旋转"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 八轴X型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.OctoX
                iconSource: getPlaneType(PlaneModel.PlaneType.OctoX)
                rotationInfo: " 1/3/5/7电机逆时针旋转 \n 2/4/6/8电机顺时针旋转"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 八轴十字型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.OctoPlus
                iconSource: getPlaneType(PlaneModel.PlaneType.OctoPlus)
                rotationInfo: " 1/3/5/7电机逆时针旋转 \n 2/4/6/8电机顺时针旋转"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 八轴共轴X型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.OctoCoaxX
                iconSource: getPlaneType(PlaneModel.PlaneType.OctoCoaxX)
                rotationInfo: " 1/2/3/4电机在上\n 5/6/7/8电机在下\n 1/3/6/8 为逆时针\n 2/4/5/7 为顺时针\n "
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
        }
        // 第三行飞机模型按钮
        Row {
            spacing: planeIconWidth / 3
            // 八轴共轴十字型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.OctoCoaxPlus
                iconSource: getPlaneType(PlaneModel.PlaneType.OctoCoaxPlus)
                rotationInfo: " 1/2/3/4电机在上\n  5/6/7/8电机在下 \n 1/2/3/4 为逆时针\n 5/6/7/8 为顺时针"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 十二轴六边形X型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.DodecaHexaX
                iconSource: getPlaneType(PlaneModel.PlaneType.DodecaHexaX)
                rotationInfo: "1/2/3/4/5/6 在上\n 7/8/9/10/11/12 在下 \n 1/3/5/8/10/12 为逆时针\n  2/4/6/7/9/11 为顺时针"
                visible: mainWindow.fcumodel_versions === "V10Pro"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 十二轴六边形十字型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.DodecaHexaPlus
                iconSource: getPlaneType(PlaneModel.PlaneType.DodecaHexaPlus)
                rotationInfo: "1/2/3/4/5/6 在上\n 7/8/9/10/11/12 在下 \n 1/3/5/8/10/12 为逆时针\n  2/4/6/7/9/11 为顺时针"
                visible: mainWindow.fcumodel_versions === "V10Pro"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 十六轴八边形X型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.DodecaOctoX
                iconSource: getPlaneType(PlaneModel.PlaneType.DodecaOctoX)
                rotationInfo: "1/2/3/4/5/6/7/8 在上\n 9/10/11/12/13/14/15/16 在下 \n 1/3/5/7/10/12/14/16 为逆时针\n  2/4/6/8/9/11/13/15/17 为顺时针"
                visible: mainWindow.fcumodel_versions === "V10Pro"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
            // 十二轴六边形H型
            PlaneModelButton {
                planeTypeValue: PlaneModel.PlaneType.DodecaHexaH
                iconSource: getPlaneType(PlaneModel.PlaneType.DodecaHexaH)
                rotationInfo: "1/2/3/4/5/6/7/8 在上\n 9/10/11/12/13/14/15/16 在下 \n 1/3/5/7/10/12/14/16 为逆时针\n  2/4/6/8/9/11/13/15/17 为顺时针"
                visible: mainWindow.fcumodel_versions === "V10Pro"
                width: planeModelSelector.planeIconWidth
                height: planeModelSelector.planeIconWidth
                currentPlaneType: planeModelSelector.currentPlaneType
                // onButtonClicked: function (planeType, rotInfo, iconSrc) {
                //     planeModelSelector.currentPlaneType = planeType
                //     motorRotationInfo = rotInfo
                // }
            }
        }
    }

    /**
     * 根据飞机类型获取对应的图标路径
     * @param planeType 飞机类型ID
     * @return 对应的图标路径
     */
    function getPlaneType(planeType) {
        // 如果是有效的飞机类型，直接返回对应的图标路径
        if (planeType >= PlaneModel.PlaneType.QuadX
                && planeType <= PlaneModel.PlaneType.DodecaOctoX) {
            return "/qmlimages/icon/" + planeType + ".png"
        }
        // 默认返回四轴X型图标
        return "/qmlimages/icon/" + PlaneType.QuadX + ".png"
    }
}
