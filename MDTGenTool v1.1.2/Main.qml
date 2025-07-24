import QtQuick
import QtQuick.Controls
import QtQuick.Window
import MDTGenTool 1.0

Window {
    id: window
    width: 630
    height: 650
    visible: true
    title: qsTr("地形生成工具")
    color: "#F5F5F7"

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
    Rectangle {
        id: content
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }
        color: "transparent"
        Column {
            anchors.centerIn: parent
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
            CheckBox {
                        id:brushOpen
                        text: "导出笔刷"
                        checked: true  // 默认选中
                        onCheckedChanged: {
                            console.log("复选框状态:", checked ? "选中" : "未选中")
                        }
                    }
            CheckBox {
                        id:brushMode
                        text: "笔刷二次函数平滑"
                        checked: false
                        onCheckedChanged: {
                            console.log("复选框状态:", checked ? "选中" : "未选中")
                        }
                    }
            CheckBox {
                        id:brushModeTow
                        text: "输出反相笔刷"
                        checked: false
                        onCheckedChanged: {
                            console.log("复选框状态:", checked ? "选中" : "未选中")
                        }
                    }

            Column {
                spacing: 4

                // 说明文本
                Text {
                    text: "边缘平滑度 (1.0 - 5.0)"
                    font.pixelSize: 12
                    color: "#555"
                }

                // 滑块和值显示
                Row {
                    spacing: 8

                    // 滑块控件
                    Slider {
                        id: edgeSmoothness
                        width: 180
                        from: 1
                        to: 5
                        value: 1
                        stepSize: 0.01
                    }

                    // 当前值显示
                    Text {
                        width: 40
                        text: edgeSmoothness.value.toFixed(2)
                        font.pixelSize: 14
                        color: "#1976D2"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                // 详细说明
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
                font {
                    pixelSize: 16
                    bold: true
                }

                background: Rectangle {
                    color: generateBtn.pressed ? "#1565C0" : "#1976D2"
                    radius: 10

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    scale: generateBtn.pressed ? 1.05 : 1.0
                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                }

                contentItem: Text {
                    text: generateBtn.text
                    font: generateBtn.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    terrainTool.generateTerrain(
                        parseInt(iterationsField.text),
                        parseFloat(rangeField.text),
                        parseInt(gainField.text),
                        parseInt(layersField.text),
                        edgeSmoothness.value,
                        brushOpen.checked,
                        brushMode.checked,
                        brushModeTow.checked,
                        "terrain.txt",
                        "terrain.png"
                    )
                }
            }

            // 结果文本
            Text {
                id: resultText
                text: "等待操作..."
                color: "#757575"  // 默认灰色
                font.pixelSize: 16
                height: 30
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
