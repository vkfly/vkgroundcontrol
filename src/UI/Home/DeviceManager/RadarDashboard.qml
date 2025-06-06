import QtQuick
import QtQuick.Controls

Canvas {
    id: canvas
    width: 400
    height: 400

    property int selectedSegment: -1 // 追踪当前选中的扇形索引

    onPaint: {
        var ctx = canvas.getContext("2d");
        var radius = canvas.width / 2;
        var centerX = canvas.width / 2;
        var centerY = canvas.height / 2;
        var segments = 4; // 扇形数量
        var segmentAngle = 60 * Math.PI / 180; // 每个扇形的角度（60度）
        var gapAngle = 30 * Math.PI / 180; // 间隙角度（30度）

        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // 扇形标签
        var labels = [qsTr("前"), qsTr("右"), qsTr("后"), qsTr("左")];
        var angles = [
            -Math.PI * 2 / 3,
            -Math.PI / 6,
            Math.PI / 3,
            Math.PI - Math.PI / 6
        ];

        ctx.font =30*mainWindow.bili_width;
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";


        for (var i = 0; i < segments; i++) {
            var startAngle = angles[i];
            var endAngle = startAngle + segmentAngle;

            // 保存当前状态
            ctx.save();

            // 将原点移到中心
            ctx.translate(centerX, centerY);

            // 设置颜色
            ctx.fillStyle = (selectedSegment === i) ? "red" : "lightgray";

            // 绘制扇形
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.arc(0, 0, radius, startAngle, endAngle);
            ctx.lineTo(0, 0);
            ctx.closePath();
            ctx.fill();
            //ctx.stroke();

            // 绘制文字
            var labelX = Math.cos(startAngle + segmentAngle / 2) * (radius / 2);
            var labelY = Math.sin(startAngle + segmentAngle / 2) * (radius / 2);

            //ctx.fillStyle = "black";
            //ctx.fillText(labels[i], labelX, labelY);

            // 恢复之前的状态
            ctx.restore();
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }
}

