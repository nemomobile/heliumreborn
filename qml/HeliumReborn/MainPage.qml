import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "common"

Page {
    id: mainPage
    tools: ToolBarLayout {
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

        InfoBanner {
            id: bookmarkAdded
            text: "Bookmark added"
            iconSource:"qrc:/qmls/pics/bookmark-icon-30x30.png"
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
            anchors.right: parent===undefined ? undefined : parent.right
            onClicked: pageStack.openDialog(Qt.resolvedUrl("MainPageMenu.qml"))
        }
    }

    function back() {
        webView.back.trigger();
    }

    function forward() {
        webView.forward.trigger();
    }

    // Header
    Header {
        id: header
        width: parent.width
        onUrlChanged: { webView.changeUrl(urlString); }
        loading: webView.loading
        z: 3
    }

    // WebView
    FlickableWebView {
        id: webView
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom

        anchors.left: parent.left
        anchors.right: parent.right
        onGotFocus: { header.abortEdit(); }
        onUrlChanged: { header.setDefaultFavIcon(); header.changeUrl(urlString); }
        onIconChanged: { header.updateFavIcon(); }
        z: 1
    }

    ScrollDecorator {
        flickableItem: webView
        z: 3
    }
}
