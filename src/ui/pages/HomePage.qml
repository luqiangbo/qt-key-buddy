import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import KeyBuddy 1.0
import "../components"

Item {
    id: page
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.edge
        spacing: Theme.spacingLG

        GroupBox {
            title: "改键"
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSM
                KeyMapItem {
                    Layout.fillWidth: true
                    trigger: "F1"
                    action: "Ctrl+Alt+Shift+S"
                }
            }
        }
    }
}


