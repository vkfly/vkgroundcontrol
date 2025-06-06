import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ScreenTools

Canvas {

    property real minSliderValue: 100 // 滑动条的最小值
    property real maxSliderValue: 500 // 滑动条的最大值
    property real centerY: height / 2 //滑块的垂直位置
    property int width_name: 3
    property real offset: width_name / 2 //偏移量
    property real sliderWidth: 200 * ScreenTools.scaleWidth //滑动条长度
    property real value: value >= minSliderValue
                         && value <= maxSliderValue ? value : minSliderValue
    property real sliderRange: maxSliderValue - minSliderValue // 滑动条范围
    //初始化滑块位置
    property real sliderPosition: value >= minSliderValue
                                  && value <= maxSliderValue ? (value - minSliderValue) * sliderWidth / sliderRange + sliderRadius : 0 + sliderRadius
    property real sliderRadius: 10 * ScreenTools.scaleWidth // 滑块半径
    property bool dragging: false // 是否正在拖动滑块
    property int fixnumed: 0 //保留几位小数
    property string huadao_color: "#0BFF05" //滑道的颜色
    property string huakuai_color: "0BFF05" //滑块的颜色
    property string huaguo_color: "0BFF05" //滑块划过的颜色
    property int slidervalues: _root1.value

    //当这个值发生变化的时候，就会调用这个方法，而它里面会重绘
    onMaxSliderValueChanged: {
        value = value.toFixed(fixnumed)
        sliderPosition = (value - minSliderValue) * sliderWidth / sliderRange + sliderRadius
        _root1.requestPaint()
    }

    onMinSliderValueChanged: {
        value = value.toFixed(fixnumed)
        sliderPosition = (value - minSliderValue) * sliderWidth / sliderRange + sliderRadius
        _root1.requestPaint()
    }
    onSliderWidthChanged: {
        value = value.toFixed(fixnumed)
        sliderPosition = (value - minSliderValue) * sliderWidth / sliderRange + sliderRadius
        // sliderPosition= (sliderWidth*value/sliderRange-sliderWidth*minSliderValue/sliderRange+sliderRadius);
        _root1.requestPaint()
    }
    onValueChanged: {
        value = value.toFixed(fixnumed)
        sliderPosition = (value - minSliderValue) * sliderWidth / sliderRange + sliderRadius
        // sliderPosition= (sliderWidth*value/sliderRange-sliderWidth*minSliderValue/sliderRange+sliderRadius);
        _root1.requestPaint()
    }

    id: _root1
    width: sliderWidth + sliderRadius * 2
    height: 80

    /*
   1.0 让滑块可以正常滑动
   2.0 对滑块的左右做限制
   3.0 现在滑块的位置
 */
    onPaint: {
        var ctx = getContext("2d")
        // 清除画布
        ctx.clearRect(0, 0, width, height)
        // 绘制灰色滑道
        ctx.fillStyle = huadao_color
        //前2个是矩形左上角的坐标
        ctx.fillRect(sliderRadius, centerY - offset, sliderWidth, width_name)

        // 在滑块划过的地方把橘黄色填充滑动条
        ctx.fillStyle = huadao_color
        ctx.fillRect(sliderRadius, centerY - offset,
                     sliderPosition - sliderRadius, width_name)

        //绘制滑块
        ctx.fillStyle = huaguo_color
        var sliderX = sliderPosition
        ctx.beginPath()
        ctx.arc(sliderX, centerY, sliderRadius, 0, 2 * Math.PI)
        ctx.fill()

        // 绘制滑块上的数值
        //参数：要显示的文本，文本的坐标（x,y）
        // if(dragging==true){
        //     ctx.fillStyle = "white";
        //     ctx.font = "12px Arial";
        //     ctx.textAlign = "center";
        //     ctx.fillText(value.toFixed(fixnum), sliderX, centerY);
        // }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            // 判断鼠标是否在滑动条范围内
            if (Math.abs(sliderPosition - mouse.x) < sliderRadius) {
                //鼠标所在的位置是滑块区域
                dragging = true
            }
        }
        onReleased: {
            dragging = false
            //当松开时，不显示文本
            // _root1.requestPaint();
        }
        onPositionChanged: {
            if (dragging) {
                //限制滑块不超出滑动条的最左边和最右边
                if (mouse.x <= sliderWidth + sliderRadius
                        && mouse.x >= sliderRadius) {
                    sliderPosition = mouse.x
                    value = ((maxSliderValue - minSliderValue) / sliderWidth
                             * (sliderPosition - sliderRadius) + minSliderValue).toFixed(
                                fixnumed)
                    _root1.requestPaint()
                }
                if (mouse.x > sliderWidth + sliderRadius) {
                    sliderPosition = sliderWidth + sliderRadius
                    value = ((maxSliderValue - minSliderValue) / sliderWidth
                             * (sliderPosition - sliderRadius) + minSliderValue).toFixed(
                                fixnumed)
                    _root1.requestPaint()
                }

                if (mouse.x < sliderRadius) {
                    sliderPosition = sliderRadius
                    //根据长度计算对应的数字个数
                    value = ((maxSliderValue - minSliderValue) / sliderWidth
                             * (sliderPosition - sliderRadius) + minSliderValue).toFixed(
                                fixnumed)
                    _root1.requestPaint()
                }
            }
        }
    }
}
