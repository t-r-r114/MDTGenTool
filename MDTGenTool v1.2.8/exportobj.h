#ifndef EXPORTOBJ_H
#define EXPORTOBJ_H

#include <QObject>
#include <QVector3D>

class exportOBJ : public QObject
{
    Q_OBJECT
public:
    explicit exportOBJ(QObject *parent = nullptr);

    Q_INVOKABLE bool exportToObj(const QString& txtPath, const QString& objPath);

signals:
    void exportFinished(bool success, const QString& message); // 导出完成信号
};

#endif // EXPORTOBJ_H
