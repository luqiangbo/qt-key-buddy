import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import KeyBuddy 1.0

Pane {
    id: root
    width: 280
    height: 140
    padding: 0

    property alias title: titleLabel.text
    property real value: 0

    background: Rectangle {
        radius: 12
        color: Theme.card
        border.color: Theme.border
        border.width: 1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacingMD
        spacing: Theme.spacingSM

        Label {
            id: titleLabel
            text: "CPU"
            font.pixelSize: Theme.fontSubTitle
            color: Theme.text
        }

        ProgressBar {
            id: bar
            Layout.fillWidth: true
            from: 0
            to: 1
            value: root.value
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: (root.value * 100).toFixed(1) + "%"
                font.pixelSize: Theme.fontTitle
                font.bold: true
                color: Theme.text
            }
            Item { Layout.fillWidth: true }
            Label {
                text: "实时"
                color: Theme.textWeak
                font.pixelSize: Theme.fontBody
            }
        }
    }
}


