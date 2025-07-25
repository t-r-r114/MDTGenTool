#ifndef MDTGENTOOL_H
#define MDTGENTOOL_H

#include <QObject>
#include <vector>
#include <QImage>  // QImage支持
#include <QDebug>

class MDTGenTool : public QObject
{
    Q_OBJECT
public:
    explicit MDTGenTool(QObject *parent = nullptr);

    // 修改参数名 pgmPath -> pngPath
    Q_INVOKABLE bool generateTerrain(int iterations, double range, int gain, int layers,
                                     int edgeSmoothness,
                                     bool exportBrush,
                                     bool brushMode,
                                     bool brushModeTow,
                                     bool isErode,
                                     int rainwaterViscosity,
                                     int erosionsTimes,
                                     int erosionIntensity,
                                     double evaporationRate,
                                     double sedimentCapacityFactor,
                                     double depositionRate,
                                     double minSlope,
                                     const QString &txtPath, const QString &pngPath);

signals:
    void terrainGenerated(bool success);

private:
    void diamondSquare(std::vector<std::vector<double>> &map, int size, double range, double roughness);

    void erodeTerrain(std::vector<std::vector<double>>& heightMap, int size,
                      int rainAmount, int erosionIterations, double erosionStrength,
                      double evaporationRate, double sedimentCapacityFactor,
                      double depositionRate, double minSlope);
};

#endif // MDTGENTOOL_H
