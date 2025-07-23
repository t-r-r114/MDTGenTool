#ifndef MDTGENTOOL_H
#define MDTGENTOOL_H

#include <QObject>
#include <vector>

class MDTGenTool : public QObject
{
    Q_OBJECT
public:
    explicit MDTGenTool(QObject *parent = nullptr);

    Q_INVOKABLE bool generateTerrain(int iterations, double range, int gain, int layers, const QString &txtPath, const QString &pgmPath);

signals:
    void terrainGenerated(bool success);

private:
    void diamondSquare(std::vector<std::vector<double>> &map, int size, double range, double roughness);
};

#endif // MDTGENTOOL_H
