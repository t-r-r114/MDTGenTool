#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qquickstyle>
#include "mdtgentool.h"
#include "exportobj.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Material");

    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    // 注册 C++ 类
    qmlRegisterType<MDTGenTool>("MDTGenTool", 1, 0, "MDTGenTool");
    qmlRegisterType<exportOBJ>("ExportOBJ", 1, 0, "ExportOBJ");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("MDTGenTool", "Main");

    return app.exec();
}
