#ifndef MDTGENTOOL_H
#define MDTGENTOOL_H

#include <QObject>
#include <vector>
#include <QImage>  // 添加QImage支持

class MDTGenTool : public QObject
{
    Q_OBJECT
public:
    explicit MDTGenTool(QObject *parent = nullptr);

    // 修改参数名 pgmPath -> pngPath
    Q_INVOKABLE bool generateTerrain(int iterations, double range, int gain, int layers,
                                     const QString &txtPath, const QString &pngPath);

signals:
    void terrainGenerated(bool success);

private:
    void diamondSquare(std::vector<std::vector<double>> &map, int size, double range, double roughness);
};

#endif // MDTGENTOOL_H
