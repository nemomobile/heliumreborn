import QtQuick 1.1
import com.nokia.meego 1.1

Menu {
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

