#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include "src/Core.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());

    viewer->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    Core *core;
    if( app->arguments().length() > 1 ) {
        core = new Core(viewer->getView(), app->arguments().last());
    } else {
        core = new Core(viewer->getView());
    }

    viewer->getView()->setWindowTitle("Browser");
    viewer->setMainQmlFile("qrc:/qmls/qml/HeliumReborn/main.qml");

    core->start();

    viewer->showExpanded();




    return app->exec();
}
