import QtQuick
import QtQuick.Controls
import ScreenTools
import VkSdkInstance

Item {
    id: comboBoxRoot

    // Public properties with camelCase naming
    property color backgroundColor: ScreenTools.titleColor
    property real buttonFontSize: 30 * ScreenTools.scaleWidth * 5 / 6
    property string labelName: ""
    property string parameterName: ""
    property var parameterValue: 0
    property var oldText: 0
    property var valueType: 3
    property int currentIndex: 0
    property var currentValue: ""
    property real comboBoxWidth: 320 * ScreenTools.scaleWidth

    onCurrentValueChanged:
    {
        if (parameterName === "GCS_DISCONT_DT" || parameterName === "OBAVOID_ACT") {
                   // 对于这些参数，0→0，5→1
                   currentIndex = (currentValue === 0) ? 0 : 1;
               } else {
                   // 其他参数直接使用值作为索引
                   currentIndex = currentValue;
               }
    }

    // Model for combo box options
    property ListModel customModel: ListModel {
        ListElement { text: qsTr("Option 1") }
        ListElement { text: qsTr("Option 2") }
        ListElement { text: qsTr("Option 3") }
    }

    // Background images (currently unused, kept for compatibility)
    property string backgroundImage0: "/qmlimages/icon/upload.png"
    property string backgroundImage1: "/qmlimages/icon/upload.png"
    property string backgroundImage2: "/qmlimages/icon/uploadfail.png"

    // Component dimensions
    width: parent.width
    height: 60 * ScreenTools.scaleWidth

    // Main content container
    Item {
        width: parent.width
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter

        // Label section
        Label {
            id: parameterLabel
            anchors.left: parent.left
            height: parent.height
            text: labelName
            font.pixelSize: buttonFontSize
            font.bold: false
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }

        // ComboBox container
        Item {
            id: comboBoxContainer
            width: comboBoxWidth
            height: parent.height
            anchors.right: parent.right
            CustomComboBox {
                id: comboBox
                width: 320 * ScreenTools.scaleWidth
                height: 50 * ScreenTools.scaleWidth
                anchors.verticalCenter: parent.verticalCenter
                model: customModel
                currentIndex: comboBoxRoot.currentIndex
                fontSize: buttonFontSize
                onActivated: {
                    handleParameterChange(currentIndex)
                }
            }
        }
    }

    // Handle parameter changes based on parameter name
    function handleParameterChange(selectedIndex) {
        if (!parameterName) {
            console.warn("No parameter name specified")
            return
        }

        var parameterValue = selectedIndex

        // Special handling for specific parameters
        switch (parameterName) {
            case "GCS_DISCONT_DT":
                parameterValue = selectedIndex === 0 ? 0 : 5
                break
            case "OBAVOID_ACT":
                parameterValue = selectedIndex === 0 ? 0 : 5
                break
            default:
                // For FS_CONF_A_* parameters, use selectedIndex directly
                break
        }

        // Send parameter to vehicle
        if (activeVehicle) {
           activeVehicle.setParam(parameterName, parameterValue)
        } else {
            console.error("No vehicle available")
        }
    }

    // Public function to get current index
    function getCurrentIndex() {
        return comboBox.currentIndex
    }

    // Public function to set current index
    function setCurrentIndex(index) {
        comboBoxRoot.currentIndex = index
    }

    // Public function to update model
    function updateModel(newModel) {
        customModel.clear()
        for (var i = 0; i < newModel.length; i++) {
            customModel.append({"text": newModel[i]})
        }
    }


}
