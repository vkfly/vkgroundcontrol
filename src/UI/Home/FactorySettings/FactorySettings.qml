import QtQuick
import QtQuick.Layouts

import VKGroundControl
import Controls
import ScreenTools
import VkSdkInstance

import "../Common"
import "../DeviceManager"

BaseSettingPage {
    id: root

    // 定义工厂设置类型枚举
    enum FactoryType {
        PlaneModel,    // 机型设置
        InstallSet,    // 安装设置
        PIDSet,        // 参数设置
        RCSet,         // 遥控设置
        MotorCheck,    // 电机设置
        JidongSet      // 机动设置
    }

    titleName: qsTr("工厂模式")
    
    // 添加 _activeVehicle 属性，避免未定义错误
    property var activeVehicle: VkSdkInstance.vehicleManager.activeVehicle
    property int factorySelectId: FactorySettings.FactoryType.PlaneModel  // 使用枚举类型初始化

    signal goToMain

    handleReturn: function () {
        goToMain()
    }

    // 内容区域
    RowLayout {
        anchors.fill: parent
        spacing: 6 * ScreenTools.scaleWidth

        // 左侧内容区域
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "white"  // 确保背景色一致

            // 使用 Loader 替代多个组件的可见性切换
            Loader {
                id: contentLoader
                anchors.fill: parent
                sourceComponent: {
                    switch(factorySelectId) {
                    case FactorySettings.FactoryType.PlaneModel: return planeModelComponent
                    case FactorySettings.FactoryType.InstallSet: return installSetComponent
                    case FactorySettings.FactoryType.PIDSet: return pidSetComponent
                    case FactorySettings.FactoryType.RCSet: return rcSetComponent
                    case FactorySettings.FactoryType.MotorCheck: return motorCheckComponent
                    case FactorySettings.FactoryType.JidongSet: return jidongSetComponent
                    default: return null
                    }
                }
            }

            Component {
                id: planeModelComponent
                PlaneModel {}
            }

            Component {
                id: installSetComponent
                InstallSetting {}
            }

            Component {
                id: pidSetComponent
                PIDSet {}
            }

            Component {
                id: rcSetComponent
                RCSet {}
            }

            Component {
                id: motorCheckComponent
                MotorCheckSetting {}
            }

            Component {
                id: jidongSetComponent
                MotionSettings {}
            }
        }

        // 右侧按钮区域
        Item {
            Layout.minimumWidth: ScreenTools.scaleWidth * 156
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // 定义按钮数据模型
                property var buttonModels: [
                    {
                        text: qsTr("遥控设置"),
                        // iconSource: "/qmlimages/icon/rc_select_u.png",
                        iconSource: "/qmlimages/icon/rc_select_d.png",
                        selectedIconSource: "/qmlimages/icon/rc_select_d.png",
                        index: FactorySettings.FactoryType.RCSet
                    },
                    {
                        text: qsTr("电机设置"),
                        // iconSource: "/qmlimages/icon/motor_select_u.png",
                        iconSource: "/qmlimages/icon/motor_select_d.png",
                        selectedIconSource: "/qmlimages/icon/motor_select_d.png",
                        index: FactorySettings.FactoryType.MotorCheck
                    },
                    {
                        text: qsTr("机动设置"),
                        // iconSource: "/qmlimages/icon/par_select_u.png",
                        iconSource: "/qmlimages/icon/jidong_b.png",
                        selectedIconSource: "/qmlimages/icon/jidong_b.png",
                        index: FactorySettings.FactoryType.JidongSet
                    },
                    {
                        text: qsTr("机型设置"),
                        // iconSource: "/qmlimages/icon/plane_select_u.png",
                        iconSource: "/qmlimages/icon/plane_select_d.png",
                        selectedIconSource: "/qmlimages/icon/plane_select_d.png",
                        index: FactorySettings.FactoryType.PlaneModel
                    },
                    {
                        text: qsTr("安装设置"),
                        // iconSource: "/qmlimages/icon/drive_select_u.png",
                        iconSource: "/qmlimages/icon/drive_select_d.png",
                        selectedIconSource: "/qmlimages/icon/drive_select_d.png",
                        index: FactorySettings.FactoryType.InstallSet
                    },
                    {
                        text: qsTr("参数设置"),
                        // iconSource: "/qmlimages/icon/par_select_u.png",
                        iconSource: "/qmlimages/icon/par_select_d.png",
                        selectedIconSource: "/qmlimages/icon/par_select_d.png",
                        index: FactorySettings.FactoryType.PIDSet
                    }
                ]

                // 使用 Repeater 创建按钮
                Repeater {
                    model: parent.buttonModels
                    delegate: VerticalIconTextButton {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        isSelected: factorySelectId === modelData.index
                        text: modelData.text
                        iconSource: modelData.iconSource
                        selectedIconSource: modelData.selectedIconSource
                        selectedTextColor: "black"
                        unSelectedTextColor: "black"
                        fontSize: 20 * sw
                        onClicked: {
                            titleName = modelData.text
                            factorySelectId = modelData.index
                            if (_activeVehicle) {
                                _activeVehicle.requestlist()
                            }
                        }
                    }
                }
            }
        }
    }
}
