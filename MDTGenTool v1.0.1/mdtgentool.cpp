#include "mdtgentool.h"
#include <fstream>
#include <cmath>
#include <cstdlib>
#include <ctime>
#include <QImage>
#include <QColor>

MDTGenTool::MDTGenTool(QObject *parent)
    : QObject{parent}
{}

void MDTGenTool::diamondSquare(std::vector<std::vector<double>> &map, int size, double range, double roughness) {
    int step = size - 1;
    while (step > 1) {
        int half = step / 2;
        for (int x = 0; x < size - 1; x += step) {
            for (int y = 0; y < size - 1; y += step) {
                double avg = (map[x][y] + map[x + step][y] + map[x][y + step] + map[x + step][y + step]) / 4.0;
                map[x + half][y + half] = avg + ((rand() / (double)RAND_MAX) * 2 - 1) * range;
            }
        }
        for (int x = 0; x < size; x += half) {
            for (int y = (x + half) % step; y < size; y += step) {
                double sum = 0;
                int count = 0;
                if (x >= half) { sum += map[x - half][y]; count++; }
                if (x + half < size) { sum += map[x + half][y]; count++; }
                if (y >= half) { sum += map[x][y - half]; count++; }
                if (y + half < size) { sum += map[x][y + half]; count++; }
                map[x][y] = sum / count + ((rand() / (double)RAND_MAX) * 2 - 1) * range;
            }
        }
        range *= roughness;
        step /= 2;
    }
}

bool MDTGenTool::generateTerrain(int iterations, double range, int gain, int layers, const QString &txtPath, const QString &pngPath) {
    int size = pow(2, iterations) + 1;
    srand(time(0));
    std::vector<std::vector<double>> finalHeight(size, std::vector<double>(size, 0.0));
    double roughness = 0.5;
    double baseRange = range;
    for (int i = 0; i < layers; ++i) {
        std::vector<std::vector<double>> layer(size, std::vector<double>(size, 0.0));
        layer[0][0] = ((rand() / (double)RAND_MAX) * 2 - 1) * baseRange;
        layer[0][size - 1] = ((rand() / (double)RAND_MAX) * 2 - 1) * baseRange;
        layer[size - 1][0] = ((rand() / (double)RAND_MAX) * 2 - 1) * baseRange;
        layer[size - 1][size - 1] = ((rand() / (double)RAND_MAX) * 2 - 1) * baseRange;
        diamondSquare(layer, size, baseRange, roughness);
        for (int x = 0; x < size; ++x)
            for (int y = 0; y < size; ++y)
                finalHeight[x][y] += layer[x][y];
        baseRange *= 0.5;
    }
    // 输出txt
    std::ofstream out(txtPath.toStdString());
    if (!out.is_open()) {
        emit terrainGenerated(false);
        return false;
    }
    for (int x = 0; x < size; x++)
        for (int y = 0; y < size; y++)
            out << x << " " << y << " " << finalHeight[x][y] * gain << "\n";
    out.close();


       // 输出PNG位图

    double minVal = finalHeight[0][0], maxVal = finalHeight[0][0];
    for (int x = 0; x < size; ++x)
        for (int y = 0; y < size; ++y) {
            minVal = std::min(minVal, finalHeight[x][y]);
            maxVal = std::max(maxVal, finalHeight[x][y]);
        }

    QImage image(size, size, QImage::Format_RGB32);

    // 填充图像数据
    for (int y = 0; y < size; ++y) {
        for (int x = 0; x < size; ++x) {
            // 归一化高度值到0-255
            int gray = static_cast<int>((finalHeight[x][y] - minVal) / (maxVal - minVal) * 255);
            gray = std::clamp(gray, 0, 255);  // 确保值在0-255范围内

            // 创建灰度颜色
            QColor color(gray, gray, gray);
            image.setPixelColor(x, y, color);
        }
    }

    // 保存PNG文件
    if (!image.save(pngPath, "PNG")) {
        emit terrainGenerated(false);
        return false;
    }

    emit terrainGenerated(true);
    return true;
}
