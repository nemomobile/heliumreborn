import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

PageStackWindow {
    id: appWindow
    property bool errorDialogOpen

    initialPage: MainPage {
        id: mainPage
    }

    Connections {
        target: appcore
        onSslError: {
            if (appWindow.errorDialogOpen)
                return

            appWindow.errorDialogOpen = true
            var dialog = pageStack.openDialog(Qt.resolvedUrl("SslWarningDialog.qml"))
            dialog.text="<b>SSL error</b><p>Site cannot be securely authenticated. <p>Error Message:<br>"+errorMsg;
            dialog.accepted.connect(function() { appWindow.errorDialogOpen = false })
            dialog.rejected.connect(function() { appWindow.errorDialogOpen = false })
        }
    }

    InfoBanner {
        id: bookmarkAdded
        text: "Bookmark added"
        iconSource:"qrc:/qmls/pics/bookmark-icon-30x30.png"
    }

    ToolBarLayout {
        id: commonTools
        visible: true

        ToolIcon {
            iconSource: "qrc:/qmls/pics/back-30x30.png"
            onClicked: { mainPage.back(); }
        }

        ToolIcon {
            iconSource: "qrc:/qmls/pics/home-30x30.png"
            onClicked: { if (appcore) appcore.loadHomeUrl(); }

        }

        ToolIcon {
            iconSource: "qrc:/qmls/pics/forward-30x30.png"
            onClicked: { mainPage.forward(); }

        }

        ToolIcon {
            iconSource: "qrc:/qmls/pics/new-bookmark-30x30.png"
            onClicked: {
                bookmarkAdded.show();
                if (appcore)
                    appcore.bookmarkCurrentUrl();
            }
        }

        ToolIcon {
            iconSource: "qrc:/qmls/pics/bookmarks-30x30.png"
            onClicked: { pageStack.openSheet(Qt.resolvedUrl("LogbookSheet.qml")) }

        }

        ToolIcon {
            platformIconId: "toolbar-view-menu";
            id: menuIcon
            anchors.right: parent===undefined ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Clear history")
                onClicked: { if (appcore) appcore.clearHistory(); }
            }
            MenuItem {
                text: qsTr("Clear cookies")
                onClicked: { if (appcore) appcore.clearCookies(); }
            }
            MenuItem {
                text: qsTr("Clear bookmarks")
                onClicked: { if (appcore) appcore.clearBookmarks(); }
            }
            MenuItem {
                text: qsTr("Reset All")
                onClicked: { if (appcore) appcore.resetAll(); }
            }
        }
    }
}
