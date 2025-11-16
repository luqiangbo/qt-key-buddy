import QtQuick 2.15
import QtQuick.Controls 2.15
import KeyBuddy 1.0

Item {
    id: root
    width: parent ? parent.width : 400
    height: 48
    property string trigger: ""
    property string action: ""

    Row {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        TextField {
            id: triggerField
            placeholderText: "触发键（如 F1）"
            text: root.trigger
            width: 140
        }
        TextField {
            id: actionField
            placeholderText: "动作（如 Ctrl+Alt+Shift+S）"
            text: root.action
            width: 240
        }
        Button {
            text: "保存"
            onClicked: {
                AppStore.addKeyMap(triggerField.text, actionField.text)
            }
        }
    }
}


