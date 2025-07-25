import QtQuick
import QtQuick.Controls
import QtQuick.Window
import MDTGenTool 1.0

Window {
    id: window
    width: 700
    height: 700
    visible: true
    title: qsTr("地形生成工具")
    color: "#F5F5F7"
    property bool showErodeEditor: false

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
                        height: 30
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

                // 侵蚀参数组
                Column {
                    visible: showErodeEditor
                    spacing: 8
                    width: parent.width

                    Label { text: "降雨量(推荐5~20):"; font.pixelSize: 12 }
                    TextField {
                        id: rainwaterViscosity
                        width: 120; height: 22
                        text: "10"
                        font.pixelSize: 14
                    }

                    Label { text: "侵蚀迭代次数(推荐30~200):"; font.pixelSize: 12 }
                    TextField {
                        id: erosionsTimes
                        width: 120; height: 22
                        text: "50"
                        font.pixelSize: 14
                    }

                    Label { text: "侵蚀强度(推荐50~90):"; font.pixelSize: 12 }
                    TextField {
                        id: erosionIntensity
                        width: 120; height: 22
                        text: "70"
                        font.pixelSize: 14
                    }

                    Label { text: "蒸发率(推荐0.05~0.2):"; font.pixelSize: 12 }
                    TextField {
                        id: evaporationRate
                        width: 120; height: 22
                        text: "0.1"
                        font.pixelSize: 14
                    }

                    Label { text: "泥沙携带能力因子(推荐0.05~0.2):"; font.pixelSize: 12 }
                    TextField {
                        id: sedimentCapacityFactor
                        width: 120; height: 22
                        text: "0.1"
                        font.pixelSize: 14
                    }

                    Label { text: "沉积率(推荐0.2~0.5):"; font.pixelSize: 12 }
                    TextField {
                        id: depositionRate
                        width: 120; height: 22
                        text: "0.3"
                        font.pixelSize: 14
                    }

                    Label { text: "最小坡度(推荐0.005~0.02):"; font.pixelSize: 12 }
                    TextField {
                        id: minSlope
                        width: 120; height: 22
                        text: "0.01"
                        font.pixelSize: 14
                    }
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

                // 生成按钮
                Button {
                    id: generateBtn
                    text: "生成地形"
                    width: 180
                    height: 48
                    font.pixelSize: 16
                    font.bold: true

                    background: Rectangle {
                        color: generateBtn.pressed ? "#1565C0" : "#1976D2"
                        radius: 10
                        Behavior on color { ColorAnimation { duration: 100 } }
                        Behavior on scale { NumberAnimation { duration: 100 } }
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

        Label {
            text: "© 2025 地形生成工具 | 使用 Diamond-Square 算法\n 版权所有:t-r-r  |  TrrSwLabs出品"
            anchors.centerIn: parent
            font.pixelSize: 12
            color: "#455A64"
        }
    }
}
