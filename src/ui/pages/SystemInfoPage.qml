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

        Label { text: "硬件信息"; font.pixelSize: 18; font.bold: true }

        GridLayout {
            Layout.fillWidth: true
            columns: width > 820 ? 2 : 1
            rowSpacing: 20
            columnSpacing: 20

            MonitorCard { title: "CPU"; value: AppStore.cpu / 100.0 }
            MonitorCard { title: "网络"; value: 0.0 }
        }
    }
}


