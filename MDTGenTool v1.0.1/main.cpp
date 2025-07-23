#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "mdtgentool.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    // 注册 C++ 类到 QML
    qmlRegisterType<MDTGenTool>("MDTGenTool", 1, 0, "MDTGenTool");

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
