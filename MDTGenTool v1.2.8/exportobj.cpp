#include "exportobj.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <cmath>

exportOBJ::exportOBJ(QObject *parent)
    : QObject{parent}
{}

bool exportOBJ::exportToObj(const QString& txtPath, const QString& objPath) {
    QFile inFile(txtPath);
    if (!inFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        emit exportFinished(false, "无法打开地形文件");
        return false;
    }

    QFile outFile(objPath);
    if (!outFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        inFile.close();
        emit exportFinished(false, "无法创建OBJ文件");
        return false;
    }

    QTextStream in(&inFile);
    QTextStream out(&outFile);

    // 写入OBJ文件头
    out << "# Terrain Exported from MDTGenTool\n";
    out << "o Terrain\n";

    // 读取所有顶点数据
    QVector<QVector3D> vertices;
    int totalLines = 0;
    while (!in.atEnd()) {
        in.readLine();
        totalLines++;
    }
    inFile.seek(0);

    int currentLine = 0;
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList parts = line.split(" ");
        if (parts.size() < 3) continue;

        bool ok;
        float x = parts[0].toFloat(&ok);
        if (!ok) continue;
        float y = parts[1].toFloat(&ok);
        if (!ok) continue;
        float z = parts[2].toFloat(&ok);
        if (!ok) continue;

        // 写入顶点 (交换Y和Z坐标)
        out << "v " << x << " " << z << " " << y << "\n";
        vertices.append(QVector3D(x, y, z));
    }

    // 计算网格尺寸
    int gridSize = sqrt(vertices.size());
    if (gridSize * gridSize != vertices.size()) {
        qWarning() << "地形数据不是正方形网格";
        emit exportFinished(false, "地形数据格式错误");
        return false;
    }

    // 生成面
    out << "\n# Faces\n";
    for (int i = 0; i < gridSize - 1; i++) {
        for (int j = 0; j < gridSize - 1; j++) {
            int idx1 = i * gridSize + j + 1;
            int idx2 = i * gridSize + j + 1 + 1;
            int idx3 = (i + 1) * gridSize + j + 1 + 1;
            int idx4 = (i + 1) * gridSize + j + 1;

            // 创建两个三角形组成的四边形
            out << "f " << idx1 << " " << idx2 << " " << idx3 << "\n";
            out << "f " << idx3 << " " << idx4 << " " << idx1 << "\n";
        }
    }

    out << "\n# End of File\n";
    inFile.close();
    outFile.close();

    emit exportFinished(true, "OBJ导出成功: " + objPath);
    qDebug() << "OBJexport succeed!" << objPath;
    return true;
}
