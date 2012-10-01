import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

PageStackWindow {
    id: appWindow

    initialPage: MainPage {
        id: mainPage
    }

    Dialog {
        id: warningDialog

        title: Rectangle {
            id: titleField
            height: 2
            width: parent.width
            color: "red"
        }

        content:Item {
            id: name
            width: parent.width
            height: 280
            Text {
                id: text
                width: parent.width
                height: parent.height
                font.pixelSize: 22
                anchors.centerIn: parent
                color: "white"
                text: "<b>SSL error</b>\n\nSite cannot be securely authenticated. \n\nReason:\n\n "
                wrapMode:Text.WordWrap

            }
        }

        buttons: ButtonRow {
            style: ButtonStyle { }
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: "Ok";
                onClicked: warningDialog.accept()
            }
        }

        Connections {
            target: appcore
            onSslError: {
                text.text="<b>SSL error</b><p>Site cannot be securely authenticated. <p>Error Message:<br>"+errorMsg;
                warningDialog.open();
            }
        }

    }

    InfoBanner {
        id: bookmarkAdded
        text: "Bookmark added"
        iconSource:"qrc:/qmls/pics/bookmark-icon-30x30.png"
    }

    Sheet {
        id: logbookSheet
        acceptButtonText: "Done"
        content: LogbookView {
        }
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
            onClicked: { logbookSheet.open(); }

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
