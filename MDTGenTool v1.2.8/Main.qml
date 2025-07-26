import QtQuick
import QtQuick.Controls
import QtQuick.Window
import MDTGenTool 1.0
import ExportOBJ 1.0

Window {
    id: window
    width: 700
    height: 700
    visible: true
    title: qsTr("地形生成工具")
    color: "#F5F5F7"
    //全局bool变量
    property bool showErodeEditor: false
    property bool showMainWindow: true
    property bool showProductionWindow: false

    MDTGenTool {
        id: terrainTool
        onTerrainGenerated: function(success) {
            if (success) {
                resultText.text = "地形生成成功！笔刷和文档保存在软件目录下terrain.txt和terrain.png";
                resultText.color = "#4CAF50";  // 成功绿色
            } else {
                resultText.text = "地形生成失败，请检查路径或参数！";
                resultText.color = "#F44336";  // 失败红色
            }
        }
    }

    ExportOBJ {
        id: objExporter
        onExportFinished: function(success, message) {
            exportBtn.enabled = true
            exportText.text = message
            exportText.color = success ? "#4CAF50" : "#F44336"
        }
    }

    // 标题区域
    Rectangle {
        id: header
        width: parent.width
        height: 60
        color: "#1976D2"

        Label {
            text: "地形生成工具"
            anchors.centerIn: parent
            font {
                pixelSize: 24
                bold: true
            }
            color: "white"
        }
    }

    // 主内容区域
    ScrollView {
        visible: showMainWindow
        opacity: showMainWindow ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: footer.top // 留出底部栏空间
        }
        clip: true // 防止内容溢出

        Rectangle {
            id: content
            width: parent.width
            implicitHeight: contentColumn.implicitHeight + 40
            color: "transparent"

            Column {
                id: contentColumn
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 20
                }
                spacing: 24

                // 参数输入组
                Grid {
                    id: paramsGrid
                    columns: 2
                    columnSpacing: 20
                    rowSpacing: 12

                    // 迭代次数
                    Label {
                        text: "迭代次数 (建议5~10):"
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        height: 40
                    }
                    TextField {
                        id: iterationsField
                        width: 180
                        height: 40
                        text: "7"
                        placeholderText: "如：7"
                        font.pixelSize: 14
                        background: Rectangle {
                            radius: 8
                            border.color: "#BDBDBD"
                            border.width: 1
                        }
                    }

                    // 初始扰动范围
                    Label {
                        text: "初始扰动范围 (推荐1~5):"
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        height: 30
                    }
                    TextField {
                        id: rangeField
                        width: 180
                        height: 40
                        text: "2"
                        placeholderText: "如：2"
                        font.pixelSize: 14
                        background: Rectangle {
                            radius: 8
                            border.color: "#BDBDBD"
                            border.width: 1
                        }
                    }

                    // 地形陡峭增益
                    Label {
                        text: "地形陡峭增益:"
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        height: 30
                    }
                    TextField {
                        id: gainField
                        width: 180
                        height: 40
                        text: "10"
                        placeholderText: "如：10"
                        font.pixelSize: 14
                        background: Rectangle {
                            radius: 8
                            border.color: "#BDBDBD"
                            border.width: 1
                        }
                    }

                    // 叠加层数
                    Label {
                        text: "叠加层数 (建议3~6):"
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        height: 30
                    }
                    TextField {
                        id: layersField
                        width: 180
                        height: 40
                        text: "4"
                        placeholderText: "如：4"
                        font.pixelSize: 14
                        background: Rectangle {
                            radius: 8
                            border.color: "#BDBDBD"
                            border.width: 1
                        }
                    }
                }

                //复选框组
                CheckBox {
                    id: brushOpen
                    text: "导出笔刷"
                    checked: true
                }

                CheckBox {
                    id: brushMode
                    text: "笔刷二次函数平滑"
                    checked: false
                }

                CheckBox {
                    id: brushModeTow
                    text: "输出反相笔刷"
                    checked: false
                }

                CheckBox {
                    id: isErode
                    text: "开启侵蚀模拟"
                    checked: false
                    onCheckedChanged: showErodeEditor = checked
                }

                // 边缘平滑度控制
                Column {
                    spacing: 4
                    width: parent.width

                    Text {
                        text: "边缘平滑度 (1.0 - 5.0)"
                        font.pixelSize: 12
                        color: "#555"
                    }

                    Row {
                        spacing: 8
                        Slider {
                            id: edgeSmoothness
                            width: 180
                            from: 1
                            to: 5
                            value: 1
                            stepSize: 0.01
                        }
                        Text {
                            width: 40
                            text: edgeSmoothness.value.toFixed(2)
                            font.pixelSize: 14
                            color: "#1976D2"
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Text {
                        text: "控制地形边缘过度的平滑程度(注意！值越大,平滑越低！)"
                        font.pixelSize: 10
                        color: "#777"
                    }
                }

                // 侵蚀参数组
                Column {
                    visible: showErodeEditor
                    spacing: 8
                    width: parent.width

                    Label { text: "降雨量R:"; font.pixelSize: 12 }
                    TextField {
                        id: rainwaterViscosity
                        width: 120; height: 32
                        text: "10"
                        font.pixelSize: 14
                    }

                    Label { text: "侵蚀迭代次数N:"; font.pixelSize: 12 }
                    TextField {
                        id: erosionsTimes
                        width: 120; height: 32
                        text: "5"
                        font.pixelSize: 14
                    }

                    Label { text: "侵蚀强度K_e:"; font.pixelSize: 12 }
                    TextField {
                        id: erosionIntensity
                        width: 120; height: 32
                        text: "20"
                        font.pixelSize: 14
                    }

                    Label { text: "蒸发率α（蒸发速率系数∂h/∂t = -αh）:"; font.pixelSize: 12 }
                    TextField {
                        id: evaporationRate
                        width: 120; height: 32
                        text: "0.1"
                        font.pixelSize: 14
                    }

                    Label { text: "泥沙携带能力因子C_s（泥沙携带能力系数 Q_s = C_s·v·S *v*:流速, S:坡度）:"; font.pixelSize: 12 }
                    TextField {
                        id: sedimentCapacityFactor
                        width: 120; height: 32
                        text: "0.08"
                        font.pixelSize: 14
                    }

                    Label { text: "沉积率β （沉积速率系数 ∂Q_s/∂t = -β(Q_s - Q_{seq}) ）:"; font.pixelSize: 12 }
                    TextField {
                        id: depositionRate
                        width: 120; height: 32
                        text: "0.3"
                        font.pixelSize: 14
                    }

                    Label { text: "最小坡度S_min:"; font.pixelSize: 12 }
                    TextField {
                        id: minSlope
                        width: 120; height: 32
                        text: "0.01"
                        font.pixelSize: 14
                    }
                }

                // 生成按钮
                Button {
                    id: generateBtn
                    text: "生成地形"
                    width: 180
                    height: 60
                    font.pixelSize: 16
                    font.bold: true
                    hoverEnabled: true // 启用悬停检测

                    // 按钮缩放属性（用于动画）
                    property real scaleFactor: 1.0

                    // 悬停效果
                    background: Rectangle {
                        id: generateBtnBg
                        color: generateBtn.pressed ? "#0D47A1" :
                                generateBtn.hovered ? "#1565C0" : "#1976D2"
                        radius: 10
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    // 弹性动画效果
                    transform: Scale {
                        origin.x: generateBtn.width/2
                        origin.y: generateBtn.height/2
                        xScale: generateBtn.scaleFactor
                        yScale: generateBtn.scaleFactor
                    }

                    // 鼠标按下时缩小
                    onPressed: {
                        generateBtn.scaleFactor = 0.95
                    }

                    // 鼠标释放时恢复并添加弹性效果
                    onReleased: {
                        elasticAnim.restart()
                    }

                    // 弹性动画序列
                    SequentialAnimation {
                        id: elasticAnim
                        PropertyAnimation {
                            target: generateBtn
                            property: "scaleFactor"
                            to: 1.05
                            duration: 100
                        }
                        PropertyAnimation {
                            target: generateBtn
                            property: "scaleFactor"
                            to: 1.0
                            duration: 200
                            easing.type: Easing.OutBounce
                        }
                    }

                    onClicked: terrainTool.generateTerrain(
                        parseInt(iterationsField.text),
                        parseFloat(rangeField.text),
                        parseInt(gainField.text),
                        parseInt(layersField.text),
                        edgeSmoothness.value,
                        brushOpen.checked,
                        brushMode.checked,
                        brushModeTow.checked,
                        isErode.checked,
                        parseInt(rainwaterViscosity.text),
                        parseInt(erosionsTimes.text),
                        parseInt(erosionIntensity.text),
                        parseFloat(evaporationRate.text),
                        parseFloat(sedimentCapacityFactor.text),
                        parseFloat(depositionRate.text),
                        parseFloat(minSlope.text),
                        "terrain.txt",
                        "terrain.png"
                    )
                }

                // 结果文本
                Text {
                    id: resultText
                    text: "等待操作..."
                    color: "#757575"
                    font.pixelSize: 16
                }

                //导出3Dobj
                Button {
                    id: exportBtn
                    text: "导出为OBJ"
                    width: 180
                    height: 60
                    font.pixelSize: 16
                    font.bold: true
                    hoverEnabled: true

                    property real scaleFactor: 1.0

                    background: Rectangle {
                    id: exportBtnBg
                    color: exportBtn.pressed ? "#0D47A1" :
                                exportBtn.hovered ? "#1565C0" : "#1976D2"
                        radius: 10
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    transform: Scale {
                        origin.x: exportBtn.width/2
                        origin.y: exportBtn.height/2
                        xScale: exportBtn.scaleFactor
                        yScale: exportBtn.scaleFactor
                    }

                    onPressed: {
                        exportBtn.scaleFactor = 0.95
                    }

                    onReleased: {
                        elasticAnimExport.restart()
                    }

                    SequentialAnimation {
                        id: elasticAnimExport
                        PropertyAnimation {
                            target: exportBtn
                            property: "scaleFactor"
                            to: 1.05
                            duration: 100
                        }
                        PropertyAnimation {
                            target: exportBtn
                            property: "scaleFactor"
                            to: 1.0
                            duration: 200
                            easing.type: Easing.OutBounce
                        }
                    }

                    onClicked: {
                        exportBtn.enabled = false
                        exportText.text = "正在导出OBJ..."
                        exportText.color = "#1976D2"
                        objExporter.exportToObj("terrain.txt", "terrain.obj")
                    }
                }

                // 导出结果文本
                Text {
                    id: exportText
                    text: "等待操作..."
                    color: "#757575"
                    font.pixelSize: 16
                }
            }
        }
    }

    // 底部信息栏
    Rectangle {
        id: footer
        width: parent.width
        height: 40
        anchors.bottom: parent.bottom
        color: "#E3F2FD"

        // 版权信息
        Label {
            text: "© 2025 地形生成工具 | 使用 Diamond-Square 算法\n 版权所有:t-r-r  |  TrrSwLabs出品"
            anchors.centerIn: parent
            font.pixelSize: 12
            color: "#455A64"
        }

        // 关于按钮
        // 关于按钮
        Button {
            visible: !showProductionWindow
            id: aboutProduction
            text: "关于制作人员"
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 15
            }
            width: 160
            height: 38
            font.pixelSize: 14
            font.bold: true
            hoverEnabled: true

            property real scaleFactor: 1.0

            background: Rectangle {
                id: aboutProductionBg
                color: aboutProduction.pressed ? "#0D47A1" :
                               aboutProduction.hovered ? "#1565C0" : "#1976D2"
                radius: 10
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            transform: Scale {
                origin.x: aboutProduction.width/2
                origin.y: aboutProduction.height/2
                xScale: aboutProduction.scaleFactor
                yScale: aboutProduction.scaleFactor
            }

            onPressed: {
                aboutProduction.scaleFactor = 0.95
            }

            onReleased: {
                elasticAnimAbout.restart()
            }

            SequentialAnimation {
                id: elasticAnimAbout
                PropertyAnimation {
                    target: aboutProduction
                    property: "scaleFactor"
                    to: 1.05
                    duration: 100
                }
                PropertyAnimation {
                    target: aboutProduction
                    property: "scaleFactor"
                    to: 1.0
                    duration: 200
                    easing.type: Easing.OutBounce
                }
            }

            onClicked: {
                showMainWindow = false
                showProductionWindow = true
            }
        }

        //返回按钮
        Button {
            visible: showProductionWindow
            id: unAboutProduction
            text: "返回"
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 15
            }
            width: 160
            height: 38
            font.pixelSize: 14
            font.bold: true
            hoverEnabled: true

            property real scaleFactor: 1.0

            background: Rectangle {
                id: unAboutProductionBg
                color: unAboutProduction.pressed ? "#0D47A1" :
                               unAboutProduction.hovered ? "#1565C0" : "#1976D2"
                radius: 10
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            transform: Scale {
                origin.x: unAboutProduction.width/2
                origin.y: unAboutProduction.height/2
                xScale: unAboutProduction.scaleFactor
                yScale: unAboutProduction.scaleFactor
            }

            onPressed: {
                unAboutProduction.scaleFactor = 0.95
            }

            onReleased: {
                elasticAnimUnAbout.restart()
            }

            SequentialAnimation {
                id: elasticAnimUnAbout
                PropertyAnimation {
                    target: unAboutProduction
                    property: "scaleFactor"
                    to: 1.05
                    duration: 100
                }
                PropertyAnimation {
                    target: unAboutProduction
                    property: "scaleFactor"
                    to: 1.0
                    duration: 200
                    easing.type: Easing.OutBounce
                }
            }

            onClicked: {
                showMainWindow = true
                showProductionWindow = false
            }
        }
    }

    //关于信息
    ScrollView {
        opacity: showMainWindow ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: 300 } }
        visible: showProductionWindow
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: footer.top
        }

        Column {
            width: parent.width
            spacing: 20
            topPadding: 30
            bottomPadding: 30

            // 标题区域
            Label {
                text: "制作人员信息"
                anchors.horizontalCenter: parent.horizontalCenter
                font {
                    pixelSize: 24
                    bold: true
                }
                color: "#1976D2"
            }

            // 开发者信息卡片
            Rectangle {
                width: 280
                height: 150
                radius: 15
                color: "#E3F2FD"
                border.color: "#BBDEFB"
                anchors.horizontalCenter: parent.horizontalCenter

                Row {
                    anchors.centerIn: parent
                    spacing: 30

                    // 开发者详细信息
                    Column {
                        spacing: 10
                        anchors.verticalCenter: parent.verticalCenter

                        Label {
                            text: "主要开发者/原作者"
                            font {
                                pixelSize: 18
                                bold: true
                            }
                            color: "#0D47A1"
                        }

                        Label {
                            text: "用户名: t-r-r"
                            font.pixelSize: 16
                        }

                        Label {
                            text: "实验室: TrrSwLabs"
                            font.pixelSize: 16
                        }

                        Label {
                            text: "开发：全栈开发者 & 算法工程师"
                            font.pixelSize: 16
                        }
                        Label {
                            text: "联系方式：3778302520@qq.com"
                            font.pixelSize: 16
                        }
                    }
                }
            }

            // 项目信息区域
            Column {
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 15

                // 项目标题
                Label {
                    text: "项目信息"
                    font {
                        pixelSize: 20
                        bold: true
                    }
                    color: "#1976D2"
                }

                // 项目描述
                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: "项目名称: 地形生成工具\n\n基于Diamond-Square算法生成3D地形。" +
                          "高度图导出和多种参数调整功能。"
                    font.pixelSize: 16
                    lineHeight: 1.4
                }

                // 技术栈
                Flow {
                    width: parent.width
                    spacing: 10
                    topPadding: 10

                    Repeater {
                        model: ["Qt Quick", "QML", "C++", "OpenGL", "Diamond-Square算法"]

                        // 单个技术标签
                        Rectangle {
                            height: 30
                            width: techText.width + 20
                            radius: 15
                            color: "#BBDEFB"

                            Label {
                                id: techText
                                text: modelData
                                anchors.centerIn: parent
                                font.pixelSize: 14
                                color: "#0D47A1"
                            }
                        }
                    }
                }
            }

            // 版权信息
            Rectangle {
                width: 250
                height: 100
                color: "#E3F2FD"

                Label {
                    anchors.centerIn: parent
                    text: "© 2025 TrrSwLabs. 保留所有权利。"
                    font.pixelSize: 14
                    color: "#455A64"
                }
            }

            Rectangle {
                width: 700
                height: 100
                color: "#E3F2FD"

                Label {
                    anchors.centerIn: parent
                    text: "注意：根据MIT开源协议，此页面原始作者信息除原作者及版权所有者外不可有任何改动、删除、歪曲原信息等行为。\n但可以添加修改者的修改/贡献信息。"
                    font.pixelSize: 12
                    color: "#455A64"
                }
            }
        }
    }
}
