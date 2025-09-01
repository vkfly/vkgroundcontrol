import QtQuick 2.15
import ScreenTools

Item {
    // 从主面板传入统一的布局参数
    property var width_text
    property var height_text
    property var button_fontsize
    property var qxbmsmsg: null  // 改为对象类型，不再使用数组

    id:_root
    width: parent.width
    height: colume.height

    Column{
        id: colume
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter

        // 顶部留白，与基础信息保持一致
        Item {
            width: parent.width
            height: 10 * ScreenTools.scaleWidth
        }

        // 第一行
        Row{
            width: parent.width
            height: height_text
            Text{
                width: width_text
                height: parent.height
                text: qsTr("ID: %1").arg(qxbmsmsg ? qxbmsmsg.id : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("电池电压: %1V").arg(qxbmsmsg ? qxbmsmsg.batVoltage.toFixed(1) : "0.0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("电堆电压: %1V").arg(qxbmsmsg ? qxbmsmsg.stackVoltage.toFixed(1) : "0.0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
        }

        // 行间距，与基础信息保持一致
        Item {
            width: parent.width
            height: 10 * ScreenTools.scaleWidth
        }

        // 第二行
        Row{
            width: parent.width
            height: height_text
            Text{
                width: width_text
                height: parent.height
                text: qsTr("电机电压: %1V").arg(qxbmsmsg ? qxbmsmsg.servoVoltage.toFixed(1) : "0.0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("电机电流: %1A").arg(qxbmsmsg ? qxbmsmsg.servoCurrent.toFixed(0) : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("气罐压力: %1MPa").arg(qxbmsmsg ? qxbmsmsg.gasTankPressure : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
        }

        // 行间距
        Item {
            width: parent.width
            height: 10 * ScreenTools.scaleWidth
        }

        // 第三行
        Row{
            width: parent.width
            height: height_text
            Text{
                width: width_text
                height: parent.height
                text: qsTr("主板温度: %1℃").arg(qxbmsmsg ? qxbmsmsg.pcbTemp : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("电堆温度: %1℃").arg(qxbmsmsg ? qxbmsmsg.stackTemp : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("总功率: %1W").arg(qxbmsmsg ? (qxbmsmsg.servoVoltage * qxbmsmsg.servoCurrent).toFixed(0) : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
        }

        // 行间距
        Item {
            width: parent.width
            height: 10 * ScreenTools.scaleWidth
        }

        // 第四行
        Row{
            width: parent.width
            height: height_text
            Text{
                width: width_text
                height: parent.height
                text: qsTr("氢气剩余: %1kg").arg(qxbmsmsg ? qxbmsmsg.gassMass.toFixed(2) : "0.00")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("氢气SOC: %1%").arg(qxbmsmsg ? qxbmsmsg.gassPercent.toFixed(1) : "0.0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("剩余续航: %1min").arg(qxbmsmsg ? qxbmsmsg.runtimeRemain.toFixed(1) : "0.0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
        }

        // 行间距
        Item {
            width: parent.width
            height: 10 * ScreenTools.scaleWidth
        }

        // 第五行
        Row{
            width: parent.width
            height: height_text
            Text{
                width: width_text
                height: parent.height
                text: qsTr("风机状态: %1%").arg(qxbmsmsg ? qxbmsmsg.fanPercent : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("风机转速: %1rpm").arg(qxbmsmsg ? qxbmsmsg.fanRpm : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("锂电池电流: %1A").arg(qxbmsmsg ? qxbmsmsg.lipoCurrent.toFixed(1) : "0.0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
        }

        // 行间距
        Item {
            width: parent.width
            height: 10 * ScreenTools.scaleWidth
        }

        // 第六行
        Row{
            width: parent.width
            height: height_text
            Text{
                width: width_text
                height: parent.height
                text: qsTr("总运行时间: %1h").arg(qxbmsmsg ? qxbmsmsg.totalRuntime.toFixed(1) : "0.0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("电池补能电流: %1A").arg(qxbmsmsg ? qxbmsmsg.batRefuelCurrent.toFixed(1) : "0.0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
        }

        // 行间距
        Item {
            width: parent.width
            height: 10 * ScreenTools.scaleWidth
        }

        // 第七行
        Row{
            width: parent.width
            height: height_text
            Text{
                width: width_text
                height: parent.height
                text: qsTr("设备状态: %1").arg(qxbmsmsg ? qxbmsmsg.workStatus : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("故障状态: %1").arg(qxbmsmsg ? qxbmsmsg.sysFaultState : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("故障编码: %1").arg(qxbmsmsg ? qxbmsmsg.sysFaultCode : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
        }

        // 行间距
        Item {
            width: parent.width
            height: 10 * ScreenTools.scaleWidth
        }

        // 第八行
        Row{
            width: parent.width
            height: height_text
            Text{
                width: width_text
                height: parent.height
                text: qsTr("自检状态:%1").arg(qxbmsmsg ? (qxbmsmsg.selfCheck === 0 ? qsTr("未通过") : qsTr("通过")) : qsTr("未检测"))
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
            Text{
                width: width_text
                height: parent.height
                text: qsTr("系统状态: %1").arg(qxbmsmsg ? qxbmsmsg.sysRunState : "0")
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
        }

        // 行间距
        Item {
            width: parent.width
            height: 10 * ScreenTools.scaleWidth
        }

        // 第九行（报警状态）
        Row{
            width: parent.width
            height: height_text
            Text{
                id:baojing
                width: width_text * 3  // 占满三列宽度
                height: parent.height
                text: qsTr("报警状态: %1").arg(getbaojing())
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: button_fontsize
            }
        }

        // 底部留白
        Item {
            width: parent.width
            height: 10 * ScreenTools.scaleWidth
        }
    }

    function getshebeionofoff(){
        if (qxbmsmsg && (qxbmsmsg.workStatus & 128)){
            return qsTr("关机")
        }
        else{
            return qsTr("开机")
        }
    }

    function getchongdian(){
        if (qxbmsmsg && (qxbmsmsg.workStatus & 64)){
            return qsTr("未充电")
        }
        else{
            return qsTr("充电中")
        }
    }

    function getfangdian(){
        if (qxbmsmsg && (qxbmsmsg.workStatus & 32)){
            return qsTr("未放电")
        }
        else{
            return qsTr("放电中")
        }
    }

    // function getSystemState(){
    //     if (!qxbmsmsg) return qsTr("未知");
    //     switch(qxbmsmsg.sysRunState) {
    //         case 0: return qsTr("待机");
    //         case 1: return qsTr("启动中");
    //         case 2: return qsTr("运行中");
    //         case 3: return qsTr("关机中");
    //         case 4: return qsTr("故障");
    //         default: return qsTr("未知状态");
    //     }
    // }

    function getbaojing(){
        if (!qxbmsmsg) return qsTr("未检测");

        var errors = [];
        const faultMask = qxbmsmsg.faultStatus;

        if(faultMask !== 0) {
            baojing.color="red"
        } else {
            baojing.color="white"
        }

        if (faultMask & 1) errors.push(qsTr("电堆温度高"));
        if (faultMask & 2) errors.push(qsTr("电堆温度低"));
        if (faultMask & 4) errors.push(qsTr("主板温度高"));
        if (faultMask & 8) errors.push(qsTr("风扇停转"));
        if (faultMask & 16) errors.push(qsTr("风扇转速异常"));
        if (faultMask & 32) errors.push(qsTr("风扇转速异常"));
        if (faultMask & 64) errors.push(qsTr("氢电池电压高"));
        if (faultMask & 128) errors.push(qsTr("氢电池电压低"));
        if (faultMask & 256) errors.push(qsTr("电机电压高"));
        if (faultMask & 512) errors.push(qsTr("电机电压低"));
        if (faultMask & 1024) errors.push(qsTr("电池电压高"));
        if (faultMask & 2048) errors.push(qsTr("电池电压低"));
        if (faultMask & 4096) errors.push(qsTr("气罐气压高"));
        if (faultMask & 8192) errors.push(qsTr("气罐气压低"));
        if (faultMask & 16384) errors.push(qsTr("管道气压高"));
        if (faultMask & 32768) errors.push(qsTr("管道气压低"));

        return errors.length > 0 ? errors.join(" / ") : qsTr("正常");
    }
}
