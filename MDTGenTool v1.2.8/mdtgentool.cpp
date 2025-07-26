#include "mdtgentool.h"
#include <fstream>
#include <cmath>
#include <cstdlib>
#include <ctime>
#include <QImage>
#include <QColor>
#include <algorithm>
#include <QDebug>
#include <random>

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

void MDTGenTool::erodeTerrain(std::vector<std::vector<double>>& heightMap, int size,
                              int rainAmount, int erosionIterations, double erosionStrength,
                              double evaporationRate, double sedimentCapacityFactor,
                              double depositionRate, double minSlope) {
    // 创建水图和沉积物图
    std::vector<std::vector<double>> waterMap(size, std::vector<double>(size, 0.0));
    std::vector<std::vector<double>> sedimentMap(size, std::vector<double>(size, 0.0));

    // 侵蚀参数使用传入的值
    const double gravity = 9.8;

    // 设置随机数生成器
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(0.0, 1.0);

    qDebug() << "Starting erosion simulation with parameters:";
    qDebug() << "  Rain Amount:" << rainAmount;
    qDebug() << "  Erosion Iterations:" << erosionIterations;
    qDebug() << "  Erosion Strength:" << erosionStrength;
    qDebug() << "  Evaporation Rate:" << evaporationRate;
    qDebug() << "  Sediment Capacity Factor:" << sedimentCapacityFactor;
    qDebug() << "  Deposition Rate:" << depositionRate;
    qDebug() << "  Min Slope:" << minSlope;

    for (int iter = 0; iter < erosionIterations; ++iter) {
        // 降雨
        for (int x = 0; x < size; ++x) {
            for (int y = 0; y < size; ++y) {
                waterMap[x][y] += rainAmount * (0.8 + dis(gen) * 0.4); // 添加随机变化
            }
        }

        // 水流和侵蚀/沉积模拟
        for (int x = 1; x < size - 1; ++x) {
            for (int y = 1; y < size - 1; ++y) {
                // 计算高度差（包括水位）
                double currentHeight = heightMap[x][y] + waterMap[x][y];

                // 找到最低邻居
                int minX = x, minY = y;
                double minHeight = currentHeight;

                for (int dx = -1; dx <= 1; ++dx) {
                    for (int dy = -1; dy <= 1; ++dy) {
                        if (dx == 0 && dy == 0) continue;
                        int nx = x + dx;
                        int ny = y + dy;
                        double neighborHeight = heightMap[nx][ny] + waterMap[nx][ny];

                        if (neighborHeight < minHeight) {
                            minHeight = neighborHeight;
                            minX = nx;
                            minY = ny;
                        }
                    }
                }

                // 如果没有下坡，跳过
                if (minX == x && minY == y) continue;

                // 计算水流方向和坡度
                double dx = minX - x;
                double dy = minY - y;
                double distance = std::sqrt(dx * dx + dy * dy);
                double slope = (currentHeight - minHeight) / distance;
                slope = std::max(slope, minSlope);

                // 计算流速和水流
                double flowVelocity = std::sqrt(slope * gravity) * waterMap[x][y];
                double waterTransfer = std::min(waterMap[x][y], flowVelocity * 0.1);

                // 转移水
                waterMap[x][y] -= waterTransfer;
                waterMap[minX][minY] += waterTransfer;

                // 计算泥沙携带能力
                double sedimentCapacity = sedimentCapacityFactor * flowVelocity * slope * erosionStrength;

                // 侵蚀或沉积
                if (sedimentMap[x][y] < sedimentCapacity) {
                    // 侵蚀
                    double erosionAmount = std::min((sedimentCapacity - sedimentMap[x][y]) * 0.5,
                                                    heightMap[x][y] * 0.1);
                    heightMap[x][y] -= erosionAmount;
                    sedimentMap[x][y] += erosionAmount;
                } else {
                    // 沉积
                    double depositAmount = (sedimentMap[x][y] - sedimentCapacity) * depositionRate;
                    heightMap[x][y] += depositAmount;
                    sedimentMap[x][y] -= depositAmount;
                }

                // 转移部分泥沙
                double sedimentTransfer = sedimentMap[x][y] * (waterTransfer / (waterMap[x][y] + waterTransfer + 1.0));
                sedimentMap[x][y] -= sedimentTransfer;
                sedimentMap[minX][minY] += sedimentTransfer;
            }
        }

        // 蒸发水和沉积剩余泥沙
        for (int x = 0; x < size; ++x) {
            for (int y = 0; y < size; ++y) {
                // 蒸发
                waterMap[x][y] *= (1.0 - evaporationRate);

                // 沉积剩余泥沙
                if (waterMap[x][y] < 0.001) {
                    heightMap[x][y] += sedimentMap[x][y];
                    sedimentMap[x][y] = 0;
                    waterMap[x][y] = 0;
                }
            }
        }
    }
}

bool MDTGenTool::generateTerrain(int iterations, double range, int gain, int layers, int edgeSmoothness,
                                 bool exportBrush, bool brushMode, bool brushModeTow,
                                 bool isErode,
                                 int rainwaterViscosity,
                                 int erosionsTimes,
                                 int erosionIntensity,
                                 double evaporationRate,
                                 double sedimentCapacityFactor,
                                 double depositionRate,
                                 double minSlope,
                                 const QString &txtPath, const QString &pngPath
                                 ) {
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

    // 如果启用侵蚀，则应用侵蚀模拟
    if (isErode) {
        erodeTerrain(finalHeight, size,
                     rainwaterViscosity,
                     erosionsTimes,
                     erosionIntensity / 100.0,  // 转换为0-1范围
                     evaporationRate,
                     sedimentCapacityFactor,
                     depositionRate,
                     minSlope);
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
    QImage brushImage;      //笔刷图像

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

    if(exportBrush){
        qDebug() << "Exporting brush image...";

        brushImage = QImage(size, size, QImage::Format_RGB32);

        // 计算图像中心点
        double centerX = (size - 1) / 2.0;
        double centerY = (size - 1) / 2.0;
        double maxDistance = sqrt(centerX * centerX + centerY * centerY); // 最大距离 中心到角落

        for(int y = 0; y < size; y++){
            for(int x = 0; x < size; x++){
                QRgb pixel = image.pixel(x, y);
                int gray = qRed(pixel);

                // 计算当前点到中心的距离
                double dx = x - centerX;
                double dy = y - centerY;
                double distance = sqrt(dx * dx + dy * dy);

                // 计算渐变权重距离中心越远，权重越大
                double weight = std::min(1.0, (distance / maxDistance) / edgeSmoothness);
                if(brushMode){
                    // 权重曲线调整使用二次曲线
                    weight = weight * weight;
                }else{
                    // 权重曲线调整使用一次曲线
                    weight = weight;
                }

                // 修改后的处理：先过渡到黑色，再根据条件反相
                int blended = static_cast<int>(gray * (1 - weight)); // 过渡到黑色
                if (brushModeTow) {
                    blended = 255 - blended; // 需要反相
                }
                int brushValue = blended;
                brushValue = std::clamp(brushValue, 0, 255);

                QColor brushColor(brushValue, brushValue, brushValue);
                brushImage.setPixelColor(x, y, brushColor);
            }
        }

        // 保存笔刷
        QString brushPath = pngPath;
        brushPath.replace(".png", "-brush.png");

        if(!brushImage.save(brushPath, "PNG")){
            qDebug() << "Failed to save brush image";
        }else{
            qDebug() << "Brush image saved:" << brushPath;
        }
    }

    emit terrainGenerated(true);
    return true;
}
