import QtQuick
import QtQuick.Controls
import ScreenTools

Row {
    id: _root
    property bool issetbool: false
    //height: parent.height
    width: issetbool ? mainWindow.width * 0.55 + 70
                       * ScreenTools.scaleWidth : 70 * ScreenTools.scaleWidth

    // width: 780*ScreenTools.scaleWidth
    enum RightWindow {
        ParSetWindow,
        VKBatteryWindow,
        VKOtherSetWindow,
        VKMessageWindow
    }
    property var set_page_index: FlyViewRightSetWindow.RightWindow.ParSetWindow
    anchors.right: parent.right
    spacing: 0
    //飞行页面右侧框显示
    Button {
        anchors.top: parent.top
        anchors.topMargin: 65 * ScreenTools.scaleWidth
        //id:setbt
        height: 100 * ScreenTools.scaleWidth
        width: 70 * ScreenTools.scaleWidth
        // anchors.verticalCenter:parent.verticalCenter
        Image {
            id: setbt_img2
            anchors.fill: parent
            source: "/qmlimages/icon/left_arrow.png"
        }
        background: Rectangle {
            color: "transparent"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {

                issetbool = !issetbool
                if (issetbool) {
                    setbt_img2.source = "/qmlimages/icon/right_arrow.png"
                } else {
                    setbt_img2.source = "/qmlimages/icon/left_arrow.png"
                }
            }
        }
    }
    Item {
        id: item
        //width: 665*ScreenTools.bili_width
        visible: issetbool

        width: mainWindow.width * 0.55

        height: parent.height
        Rectangle {
            width: item.width
            color: "black"
            height: item.height
            Row {
                width: item.width
                height: item.height
                Flickable {
                    height: parent.height
                    width: 75 * ScreenTools.scaleWidth
                    contentHeight: left_pageq.implicitHeight
                    Column {
                        id: left_pageq
                        width: 65 * ScreenTools.scaleWidth
                        anchors.horizontalCenter: parent.horizontalCenter

                        spacing: 65 * ScreenTools.scaleWidth
                        Button {
                            height: 65 * ScreenTools.scaleWidth
                            width: 65 * ScreenTools.scaleWidth
                            Image {
                                height: 45 * ScreenTools.scaleWidth
                                width: 45 * ScreenTools.scaleWidth
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: set_page_index === FlyViewRightSetWindow.RightWindow.ParSetWindow ? "/qmlimages/icon/plane_b.png" : "/qmlimages/icon/plane_a.png"
                            }

                            background: Rectangle {
                                color: "transparent"
                            }
                            onClicked: {
                                set_page_index = FlyViewRightSetWindow.RightWindow.ParSetWindow
                            }
                        }

                        Button {
                            height: 65 * ScreenTools.scaleWidth
                            width: 65 * ScreenTools.scaleWidth
                            Image {
                                height: 45 * ScreenTools.scaleWidth
                                width: 45 * ScreenTools.scaleWidth
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                //anchors.fill: parent
                                source: set_page_index === FlyViewRightSetWindow.RightWindow.VKBatteryWindow ? "/qmlimages/icon/battery_set_b.png" : "/qmlimages/icon/battery_set_a.png"
                            }
                            background: Rectangle {
                                color: "transparent"
                            }
                            onClicked: {
                                set_page_index = FlyViewRightSetWindow.RightWindow.VKBatteryWindow
                            }
                        }

                        Button {
                            height: 65 * ScreenTools.scaleWidth
                            width: 65 * ScreenTools.scaleWidth
                            Image {
                                height: 45 * ScreenTools.scaleWidth
                                width: 45 * ScreenTools.scaleWidth
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: set_page_index === FlyViewRightSetWindow.RightWindow.VKMessageWindow ? "/qmlimages/icon/msg_b.png" : "/qmlimages/icon/msg_a.png"
                            }

                            background: Rectangle {
                                color: "transparent"
                            }
                            onClicked: {
                                set_page_index = FlyViewRightSetWindow.RightWindow.VKMessageWindow
                            }
                        }
                        Button {
                            height: 65 * ScreenTools.scaleWidth
                            width: 65 * ScreenTools.scaleWidth
                            Image {
                                height: 45 * ScreenTools.scaleWidth
                                width: 45 * ScreenTools.scaleWidth
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: set_page_index == FlyViewRightSetWindow.RightWindow.VKOtherSetWindow ? "/qmlimages/icon/set_b.png" : "/qmlimages/icon/set_a.png"
                            }
                            background: Rectangle {
                                color: "transparent"
                            }
                            onClicked: {
                                set_page_index = FlyViewRightSetWindow.RightWindow.VKOtherSetWindow
                            }
                        }

                        Text {
                            height: 165 * ScreenTools.scaleWidth
                            width: 65 * ScreenTools.scaleWidth
                        }
                    }
                }
                Item {
                    width: 2
                    height: parent.height
                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                    }
                }
                Item {
                    id: item1
                    width: item.width - 75 * ScreenTools.scaleWidth
                    height: parent.height
                    MessageAllShow {
                        width: item1.width
                        height: parent.height
                        visible: set_page_index
                                 === FlyViewRightSetWindow.RightWindow.VKMessageWindow
                    }

                    VKBatterySet {
                        width: item1.width
                        height: parent.height

                        visible: set_page_index
                                 === FlyViewRightSetWindow.RightWindow.VKBatteryWindow
                    }
                    VKParSet {
                        width: item1.width
                        height: parent.height
                        visible: set_page_index === FlyViewRightSetWindow.RightWindow.ParSetWindow
                    }
                    VKOtherSet {
                        width: item1.width
                        height: parent.height
                        visible: set_page_index
                                 === FlyViewRightSetWindow.RightWindow.VKOtherSetWindow
                    }
                }
            }
        }
    }
}
