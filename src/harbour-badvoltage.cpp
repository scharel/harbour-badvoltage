#include <sailfishapp.h>
#include "FileDownloader.h"
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlContext>
#include <QGuiApplication>
#include <QStandardPaths>
#include <QDir>

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    // make sure the data directory exists to store the feed and the downloaded episodes
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));
    dir.mkpath(".");

    // remove the old settings of app versions prior 1.0-1
    QDir(QString(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation)).append("/harbour-badvoltage")).removeRecursively();

    qmlRegisterType<FileDownloader>("FileDownloader", 1, 0, "FileDownloader");

    view->setSource(SailfishApp::pathTo("qml/harbour-badvoltage.qml"));
    view->rootContext()->setContextProperty("version", QVariant("1.0-1"));
#ifdef QT_DEBUG
    view->rootContext()->setContextProperty("debug", QVariant(true));
#else
    view->rootContext()->setContextProperty("debug", QVariant(false));
#endif
    view->show();
    return app->exec();
}
