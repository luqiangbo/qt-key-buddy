import QtQuick 2.15
import QtQuick.Controls 2.15
import KeyBuddy 1.0
import "../components"

Item {
    id: page
    anchors.fill: parent

    Column {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Label { text: "设置" }

        AppCard {
            anchors.left: parent.left
            anchors.right: parent.right
            content: SettingsForm {
                model: [
                    {
                        type: "switch",
                        label: "跟随系统主题",
                        get: function() { return AppStore.followSystemTheme },
                        set: function(v) { AppStore.followSystemTheme = v }
                    },
                    {
                        type: "switch",
                        label: "暗黑模式（关闭跟随系统时生效）",
                        get: function() { return AppStore.darkMode },
                        set: function(v) { AppStore.darkMode = v }
                    }
                ]
            }
        }
    }
}


