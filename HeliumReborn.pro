TARGET = heliumreborn

TEMPLATE = app

QT += declarative \
    gui \
    core \
    network \
    webkit \
    opengl \
    sql

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE244D944

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    src/Core.cpp \
    src/Logbook.cpp \
    src/FaviconImageProvider.cpp \
    src/CoreDbHelper.cpp \
    src/models/LinkItemsSharedCaches.cpp \
    src/models/HistoryListModel.cpp \
    src/models/BookmarksListModel.cpp \
    src/WebViewInterface.cpp \
    src/Settings.cpp \
    src/models/MostVisitedListModel.cpp \
    src/utility/SqliteDbHelper.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

target.path=/usr/bin

RESOURCES += \
    res.qrc

HEADERS += \
    src/Core.h \
    src/LogbookLinkItems.h \
    src/Logbook.h \
    src/LinkItem.h \
    src/FaviconImageProvider.h \
    src/CoreDbHelper.h \
    src/models/LinkItemsSharedCaches.h \
    src/models/HistoryListModel.h \
    src/models/BookmarksListModel.h \
    src/WebViewInterface.h \
    src/Settings.h \
    src/models/MostVisitedListModel.h \
    src/utility/SqliteDbHelper.h \
    src/utility/macros.h \
    src/utility/Declarativable.h \
    src/buildconfig.h

INCLUDEPATH+=src \
             src/utility

OTHER_FILES += \
    qml/HeliumReborn/MainPage.qml \
    qml/HeliumReborn/main.qml \
    qml/HeliumReborn/LogbookView.qml \
    qml/HeliumReborn/Header.qml \
    qml/HeliumReborn/FlickableWebView.qml \
    qml/HeliumReborn/FieldText.qml \
    qml/HeliumReborn/common/VScrollDropShadow.qml \
    qml/HeliumReborn/common/TopDropShadow.qml \
    qml/HeliumReborn/common/ToolTip.qml \
    qml/HeliumReborn/common/EmbossedButton.qml \
    qml/HeliumReborn/common/BottomDropShadow.qml \
    qml/HeliumReborn/common/BarIcon.qml \
    qml/HeliumReborn/common/Background.qml \
    qml/HeliumReborn/LogbookViewComponents/TabButton.qml \
    qml/HeliumReborn/LogbookViewComponents/TabBar.qml \
    qml/HeliumReborn/LogbookViewComponents/MostVisitedListView.qml \
    qml/HeliumReborn/LogbookViewComponents/LogbookListView.qml \
    qml/HeliumReborn/LogbookViewComponents/HistoryListView.qml \
    qml/HeliumReborn/LogbookViewComponents/Header.qml \
    qml/HeliumReborn/LogbookViewComponents/BookmarksListView.qml
















