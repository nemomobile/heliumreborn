import QtQuick 1.1
import com.nokia.meego 1.0

Dialog {
    id: warningDialog
    property alias text: warningText.text

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
            id: warningText
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

}

