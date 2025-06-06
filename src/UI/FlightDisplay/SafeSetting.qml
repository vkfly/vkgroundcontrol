import QtQuick
import QtQuick.Controls

import Controls

Flickable {
    height: parent.height
    width: parent.width
    contentHeight: column11.implicitHeight
    Column {
        width: parent.width
        id: column11
        VTitle {
            id: vt
            vt_title: "安全设置"
        }
        GroupBox {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: column.height * 1.02
            Item {
                width: parent.width
                height: parent.height
                //anchors.fill: parent
                Column {
                    id: column
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    ParameterBar {
                        id: par1
                        labelName: "一级保护电压"
                        canshu: "VOLT1_LOW_VAL"
                        fixnum: 1
                        slidermaxvalue: 120
                        sliderminvalue: 12
                        danwei: "V"
                        value_type: 9
                    }
                    ParameterBar {
                        //id:par1
                        labelName: "一级保护电量"
                        canshu: "VCAP1_LOW_VAL"
                        //fixnum:1
                        slidermaxvalue: 100
                        sliderminvalue: 5
                        danwei: "%"
                        value_type: 1
                    }
                    ComboxUI {
                        id: combox1
                        value_1: combox1.getcurrentIndex()
                        value_2: combox2.getcurrentIndex()
                        value_3: combox3.getcurrentIndex()
                        canshu: "FS_CONF_A_1"
                        labelName: "一级保护动作"
                        customModel: ListModel {
                            ListElement {
                                text: "无动作"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "悬停"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "返航"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "去往备降点"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "原地降落"
                                //text.pixelSize:18
                            }
                        }
                    }
                    ParameterBar {
                        labelName: "二级保护电压"
                        canshu: "VOLT2_LOW_VAL"
                        fixnum: 1
                        slidermaxvalue: 120
                        sliderminvalue: 12
                        danwei: "V"
                        value_type: 9

                        /* onClicktext: {
                            kayboard.minvalue=sliderminvalue
                            kayboard.maxvalue=slidermaxvalue
                            kayboard.texttitle=labelName
                            kayboard.danwei=danwei
                            kayboard.fixednum=fixnum
                            kayboard.str_text=slidervalue
                            kayboard.issend=true
                            kayboard.canshu=canshu
                            kayboard.value_type=value_type
                            kayboard.send_id=99
                            popupWindow.visible=true
                        }*/
                    }

                    ParameterBar {
                        //id:par1
                        labelName: "二级保护电量"
                        canshu: "VCAP2_LOW_VAL"
                        //fixnum:1
                        slidermaxvalue: 100
                        sliderminvalue: 5
                        danwei: "%"
                        value_type: 1
                    }
                    ComboxUI {
                        id: combox2
                        value_1: combox1.getcurrentIndex()
                        value_2: combox2.getcurrentIndex()
                        value_3: combox3.getcurrentIndex()
                        canshu: "FS_CONF_A_2"
                        labelName: "二级保护动作"
                        customModel: ListModel {
                            ListElement {
                                text: "无动作"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "悬停"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "返航"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "去往备降点"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "原地降落"
                                //text.pixelSize:18
                            }
                        }
                    }

                    /* ParameterBar{
                        //id:par1
                        labelName: "电压保护通道"
                        canshu:"VOLT_PROT_CH"
                        //fixnum:1
                        slidermaxvalue: 10
                        sliderminvalue: 0
                        danwei:""
                        value_type:3
                    }*/
                    ParameterBar {
                        labelName: "地面站失联时间"
                        canshu: "GCS_DISCONT_DT"
                        ms_labelName: "(0为关闭此功能)"
                        value_type: 3
                        slidermaxvalue: 1200
                        sliderminvalue: 0
                        danwei: "s"
                        onClicktext: {
                            kayboard.minvalue = sliderminvalue
                            kayboard.maxvalue = slidermaxvalue
                            kayboard.texttitle = labelName
                            kayboard.danwei = danwei
                            kayboard.fixednum = fixnum
                            kayboard.str_text = slidervalue
                            kayboard.issend = true
                            kayboard.canshu = canshu
                            kayboard.value_type = value_type
                            kayboard.send_id = 99
                            popupWindow.visible = true
                        }
                    }
                    ParameterBar {
                        labelName: "RC失联停时间"
                        canshu: "RCFAIL_LOT_T"
                        slidermaxvalue: 1200
                        sliderminvalue: 0
                        danwei: "s"
                        value_type: 3
                        onClicktext: {
                            kayboard.minvalue = sliderminvalue
                            kayboard.maxvalue = slidermaxvalue
                            kayboard.texttitle = labelName
                            kayboard.danwei = danwei
                            kayboard.fixednum = fixnum
                            kayboard.str_text = slidervalue
                            kayboard.issend = true
                            kayboard.canshu = canshu
                            kayboard.value_type = value_type
                            kayboard.send_id = 99
                            popupWindow.visible = true
                        }
                    }
                    ParameterBar {
                        labelName: "避障距离"
                        canshu: "OBAVOID_DIST"
                        slidermaxvalue: 8
                        sliderminvalue: 2
                        danwei: "m"
                        value_type: 9
                        onClicktext: {
                            kayboard.minvalue = sliderminvalue
                            kayboard.maxvalue = slidermaxvalue
                            kayboard.texttitle = labelName
                            kayboard.danwei = danwei
                            kayboard.fixednum = fixnum
                            kayboard.str_text = slidervalue
                            kayboard.issend = true
                            kayboard.canshu = canshu
                            kayboard.value_type = value_type
                            kayboard.send_id = 99
                            popupWindow.visible = true
                        }
                    }

                    ParameterBar {
                        labelName: "避障动作"
                        ms_labelName: "(0-无 1-悬停 2-爬高)"
                        canshu: "OBAVOID_ACT"
                        slidermaxvalue: 2
                        sliderminvalue: 0
                        danwei: ""
                        value_type: 1
                        onClicktext: {
                            kayboard.minvalue = sliderminvalue
                            kayboard.maxvalue = slidermaxvalue
                            kayboard.texttitle = labelName
                            kayboard.danwei = danwei
                            kayboard.fixednum = fixnum
                            kayboard.str_text = slidervalue
                            kayboard.issend = true
                            kayboard.canshu = canshu
                            kayboard.value_type = value_type
                            kayboard.send_id = 99
                            popupWindow.visible = true
                        }
                    }

                    ParameterBar {
                        labelName: "一级高度限制"
                        ms_labelName: "(达到高度触发返航)"
                        canshu: "ALT_LIM_UP1"
                        slidermaxvalue: 10000
                        sliderminvalue: 10
                        danwei: "m"
                        value_type: 3
                        onClicktext: {
                            kayboard.minvalue = sliderminvalue
                            kayboard.maxvalue = slidermaxvalue
                            kayboard.texttitle = labelName
                            kayboard.danwei = danwei
                            kayboard.fixednum = fixnum
                            kayboard.str_text = slidervalue
                            kayboard.issend = true
                            kayboard.canshu = canshu
                            kayboard.value_type = value_type
                            kayboard.send_id = 99
                            popupWindow.visible = true
                        }
                    }
                    ParameterBar {
                        labelName: "二级高度限制"
                        ms_labelName: "(达到高度触发迫降)"
                        canshu: "ALT_LIM_UP2"
                        slidermaxvalue: 10000
                        sliderminvalue: 10
                        danwei: "m"
                        value_type: 3
                        onClicktext: {
                            kayboard.minvalue = sliderminvalue
                            kayboard.maxvalue = slidermaxvalue
                            kayboard.texttitle = labelName
                            kayboard.danwei = danwei
                            kayboard.fixednum = fixnum
                            kayboard.str_text = slidervalue
                            kayboard.issend = true
                            kayboard.canshu = canshu
                            kayboard.value_type = value_type
                            kayboard.send_id = 99
                            popupWindow.visible = true
                        }
                    }
                    ParameterBar {
                        labelName: "水平距离限制"
                        ms_labelName: "(0为关闭此功能)"
                        canshu: "MAX_HOR_DIST"
                        slidermaxvalue: 50000
                        sliderminvalue: 0
                        danwei: "m"
                        value_type: 5
                        onClicktext: {
                            kayboard.minvalue = sliderminvalue
                            kayboard.maxvalue = slidermaxvalue
                            kayboard.texttitle = labelName
                            kayboard.danwei = danwei
                            kayboard.fixednum = fixnum
                            kayboard.str_text = slidervalue
                            kayboard.issend = true
                            kayboard.canshu = canshu
                            kayboard.value_type = value_type
                            kayboard.send_id = 99
                            popupWindow.visible = true
                        }
                    }
                    ComboxUI {
                        id: combox3
                        value_1: combox1.getcurrentIndex()
                        value_2: combox2.getcurrentIndex()
                        value_3: combox3.getcurrentIndex()
                        canshu: "FS_CONF_A_3"
                        labelName: "动力故障保护"
                        customModel: ListModel {
                            ListElement {
                                text: "无动作"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "悬停"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "返航"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "去往备降点"
                                //text.pixelSize:18
                            }
                            ListElement {
                                text: "原地降落"
                                //text.pixelSize:18
                            }
                        }
                    }

                    ParameterBar {
                        labelName: "最大倾斜角度"
                        canshu: "TILT_ANG_MAX"
                        slidermaxvalue: 45
                        sliderminvalue: 10
                        danwei: "°"
                        //value_type:3
                        onClicktext: {
                            kayboard.minvalue = sliderminvalue
                            kayboard.maxvalue = slidermaxvalue
                            kayboard.texttitle = labelName
                            kayboard.danwei = danwei
                            kayboard.fixednum = fixnum
                            kayboard.str_text = slidervalue
                            kayboard.issend = true
                            kayboard.canshu = canshu
                            kayboard.value_type = value_type
                            kayboard.send_id = 99
                            popupWindow.visible = true
                        }
                    }
                }
            }
        }
    }
}
