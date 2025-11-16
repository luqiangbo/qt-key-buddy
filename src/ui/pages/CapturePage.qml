import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: page
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        Label { text: "截图"; font.pixelSize: 18; font.bold: true }
        RowLayout {
            spacing: 8
            Button { text: "截全屏" }
            Button { text: "截区域" }
        }
        Label { text: "（占位）功能即将实现"; color: "#90a4ae" }
    }
}


